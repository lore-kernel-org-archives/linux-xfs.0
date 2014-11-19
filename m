Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26C637F3F
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 16:12:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AACABAC001
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 14:12:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kwnBBm5dhjthbYfW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Nov 2014 14:12:53 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAJMCq9X025043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 17:12:52 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAJMCpnB000656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 17:12:52 -0500
Message-ID: <546D15E3.5000200@redhat.com>
Date: Wed, 19 Nov 2014 16:12:51 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: catch invalid negative blknos in _xfs_buf_find()
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

Here blkno is a daddr_t, which is a __s64; it's possible to hold
a value which is negative, and thus pass the (blkno >= eofs)
test.  Then we try to do a xfs_perag_get() for a ridiculous
agno via xfs_daddr_to_agno(), and bad things happen when that
fails, and returns a null pag which is dereferenced shortly
thereafter.

Found via a user-supplied fuzzed image...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 24b4ebe..f54a497 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -463,7 +463,7 @@ _xfs_buf_find(
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
 	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (blkno >= eofs) {
+	if (blkno < 0 || blkno >= eofs) {
 		/*
 		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
 		 * but none of the higher level infrastructure supports

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
