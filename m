Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2546EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiF1Utq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiF1Utq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6601D2CDF4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B54B82013
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDF2C341C8;
        Tue, 28 Jun 2022 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449382;
        bh=zUTryASuyNnHTWz9bmXwIAR5FK2rMi5Wbcn0zdMHOsg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CRG+yH8KyVn8gy5/jamzEkjLfy681fj82OsTsCJS/1O4HG4CNUpIiarTICBfP1lUe
         4A3H8pCdPevn5ASvHnaTaUA++V1upZCKWn6TTpRoi8XxUg3CLptzyUO+9eEuQ/NHr5
         E9A0JfHeRy1rN9bbm80zddqXSd0bcjJ/SVna1/Ce0xKmzZkFMTkN8twwyenEDI8UzL
         vmo6LHAYo8A0eAoDxZEUTdhhD5lv47DRIgbUvSL7WHduDebjg9IuBsdZHwddvo9qEj
         DZbVK+Q6Kj6l3oI9K8H5r5/Xd+0cPEaYfP1fSZOYxSCnhxVlrT5GUe3TvJlQOlkcdF
         FH3P5RIr7Fr3w==
Subject: [PATCH 5/6] mkfs: document the large extent count switch in the
 --help screen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:42 -0700
Message-ID: <165644938238.1089996.650756637007296156.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We should document this feature in the --help screen for mkfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a4705ee4..db322b3a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -952,7 +952,7 @@ usage( void )
 			    sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1,sparse=0|1]\n\
+			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\

