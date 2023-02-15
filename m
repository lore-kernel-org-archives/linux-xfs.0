Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEC2C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjBOBq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjBOBq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3343400F;
        Tue, 14 Feb 2023 17:46:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17FE761838;
        Wed, 15 Feb 2023 01:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7910EC433D2;
        Wed, 15 Feb 2023 01:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425584;
        bh=NklK8j5aIk23WQ11zKifZreUOFsN+M1nMiw6yA+yz64=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XGX2DCXeWexgXn/fRcFQW5mkbZ2ofZUp+SQmjExDYBTQ3Wm9jQgVV5gQuHQX56xDb
         yQv1Lccax+hR78Qu6QVJPizSEtfbCWz8FKl6jYgmIzO0kbG9i+pPy0RzJbnwAV5fuf
         Dyp9bFNKLbgFpCV48WhV68Ue82b/P+nLaezpczpyPm3W/gVIG/BzfYXb6hmgVgjisn
         vZK97GYhPVnWUvBdRZPhSCDOqO9xdO9jkkpgjj9mWNAPFHHtMpe6UpmyzTqqyLLubU
         AVma1tZSv8l+fh9SReEh3Xu/jSDl0ypz2PIBbvr7D21yrdkQLX+Z6MXIXqvtQ9mpdl
         ZDbU7Q4OX/Pzw==
Subject: [PATCH 08/14] report: sort properties by name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:24 -0800
Message-ID: <167642558408.2118945.1132135244227280829.stgit@magnolia>
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

