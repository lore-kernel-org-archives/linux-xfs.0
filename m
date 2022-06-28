Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A69BCCA47E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiF1UYv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiF1UYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2771B9;
        Tue, 28 Jun 2022 13:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A34B8203F;
        Tue, 28 Jun 2022 20:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599A2C3411D;
        Tue, 28 Jun 2022 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447689;
        bh=2JOj/dlXSEREQSET8mJRQgRFukJ+oDopxcwXgx8GfoE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iEv6tl7GwXz1dOz/iBAFN/4tTr+9QmL+PAU7/nojB0wTaPzqyT8b0CAo44uCnAN0u
         I8ADdVvUoe0P1S1Tf/xRcZ+pGCZnPpgg3xbNshdXEeEt9D0Q4u6kBg3ye1REoEIYfa
         hro3rFjVhQihqY+Z90vUu4DH50m9M87Uc1uEGjvqoHKblDvUOHqCmj5+nqUxmPAAs4
         EmfXkNksBw1Vbs/vtDFkSSDaTRAMHcQi0IzLDwJ+bUsDDdtXCjQtEgWydPBRfeOjv4
         2Pyv/ZjE8guAF3hP3kU7Jf96D1xUvCWSyFxuN/QuN3zhdM3k+TauxPrb/EGJzU0CCs
         KMxY6yP+SfUMA==
Subject: [PATCH 2/9] xfs/070: filter new superblock verifier messages
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:28 -0700
Message-ID: <165644768886.1045534.3177166462110135738.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In Linux 5.19, the superblock verifier logging changed to elaborate on
what was wrong.  Fix the xfs_repair filtering function to accomodate
this development.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/repair |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/repair b/common/repair
index 463ef9db..398e9904 100644
--- a/common/repair
+++ b/common/repair
@@ -29,6 +29,7 @@ _filter_repair()
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
 s/(pointer to) (\d+)/\1 INO/;
+s/Superblock has bad magic number.*/bad magic number/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;
 s/realtime bitmap inode value /realtime bitmap inode /;

