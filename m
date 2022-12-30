Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912D2C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiLaAtw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:49:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595D11DDF3;
        Fri, 30 Dec 2022 16:49:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB29C61D62;
        Sat, 31 Dec 2022 00:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B51C433EF;
        Sat, 31 Dec 2022 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447790;
        bh=pWI/7gx+/2hlyL1T3qHgE+gsGHJ43Hifpc1+LEFASJw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OeBZ55SgHWU114gQz4fdJ7YclGzggnI7T6lbFAqqENhpKsLW6mbMpN3v1tByswENy
         Rh8f2E4K6iterdh0+9klFVbAKryTaHO+m35gNNaU7glIw84M8EHPL/1NOKZgjCUavI
         h8ij+wMKUtFBA8ZiDKfbNL5mPk09+yrdflaFWyKXElF8I2a5g6IyXJTNu3sk8VsNdV
         7UUx+Uf6LVMyrW1qZwOpREFckxIZXt98X1RiNIcmiSNVdQLhvpKOR2+2kHgW144VPd
         gDRkCii1Cn6lbicU93rIfcuYQpX7id9DWNlu8BHuI9dcpSHdFDJSvK1WComneVMrTn
         rG/psKsJBKRGg==
Subject: [PATCH 22/24] fuzzy: report the fuzzing repair strategy in
 seqres.full
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878185.730387.13872846406219490291.stgit@magnolia>
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

Record in the seqres.full file the filesystem repair strategy that we're
going to use to detect the fuzzed metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 7eaf883c0f..f34fcadefe 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -540,7 +540,7 @@ _scratch_xfs_fuzz_metadata() {
 
 	fields="$(_scratch_xfs_list_metadata_fields "${filter}" "$@")"
 	verbs="$(_scratch_xfs_list_fuzz_verbs)"
-	echo "Fields we propose to fuzz under: $@"
+	echo "Fields we propose to fuzz with the \"${repair}\" repair strategy: $@"
 	echo $(echo "${fields}")
 	echo "Verbs we propose to fuzz with:"
 	echo $(echo "${verbs}")

