Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029CFC432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB752068E
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g0mzpy3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKPSWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tLqFi/5dDVSaAew6CXVHELhWgKMMjbH7u4/CssfbTsM=; b=g0mzpy3b+AqgHD7gaHBubsCR6
        rZFkvk+rx/YAmTXFKu7KUh0kM0ZSp/1ZPMep3NLSTSQcjVX+27JPl4r1TxCtH50CA7vDp1PSVjdad
        Y16wg2a7sbJ2H+LlCks8ERACHrk1R3lruAIN8nYO3xmJqDCiUIiPDC3xf6/Eh/3jVbRwCTHYzrCNM
        KBVvI3gYDm7p63MJc1C2IkG2TCIas5NZnkEnCGjOWgfA52ob0qRYUmO3f5gsW2G16r0oTEXzSlY0O
        2pSOuCi/UZpepuCfKDT25vgAUShGG2bsLLziC2WiVb+Anon8F418ctcd9NdFnuJtP3ZK8Qv70DTOd
        abBK6Hixw==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iA-0006gH-5u; Sat, 16 Nov 2019 18:22:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: RFC: clean up the dabuf mappedbno interface
Date:   Sat, 16 Nov 2019 19:22:05 +0100
Message-Id: <20191116182214.23711-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this (lightly tested) series cleanups the strange mappedbno argument
to various dabuf helpers.  If that argument has a positive value
it is used as xfs_daddr_t to get/read the block, and otherwise
it is overloaded for a flag.  This series splits out the users that
have a xfs_daddr_t to just use the buffer interfaces directly, and
the replaces the magic with a flags argument and one properly
named flag.
