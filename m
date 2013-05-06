Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 227D829DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 12:04:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A37FCAC008
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 10:04:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xPNIRSBNFSHMAeom for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 10:04:17 -0700 (PDT)
Message-ID: <5187E290.8090109@sandeen.net>
Date: Mon, 06 May 2013 12:04:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Internal error xfs_sb_read_verify at line 726
References: <20130506112717.GA502@x4>
In-Reply-To: <20130506112717.GA502@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On 5/6/13 6:27 AM, Markus Trippelsdorf wrote:
> Today I accidentally tried to mount my backup disk at /dev/sdc instead
> of /dev/sdc1 and this is what happened:
> 
> ...
> EXT4-fs (sdc): VFS: Can't find ext4 filesystem
> FAT-fs (sdc): bogus number of reserved sectors
> FAT-fs (sdc): Can't find a valid FAT filesystem
> FAT-fs (sdc): bogus number of reserved sectors
> FAT-fs (sdc): Can't find a valid FAT filesystem
> ISOFS: Unable to identify CD-ROM format.
> XFS (sdc): bad magic number
> ffff8800db620000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff8800db620010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff8800db620020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff8800db620030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> XFS (sdc): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff8119e5cd

This seems to be a recent regression.

Comments above xfs_sb_quiet_read_verify() indicate that this behavior is
to be avoided:

 * We may be probed for a filesystem match, so we may not want to emit
 * messages when the superblock buffer is not actually an XFS superblock.

and it checks for proper magic prior to all the chattiness above int
that function.

The superblock read is suposed to choose whether to be noisy or not,
in xfs_readsb():

reread:
        bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
                                   BTOBB(sector_size), 0,
                                   loud ? &xfs_sb_buf_ops
                                        : &xfs_sb_quiet_buf_ops);

so it looks like this *should* be working properly.

I'll look into it and send a patch in a a bit.

(FWIW though, I don't get this probing from the kernel; I only
see it if I specify a -t xfs type on the mount command)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
