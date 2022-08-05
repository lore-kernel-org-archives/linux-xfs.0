Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA89C3F6B0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 02:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiHECkX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 22:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiHECkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 22:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340566166
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 19:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2319B827D4
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A882C433D6;
        Fri,  5 Aug 2022 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659667217;
        bh=JGyT4ty6r+s5vVoBYm+JfD9Oy5cRdg83Und3tvN1FEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o+b/kWRVED3HxveETbT+JFFTsOqp0jkIX7POz1kAE0uzYsE5xE88j7qfafwfFl9+x
         o9lbGur17C/VTtjhH2u+I193AYl8fFKXX2J3sZu8MFL2pgSI/n7K66oem3qYXy/5kS
         pElsA1yC4v6fz+WI+cVBI9f22xXjhATsWpxybiZBzgHxJ3aKYbLvFCYQTe+ORMwFxY
         RKwUm6iPDMQo57zLLswpeMffCirgU/nTIoy+jNyLk3yY0jVAKojFR/xYXcrssGpDie
         VswzkUS6Zo2MjKaqV1eW255vEHUJYy1C4yr4lAmh5Uj2JgdD+2sVXqBJfUdDDnW7eL
         +BuBlSz6lUOgw==
Date:   Thu, 4 Aug 2022 19:40:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/1] xfs_repair: fix printf format specifiers on 32-bit
 platforms
Message-ID: <YuyDEDALtN4f6J4/@magnolia>
References: <165826708900.3268805.5228849676662461141.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <165826708900.3268805.5228849676662461141.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

armv7l builds spit out the following warnings:

In file included from ../include/platform_defs.h:44,
                 from ../include/libxfs.h:13,
                 from bmap.c:7:
bmap.c: In function ‘blkmap_alloc’:
bmap.c:41:11: error: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘xfs_extnum_t’ {aka ‘long long unsigned int’} [-Werror=format=]
   41 |         _("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
      |           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bmap.c:41:9: note: in expansion of macro ‘_’
   41 |         _("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
      |         ^
bmap.c:41:58: note: format string is defined here
   41 |         _("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
      |                                                         ~^
      |                                                          |
      |                                                          int
      |                                                         %lld
In file included from ../include/platform_defs.h:44,
                 from ../include/libxfs.h:13,
                 from bmap.c:7:
bmap.c:54:35: error: format ‘%zu’ expects argument of type ‘size_t’, but argument 2 has type ‘xfs_extnum_t’ {aka ‘long long unsigned int’} [-Werror=format=]
   54 |                         do_warn(_("malloc failed in blkmap_alloc (%zu bytes)\n"),
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bmap.c:54:33: note: in expansion of macro ‘_’
   54 |                         do_warn(_("malloc failed in blkmap_alloc (%zu bytes)\n"),
      |                                 ^
bmap.c:54:69: note: format string is defined here
   54 |                         do_warn(_("malloc failed in blkmap_alloc (%zu bytes)\n"),
      |                                                                   ~~^
      |                                                                     |
      |                                                                     unsigned int
      |                                                                   %llu

Fix these.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c |    8 ++++----
 repair/bmap.c       |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 82e1f682..836156e0 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -493,16 +493,16 @@ xlog_print_trans_inode_core(
 	nextents = ip->di_big_nextents;
     else
 	nextents = ip->di_nextents;
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%llx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, nextents);
+	   ip->di_extsize, (unsigned long long)nextents);
 
     if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
 	nextents = ip->di_big_anextents;
     else
 	nextents = ip->di_anextents;
-    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   nextents, (int)ip->di_forkoff, ip->di_dmevmask, ip->di_dmstate);
+    printf(_("naextents 0x%llx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   (unsigned long long)nextents, (int)ip->di_forkoff, ip->di_dmevmask, ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
     if (ip->di_version == 3) {
diff --git a/repair/bmap.c b/repair/bmap.c
index 44e43ab4..cd1a8b07 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -38,10 +38,10 @@ blkmap_alloc(
 #if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
 	if (nex > BLKMAP_NEXTS_MAX) {
 		do_warn(
-	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
+	_("Number of extents requested in blkmap_alloc (%llu) overflows 32 bits.\n"
 	  "If this is not a corruption, then you will need a 64 bit system\n"
 	  "to repair this filesystem.\n"),
-			nex);
+			(unsigned long long)nex);
 		return NULL;
 	}
 #endif
@@ -51,8 +51,8 @@ blkmap_alloc(
 	if (!blkmap || blkmap->naexts < nex) {
 		blkmap = realloc(blkmap, BLKMAP_SIZE(nex));
 		if (!blkmap) {
-			do_warn(_("malloc failed in blkmap_alloc (%zu bytes)\n"),
-				BLKMAP_SIZE(nex));
+			do_warn(_("malloc failed in blkmap_alloc (%llu bytes)\n"),
+				(unsigned long long)BLKMAP_SIZE(nex));
 			return NULL;
 		}
 		pthread_setspecific(key, blkmap);
