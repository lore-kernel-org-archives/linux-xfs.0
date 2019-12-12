Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDE6C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90D782077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CNgBStfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbfLLKyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfLLKyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NFaNSh+wEfRCAnWsH7X2zFVrPj1pR7S65WayQ6RiUpI=; b=CNgBStfq5rHuhwH1MqIcFYnb6
        lIAZ/MYOFQahIdcQI+jyKdOM16PQZ0zvKL60hx/s9fuKuvRWF3pTxTtJP4fW+kL8skC0trZ389eS2
        1jYlO1tfWgZDaM06M8dROHANuiH4jfOaFB1zpZgmmrj16VJPrNiCaIC5/6Bu3Dw2M3jgwZ3ww9QsB
        JT/DyjtnNVlfjn+fkH/slNA0U+hr5dyYk2Ic2ubZEVmdzb8AFG1+2uCgk0CIk7EnldM2kOFjB5EDb
        qQ2KlVrjz5u45rK/UU4rxRRn3AuGVmN+I5YAghVhVyDxOAcQ+8HyQrAydXwGUhAjVSRjn72zTxutm
        UnWeAsQHg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7A-00016T-HR; Thu, 12 Dec 2019 10:54:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface
Date:   Thu, 12 Dec 2019 11:54:00 +0100
Message-Id: <20191212105433.1692-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

while looking over the parent pointer series from Allison I found
various issues with our attr interfaces.  Initially I was just
concerned about the XFS internal interface, but it turns out we
have some nasty blunders in the ioctl interface as well.  This
series thus turned out a bit bigger than I hoped.  The first few
patches are actual bug fixes that are 5.5 and -stable candidates.
