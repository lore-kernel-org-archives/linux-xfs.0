Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BAAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiF1UvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1UvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:51:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CCF32EFE
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B54C9B81F9B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7F6C341C8;
        Tue, 28 Jun 2022 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449460;
        bh=HTKQNi/1gFd+EGLf8sC6BzRjEBjTKlgrS9rBNpdivjI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sn2CYCke8F27HDsxnaQNEFyuxaDRiCkFH7EqdB9/yJ4n5ZnSMbM/wSfVPFnNRadW6
         HF7mmhPJfgLla6jAuDiNcAeDI4p+/Qw+yobyIfVEAxj2lB5s2WPkD2dNdU7birGpUq
         qjVSJ17lnmNKRKggyEysFa/ID5M92KU+x6ytuz0Ji+HRvjTVsIaicDHnbpbzLvUGgd
         PmGAhIB+iLhIbr6znn/9Is5Sb4eEXjQellUqKlzda2DHnUSZfLoHDgOhfyc7MyK+Aq
         +IqdGfjRGcPsP3E1P9j+oVGdXFDxrdvQ8zL4mlJgSzzjFfkS8atBL0/EhY7iGwDu78
         7j9yOGK2shGCQ==
Subject: [PATCH 1/1] xfs_db: identify the minlogsize transaction reservation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:51:00 -0700
Message-ID: <165644946000.1091822.9533075738203869891.stgit@magnolia>
In-Reply-To: <165644945449.1091822.7139201675279236986.stgit@magnolia>
References: <165644945449.1091822.7139201675279236986.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Right now, we don't make it easy to spot the transaction reservation
used to compute the minimum log size in userspace:

# xfs_db -c logres /dev/sda
type 0 logres 168184 logcount 5 flags 0x4
...
type 25 logres 760 logcount 0 flags 0x0
type -1 logres 547200 logcount 8 flags 0x4

Type "-1" doesn't communicate the purpose at all, it just looks like a
math error.  Help out the user a bit by printing more information:

minlogsize logres 547200 logcount 8

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/logformat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/db/logformat.c b/db/logformat.c
index 38b0af11..5edaa549 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -160,8 +160,10 @@ logres_f(
 	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
 	for (i = 0; res < end_res; i++, res++)
 		print_logres(i, res);
+
 	libxfs_log_get_max_trans_res(mp, &resv);
-	print_logres(-1, &resv);
+	dbprintf(_("minlogsize logres %u logcount %d\n"),
+			resv.tr_logres, resv.tr_logcount);
 
 	return 0;
 }

