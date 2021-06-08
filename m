Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D295CC4743F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B63B561351
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhFHRVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhFHRVV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08D2361359;
        Tue,  8 Jun 2021 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172768;
        bh=Qa57kI1fGHkYAMkToh9ejc4GN8tRVM+CoTHt5jT/UKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dT0B+RnjwBRIlEyf/sFlG6bvMtHOc2k6mXDda0BDs54+KXawrYT1TFz6pZ2hXq+bN
         P06uW50xZHzItyEcqrC9J6sgua3ChvM+/FL0j3fPUt4tH9c5uplhbGBNsSR6EIh1yU
         ral00v+lJQYSzCyj8gvfMCmsFslzzBBluGipbIbTiGsB/yMGBmogjQ9ACFuhFqBlUC
         UndgH+bzb6HjJnpV3pVspFU2/3yEkOJ9251vjFj/WWmh5yyAnuAC8qFbYQ9KytvAXr
         +S3q7axj8w1/X0jjeelpo/ojfM8nKl5H7fX2U+y5cSdf1y2AuCK/DICsBWuTfDcLdY
         4vfQXYReOb5og==
Subject: [PATCH 01/13] fstests: fix group check in new script
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:19:27 -0700
Message-ID: <162317276776.653489.15862429375974956030.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the tests/*/group files, group names are found in the Nth columns of
the file, where N > 1.  The grep expression to warn about unknown groups
is not correct (since it currently checks column 1), so fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/new b/new
index bb427f0d..357983d9 100755
--- a/new
+++ b/new
@@ -243,10 +243,7 @@ else
     #
     for g in $*
     do
-	if grep "^$g[ 	]" $tdir/group >/dev/null
-	then
-	    :
-	else
+	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
 	    echo "Warning: group \"$g\" not defined in $tdir/group"
 	fi
     done

