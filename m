Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4751CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiLaAfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:35:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D779D1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7474061C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E0BC433D2;
        Sat, 31 Dec 2022 00:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446918;
        bh=Bodft67axSWtEbIInsJXd2K4KfRR/Y1t3ertYWCMpiU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l+tqnlzEz7Fod5xXdXd+qsH8XpH7NHLsn5lhjvUm/WTmKj9nXcIxyGIyQYPL3YuUN
         R6E+0ZTKlFOms2WUoZI7UVJtlZsxA/WQt63lBA4FeZlIphPTTscjaHka9eVMm16JK7
         jZ8yFRCJnnh1NsOMDdE2nyLbbUz1lB22b1k1e0NShX3CzhpTiS9tAg7pI5QCg81N9W
         CX82AeznSOO3QRpryjAnIsvTnY9APqacdW0dgwdgcsbFb9rvuFrF+V3YS0eYnf7nvd
         x6Zf8FtH8y3rSLD3Un0iXmBOYqcsF9PW9YhPKsa9u2eHmLAtL4T5Qa5M0P/7YEbd8n
         ZJlGhOTcA8BPw==
Subject: [PATCH 6/8] xfs_scrub_all: fix argument passing when invoking
 xfs_scrub manually
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871177.717702.7249068927476129957.stgit@magnolia>
In-Reply-To: <167243871097.717702.15336500890922415647.stgit@magnolia>
References: <167243871097.717702.15336500890922415647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_scrub_all will try to invoke xfs_scrub with argv[1] being
"-n -x".  This of course is recognized by C getopt as a weird looking
string, not two individual arguments, and causes the child process to
exit with complaints about CLI usage.

What we really want is to split the string into a proper array and then
add them to the xfs_scrub command line.  The code here isn't strictly
correct, but as @scrub_args@ is controlled by us in the Makefile, it'll
do for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5b76b49adab..32bcfb15f5a 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -132,7 +132,9 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Invoke xfs_scrub manually
-		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
+		cmd = ['@sbindir@/xfs_scrub']
+		cmd += '@scrub_args@'.split()
+		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs, \
 				lambda proc: proc.terminate())
 		if ret >= 0:

