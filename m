Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CC2C3DA78
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiLTAB3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLTAB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEEB266D;
        Mon, 19 Dec 2022 16:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 377466117E;
        Tue, 20 Dec 2022 00:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6FC433D2;
        Tue, 20 Dec 2022 00:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494486;
        bh=Wku4FtOgk/DHwwvpv+yxM3NQ/iaBGbXawl52x+/5Fp4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C3CiaSUf8l/EmiOKs+XJI8N1QhEyGBrQazlPGI26eSXQVD9EFyynWC2TfTFUsZeTm
         1+NpWnaggVF/uvYZ9OltsGHueyIl8OBF+mgzqSiR9vrEFYC5PKQlM6rSxQwIO+u5Ns
         oZIFOX+TT9rZgPuXLwc4tm9KXS5+KRx7ua/oepMEMAOMsgtSg25HSbScIxpe7nZzfe
         Dbv85bxYjWZ+RtB3dj7HxwdRJi4lJ+w+L4sP5runVGX4ZzTck3G4izACvmkJdoBKfF
         DMDqdoqeqPLj8O4jfRrU+gNkR196e8H5yLIHFhHSn6FnYGd0poqcrwRWZnJ2g4wMTg
         XdN1okRgdfupg==
Subject: [PATCH 4/8] report: sort properties by name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:26 -0800
Message-ID: <167149448624.332657.10588092617370450616.stgit@magnolia>
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

When we're generating a junit xml report, always sort the properties by
name.  This makes it easier for humans to find a particular property.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/report b/common/report
index 1817132d51..b415a2641d 100644
--- a/common/report
+++ b/common/report
@@ -27,7 +27,7 @@ _xunit_add_property()
 	local value="${!name}"
 
 	if [ ! -z "$value" ]; then
-		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>" >> $REPORT_DIR/result.xml
+		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
 	fi
 }
 _xunit_make_section_report()
@@ -68,7 +68,7 @@ ENDL
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
 	for p in "${REPORT_ENV_LIST[@]}"; do
 		_xunit_add_property "$p"
-	done
+	done | sort >> $REPORT_DIR/result.xml
 	echo -e "\t</properties>" >> $REPORT_DIR/result.xml
 	if [ -f $report ]; then
 		cat $report >> $REPORT_DIR/result.xml

