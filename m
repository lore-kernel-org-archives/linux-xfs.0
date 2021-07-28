Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0866C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F8E6103B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhG1VQP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhG1VQP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2D76101B;
        Wed, 28 Jul 2021 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506973;
        bh=s1TZANbINjWYC2xyIio4wtLLyvJ/FA7J08V5+R5Ard8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DxE8GZMNu613bT6LJrfMzhrFZJVyKoJlvDs5093VZMH2F3ZF9On2GHcmtdH/T9PW1
         7/W3mChkh7zzbHMQhlJWfUvelJQimKGI5/D+4c8nzbQcOOOtMmNvSsY8tpxr8tbRM8
         3SrW5QwMSc9GxzhmPb4+ozaiLZf5vZGr0LmLsB601gwfauIupPI7fhhB32G82RcQuW
         Wup3J0gqZRA7flrSV8Ru3b7ra4jURvCmaTquFbzV/omvvnXK+D4rGvEI9vzOgrJBPd
         hDue0RAhRXvMmvc97TOb/cf/m3T0hmKLFCFM5l2i3/NXHIvA1ZQ2se7IvVxS6icfQ8
         uJAThUPLG/ZIA==
Subject: [PATCH 1/2] xfs_io: only print the header once when dumping fsmap in
 csv format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:13 -0700
Message-ID: <162750697323.45811.16662373563564383023.stgit@magnolia>
In-Reply-To: <162750696777.45811.13113252405327690016.stgit@magnolia>
References: <162750696777.45811.13113252405327690016.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Only print the column names once when we're dumping fsmap information in
csv format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/fsmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index 4b217595..9f179fa8 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -116,7 +116,8 @@ dump_map_machine(
 	struct fsmap		*p;
 	char			*fork;
 
-	printf(_("EXT,MAJOR,MINOR,PSTART,PEND,OWNER,OSTART,OEND,LENGTH\n"));
+	if (*nr == 0)
+		printf(_("EXT,MAJOR,MINOR,PSTART,PEND,OWNER,OSTART,OEND,LENGTH\n"));
 	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
 		printf("%llu,%u,%u,%lld,%lld,", i + (*nr),
 			major(p->fmr_device), minor(p->fmr_device),

