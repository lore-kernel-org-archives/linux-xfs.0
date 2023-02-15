Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F57AC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjBOBqR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjBOBqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0184233462;
        Tue, 14 Feb 2023 17:46:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A569FB81F5F;
        Wed, 15 Feb 2023 01:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51589C433EF;
        Wed, 15 Feb 2023 01:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425573;
        bh=5ZjDhw74kNEdDtZQQatDNNzQ8pK7OUwxcc6xRLiOFg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZNhsbal8V0IYRK1bq7pbWqvULYt8Rz4+Zy0PTw7AY7cn3OguBhr2b5tJbLbOkRpPD
         NtCfT7wwFbANcIwGhjyTAp383vq8Pyx/xfxWEu1R0++bthHToDI7N+d7rp9I17152a
         5LDvixU1CCgoEwNQwM/cOaTkJrV+DzHMmelm3je1dqInPflq6GitGG8hA7SI2s55fG
         bSYwCxxWNy4c8vuwSM9lwyp1lw5OUWyE42ihQqnC0O6zmqjNn1v/732ep015Uamoad
         X3Nh8Q1cYpV0xAFlosKojLt9MTTR//DvNlKawBkesaqjyzAh5pggw06nwaukkEe/Kk
         Xb0Eonl6wUzMA==
Subject: [PATCH 06/14] report: encode cdata sections correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:12 -0800
Message-ID: <167642557283.2118945.17850442578198357959.stgit@magnolia>
In-Reply-To: <167642553879.2118945.15448815976865210889.stgit@magnolia>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
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

