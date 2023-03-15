Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933C9C76195
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCOAxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCOAx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7217F44AC;
        Tue, 14 Mar 2023 17:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BC4C61A87;
        Wed, 15 Mar 2023 00:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658B3C433D2;
        Wed, 15 Mar 2023 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841596;
        bh=NklK8j5aIk23WQ11zKifZreUOFsN+M1nMiw6yA+yz64=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DlWQSi7ObvIJWUG2RKZXpKmvVMHafJSvvFCh+T3i2s5sllIW4uA0Fk1LTJCxDrGHz
         mfsHKDby0xbR7Fgt3awQ9Zs8a2+x4lrShvkL5JwKvysFOoiY/gG0GKJnrRdUyYKe/M
         C356WDvf1k94NP2i+l3vg0GEp1o34dCkEWTT2N5fzpM5raswhE95iTnuvx82Dml2oY
         N5dUUsKN+S1YcHXWWl3mkX6i3Y9btooz/9LVTzxlly0vcnQ1GznirgTGP2+Ki3dK+L
         r9r32W5r9HyJNGB5OMA7sXtUxfIQYp4B+Gv/AC8ViiV0wlZvyAGQow3X9ERDizWgNx
         03LdNp6N0A7BQ==
Subject: [PATCH 08/15] report: sort properties by name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:15 -0700
Message-ID: <167884159597.2482843.3047170173182476876.stgit@magnolia>
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

When we're generating a junit xml report, always sort the properties by
name.  This makes it easier for humans to find a particular property.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/report b/common/report
index 2e5959312a..3ec2d88178 100644
--- a/common/report
+++ b/common/report
@@ -32,7 +32,7 @@ _xunit_add_property()
 	local value="${!name}"
 
 	if [ ! -z "$value" ]; then
-		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>" >> $REPORT_DIR/result.xml
+		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
 	fi
 }
 _xunit_make_section_report()
@@ -77,7 +77,7 @@ ENDL
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
 	for p in "${REPORT_ENV_LIST[@]}"; do
 		_xunit_add_property "$p"
-	done
+	done | sort >> $REPORT_DIR/result.xml
 	echo -e "\t</properties>" >> $REPORT_DIR/result.xml
 	if [ -f $report ]; then
 		cat $report >> $REPORT_DIR/result.xml

