Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206BFC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 019B5206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586954971;
	bh=RgLLwNK5+pFXHOHmYUgGmzQE3WjnTG/qYUCJPa6BMcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=b/epdC+o/PeAnQ37b6pq6zGTO0kLTrHbC07nu3v8wki08oez8HSCAQBCrn5gn3LHA
	 lX8Lm/lMhJjtwQg3cXOiAKhIIJDouKWWOZkw2BtXMU95CIFIJucysmSgchRreqzZcf
	 +ngq7s12EkQZaFcc6/COlNtp+yexfJM70ecyNM/E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370315AbgDOMtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408947AbgDOLnC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45BD20857;
        Wed, 15 Apr 2020 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950982;
        bh=RgLLwNK5+pFXHOHmYUgGmzQE3WjnTG/qYUCJPa6BMcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lddvriWoKjfDbtOgIg6LTEN8hzJQfvSqR3V3LW1DqK7iPiWEO6ADzpHxCfbK2x9Yi
         Y/YcvzKW1IPnpwu7l2kzYANl+qJzL+WPcKzs4E2dirxSyhQj1PjspVDN/gHE3FrdGW
         QsCBF3XCiD37QpevD28MQwQmH1vsaN5c+qzQgWsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 030/106] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Date:   Wed, 15 Apr 2020 07:41:10 -0400
Message-Id: <20200415114226.13103-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 77ca1eed5a7d2bf0905562eb1a15aac76bc19fe4 ]

When I lifted the code in xfs_alloc_ag_vextent_lastblock out of a loop,
I forgot to convert all the accesses to len to be pointer dereferences.

Coverity-id: 1457918
Fixes: 5113f8ec3753ed ("xfs: clean up weird while loop in xfs_alloc_ag_vextent_near")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89f..5b0c20a0d7f2f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1515,7 +1515,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * maxlen, go to the start of this block, and skip all those smaller
 	 * than minlen.
 	 */
-	if (len || args->alignment > 1) {
+	if (*len || args->alignment > 1) {
 		acur->cnt->bc_ptrs[0] = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
-- 
2.20.1

