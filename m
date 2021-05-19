Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04ED9C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF8746135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhESTK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhESTKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5965C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Wt2zLrbWBMPnydzkQ+dM4wQ2/xYVtXps+SCOkZWbNzY=; b=xl6blOYQr1Z7XvK23KK+fWXmxI
        HFMsLNdubKPbBSXFBnYUZUwOdIxUxEi4egatra09cmpmaf/+VjZ85MAun8LjrUaoH0I+zoaTr73Ey
        +0V/90hdiR2r4oNq8d/NTy4IDHdezaRJWnSKcUyzN1vSeexZFATL59RLMc6ZnzX1Zp9M1jZuV469T
        vUxCW+JE0cWOe+fmskqu2D9jdXL+OnjFubWKJWSRWqC9HCjscJxJDUbXj408Z54ZHbGacXgqDBQOL
        29cOuK36zeOEV0gyKUF3c/lyc0C+B5FSBGmzAJLEV1+oTB+35i43vnrplpHm7zUcvmrWUv+Uva4Qs
        9qfuCehA==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZ1-00Fira-NZ; Wed, 19 May 2021 19:09:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: RFC: buffer cache backing page allocation cleanup
Date:   Wed, 19 May 2021 21:08:49 +0200
Message-Id: <20210519190900.320044-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

while reviewing the patch from Dave to use alloc_pages_bulk_array I
stumbled over all kinds of lose end in the buffer cache, and I started
cleaning them up while procrastinating and avoiding more urgent work,
and rebased the alloc_pages_bulk_array patch on top.

Only run through a quick group xfstests run on a 4k file system so far.

Diffstat:
 libxfs/xfs_ag.c |    1 
 xfs_buf.c       |  256 +++++++++++++++++++++-----------------------------------
 xfs_buf.h       |    3 
 3 files changed, 99 insertions(+), 161 deletions(-)
