Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABAFC00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjARA6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjARA6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:58:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30995A801;
        Tue, 17 Jan 2023 16:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96843B8164A;
        Wed, 18 Jan 2023 00:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C71C433EF;
        Wed, 18 Jan 2023 00:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002674;
        bh=bk2W7mh2lu0tQsYqc/CuqqVAHOCqpCzTnRs/t4kldZc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VGSaNKq7RRoaeTXHpnCCc/FLRujDGFCWCvbjsUOfrVqWqsKuiCvwyB6se4XSMBYfg
         aoirJdghCD0ZCxVX5YcGnAx1NQw0JSWd3IJVNKppC/ysEJqrmALk24cXUOdnpo5jVy
         wVg0EKw6990c6jkxmLoC2j/xs/VNGiJibdN2dPFIvBG13Xg2GC4qSFPbFMutAivMu2
         nIatNYlaRSl2YESzkuumyOFVG1sHeG+HH4LFnrgfWEtB/hUZb7jpw15D7wv3nwb4yW
         tVQlazJJqVhUE7Gl95IIyNKY8nbjSvKLtfGHXRfWC2Xemyi5qo11F7fGbi2MGOkTki
         IhNCUuZ8ObXPg==
Date:   Tue, 17 Jan 2023 16:44:33 -0800
Subject: [PATCH 4/4] populate: improve runtime of __populate_fill_fs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com
Message-ID: <167400103096.1915094.8399897640768588035.stgit@magnolia>
In-Reply-To: <167400103044.1915094.5935980986164675922.stgit@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Run the copy loop in parallel to reduce runtime.  If filling the
populated fs is selected (which it isn't by default in xfs/349), this
reduces the runtime from ~18s to ~15s, since it's only making enough
copies to reduce the free space by 5%.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index f34551d272..1c3c28463f 100644
--- a/common/populate
+++ b/common/populate
@@ -151,8 +151,9 @@ __populate_fill_fs() {
 	echo "FILL FS"
 	echo "src_sz $SRC_SZ fs_sz $FS_SZ nr $NR"
 	seq 2 "${NR}" | while read nr; do
-		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}"
+		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}" &
 	done
+	wait
 }
 
 # For XFS, force on all the quota options if quota is enabled

