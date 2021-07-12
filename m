Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E04C07E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E174610E6
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhGLLPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbhGLLPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:15:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA09C0613DD;
        Mon, 12 Jul 2021 04:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hUgB9pK4cAr+UwfpqUqx+hqKvVTl3agpw3rGCT601gs=; b=CPAsDuPaMacJt9eisrHy+cA/2s
        c/f199rHj9sU0uMrGendQ0pKbD6SVtUcpjFjAqY+dxY/qT6Z7VU3m6qN6a8F8F80KS1fS5JUlEx6z
        sfPp4LITE9i5DTmnOrIlmv5l5cJ6L8V+gdrRA6oDvtl0HUEoEG4hb6HfxsLg2EJqzZn8LOGH005oN
        Z6REXCfksZLvpH/hCXNbNMMts4DqXQX5JELfMQDVBQ5qsTwTdlSTJRnddaRSPeY20qkBB005JmDlW
        a9BWFKlEo2/OJj+IOwP7OAwjq4E2n9yYrbiDwk8LLor90z+7hvF74QqrpGo6dxZIin4WT9XdATKuc
        OuzhVANg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2trO-00HXEe-2Q; Mon, 12 Jul 2021 11:12:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs/007: unmount after disabling quota
Date:   Mon, 12 Jul 2021 13:11:42 +0200
Message-Id: <20210712111146.82734-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the pending patches to remove support for disabling quota
accounting on a mounted file system we need to unmount the
file system first before removing the quota files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/007 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 09268e8c..d1946524 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -41,6 +41,9 @@ do_test()
 	_qmount
 	echo "*** turn off $off_opts quotas"
 	xfs_quota -x -c "off -$off_opts" $SCRATCH_MNT
+	_scratch_unmount
+	_qmount_option ""
+	_scratch_mount
 	xfs_quota -x -c "remove -$off_opts" $SCRATCH_MNT
 	echo "*** umount"
 	_scratch_unmount
-- 
2.30.2

