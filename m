Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F60C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiLaAqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaAqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:46:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFCDB9C;
        Fri, 30 Dec 2022 16:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D6A0B81D68;
        Sat, 31 Dec 2022 00:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CE0C433D2;
        Sat, 31 Dec 2022 00:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447556;
        bh=O8ylGs9dvytA68wL2FE9ofweoWLYgVt7Mpcyx7HqrM0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HIbuQOj1flYh3h9eFlbkDd7pM5NkYW/iv8sUON2z3GkApcsEOP1hSUNWXusoYJ6F1
         A/IBrhMZaYs75qFp6yY77jVxVgmy1+3ZlW50v10I0jxusQYU2kp6beft7zaA/OBik4
         Wf0dM5gjCCyrbkfar4CvgxPalzHM+Z+424gR3Nk2MmVemdEz+fAGwJ13bf5ckS92g4
         KKmiQtCk+OMr8vINOSOH0kHcsv1AbvsaiSAt92IQSWmF67OYsCsO81RxYa1/EpOKH5
         qiuM0Svh2kfovUirZ8cNQ9WSwX5TasJTt5zNtGEzb46Amjlqt+tLqMS/5cZHcAUJ79
         BjlxYm7/q1BxQ==
Subject: [PATCH 07/24] fuzzy: don't fuzz xattr namespace flags and values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877996.730387.15482162605984984086.stgit@magnolia>
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

Extended attribute namespace flags are controlled by userspace, and
there is no validation imposed on the values.  Don't bother fuzzing
either of these things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 6f5083041a..866901931e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -92,7 +92,13 @@ __filter_unvalidated_xfs_db_fields() {
 	    -e '/^core.noatime/d' \
 	    -e '/^core.nodump/d' \
 	    -e '/^core.nodefrag/d' \
-	    -e '/^v3.dax/d'
+	    -e '/^v3.dax/d' \
+	    -e '/^nvlist.*value/d' \
+	    -e '/^entries.*root/d' \
+	    -e '/^entries.*secure/d' \
+	    -e '/^a.sfattr.list.*value/d' \
+	    -e '/^a.sfattr.list.*root/d' \
+	    -e '/^a.sfattr.list.*secure/d'
 }
 
 # Filter the xfs_db print command's field debug information

