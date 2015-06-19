Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B1197F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:30:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D28E304032
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 13:30:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ToF5RFNdnB7QihKU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 13:30:35 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 958E12F811F
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 20:30:34 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5JKUWY3016155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 16:30:34 -0400
Message-ID: <55847BE8.8010908@redhat.com>
Date: Fri, 19 Jun 2015 15:30:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: obfuscate remote symlinks on CRC filesystems
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

On CRC filesystems, the symlink block starts with a header,
which contains magic, "XLSM"

The code happens to "work" today w/o corrupting anything,
because it seems "XSLM" as a string, decides it's too short
to obfuscate, and leaves it alone.

But the real symlink target is untouched.  Fix that by moving
the pointer to the string we want to obfuscate by the size
of the header, and shorten the length to obfuscate accordingly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index a599571..80a41cd 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1239,8 +1239,12 @@ static void
 obfuscate_symlink_block(
 	char			*block)
 {
-	/* XXX: need to handle CRC headers */
-	obfuscate_path_components(block, mp->m_sb.sb_blocksize);
+	if (xfs_sb_version_hascrc(&(mp)->m_sb))
+		block += sizeof(struct xfs_dsymlink_hdr);
+
+	obfuscate_path_components(block,
+				  XFS_SYMLINK_BUF_SPACE(mp,
+					mp->m_sb.sb_blocksize));
 }
 
 #define MAX_REMOTE_VALS		4095

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
