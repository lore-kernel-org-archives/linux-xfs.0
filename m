Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA0FCA9EAB
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 14:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567AE21744
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 14:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B2hCGTBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfJSOoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 10:44:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfJSOoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 10:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dI0HPTI6f50Ws6XwcMa9vTWNcPNowZ5uXG0cFDwvhv0=; b=B2hCGTBiOVAN5G9oQUn4jJOzE
        gveUZSAKHu9s8fj2U0ecqRy7XshEw/4rB8sBZc7XA9Lym9yaBeohn6/5pd+OFFSqjAZ9jOhjw2bk1
        39Mnzx61ZiuianGWyYB3BZfsh8GQKksV6Ak6ByBdMOwUtEwY4IGFD+G1Aj9Js6Kg98iEy6P9dx9Ey
        pL65Y8TF+mCe5k5FRNjDUakIk7WFRKedSsm7OybF1JRfBcqgPvgRpZ9dQxgmTRcGDrDL8bsTgylHN
        JN3neiZ/cWqC+4J1r8yXFwBw+bF3k47BhepXnw4+EHFK89GjuKFvIVDTRE0zycegDXz/QRnlz+d0k
        L8XgnrQdQ==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLpyQ-0001p4-2f; Sat, 19 Oct 2019 14:44:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: xfs COW cleanups v3
Date:   Sat, 19 Oct 2019 16:44:36 +0200
Message-Id: <20191019144448.21483-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Changes since v2:
 - rebased on the latest iomap-for-next and dropped patches already
   merged

Changes since v1:
 - renumber IOMAP_HOLE to 0 and avoid the reserved 0 value
 - fix minor typos and update comments
