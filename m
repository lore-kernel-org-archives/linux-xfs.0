Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0F9C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiHIVHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiHIVG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:06:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E354AD61
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 14:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E10B818AE
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 21:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B85C433C1;
        Tue,  9 Aug 2022 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660079212;
        bh=r1x6pqyfqLeUnI3COca5Iuvj0TLG/1Q00AYxwjlC8V0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DTgYEf6c3jmP5r3aZNi7c0UxGPF76VheAkMOlyEuxKjAqy+hPW27bGbxdHBJwFnW1
         uK1IOuYtaUKgwo4sN8l0fS7EnyRxCFjAh41keQzUuJOLRkDFL232IXCDG3fJvvxF3U
         4Qv/bmHliIBXK3tUBUrYX948KywaVWfXtQK/ADmJPqPREtp6oHDKgTYQt9v+DUKGA8
         eF0agef/bS9num/JPEPEVXm5NoWg4Rdhdd0JsErZ8rKDGHbA4vYxskEkC/tr11niNe
         4KpxOU06pD6mb3WPahqGM7UXdbniT8bBlXCsj2+9PjR3Fjq8EPs2Ms+r+we5k8xr5j
         QB6bKyUT9Ed2Q==
Subject: [PATCH 1/2] xfs_repair: fix printf format specifiers on 32-bit
 platforms
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 14:06:51 -0700
Message-ID: <166007921188.3294543.15116997712558160181.stgit@magnolia>
In-Reply-To: <166007920625.3294543.10714247329798384513.stgit@magnolia>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

