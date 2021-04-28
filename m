Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4971C43470
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 954BD613E5
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhD1EJt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhD1EJp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A066140B;
        Wed, 28 Apr 2021 04:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582930;
        bh=4PwztGnSxWZ/VL6GvbuVYk2rwUt/YXaCyz2ijRT7LHs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dlbWci5t2n/UQv3wyarjorqGEDDuUfbknxOrEYI5Bhg2jwk8USDAs3sKntRTEm8lO
         JcYd8U8z43CVNfJX0XnhKpOSKWQBE9aT7lp18RlPziPZlBthXuIwp+ajGsxnD4jmFk
         O62pcEw97uMmnlkKZjDjrzbpHGe9Lbor5rCm6oW7JhwQEwF8FNC/rf3Mmo1eLtpCIq
         la7sS/HCZ46J6ulLmFOvjmCOz28pZ9FcbAdJgzC+XuO7PD++T9KQo7AAXX02V8N8FH
         pAfigX/xwlg1N6QEAYmE2q8g4LS5mnc/zPWVFJj19QSD/N7U+IflJL08SIHGNpEcEV
         gDWvIKwF5HKIg==
Subject: [PATCH 2/2] xfs/010: filter out bad finobt levels complaint
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:08:50 -0700
Message-ID: <161958292995.3452247.16052548384852587095.stgit@magnolia>
In-Reply-To: <161958291787.3452247.15296911612919535588.stgit@magnolia>
References: <161958291787.3452247.15296911612919535588.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we're adding to xfs_repair the ability to warn about bad finobt
levels, filter that out.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/010 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/010 b/tests/xfs/010
index 95cc2555..a9394077 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -114,6 +114,7 @@ _corrupt_finobt_root $SCRATCH_DEV
 
 filter_finobt_repair() {
 	sed -e '/^agi has bad CRC/d' \
+	    -e '/^bad levels/d' \
 	    -e '/^bad finobt block/d' | \
 		_filter_repair_lostblocks
 }

