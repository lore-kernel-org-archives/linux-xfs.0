Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F0FC2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 11:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1CE7206D5
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 11:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mklb0lvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAZLfy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 06:35:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZLfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dh5UfysYkuO2azMyXjsgBe3QvmkACKK2Q35CuijdLCY=; b=Mklb0lvBzAgXyPP5vI/7lurQs
        /pogssmCOxlh8JT0AfvDrZ61V46Qxfx0zDg4UGOqeMpEmNgrRpzRNquO6EnoLUFLGd7I4u3hbEMxx
        l3xalBWxodfjkUvt++mHpGSUpcJzRQoWPOm9FHUZWC5H5jJ7LmgOVz3xaaxAriSD5nYEYf8K1Wk23
        GjuAKgSetQMzfHo7i6fwkxgIhEPYf2tgx93usNDxpN8VLtxP0vNb2K6yJXt+Ae5xdStJcLyei00UB
        lQQIo/C6hXzVlifzolycfSsDYYoPAevnOCHamCZTvNQ60iCvYBg8e+W977tQ2ujyssb8+lc/2VfHQ
        qBtMUJhSg==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgCl-00089O-Km
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:35:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: stop generating platform_defs.h
Date:   Sun, 26 Jan 2020 12:35:36 +0100
Message-Id: <20200126113541.787884-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series gets rid of the need to generate platform_defs.h from
autoconf.  Let me know what you think.
