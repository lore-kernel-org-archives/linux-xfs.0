Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A9CC001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiLTABf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiLTABe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326B266D;
        Mon, 19 Dec 2022 16:01:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C762A611B3;
        Tue, 20 Dec 2022 00:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BD1C433F0;
        Tue, 20 Dec 2022 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494492;
        bh=osCYtWlvvFAP0wEvCU8bqtrlJt6VUmNOanZLEEPHx7M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jR5XzhJ/4NfEBj9I7x6ZxSZyTEXXtNDMsa8oBcA+gW/CPHUARuKz7WMcO/jAIvU5o
         60S6ifX9sDOtCZceHDmi4vVONZQuumOZ4XPGbKNkW9o5HQ8Fkpr1PR88+iG51I1yw8
         SL3hKGLxDJM5CGvs4CKcjIB83WRnFUMaq/h2WXy2GNlRDcpgn2OZew1PLSZZtCH9b4
         gHpvnrQirXYwOww1r9fhKmqV24ts8Zo4S2hWRfTlztW6A+jZTrknidqG+YUeHS1kYz
         AU5KQN6s4zYmWgKRm1Sebm9h3qPW+zjYvNIDeNTZ4F5RB+DnCPf+XytBdH0Ym/+UzO
         rwxQ9/XgM6rgA==
Subject: [PATCH 5/8] report: pass property value to _xunit_add_property
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:31 -0800
Message-ID: <167149449179.332657.7712352434986216407.stgit@magnolia>
In-Reply-To: <167149446381.332657.9402608531757557463.stgit@magnolia>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change this helper to require the caller to pass the value as the second
parameter.  This prepares us to start reporting a lot more information
about a test run, not all of which are encoded as bash variables.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/report b/common/report
index b415a2641d..642e0426a6 100644
--- a/common/report
+++ b/common/report
@@ -24,9 +24,9 @@ encode_xml()
 _xunit_add_property()
 {
 	local name="$1"
-	local value="${!name}"
+	local value="$2"
 
-	if [ ! -z "$value" ]; then
+	if [ -n "$value" ]; then
 		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
 	fi
 }
@@ -67,7 +67,7 @@ ENDL
 	# Properties
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
 	for p in "${REPORT_ENV_LIST[@]}"; do
-		_xunit_add_property "$p"
+		_xunit_add_property "$p" "${!p}"
 	done | sort >> $REPORT_DIR/result.xml
 	echo -e "\t</properties>" >> $REPORT_DIR/result.xml
 	if [ -f $report ]; then

