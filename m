Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB12C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiLaAqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaAq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEE255BF;
        Fri, 30 Dec 2022 16:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F3E961D61;
        Sat, 31 Dec 2022 00:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A96C433D2;
        Sat, 31 Dec 2022 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447588;
        bh=9VwwU7hTMZIES10TLAMkoJh3qKz4roC3+OsqD38DEiU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nNjlE7f79fABxy5zkbYsj7xy4Ift0mUZoHMnNXkl8oFG509qujuAdzYKWcRcWAjWt
         YYqRU1LXLMMY5faJoLAl8dpy/rKdbJkShBPkEqxEHqDRwl1pk9WqiYGHDX7bozfpLE
         5PmR/jg/LesJ8n89Ffb4uAkT/NFLyNdsHtVfh4FX+JPANrEPTFs/Y/lK+JlZLL5tRU
         h0PqZ2f2lFmZKfWRTpX3HuMI6BmKSe6PXM2C5L1UD4azHWoIhQTQNzOsFE2Ssj5IXe
         GtXauOrajhzTqEDR8vV85+tfn8g+/Hq3MMJQOVuPIbqwA30zxs9PvPAOYqFADGkRMk
         xIsFwgdaWt1WQ==
Subject: [PATCH 09/24] common/fuzzy: add an underline to the full log between
 sections
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878022.730387.11367148207366685525.stgit@magnolia>
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

The fuzz scripts use __fuzz_notify in effect to log each step in the
fuzz process.  Enhance it to print an "underline" to ease readability a
bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index ef42336fa6..7efa5eeaf7 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -190,7 +190,9 @@ __scratch_xfs_fuzz_mdrestore()
 }
 
 __fuzz_notify() {
+	echo '========================================'
 	echo "$@"
+	echo '========================================'
 	test -w /dev/ttyprintk && echo "$@" >> /dev/ttyprintk
 }
 
@@ -348,7 +350,6 @@ __scratch_xfs_fuzz_field_test() {
 
 	# Set the new field value
 	__fuzz_notify "+ Fuzz ${field} = ${fuzzverb}"
-	echo "========================"
 	_scratch_xfs_fuzz_metadata_field "${field}" ${fuzzverb} "$@"
 	res=$?
 	test $res -ne 0 && return

