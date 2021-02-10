Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43462C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F09564E5B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBJC5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B3D64E54;
        Wed, 10 Feb 2021 02:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925797;
        bh=AaVPoVeDsBlYC3J3v9d2DT6H+ZioUCv66BBxdeVIgpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TnR0mgerm9lAY83s/zLh0lDQMBTelPIBvYGMOdzMNGefdOeWLXkaIjz6Qll7rf+hh
         5/nGxOAsb2utVVIsCWeBnf60gXuf6f59H9XF8ldWPr8ZuiVmx8tDBLpgfZ5mlpldjp
         NXNu+5bFRg4AWAS6etO9kJpHh6G7mzkCmfWotNMcwseRowN+s7wqR7WberRhqNy7h+
         rqMixGpfwYI6VI6STQwJflJoaDRnUhkTLvEwtD3DEobPfIJYftrMfrFjkECiVC9POl
         XLoQ8/E15UAdWxinq9b+g1jUb71I1FEZe4C9p+jF/R8FeMVCrMTf8yaAcew/lNdJRn
         GClB0MP3gCsJQ==
Subject: [PATCH 3/6] check: allow '-e testid' to exclude a single test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:36 -0800
Message-ID: <161292579650.3504537.2704583548318437413.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This enables us to mask off specific tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/check b/check
index c6ad1d6c..e51cbede 100755
--- a/check
+++ b/check
@@ -79,6 +79,7 @@ testlist options
     -g group[,group...]	include tests from these groups
     -x group[,group...]	exclude tests from these groups
     -X exclude_file	exclude individual tests
+    -e testlist         exclude a specific list of tests
     -E external_file	exclude individual tests
     [testlist]		include tests matching names in testlist
 
@@ -287,6 +288,11 @@ while [ $# -gt 0 ]; do
 
 	-X)	subdir_xfile=$2; shift ;
 		;;
+	-e)
+		xfile=$2; shift ;
+		echo "$xfile" | tr ', ' '\n\n' >> $tmp.xlist
+		;;
+
 	-E)	xfile=$2; shift ;
 		if [ -f $xfile ]; then
 			sed "s/#.*$//" "$xfile" >> $tmp.xlist

