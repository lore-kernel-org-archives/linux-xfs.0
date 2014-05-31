Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 246517F7E
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 10:39:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13E5C30404E
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 08:39:54 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id cnjD97khhkEGePWV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 May 2014 08:39:49 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Sat, 31 May 2014 17:37:52 +0200
Message-ID: <5507340.nVBP5LFtqn@wuerfel>
In-Reply-To: <20140531011450.GJ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Saturday 31 May 2014 11:14:50 Dave Chinner wrote:
> On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
> > On 05/30/2014 05:37 PM, Dave Chinner wrote:
> > > 
> > > IOWs, the filesystem has to be able to reject any attempt to set a
> > > timestamp that is can't represent on disk otherwise Bad Stuff will
> > > happen,
> > 
> > Actually it is questionable if it is worse to reject a timestamp or just
> > let it wrap.  Rejecting a valid timestamp is a bit like "You don't
> > exist, go away."
> 
> I think having the new systems calls being able to
> return EINVAL if the value cannot be stored permanently on disk
> correctly is the right thing to do. Having it silently mangled
> by the filesystem and returning "everything is just fine, trust me"
> is close to the worst solution I can think of. That's exactly what
> leads to overflow bugs occurring....

While going through the file systems, I was wondering whether
we should have the times stop at the end of each file systems
epoch rather than wrap around.

> > > and filesystems have to be able to specify in their on
> > > disk format what timestamp encoding is being used. The solution will
> > > be different for every filesystem that needs to support time beyond
> > > 2038.
> > 
> > Actually the cutoff can be really different for each filesystem, not
> > necessarily 2038.  However, I maintain the above still holds.
> 
> Sure, but all filesystems are supposed to handle at least the
> current unix epoch.

In my list at http://kernelnewbies.org/y2038, I found that almost
all file systems at least times until 2106, because they treat
the on-disk value as unsigned on 64-bit systems, or they use
a completely different representation. My guess is that somebody
earlier spent a lot of work on making that happen.

The exceptions are:

* exofs uses signed values, which can probably be changed to be
  consistent with the others.
* isofs has a bug that limits it until 2027 on architectures with
  a signed 'char' type (otherwise it's 2155).
* udf can represent times for many thousands of years through a
  16-bit year representation, but the code to convert to epoch
  uses a const array that ends at 2038.
* afs uses signed seconds and can probably be fixed
* coda relies on user space time representation getting passed
  through an ioctl.
* I miscategorized xfs/ext2/ext3 as having unsigned 32-bit seconds,
  where they really use signed.

I was confused about XFS since I didn't noticed that there are
separate xfs_ictimestamp_t and xfs_timestamp_t types, so I expected
XFS to also use the 1970-2106 time range on 64-bit systems today.

If we are using the variant of my patch that extends
indode_time->tv_sec to s64, nothing should change for XFS
at all, the main difference is that we if it gets extended
to wider on-disk timestamps, they will work the same way on
32-bit and 64-bit kernels. 

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
