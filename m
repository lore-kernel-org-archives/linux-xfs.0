Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3065FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiKICGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF5C67F40
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF028B81619
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90034C433C1;
        Wed,  9 Nov 2022 02:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959576;
        bh=m93GOKQbivFlnvGYZtADaqfmx9hB2rKPdcgU9Qv+Aww=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e077x4Runu4gw7pSc8RLLq7E+o32KJe0NlaEtOBHi8K8aGFkB71XhEdf1BhVhIAUJ
         NpW1K4u4zcdFqA0vRVjYvfm7t/7pyZ5Hm2OayzGtBvqtWT3H9KlbGCqtJMpob2Io0X
         zor4aHDE+QLgk4j0jCBMVCzCe2r89cl39yYysPKKgGqHS231T6194HOSODAByZWChc
         QJOyMFw2RLNUdDv2NIw/c1HaWpdu+wBGWjRAd7B+lWP7MxVZhpEnex7rV0f6VfjBwY
         wL+s3tTGV5nlryoflME+FHnvD8NCk/waQsQlauTOtg8S2eIItfQeUDn3pCye1zypNP
         tu/bulqSN9npQ==
Subject: [PATCH 06/24] treewide: use get_random_u32() when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yury Norov <yury.norov@gmail.com>, Jan Kara <jack@suse.cz>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Helge Deller <deller@gmx.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:16 -0800
Message-ID: <166795957617.3761583.14978349837941360702.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

Source kernel commit: a251c17aa558d8e3128a528af5cf8b9d7caae4fd

The prandom_u32() function has been a deprecated inline wrapper around
get_random_u32() for several releases now, and compiles down to the
exact same code. Replace the deprecated wrapper with a direct call to
the real function. The same also applies to get_random_int(), which is
just a wrapper around get_random_u32(). This was done as a basic find
and replace.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Helge Deller <deller@gmx.de>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 libxfs/libxfs_priv.h |    6 +++---
 libxfs/xfs_ialloc.c  |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b2c3f694b0..ad4b947583 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -225,10 +225,10 @@ static inline bool WARN_ON(bool expr) {
 #define WRITE_ONCE(x, val)		((x) = (val))
 
 /*
- * prandom_u32 is used for di_gen inode allocation, it must be zero for libxfs
- * or all sorts of badness can occur!
+ * get_random_u32 is used for di_gen inode allocation, it must be zero for
+ * libxfs or all sorts of badness can occur!
  */
-#define prandom_u32()		0
+#define get_random_u32()	(0)
 
 #define PAGE_SIZE		getpagesize()
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 18f3dea5f5..e05aa0c11b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -800,7 +800,7 @@ xfs_ialloc_ag_alloc(
 	 * number from being easily guessable.
 	 */
 	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag->pag_agno,
-			args.agbno, args.len, prandom_u32());
+			args.agbno, args.len, get_random_u32());
 
 	if (error)
 		return error;

