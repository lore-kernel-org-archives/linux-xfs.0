Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA41C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E0F613C1
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348953AbhDNBE6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345256AbhDNBE5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:04:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8C68613B6;
        Wed, 14 Apr 2021 01:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362277;
        bh=cgiDZ13ABBPC9pI4equNCaYoOg9yWAJ0nyzpEr46KGU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=urqwu7jjm7vMw8SeDyt4OwBmJyK8bKBhGA0Im0GRUwmXwR9BTV9VNlKFJNu/41KwO
         V41ZYlFiO2mEwujp17jTlmwtqZ4tv6hGoV/4fAaMBlWUgXjb23v7GixrsXq4h6TU1h
         Z1gdRu8GNWXrMaxmez88/0XhWVIwk/zULrrzo5JCLwX+X69YE6piFJ+MdVyEIpCwCe
         kwISRrVN8aOxcrXHpmhSLCkREmNyCAKUJBl0nbQUDi5hqR448RcBWwr2dMA2v0SixP
         VMBQimYOiESBSUAT+L9z8i+gBa5bJekz0/QoiqTgEUtX2SzNJKxUavJ61t2goncPyq
         1VuL1c3DH9+qg==
Subject: [PATCH 1/9] xfs/506: fix regression on freshly quotachecked
 filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:04:36 -0700
Message-ID: <161836227616.2754991.13243990456152675669.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The first thing this test checks is that the health command reports that
nothing has been checked.  This isn't true if we regenerated the quota
counts when we mounted the filesystem (and hence they're marked healthy
and checked), so cycle the mount to get rid of that state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/506 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/506 b/tests/xfs/506
index ddda8614..7e553849 100755
--- a/tests/xfs/506
+++ b/tests/xfs/506
@@ -36,6 +36,7 @@ rm -f $seqres.full
 
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount
+_scratch_cycle_mount	# make sure we haven't run quotacheck on this mount
 
 # Haven't checked anything, it should tell us to run scrub
 $XFS_SPACEMAN_PROG -c "health" $SCRATCH_MNT

