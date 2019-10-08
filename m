Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56608C10F14
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CAAF218AC
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qy8OitjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfJHHPc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:15:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfJHHPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B+KZ2CWthn3qi8frDFdu82EATrRyublF5XnZOEvZyjo=; b=Qy8OitjIKa6k/e9/4wWp8KmWL
        HXQD07MhpTIakI1wWi/RVv57dM1RooZS6Q58D1huHDafGEUTI+2Ynys1y1F1+ra1kpj8BOkemZntG
        BIJJvCkOLGsN/+T4MrATcqRRwCABS9c8sDOorIncqsBabG1vBH8X2ModVI/jo61h6CUf+ZEiCD/f2
        Pb0OOPt1Es6DbGe3WlZQ2PfuqsAOM8JIL1gCXGCI4T0Xu+aD15ODxkc0MCpgmOoHtNjf/02Q4ik22
        hbXD2MPZydnDyWfCdSxuAsRrcEjcvwW5mMJt2foQrQ76sWNeOS7ghNVZA1eZ3aLgKD5igBvqfIavo
        IhIsIbu+g==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjiV-0005KI-CH; Tue, 08 Oct 2019 07:15:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: iomap and xfs COW cleanups v2
Date:   Tue,  8 Oct 2019 09:15:07 +0200
Message-Id: <20191008071527.29304-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series started out based on a review of the btrfs iomap series
from Goldwyn.  I've taken his main srcmap patch and modified it a bit
based on my experience of converting xfs over to use the feature.
That led to comments that the xfs code is a mess, so I resurrected
an old series to clean that up and merged it in.  That series also
happens to massively clean up the unshare path in the iomap and xfs
code as well.  The series is on top of the move of the xfs writeback
code to iomap.

Changes since v1:
 - renumber IOMAP_HOLE to 0 and avoid the reserved 0 value
 - fix minor typos and update comments
