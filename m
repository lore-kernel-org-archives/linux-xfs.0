Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5FFC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiLaApr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbiLaApo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:45:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5EB9C;
        Fri, 30 Dec 2022 16:45:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92F67B81E6C;
        Sat, 31 Dec 2022 00:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BB9C433EF;
        Sat, 31 Dec 2022 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447541;
        bh=8FbULoN8kBXZHkVgmJabgBicREZdwJSjrlqSu6tx9Rc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uk/VEV6j9baXvNj0G3zUP6K3MIBOLzwTtRoIvVl8QnoBN7QPsK6VEcl3lLDQBTu8Q
         tr1RXJRADdviwkk+UJT4pqLxyeJNcGDzUinPsvCFUODgjXSI0jqczPyg6uEk+haejn
         yUs2DUO+IEc/cQdo7W7xOaNfAsP3Vrf7NvrNJPd7I0ogBtVU9qTLnAUG6G5eLP/O1m
         ty/KLMaOzUe6lqBuvCtWNrwDG5Qa2w4tYZmiMul1HMnRJGNKIYaabf/J+sAShd4l7i
         x0qGKtpQeNNutYhPTiMWWF5fYcanmcnXuv0L204Uu/UZ7/hQSQZ4C94vyBG4pRtxrZ
         Olhm01JFe6pwg==
Subject: [PATCH 06/24] fuzzy: don't fuzz user-controllable inode flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877984.730387.14992965943174698029.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't fuzz the inode flags that are controlled by userspace and don't
actually have any other effects on the ondisk metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 0d7e60a011..6f5083041a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -84,7 +84,15 @@ __filter_unvalidated_xfs_db_fields() {
 	    -e '/^core.flushiter/d' \
 	    -e '/^core.dmevmask/d' \
 	    -e '/^core.dmstate/d' \
-	    -e '/^core.gen/d'
+	    -e '/^core.gen/d' \
+	    -e '/^core.prealloc/d' \
+	    -e '/^core.immutable/d' \
+	    -e '/^core.append/d' \
+	    -e '/^core.sync/d' \
+	    -e '/^core.noatime/d' \
+	    -e '/^core.nodump/d' \
+	    -e '/^core.nodefrag/d' \
+	    -e '/^v3.dax/d'
 }
 
 # Filter the xfs_db print command's field debug information

