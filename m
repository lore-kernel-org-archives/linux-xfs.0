Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1912329DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 13:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1F628F8037
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 11:30:26 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 1fSK7YQFs3g3B6X0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 11:30:24 -0700 (PDT)
Date: Mon, 6 May 2013 20:30:20 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Internal error xfs_sb_read_verify at line 726
Message-ID: <20130506183020.GA513@x4>
References: <20130506112717.GA502@x4>
 <5187E290.8090109@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5187E290.8090109@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 2013.05.06 at 12:04 -0500, Eric Sandeen wrote:
> On 5/6/13 6:27 AM, Markus Trippelsdorf wrote:
> > Today I accidentally tried to mount my backup disk at /dev/sdc instead
> > of /dev/sdc1 and this is what happened:
> > 
> > ...
> > EXT4-fs (sdc): VFS: Can't find ext4 filesystem
> > FAT-fs (sdc): bogus number of reserved sectors
> > FAT-fs (sdc): Can't find a valid FAT filesystem
> > FAT-fs (sdc): bogus number of reserved sectors
> > FAT-fs (sdc): Can't find a valid FAT filesystem
> > ISOFS: Unable to identify CD-ROM format.
> > XFS (sdc): bad magic number
> > ffff8800db620000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > ffff8800db620010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > ffff8800db620020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > ffff8800db620030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > XFS (sdc): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff8119e5cd
> 
> This seems to be a recent regression.
> 
> Comments above xfs_sb_quiet_read_verify() indicate that this behavior is
> to be avoided:
> 
>  * We may be probed for a filesystem match, so we may not want to emit
>  * messages when the superblock buffer is not actually an XFS superblock.
> 
> and it checks for proper magic prior to all the chattiness above int
> that function.
> 
> The superblock read is suposed to choose whether to be noisy or not,
> in xfs_readsb():
> 

The following patch fixes the issue for me:


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f6bfbd7..db8f27f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -721,6 +721,11 @@ xfs_sb_read_verify(
 	}
 	error = xfs_sb_verify(bp);
 
+	if (error == XFS_ERROR(EWRONGFS)) {
+		xfs_buf_ioerror(bp, EWRONGFS);
+		return;
+	}
+
 out_error:
 	if (error) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
