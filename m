Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA1BC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiDKW5j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350488AbiDKW5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581FC13FBD;
        Mon, 11 Apr 2022 15:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9182616CA;
        Mon, 11 Apr 2022 22:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5497BC385A4;
        Mon, 11 Apr 2022 22:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717714;
        bh=BeLksA9BwxA4ffS1xEJjGHR2kUFHyaW+5K/3ICaXEzU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V3DoP+tzBR9B2lUPB6HQzy2vMK3B2obIGMIhOF/8T04D0Stm+Ml8PZp4uA2UQX4BT
         45+9ILjs/0cr59OKX3K96o+nPpxll9XXnqAVeo7QHGQirfircWBbY8eVpXspX2kJVb
         IHf9laOJ5+i+mUdP4hvwdJB38HOCHY6bVdOKB1Qas7QFc1Hv8zSI0hLVLR/BF+p3n9
         l78DHVTEYPKOcrggRdZNUvDGfRzUC3Xm9mkMQQZ+WXgpcnTBVTV+aS2b+N2k218RGU
         bmAVuXln1lPDl/6AY6lWAQUBnJuwmPlfd0WwtIxxe/5aEz47ge/cEvA6kcVhgrI/Ct
         IBI8ZBCabIafw==
Subject: [PATCH 3/3] xfs/216: handle larger log sizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:55:13 -0700
Message-ID: <164971771391.170109.16368399851366024102.stgit@magnolia>
In-Reply-To: <164971769710.170109.8985299417765876269.stgit@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

mkfs will soon refuse to format a log smaller than 64MB, so update this
test to reflect the new log sizing calculations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/216.out |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/216.out b/tests/xfs/216.out
index cbd7b652..3c12085f 100644
--- a/tests/xfs/216.out
+++ b/tests/xfs/216.out
@@ -1,10 +1,10 @@
 QA output created by 216
-fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
-fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
+fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
 fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
 fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2

