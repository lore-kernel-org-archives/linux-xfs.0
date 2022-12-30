Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47EEC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiLaDLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:11:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B49E59;
        Fri, 30 Dec 2022 19:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89F9DB81E6B;
        Sat, 31 Dec 2022 03:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48092C433D2;
        Sat, 31 Dec 2022 03:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456308;
        bh=j/LDjaycDFOUuOJOHXG9wZs/COuMk+TbL0io55B4u7o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WLZiCGroHty9yO2wM/+VhHCxUvJh77OpMA36ekIkOL4vwnyRYz2WHClNXZS1if5TZ
         DRS1EdmXKjcZxD+cpuARIut+pjIVL/K0Ujma1Ly7OgZe2m5lzN4fYUrRQKkedo64a6
         H1LLHoAIEs+aDqAKpbOB0WxMw0b3jralbK8c2cS+ePzhsbyxPs6k07JjTtSeldkrwS
         bi9JFIaX+ue5v1CsEojWdfQPUAhCZoleHYHnw7cKI4IfsPuDA//IDTcJg3Ui6GCYNu
         K3wdqaAegoczsXgYrUz8dGE04CwAq1s/kDUGv7RldpL6EuLjfng6p3oQwdffSqiuLL
         tiRNepRabcdtA==
Subject: [PATCH 09/12] xfs/122: udpate test to pick up rtword/suminfo ondisk
 unions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884063.739029.10787000865854510244.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update this test to check that the ondisk unions for rt bitmap word and
rt summary counts are always the correct size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122     |    2 +-
 tests/xfs/122.out |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index e616f1987d..fe6c1e36e9 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -187,7 +187,7 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
 #
 cat /usr/include/xfs/xfs*.h | indent |\
 _attribute_filter |\
-grep -E '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
+grep -E '(} *xfs_.*_t|^(union|struct) xfs_[a-z0-9_]*$)' |\
 grep -E -v -f $tmp.ignore |\
 sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
 sort | uniq |\
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 336618cf7a..1379c7b3b5 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -128,6 +128,8 @@ sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_sxd_log_format) = 16
 sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
+sizeof(union xfs_rtword_ondisk) = 4
+sizeof(union xfs_suminfo_ondisk) = 4
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 344

