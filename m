Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87F8C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08F661209
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbhIQAkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241749AbhIQAkv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8D8611C8;
        Fri, 17 Sep 2021 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839170;
        bh=GXnxWugkT5bZAzshtv29zeLiGJmJD6UN9batAJhqNx4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aORwphKmzviK+K/5gMHa1J8lpUG3MQsvtf78OvoZCimfrsT+oDzXQmHc8vOFOP3n0
         6KTwQrME5OudROOWdggLBy3mgwT//mOIkVwbUm/FulE8Oup1mlx6fh+rFmetov/b1C
         6z6iP9an7/95BLwybyoSe1a2FkHzCEfvpNelJ60vadl84CuY6VlTAIEm3lzUqu+Yco
         KY4z6i2oxmaNmF28edKSZJZtaqISUPJs3R9J+G+PsH7woBESO0aCBQKgXX5fsoSAKJ
         6He5/Pf+kPPge77msEFd0mr/U1ArpI542ba3GTP5Z5eb3y0QPFON/zg48+w4cpSruK
         M1Q66Ot66kL+Q==
Subject: [PATCH 5/8] generic/631: change this test to use the 'whiteout' group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:30 -0700
Message-ID: <163183917038.952957.10850866042374177399.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test isn't really an overlay test; it's a regression test for a bug
that someone found in xfs handling of whiteout files.  Since the
'overlay' group has one member, let's move it to 'whiteout'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/631 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/631 b/tests/generic/631
index a1acdedb..aae181dd 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -22,7 +22,7 @@
 # in xfs_rename").
 
 . ./common/preamble
-_begin_fstest auto rw overlay rename
+_begin_fstest auto rw whiteout rename
 
 # Override the default cleanup function.
 _cleanup()

