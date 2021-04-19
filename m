Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1418C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9E061151
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhDSI2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhDSI2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96188C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0B0+QjlPY0WCQ0BhnKtpxcamgOR30kPfzC1L5YfHUlU=; b=IvjmncTatHo2DzTRgziEiesTyM
        W0JfgxarRWjDaHgH1Hvv1xbh3XeUwFc5yP+3S77dVYWik0o0NIraYUnBWpSkICBgonWIrbgto7BxK
        LaTVxgqukgxVf0+VFo9QqIqbzvo6+JlcPr3q9qLAXgr0mk4rjwLLJ1U8iJjpYK50qUnD4919efMIo
        E5pE8xf3rrvUsVYkWFk2CXBOuAH81Vi/S5wmUIjhKR9CPAuhrBvPEJqTOKwbv76DG08cO5MqKXBR4
        ACM0eTxb3Z/eds4yyMUXGq84+LaEAG4PO6kIGmRjs0pjfcpRYDqFCxThIwX+ctdkVYcqnWRErkQac
        8mkkydtg==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGJ-00BBd8-Qm; Mon, 19 Apr 2021 08:28:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: cleanup the EFI/EFD definitions
Date:   Mon, 19 Apr 2021 10:27:57 +0200
Message-Id: <20210419082804.2076124-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up how we define the on-disk EFI and EFD items.  The
last patch is a rebased version of the patch from Gustavo to remove the
one item arrays in these formats.

Diffstat
 libxfs/xfs_log_format.h |   69 ++++++---------------
 xfs_extfree_item.c      |  157 ++++++++++++++++++------------------------------
 xfs_extfree_item.h      |   16 ++++
 xfs_ondisk.h            |    9 +-
 xfs_super.c             |   12 +--
 5 files changed, 103 insertions(+), 160 deletions(-)
