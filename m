Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E1DC43219
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKICGQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKICGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7AF67F43
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A734B81CD7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A4FC433C1;
        Wed,  9 Nov 2022 02:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959571;
        bh=fZ73h36H4v2wozkAxjWHI56L2pG6glQNaBVXoAieXOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rs0T5bmqnZ9lMg04sB9qRX5DhhzpiBL8dSSnCqvWFoSJ6SN4qjzWNaavyiysC2uxu
         B4pKWFbEZmvGfsMeL8TGlxmrsoJOaHJmAW1NCy6K6bLdvr6zpdib6tWvgH+HO5fp5b
         xu2iXWKWwIoXaOCiDkHbe0E9BAC94X3k7HUNR/I8VuyU3bWZXkaC7Km09+pAd6avZf
         iWTeVbA8I7EhTzr8OGJ5x5oJVbAF4h0PoLl4/1xNewHZ5P2X0HUSqViwk218lI66Jl
         lFo8dENPJfNO5gcfRFSl6eYQU7ia3OUGf4Fu8mQ1JVHxuMq03gkVuAifO/8J3uTY69
         kIlR0/T/QKn0Q==
Subject: [PATCH 05/24] treewide: use prandom_u32_max() when possible, part 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yury Norov <yury.norov@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jan Kara <jack@suse.cz>,
        =?utf-8?q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:10 -0800
Message-ID: <166795957064.3761583.12187898025422805623.stgit@magnolia>
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

Source kernel commit: 81895a65ec63ee1daec3255dc1a06675d2fbe915

Rather than incurring a division or requesting too many random bytes for
the given range, use the prandom_u32_max() function, which only takes
the minimum required bytes from the RNG and avoids divisions. This was
done mechanically with this coccinelle script:

@basic@
expression E;
type T;
identifier get_random_u32 =~ "get_random_int|prandom_u32|get_random_u32";
typedef u64;
@@
(
- ((T)get_random_u32() % (E))
+ prandom_u32_max(E)
|
- ((T)get_random_u32() & ((E) - 1))
+ prandom_u32_max(E * XXX_MAKE_SURE_E_IS_POW2)
|
- ((u64)(E) * get_random_u32() >> 32)
+ prandom_u32_max(E)
|
- ((T)get_random_u32() & ~PAGE_MASK)
+ prandom_u32_max(PAGE_SIZE)
)

@multi_line@
identifier get_random_u32 =~ "get_random_int|prandom_u32|get_random_u32";
identifier RAND;
expression E;
@@

-       RAND = get_random_u32();
... when != RAND
-       RAND %= (E);
+       RAND = prandom_u32_max(E);

// Find a potential literal
@literal_mask@
expression LITERAL;
type T;
identifier get_random_u32 =~ "get_random_int|prandom_u32|get_random_u32";
position p;
@@

((T)get_random_u32()@p & (LITERAL))

// Add one to the literal.
@script:python add_one@
literal << literal_mask.LITERAL;
RESULT;
@@

value = None
if literal.startswith('0x'):
value = int(literal, 16)
elif literal[0] in '123456789':
value = int(literal, 10)
if value is None:
print("I don't know how to handle %s" % (literal))
cocci.include_match(False)
elif value == 2**32 - 1 or value == 2**31 - 1 or value == 2**24 - 1 or value == 2**16 - 1 or value == 2**8 - 1:
print("Skipping 0x%x for cleanup elsewhere" % (value))
cocci.include_match(False)
elif value & (value + 1) != 0:
print("Skipping 0x%x because it's not a power of two minus one" % (value))
cocci.include_match(False)
elif literal.startswith('0x'):
coccinelle.RESULT = cocci.make_expr("0x%x" % (value + 1))
else:
coccinelle.RESULT = cocci.make_expr("%d" % (value + 1))

// Replace the literal mask with the calculated result.
@plus_one@
expression literal_mask.LITERAL;
position literal_mask.p;
expression add_one.RESULT;
identifier FUNC;
@@

-       (FUNC()@p & (LITERAL))
+       prandom_u32_max(RESULT)

@collapse_ret@
type T;
identifier VAR;
expression E;
@@

{
-       T VAR;
-       VAR = (E);
-       return VAR;
+       return E;
}

@drop_var@
type T;
identifier VAR;
@@

{
-       T VAR;
... when != VAR
}

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: KP Singh <kpsingh@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 libxfs/xfs_alloc.c  |    2 +-
 libxfs/xfs_ialloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 271c48dd83..3e310ce3e5 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1516,7 +1516,7 @@ xfs_alloc_ag_vextent_lastblock(
 
 #ifdef DEBUG
 	/* Randomly don't execute the first algorithm. */
-	if (prandom_u32() & 1)
+	if (prandom_u32_max(2))
 		return 0;
 #endif
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f27de1fdd0..18f3dea5f5 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -631,7 +631,7 @@ xfs_ialloc_ag_alloc(
 	/* randomly do sparse inode allocations */
 	if (xfs_has_sparseinodes(tp->t_mountp) &&
 	    igeo->ialloc_min_blks < igeo->ialloc_blks)
-		do_sparse = prandom_u32() & 1;
+		do_sparse = prandom_u32_max(2);
 #endif
 
 	/*

