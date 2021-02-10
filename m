Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80FBC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89ADD64E6F
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhBJC5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhBJC5l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CAB64E58;
        Wed, 10 Feb 2021 02:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925813;
        bh=Jctu2w3c0AYOfZudWG8jQ0l2prBCLIylzSLUqaa1HKM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cSpZv64dSSHVFvqQLyZ66nxfUMrRiqr9s5h1kewUCEGUhwC8qlT1YoQHfPsHCbrVJ
         QXgvw+IbDUelqDuIHj7OT872DfDbrZU+3OWd0GG1Ju3Gj+KfQeu12QWijel4UhTzTy
         u0xOsbteUM/N8O/KXf2pEtPc4MWhttmnGSN1yRQMmibNppedHYvSrM1pF1h0aVKrED
         t+ckEr+lQK93dNMyGYWwXN5+nVOuAVN7LG/EVy/dWblQnzA0wWqZxKeX0jdusqfYT0
         gw5m4SA0Q8MK7zSrkq902WHBx+EsM5XZ0476GGluiO9JDb92xqQvglSBfSM/qZhigk
         X7GkGj4HAnswA==
Subject: [PATCH 6/6] fuzzy: capture core dumps from repair utilities
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:53 -0800
Message-ID: <161292581331.3504537.1750366426922427428.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always capture the core dumps when we run repair tools against a fuzzed
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index bd08af1c..809dee54 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -307,6 +307,9 @@ _scratch_xfs_fuzz_metadata() {
 	echo "Verbs we propose to fuzz with:"
 	echo $(echo "${verbs}")
 
+	# Always capture full core dumps from crashing tools
+	ulimit -c unlimited
+
 	echo "${fields}" | while read field; do
 		echo "${verbs}" | while read fuzzverb; do
 			__scratch_xfs_fuzz_mdrestore

