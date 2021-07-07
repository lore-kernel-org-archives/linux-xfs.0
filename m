Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D4C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9472961C91
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGGAYD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhGGAYD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC5CF61CAC;
        Wed,  7 Jul 2021 00:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617283;
        bh=84NI+vdNCAjgNt1u6M0ETco3h9hnPRmdnm7wHHgqLPI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tNHwe3zmzmCbkX5Ph1ib4GgjvpMYpEOR2peO1NKU4vA6wpAqSnSZWElbDrNXk/MJG
         fSKZ+V8CcYGXGkuO5i9aVv9KZXrWLKqS16PjuJ93o33nr3TuxGfI5d5AvUpLMrtd2W
         l1u1diQjlM0MzqIbVcB6/iG8qx18uMbLy/bGVHziyK0sKSzBwVsrtCE6/piFNzC6MK
         +kSLlulv/S4dBsKolmpG8u6jT0725k/1vDFcKPQFtSXp6/xM8Y4YyPbv87pbKf3mvG
         5TA7mxp/iCmo2SPN9SF/qP7Zr2qyeIcXeYxt+BhOtIYiK6eEpg8PTsJEzbnEBKHHL7
         257mLtaMHkQpA==
Subject: [PATCH 3/8] shared/298: fix random deletion when filenames contain
 spaces
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:23 -0700
Message-ID: <162561728342.543423.12599584091972556414.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Correct the deletion loop in this test to work properly when there are
files in $here that have spaces in their name.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/shared/298 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/shared/298 b/tests/shared/298
index 981a4dfc..bd52b6a0 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -163,7 +163,7 @@ get_holes $img_file > $fiemap_ref
 
 # Delete some files
 find $loop_mnt -type f -print | $AWK_PROG \
-	'BEGIN {srand()}; {if(rand() > 0.7) print $1;}' | xargs rm
+	'BEGIN {srand()}; {if(rand() > 0.7) printf("%s\0", $0);}' | xargs -0 rm
 echo "done."
 
 echo -n "Running fstrim..."

