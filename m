Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3B1A7F54
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C068B8F80DC
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 00:35:20 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id cRKKGxXQnQ3P5NnC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 00:35:18 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Tue, 03 Jun 2014 09:33:36 +0200
Message-ID: <5082342.alZgfaU1Q0@wuerfel>
In-Reply-To: <20140603003227.GP6677@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<7106937.MLk03lftzD@wuerfel> <20140603003227.GP6677@dastard>
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

On Tuesday 03 June 2014 10:32:27 Dave Chinner wrote:
> On Mon, Jun 02, 2014 at 01:43:44PM +0200, Arnd Bergmann wrote:
> > On Monday 02 June 2014 10:28:22 Dave Chinner wrote:
> > > On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> > > > On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > > > > In my list at http://kernelnewbies.org/y2038, I found that almost
> > > > > all file systems at least times until 2106, because they treat
> > > > > the on-disk value as unsigned on 64-bit systems, or they use
> > > > > a completely different representation. My guess is that somebody
> > > > > earlier spent a lot of work on making that happen.
> > > > > 
> > > > > The exceptions are:
> > > > > 
> > > > > * exofs uses signed values, which can probably be changed to be
> > > > >   consistent with the others.
> > > > > * isofs has a bug that limits it until 2027 on architectures with
> > > > >   a signed 'char' type (otherwise it's 2155).
> > > > > * udf can represent times for many thousands of years through a
> > > > >   16-bit year representation, but the code to convert to epoch
> > > > >   uses a const array that ends at 2038.
> > > > > * afs uses signed seconds and can probably be fixed
> > > > > * coda relies on user space time representation getting passed
> > > > >   through an ioctl.
> > > > > * I miscategorized xfs/ext2/ext3 as having unsigned 32-bit seconds,
> > > > >   where they really use signed.
> > > > > 
> > > > > I was confused about XFS since I didn't noticed that there are
> > > > > separate xfs_ictimestamp_t and xfs_timestamp_t types, so I expected
> > > > > XFS to also use the 1970-2106 time range on 64-bit systems today.
> > > > 
> > > > You've missed an awful lot more than just the implications for the
> > > > core kernel code.
> > > > 
> > > > There's a good chance such changes propagate to APIs elsewhere in
> > > > the filesystems, because something you haven't realised is that XFS
> > > > effectively exposes the on-disk timestamp format directly to
> > > > userspace via the bulkstat interface (see struct xfs_bstat). It also
> > > > affects the XFS open-by-handle ioctl and the swap extent ioctl used
> > > > by the online defragmenter.
> > 
> > I really didn't look at them at all, as ioctl is very late on my
> > mental list of things to change. I do realize that a lot of drivers
> > and file systems do have ioctls that pass time values and we need to
> > address them one by one.
> > 
> > I just looked at the ioctls you mentioned but don't see how open-by-handle
> > is affected by this. Can you point me to what you mean?
> 
> Sorry, I misremembered how some of the XFS open-by-handle code works
> in userspace (XFS has a pretty rich open-by-handle ioctl() interface
> that predates the kernel syscalls by at least 10 years).  Basically
> there is code in userspace that uses the information returned from
> bulkstat to construct file handles to pass to the open-by-handle
> ioctls. xfs_fsr then uses the combination of open-by-handle from the
> bulkstat output and the bulkstat output to feed into the swap extent
> ioctls....
> 
> i.e. the filesystem's idea of what time is is passed to userspace as
> an opaque cookie in this case, but it is not used directly by the
> open-by-handle interfaces like I implied it was.

Ok, I see.

> > My patch set
> > (at least with the 64-bit tv_sec) just gets 32-bit kernels to behave
> > more like 64-bit kernels regarding inode time stamps, which does
> > impact all the file systems that the a 64-bit time or the NFS
> > unsigned epoch (1970-2106), while your patch extends the file
> > system internal epoch (1901-2038 for XFS) so it can be used by
> > anything that knows how to handle larger than 32-bit second values
> > (either 64-bit kernel or 32-bit with inode_time patch).
> 
> Right, but the issue is that 64 bit second counters are broken right
> now because most filesystems can't support more than 32 bit values.
> So it doesn't matter whether it's 32 bit or 64 bit machines, just
> adding explicit support for >32 bit second counters without doing
> anything else just extends that brokenness into the indefinite
> future.

Of course, "most filesystems" are obsolete, and most of the modern
file systems already support >32 bit timestamps: ext4, btrfs, cifs,
f2fs, 9p, nfsv4, ntfs, gfs2, ocfs2, fuse, ufs2. Everything else
except xfs, ext2/3 and exofs uses the nfsv3 interpretation on
64-bit systems, which interprets time stamps with the high bit
set as years 2038-2106 rather than 1903-1969.

> If we don't fix it now (i.e in the new user API and supporting
> infrastructure), then we'll *never be able to fix it* and we'll be
> stuck with timestamps that do really weird things when you pass
> arbitrary future dates to the kernel.

We already have that. I agree it's fixable and we should fix it,
but I don't see how this is different from what we had 20 years
ago when Linux on Alpha first introduced a 64-bit time_t. It's
been this way on every 64-bit Linux system since.

> > This is how ext4 does it (I mean
> > the sizeof() trick, not the bit stuffing they do):
> ....
> > I guess if there is general agreement on introducing 'struct inode_time',
> > we can skip that intermediate step.
> 
> Also, I don't like the concept of having filesystems that will work
> on 64 bit but not 32 bit machines. Over the past 10 years, we've
> managed to remove most of those differences from the VFS and XFS,
> so adding new distinctions between 32/64 bit machines is not the
> direction I want to head in.
> 
> As it is, I'm expecting to do this only after the struct inode_time
> and the superblock "time range" infrastructure have been added to
> the kernel and VFS.  If that change is not made, then we've still
> only got 32 bit time....

Ok.

> > Do you have to manually change it in the
> > superblock? Since most of the time I'd suspect you wouldn't actually
> > use it for the foreseeable future, would it make sense to have a mount
> > option that allows it to be set, but doesn't actually change the
> > superblock until the first inode gets written with a nonzero epoch?
> 
> Yes, we could set the flag on the first timestamp that goes beyond
> the current epoch, but that has two problems:
> 
> 	1. filesystem silently becomes incompatible with older
> 	kernels so failed upgrade rollbacks become problematic; and
> 
> 	2. It adds unecessary complexity, as this will end up being
> 	the default behaviour for all new filesystems within a year.
> 	Then we end up with a mount option and conversion functions
> 	that never get used but we have to support for years....
> 
> > That way, you'd still be able to mount it with an older kernel but
> > also be forward compatible with time moving on.
> 
> We've got plenty of time to roll this out so I don't see any need
> for putting in place temporary support mechanisms that unnecessarily
> complicate the code.

Ok, fair enough.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
