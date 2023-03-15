Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A4EC7618D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCOAxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCOAxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8E41B75;
        Tue, 14 Mar 2023 17:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75DF61A9D;
        Wed, 15 Mar 2023 00:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E99C433D2;
        Wed, 15 Mar 2023 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841585;
        bh=5ZjDhw74kNEdDtZQQatDNNzQ8pK7OUwxcc6xRLiOFg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M5v1BNKGdIXeMG1W+2+UnJeX81uKs7wPTeZ10nNA47W7rJ8PfgVG1iPz1W5vkuYvC
         n0nmo7r1XCMrrJ7EOc5ew0msHDb8WVEqPq6O0t+VGu6PTJfxLKCWeDvLZOsu8ZRQRM
         GyYK6rq2LZkevUyujdHsaVfZWsLxliiPDCgNgtaU2a5bC5ifvAO2nnG/OqT/7k4+wo
         u84yCYrFBR7H36bW2+I3uYMwlGe/QusWzepEK5VhkZRC1e7vrOnP/09s3n+4ITx9RZ
         S6htJR5oKoBZTaM7HskLhX30hzf3KYD2bKK8m9O2mhgofgFjB2vvpThnt802qi4fx8
         GhOcsaVFRCTUg==
Subject: [PATCH 06/15] report: encode cdata sections correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:04 -0700
Message-ID: <167884158467.2482843.6284263235769240995.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The XML report format captures the contents of .full and .out.bad files
in CDATA sections.  CDATA sections are supposed to be a stream of
verbatim data, terminated with a "]]>".  Hence XML entities such as
quotation marks and angle brackes should not be escaped, and an actual
bracket-bracket-gt sequence in those files /does/ need escaping.

Create a separate filtering function so that these files are encoded
properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/common/report b/common/report
index be991b55f5..eb169175bc 100644
--- a/common/report
+++ b/common/report
@@ -19,6 +19,11 @@ encode_xml()
 		-e 's/"/\&quot;/g'
 }
 
+encode_cdata()
+{
+	cat -v | sed -e 's/]]>/]]]]><![CDATA[>/g'
+}
+
 #
 # Xunit format report functions
 _xunit_add_property()
@@ -128,7 +133,7 @@ _xunit_make_testcase_report()
 		if [ -z "$quiet" -a -s "$full_file" ]; then
 			echo -e "\t\t<system-out>" >> $report
 			printf	'<![CDATA[\n' >>$report
-			cat "$full_file" | tr -dc '[:print:][:space:]' | encode_xml >>$report
+			cat "$full_file" | tr -dc '[:print:][:space:]' | encode_cdata >>$report
 			printf ']]>\n'	>>$report
 			echo -e "\t\t</system-out>" >> $report
 		fi
@@ -137,13 +142,13 @@ _xunit_make_testcase_report()
 		elif [ -f "$dmesg_file" ]; then
 			echo -e "\t\t<system-err>" >> $report
 			printf	'<![CDATA[\n' >>$report
-			cat "$dmesg_file" | tr -dc '[:print:][:space:]' | encode_xml >>$report
+			cat "$dmesg_file" | tr -dc '[:print:][:space:]' | encode_cdata >>$report
 			printf ']]>\n'	>>$report
 			echo -e "\t\t</system-err>" >> $report
 		elif [ -s "$outbad_file" ]; then
 			echo -e "\t\t<system-err>" >> $report
 			printf	'<![CDATA[\n' >>$report
-			$diff "$out_src" "$outbad_file" | encode_xml >>$report
+			$diff "$out_src" "$outbad_file" | encode_cdata >>$report
 			printf ']]>\n'	>>$report
 			echo -e "\t\t</system-err>" >> $report
 		fi

