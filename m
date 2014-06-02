Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18F1929DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 14:56:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 090B68F8070
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 12:56:55 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	by cuda.sgi.com with ESMTP id bf3LjAnYBItart7C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 12:56:53 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Mon, 02 Jun 2014 21:55:52 +0200
Message-ID: <7175692.dpgYFMbTaP@wuerfel>
In-Reply-To: <538CCFDE.2010107@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4233989.Saca0ocOUr@wuerfel> <538CCFDE.2010107@zytor.com>
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

On Monday 02 June 2014 12:26:22 H. Peter Anvin wrote:
> On 06/02/2014 12:19 PM, Arnd Bergmann wrote:
> > On Monday 02 June 2014 13:52:19 Joseph S. Myers wrote:
> >> On Fri, 30 May 2014, Arnd Bergmann wrote:
> >>
> >>> a) is this the right approach in general? The previous discussion
> >>>    pointed this way, but there may be other opinions.
> >>
> >> The syscall changes seem like the sort of thing I'd expect, although 
> >> patches adding new syscalls or otherwise affecting the kernel/userspace 
> >> interface (as opposed to those relating to an individual filesystem) 
> >> should go to linux-api as well as other relevant lists.
> > 
> > Ok. Sorry about missing linux-api, I confused it with linux-arch, which
> > may not be as relevant here, except for the one question whether we
> > actually want to have the new ABI on all 32-bit architectures or only
> > as an opt-in for those that expect to stay around for another 24 years.
> > 
> > Two more questions for you:
> > 
> > - are you (and others) happy with adding this type of stat syscall
> >   (fstatat64/fstat64) as opposed to the more generic xstat that has
> >   been discussed in the past and that never made it through the bike-
> >   shedding discussion?
> > 
> > - once we have enough buy-in from reviewers to merge this initial
> >   series, should we proceed to define rest of the syscall ABI
> >   (minus driver ioctls) so glibc and kernel can do the conversion
> >   on top of that, or should we better try to do things one syscall
> >   family at a time and actually get the kernel to handle them
> >   correctly internally?
> > 
> 
> The bit that is really going to hurt is every single ioctl that uses a
> timespec.
> 
> Honestly, though, I really don't understand the point with "struct
> inode_time".  It seems like the zeroeth-order thing is to change the
> kernel internal version of struct timespec to have a 64-bit time... it
> isn't just about inodes.  We then should be explicit about the external
> uses of time, and use accessors.

I picked these because they are fairly isolated from all other uses,
in particular since inode times are the only things where we really
care about times in the distant past or future (decades away as opposed
to things that happened between boot and shutdown).

For other kernel-internal uses, we may be better off migrating to
a completely different representation, such as nanoseconds since
boot or the architecture specific ktime_t, but this is really something
to decide for each subsystem.

I just tried building an arm32 kernel with a s64 time_t, and that
failed horribly, I get linker errors for missing 64-bit divides
and lots of warnings for code that expects time_t pointers to
functions taking a 'long' or vice versa. I also think the only
way to maintain ABI compatibility is to separate the internal uses
from the interface, which means auditing all code in the end.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
