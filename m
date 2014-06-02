Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 078657F6B
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:45:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF785304032
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 04:45:50 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id ykqBmIB3ZIorCObz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 04:45:48 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 13:43:44 +0200
Message-ID: <7106937.MLk03lftzD@wuerfel>
In-Reply-To: <20140602002822.GQ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<20140601002437.GL14410@dastard> <20140602002822.GQ14410@dastard>
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

On Monday 02 June 2014 10:28:22 Dave Chinner wrote:
> On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> > On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > > In my list at http://kernelnewbies.org/y2038, I found that almost
> > > all file systems at least times until 2106, because they treat
> > > the on-disk value as unsigned on 64-bit systems, or they use
> > > a completely different representation. My guess is that somebody
> > > earlier spent a lot of work on making that happen.
> > > 
> > > The exceptions are:
> > > 
> > > * exofs uses signed values, which can probably be changed to be
> > >   consistent with the others.
> > > * isofs has a bug that limits it until 2027 on architectures with
> > >   a signed 'char' type (otherwise it's 2155).
> > > * udf can represent times for many thousands of years through a
> > >   16-bit year representation, but the code to convert to epoch
> > >   uses a const array that ends at 2038.
> > > * afs uses signed seconds and can probably be fixed
> > > * coda relies on user space time representation getting passed
> > >   through an ioctl.
> > > * I miscategorized xfs/ext2/ext3 as having unsigned 32-bit seconds,
> > >   where they really use signed.
> > > 
> > > I was confused about XFS since I didn't noticed that there are
> > > separate xfs_ictimestamp_t and xfs_timestamp_t types, so I expected
> > > XFS to also use the 1970-2106 time range on 64-bit systems today.
> > 
> > You've missed an awful lot more than just the implications for the
> > core kernel code.
> > 
> > There's a good chance such changes propagate to APIs elsewhere in
> > the filesystems, because something you haven't realised is that XFS
> > effectively exposes the on-disk timestamp format directly to
> > userspace via the bulkstat interface (see struct xfs_bstat). It also
> > affects the XFS open-by-handle ioctl and the swap extent ioctl used
> > by the online defragmenter.

I really didn't look at them at all, as ioctl is very late on my
mental list of things to change. I do realize that a lot of drivers
and file systems do have ioctls that pass time values and we need to
address them one by one.

I just looked at the ioctls you mentioned but don't see how open-by-handle
is affected by this. Can you point me to what you mean?

> Just to put that in context, here's the kernel patch to add extended
> epoch support to XFS. It's completely untested as I haven't done any
> userspace code changes to enable the feature. However, it should
> give you an indication of how far the simple act of changing the
> kernel time representation spread through the filesystem. This does
> not include any of the VFS infrastructure to specifying the range of
> supported timestamps.  It survives some smoke testing, but dies when
> the online defragmenter starts using the bulkstat and swap extent
> ioctls (the assert in xfs_inode_time_from_epoch() fires), so I
> probably don't have that all sorted correctly yet...
> 
> To test extended epoch support, however, I need to some fstests that
> define and validate the behaviour of the new syscalls - until we get
> those we can't validate that the filesystem follows the spec
> properly. I also suspect we are going to need an interface to query
> the supported range of timestamps from a filesystem so that we can
> test boundary conditions in an automated fashion....

Thanks a lot for having an initial look at this yourself!

I'd still consider the two problems largely orthogonal. My patch set
(at least with the 64-bit tv_sec) just gets 32-bit kernels to behave
more like 64-bit kernels regarding inode time stamps, which does
impact all the file systems that the a 64-bit time or the NFS
unsigned epoch (1970-2106), while your patch extends the file
system internal epoch (1901-2038 for XFS) so it can be used by
anything that knows how to handle larger than 32-bit second values
(either 64-bit kernel or 32-bit with inode_time patch).

> diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
> index 623bbe8..79f94722 100644
> --- a/fs/xfs/xfs_dinode.h
> +++ b/fs/xfs/xfs_dinode.h
> @@ -21,11 +21,53 @@
>  #define        XFS_DINODE_MAGIC                0x494e  /* 'IN' */
>  #define XFS_DINODE_GOOD_VERSION(v)     ((v) >= 1 && (v) <= 3)
>  
> +/*
> + * Inode timestamps get more complex when we consider supporting times beyond
> + * the standard unix epoch of Jan 2038. The struct xfs_timestamp cannot support
> + * more than a single extension by playing sign games, and that is still not
> + * reliable. We also can't extend the timestamp structure because there is no
> + * free space around them in the on-disk inode.
> + *
> + * Hence the simplest thing to do is to add an epoch counter for each timestamp
> + * in the inode. This can be a single byte for each timestamp and make use of
> + * a hole we currently pad. This gives us another 255 epochs range for the
> + * timestamps, but requires a superblock feature bit to indicate that these
> + * fields have meaning and can be non-zero.

Nice trick!

> +static inline __uint8_t
> +xfs_timestamp_epoch(
> +       struct timespec         *time)
> +{
> +       /* will be zero until the extended struct inode_time is introduced */
> +       return 0;
> +}
> +
> +static inline __int32_t
> +xfs_timestamp_sec(
> +       struct timespec         *time)
> +{
> +       return time->tv_sec;
> +}
> +
> +static inline __kernel_time_t
> +xfs_inode_time_from_epoch(
> +       __uint8_t       epoch,
> +       __int32_t       seconds)
> +{
> +       /* need to handle non-zero epoch when struct inode_time is introduced */
> +       ASSERT(epoch == 0);
> +       return seconds;
> +}

Why don't you already implement epoch conversion for 64-bit kernels that
are able to represent the time today? This is how ext4 does it (I mean
the sizeof() trick, not the bit stuffing they do):

static inline __le32 ext4_encode_extra_time(struct inode_time *time)
{
       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
                           (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
}

static inline void ext4_decode_extra_time(struct inode_time *time, __le32 extra)
{
       if (sizeof(time->tv_sec) > 4)
               time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
                               << 32;
       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
}

I guess if there is general agreement on introducing 'struct inode_time',
we can skip that intermediate step.

> @@ -509,8 +509,11 @@ xfs_sb_has_ro_compat_feature(
>  }
>  
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE     (1 << 0)        /* filetype in dirent */
> +#define XFS_SB_FEAT_INCOMPAT_EPOCH     (1 << 1)        /* Time beyond 2038 */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
> -               (XFS_SB_FEAT_INCOMPAT_FTYPE)
> +               (XFS_SB_FEAT_INCOMPAT_FTYPE | \
> +                XFS_SB_FEAT_INCOMPAT_EPOCH | \
> +                0)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN   ~XFS_SB_FEAT_INCOMPAT_ALL

How does this flag get set? Do you have to manually change it in the
superblock? Since most of the time I'd suspect you wouldn't actually
use it for the foreseeable future, would it make sense to have a mount
option that allows it to be set, but doesn't actually change the
superblock until the first inode gets written with a nonzero epoch?

That way, you'd still be able to mount it with an older kernel but
also be forward compatible with time moving on.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
