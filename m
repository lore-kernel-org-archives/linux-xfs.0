Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66A627F54
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:16:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 541B53040D2
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 11:16:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JIDiZvltIM0H8m0J for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 11:16:35 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3195B63CDA11
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:16:35 -0500 (CDT)
Message-ID: <559AC602.5050309@sandeen.net>
Date: Mon, 06 Jul 2015 13:16:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] metadump: Fill attribute values with 'v' rather than NUL
References: <559AC5AA.5040900@sandeen.net>
In-Reply-To: <559AC5AA.5040900@sandeen.net>
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

Rather than memset attribute values to '\0', use the character 'v' -
otherwise in some cases we get attributes with a non-zero value
length which start with a NUL, and that makes some userspace tools
unhappy, yielding results like this:

security.oO^Lio.=0sAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index 2286b71..a30f90e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1083,8 +1083,8 @@ obfuscate_sf_attr(
 	xfs_dinode_t		*dip)
 {
 	/*
-	 * with extended attributes, obfuscate the names and zero the actual
-	 * values.
+	 * with extended attributes, obfuscate the names and fill the actual
+	 * values with 'v' (to see a valid string length, as opposed to NULLs)
 	 */
 
 	xfs_attr_shortform_t	*asfp;
@@ -1124,7 +1124,7 @@ obfuscate_sf_attr(
 		}
 
 		generate_obfuscated_name(0, asfep->namelen, &asfep->nameval[0]);
-		memset(&asfep->nameval[asfep->namelen], 0, asfep->valuelen);
+		memset(&asfep->nameval[asfep->namelen], 'v', asfep->valuelen);
 
 		asfep = (xfs_attr_sf_entry_t *)((char *)asfep +
 				XFS_ATTR_SF_ENTSIZE(asfep));
@@ -1302,7 +1302,7 @@ obfuscate_attr_block(
 				/* magic to handle attr and attr3 */
 				memset(block +
 					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
-				      0, XFS_ATTR3_RMT_BUF_SPACE(mp, bs));
+				      'v', XFS_ATTR3_RMT_BUF_SPACE(mp, bs));
 		}
 		return;
 	}
@@ -1339,7 +1339,7 @@ obfuscate_attr_block(
 			}
 			generate_obfuscated_name(0, local->namelen,
 				&local->nameval[0]);
-			memset(&local->nameval[local->namelen], 0,
+			memset(&local->nameval[local->namelen], 'v',
 				be16_to_cpu(local->valuelen));
 		} else {
 			remote = xfs_attr3_leaf_name_remote(leaf, i);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
