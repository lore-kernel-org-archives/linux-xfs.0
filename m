Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0A4C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjBPVDN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPVDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:03:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D692A16F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A5AB8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ED6C433D2;
        Thu, 16 Feb 2023 21:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581388;
        bh=xOrrU5sb2aMdnsZ1/qSxdUGBJNZl7InBE75xBzthy6A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MTHz73iGr+m9rA+l6i8msrNOz3jokTHMvW8LY0jqxxScHFEmQcozFdORRmJTGaNOo
         I/XoQhSysN9lKvSfQWVO+tUWwl0av/chr5qoxN6LEKK/3LlqKxWc6LcMBDeLrEn6V1
         ttGDCZ+XdkxdH/gW8vWBBZH4RX9WsWfzV29JtdQz4/vSDoTUDtoecFXqDgto0mNmk/
         VR/rLzU1hZfkkH7kmezTDxhjXdQtjC2Ck5DHoByhEFZRRWssYRHbZMCaid9ITsPqu+
         UgVzNmCdkMvipln/NE1sziF1Yq7vGroACVGVJgmKa/3hDdCUMnsGPpNH2Hx0nHIkgA
         969RaoaiBTJ2A==
Date:   Thu, 16 Feb 2023 13:03:08 -0800
Subject: [PATCH 6/6] xfs_db: obfuscate dirent and pptr names consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879975.3476911.17527186602594776178.stgit@magnolia>
In-Reply-To: <167657879895.3476911.2211427543938389071.stgit@magnolia>
References: <167657879895.3476911.2211427543938389071.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When someone wants to perform an obfuscated metadump of a filesystem
where parent pointers are enabled, we have to use the *exact* same
obfuscated name for both the directory entry and the parent pointer.
Instead of using an RNG to influence the obfuscated name, use the dirent
inode number to start the obfuscated name.  This makes them consistent,
though the resulting names aren't quite so full of control characters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43..bb441fbb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -740,12 +740,14 @@ nametable_add(xfs_dahash_t hash, int namelen, unsigned char *name)
 #define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
 
 static inline unsigned char
-random_filename_char(void)
+random_filename_char(xfs_ino_t	ino)
 {
 	static unsigned char filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 						"abcdefghijklmnopqrstuvwxyz"
 						"0123456789-_";
 
+	if (ino)
+		return filename_alphabet[ino % (sizeof filename_alphabet - 1)];
 	return filename_alphabet[random() % (sizeof filename_alphabet - 1)];
 }
 
@@ -815,6 +817,7 @@ in_lost_found(
  */
 static void
 obfuscate_name(
+	xfs_ino_t	ino,
 	xfs_dahash_t	hash,
 	size_t		name_len,
 	unsigned char	*name)
@@ -842,7 +845,7 @@ obfuscate_name(
 	 * Accumulate its new hash value as we go.
 	 */
 	for (i = 0; i < name_len - 5; i++) {
-		*newp = random_filename_char();
+		*newp = random_filename_char(ino);
 		new_hash = *newp ^ rol32(new_hash, 7);
 		newp++;
 	}
@@ -1207,7 +1210,10 @@ generate_obfuscated_name(
 	/* Obfuscate the name (if possible) */
 
 	hash = libxfs_da_hashname(name, namelen);
-	obfuscate_name(hash, namelen, name);
+	if (xfs_has_parent(mp))
+		obfuscate_name(ino, hash, namelen, name);
+	else
+		obfuscate_name(0, hash, namelen, name);
 
 	/*
 	 * Make sure the name is not something already seen.  If we
@@ -1320,7 +1326,7 @@ obfuscate_path_components(
 			/* last (or single) component */
 			namelen = strnlen((char *)comp, len);
 			hash = libxfs_da_hashname(comp, namelen);
-			obfuscate_name(hash, namelen, comp);
+			obfuscate_name(0, hash, namelen, comp);
 			break;
 		}
 		namelen = slash - (char *)comp;
@@ -1331,7 +1337,7 @@ obfuscate_path_components(
 			continue;
 		}
 		hash = libxfs_da_hashname(comp, namelen);
-		obfuscate_name(hash, namelen, comp);
+		obfuscate_name(0, hash, namelen, comp);
 		comp += namelen + 1;
 		len -= namelen + 1;
 	}
@@ -1407,10 +1413,15 @@ process_sf_attr(
 		}
 
 		if (obfuscate) {
-			generate_obfuscated_name(0, asfep->namelen,
-						 &asfep->nameval[0]);
-			memset(&asfep->nameval[asfep->namelen], 'v',
-			       asfep->valuelen);
+			if (asfep->flags & XFS_ATTR_PARENT) {
+				generate_obfuscated_name(cur_ino, asfep->valuelen,
+					 &asfep->nameval[asfep->namelen]);
+			} else {
+				generate_obfuscated_name(0, asfep->namelen,
+							 &asfep->nameval[0]);
+				memset(&asfep->nameval[asfep->namelen], 'v',
+				       asfep->valuelen);
+			}
 		}
 
 		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
@@ -1785,7 +1796,7 @@ process_attr_block(
 						(long long)cur_ino);
 				break;
 			}
-			if (obfuscate) {
+			if (obfuscate && !(entry->flags & XFS_ATTR_PARENT)) {
 				generate_obfuscated_name(0, local->namelen,
 					&local->nameval[0]);
 				memset(&local->nameval[local->namelen], 'v',
@@ -1797,6 +1808,9 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
 				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
 				 nlen + vlen);
+			if (obfuscate && (entry->flags & XFS_ATTR_PARENT))
+				generate_obfuscated_name(cur_ino, vlen,
+						&local->nameval[nlen]);
 			if (zero_stale_data)
 				memset(&local->nameval[nlen + vlen], 0, zlen);
 		} else {

