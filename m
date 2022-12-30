Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08193C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiLaAtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiLaAtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C662D1C90A;
        Fri, 30 Dec 2022 16:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78EE4B81DF1;
        Sat, 31 Dec 2022 00:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D2BC433D2;
        Sat, 31 Dec 2022 00:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447759;
        bh=XH1DysJORpOtUFE+x7fJQw8bzUSsfmgCq3QqNexVkKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sEaD3ulI66RRW7KWBPRMxn3eOL7HJuZ1lM+ILxTqATXfCMhYBFOw00Y/uAZpZHEcT
         f0nsXOGZbd4yLsNnl6LVIL8ItMGrRpU0L75C7RqpanVPZ0OxtNhr/PVnuUo3q+L2Ij
         fHRhaX6heZZykD5sSgEueXSb61eHV+JZKB6arur2xwJ1OkcCfvffZht5aZ9VyXnCj1
         xi+V9oJJgmz2zYXnqv7qWhE9cS2KUCqVDFUrGcM59UJzBuITIqLFBPyOgtJ5EV0gmx
         7O2CC7saMd8szWLb3uO0tAnNmk3neLe9aocKuvxt8wLNasSZUPt6EtxuPlGe/t3GIq
         D5/0CH3QOm7/w==
Subject: [PATCH 20/24] fuzzy: dump metadata state before fuzzing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878162.730387.16597687752166658725.stgit@magnolia>
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

When we start a fuzz test, dump the metadata to stdout so that anyone
analyzing a failure can see what was in the (supposedly) good image, and
what it turns into after fuzzing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index 3de6f43dc6..939f5e5ef2 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -110,6 +110,16 @@ __filter_xfs_db_print_fields() {
 	done | grep -E "${filter}" | __filter_unvalidated_xfs_db_fields
 }
 
+# Dump the current contents of a metadata object.
+# All arguments are xfs_db commands to locate the metadata.
+_scratch_xfs_dump_metadata() {
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	_scratch_xfs_db "${cmds[@]}" -c print
+}
+
 # Navigate to some part of the filesystem and print the field info.
 # The first argument is an grep filter for the fields
 # The rest of the arguments are xfs_db commands to locate the metadata.
@@ -534,6 +544,8 @@ _scratch_xfs_fuzz_metadata() {
 	echo $(echo "${fields}")
 	echo "Verbs we propose to fuzz with:"
 	echo $(echo "${verbs}")
+	echo "Current metadata object state:"
+	_scratch_xfs_dump_metadata "$@"
 
 	# Always capture full core dumps from crashing tools
 	ulimit -c unlimited

