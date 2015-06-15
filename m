Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E9D47F4E
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 17:13:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51D80304067
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 15:13:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fQcdRXGwxSi2JqEP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 15:13:52 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 9F4652B51A2
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 22:13:51 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5FMDoMj014852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 18:13:51 -0400
Message-ID: <557F4E1E.8000505@redhat.com>
Date: Mon, 15 Jun 2015 17:13:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix remote symlinks on V5/CRC filesystems
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
To: xfs-oss <xfs@oss.sgi.com>

If we create a CRC filesystem, mount it, and create a symlink with
a path long enough that it can't live in the inode, we get a very
strange result upon remount:

# ls -l mnt
total 4
lrwxrwxrwx. 1 root root 929 Jun 15 16:58 link -> XSLM

XSLM is the V5 symlink block header magic (which happens to be
followed by a NUL, so the string looks terminated).

xfs_readlink_bmap() advanced cur_chunk by the size of the header
for CRC filesystems, but never actually used that pointer; it
kept reading from bp->b_addr, which is the start of the block,
rather than the start of the symlink data after the header.

Looks like this problem goes back to v3.10.

Fixing this gets us reading the proper link target, again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: stable@vger.kernel.org
---

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3df411e..40c0765 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -104,7 +104,7 @@ xfs_readlink_bmap(
 			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
 		}
 
-		memcpy(link + offset, bp->b_addr, byte_cnt);
+		memcpy(link + offset, cur_chunk, byte_cnt);
 
 		pathlen -= byte_cnt;
 		offset += byte_cnt;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
