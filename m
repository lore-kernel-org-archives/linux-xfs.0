Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 914207F9E
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 14:28:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 160A1AC005
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 12:27:56 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kTjqY63OT2XYIZA3 for <xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 12:27:55 -0800 (PST)
Date: Wed, 13 Feb 2013 07:27:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130212202753.GC26694@dastard>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: sandeen@redhat.com, kzak@redhat.com, xfs@oss.sgi.com

On Tue, Feb 12, 2013 at 12:06:55PM +0100, Lukas Czerner wrote:
> We should wipe off all the signatures from the device prior the file
> system creation. It is because because some file systems (btrfs) may
> still have their signatures on the device which can be confusing for
> userspace possibly resulting in the unmountable file system.
> 
> This patch adds a function which uses libblkid library to wipe all the
> signatures from the device.
> 
> If user disables libblkid library or does not have it installed this new
> feature will not be used. This case can be implemented separately.

mkfs.xfs already zeros the first part of the block device regardless
of whether it is using libblkid or not:

....
/* amount (in bytes) we zero at the beginning and end of the device to
 * remove traces of other filesystems, raid superblocks, etc.
 */
#define WHACK_SIZE (128 * 1024)
....

        /*
         * Zero out the beginning of the device, to obliterate any old
         * filesystem signatures out there.  This should take care of
         * swap (somewhere around the page size), jfs (32k),
         * ext[2,3] and reiserfs (64k) - and hopefully all else.
         */
        mp->m_ddev_targ.dev = xi.ddev;
        mp->m_ddev_targ.bt_mount = mp;
        buf = libxfs_getbuf(mp->m_ddev_targ, 0, BTOBB(WHACK_SIZE));
        memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
        libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
        libxfs_purgebuf(buf);

Isn't 128k of zeroing enough to kill existing filesystem signatures?
If not how much is, and why can't we just change WHACK_SIZE to
reflect the size that will kill those signatures that are further
offset into the device?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
