Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D4EC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6EFD206DA
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IUlLMTw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfLLKne (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:43:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbfLLKne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NFaNSh+wEfRCAnWsH7X2zFVrPj1pR7S65WayQ6RiUpI=; b=IUlLMTw8L/NxlUHMZOYPzBfe7
        5I1dIHuUFd+GpoA5KNV69NdtwgnZsW9iUALegniTLy4x7N01sxNCQSVXJnqM+saYYBcZkBxk74jx9
        0f/1WtRlLSpp5SNNUNPeLX5YhGbVcfrhVGieNIeUbPDA6bp66cxw4Mu3tF0u/TC+sPmV4GJbgtOcu
        WlieJoZFM/7l4pZm6/8cw7sAqo+i8vp79g7PUmu2+qLjlAGo71wFKkhZ+fUzOTT5F4LoylwrF7iGN
        srlJdplfiOvRSTYmFvK5SulhMI0nhTVomJ37KmA2ZsXR8eSy018hGB18b81/Cioa9ZvnEgfRV/HTI
        pKChuUL2A==;
Received: from 213-225-7-93.nat.highway.a1.net ([213.225.7.93] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifLwS-0005Vz-Nw; Thu, 12 Dec 2019 10:43:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface
Date:   Thu, 12 Dec 2019 11:40:44 +0100
Message-Id: <20191212104117.781-1-hch@lst.de>
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
