Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF18C7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 18:09:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E260B304053
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 16:09:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2ifKJnmZAQ6ZK30k for
	<xfs@oss.sgi.com>; Thu, 05 Jun 2014 16:09:16 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s55N9G2w009654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2014 19:09:16 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s55N9FXv001914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2014 19:09:16 -0400
Message-ID: <5390F89C.2050305@redhat.com>
Date: Thu, 05 Jun 2014 18:09:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_mdrestore: initialize sb prior to xfs_sb_from_disk()
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

If we xfs_mdrestore an image from a non-crc filesystem, lo
and behold the restored image has gained a CRC:

# db/xfs_metadump.sh -o /dev/sdc1 - | xfs_mdrestore - test.img
# xfs_db -c "sb 0" -c "p crc" /dev/sdc1
crc = 0 (correct)
# xfs_db -c "sb 0" -c "p crc" test.img
crc = 0xb6f8d6a0 (correct)

Obviously it can't really be correct :)

The problem is, xfs_sb_from_disk doesn't fill in the sb_crc
field.

An earlier commit:

  47de6e1 repair: ensure that unused superblock fields are zeroed

fixed this same sort of problem for xfs_repair.  Do the same
for mdrestore.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

But ... should we maybe just do this once and for all in
xfs_sb_from_disk?  I'm not sure leaving it up to every
caller is a good idea, unless somebody ahs a reason to
pre-populate some fields - I can't imagine why that would
be, though...

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index e57bdb2..0453f17 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -104,6 +104,7 @@ perform_restore(
 			1, src_f) != 1)
 		fatal("error reading from file: %s\n", strerror(errno));
 
+	memset(&sb, 0, sizeof(struct xfs_sb));
 	libxfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
 
 	if (sb.sb_magicnum != XFS_SB_MAGIC)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
