Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD5CC4743E
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECD8B61370
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhFHRV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhFHRV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746BB61351;
        Tue,  8 Jun 2021 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172773;
        bh=D/BMXwROd6kHDetTs1ZdeOpLW7yhEGM6D/DMFoKmKaU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CdidKy7LGGEeT+d9Fa+0BmZ9H5O8INqFMAqgu7WBcbbubr0ZhPw+wLDSBDfY5/LB8
         TLlz9rd6v+Pl2ILWtgiamFj9rAy/G6z+82fBcTV8r+2sxUX2/c6XjcXopFXhcARj8n
         XsblP5gnNuAzlxX45XNCcRXEaA0O5ttmkbEANRX12oygp0Xg0k8FjR7iDVYGms5yj6
         zFQfnPi2jilcCZkHxe2hhr3mJ4tb8sLbLSCkcRlOhMv2/fTmkfTCoJANsGMiNbyGWH
         NtM0VX1cMZuohreN22jqjF7JYDBxjSZ2rJfWvd4lFtwx15IVt2qDvMl+tpdnz0H8bH
         CfnKrgEsOPGcA==
Subject: [PATCH 02/13] misc: move exit status into trap handler
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:19:33 -0700
Message-ID: <162317277320.653489.6399691950820962617.stgit@locust>
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

Move the "exit $status" clause of the _cleanup function into the
argument to the "trap" command so that we can standardize the
registration of the atexit cleanup code in the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/068 |    3 +--
 tests/xfs/004     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/tests/generic/068 b/tests/generic/068
index 932a8560..573fbd45 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -22,10 +22,9 @@ _cleanup()
     cd /
 
     trap 0 1 2 3 15
-    exit $status
 }
 
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/004 b/tests/xfs/004
index d3fb9c95..4d92a08e 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -18,9 +18,8 @@ _cleanup()
 {
 	_scratch_unmount
 	rm -f $tmp.*
-	exit $status
 }
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _populate_scratch()
 {

