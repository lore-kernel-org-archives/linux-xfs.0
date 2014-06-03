Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F43D7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ABE18F8081
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:25:06 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	by cuda.sgi.com with ESMTP id X4CPfQEuHhKMaC6f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 07:25:04 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Tue, 03 Jun 2014 16:22:19 +0200
Message-ID: <5011138.W0gbOc20Qp@wuerfel>
In-Reply-To: <538CF346.2070504@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<7175692.dpgYFMbTaP@wuerfel> <538CF346.2070504@zytor.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, logfs@logfs.org, linux-afs@lists.infradead.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Monday 02 June 2014 14:57:26 H. Peter Anvin wrote:
> On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
> >>
> >> The bit that is really going to hurt is every single ioctl that uses a
> >> timespec.
> >>
> >> Honestly, though, I really don't understand the point with "struct
> >> inode_time".  It seems like the zeroeth-order thing is to change the
> >> kernel internal version of struct timespec to have a 64-bit time... it
> >> isn't just about inodes.  We then should be explicit about the external
> >> uses of time, and use accessors.
> > 
> > I picked these because they are fairly isolated from all other uses,
> > in particular since inode times are the only things where we really
> > care about times in the distant past or future (decades away as opposed
> > to things that happened between boot and shutdown).
> > 
> 
> If nothing else, I would expect to be able to set the system time to
> weird values for testing.  So I'm not so sure I agree with that...

I think John Stultz and Thomas Gleixner have already started looking
at how the timekeeping code can be updated. Once that is done, we should
be able to add a functional 64-bit gettimeofday/settimeofday syscall
pair. While I definitely agree this is one of the most basic things to
have, it's also not an area of the kernel that is easy to change.

> > For other kernel-internal uses, we may be better off migrating to
> > a completely different representation, such as nanoseconds since
> > boot or the architecture specific ktime_t, but this is really something
> > to decide for each subsystem.
> 
> Having a bunch of different time representations in the kernel seems
> like a real headache...

We already have time_t, ktime_t, timeval, timespec, compat_timespec,
clock_t, cputime_t, cputime64_t, tm, nanoseconds, jiffies, jiffies64,
and lots of driver or file system specific representations. I'm all for
removing a bunch of these from the kernel, but my feeling is that this is
one of the cases where we first have to add new ones in order to remove
those that are already there.
To complicate things further, we also have various times bases
(realtime/utc, realtime/tai, monotonic, monotonic_raw, boottime, ...),
and at least for the timespec values we pass around, it's not always
obvious which one is used, of if that's the right one.

We probably don't want to add a lot of new representations, and it's
possible that we can change most of the internal code we have to
ktime_t and then convert that to whatever user space wants at the
interfaces.

The possible uses I can see for non-ktime_t types in the kernel are:
* inodes need 96 bit timestamps to represent the full range of values
  that can be stored in a file system, you made a convincing argument
  for that. Almost everything else can fit into 64 bit on a 32-bit
  kernel, in theory also on a 64-bit kernel if we want that.
* A number of interfaces pass relative timespecs: nanosleep(), poll(),
  select(), sigtimedwait(), alarm(), futex() and probably more. There is
  nothing wrong with the use of timespec here, and it may be good to
  annotate that by using a new type (e.g. struct timeout) that is defined
  as compatible with the current timespec.
* For new user interfaces, we need a new type such as the
  __kernel_timespec64 I introduced, so it doesn't clash with the normal
  user timespec that may be smaller, depending on the libc.
* A lot of drivers will need new ioctl commands, and for drivers that
  just need time stamps (audio, v4l, sockets, ...) it may be more
  efficient and more correct to use a new timestamp_t (e.g. boot time
  64-bit nanoseconds) than __kernel_timespec64, which is not normally
  monotonic and requires a normalization step. If we end up introducing
  such a type in the user interface, we can also start using it in the
  kernel.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
