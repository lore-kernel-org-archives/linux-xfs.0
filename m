Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2884DC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8E4223774
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RWe4oCQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfICM5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 08:57:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfICM5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 08:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gE0lAjT5KV53XSH79+iXLIgNXCpho5V7Qseo5fcvl8s=; b=RWe4oCQORqXHbZlPgMeQPdzuq
        z2UJXOpYn5vEYON+x+MNnYUWfLppi3KF+p1y7vU4J9rOBlA4k7X7xkGsD4w8UxwB4k2cknk7FSITv
        WbpkMF8HuupfIFZsFBfH+lE3eI7A2US24MrTnZlOGJl8vbBwEKfgeAV0PGmX/Jug34A2Fq7cb2ZVC
        5Hu8TwWfhMVmj6/G1Vp9pIfoF/SQkDo0Ot3AdEAPBbaufu534W6k+NvLU7X4Hr/9ZWLa15rxwZHPl
        BuFZo+9CINljguXcHzLrgsi7K/1gj/yoBVo0M4Gjmj1oLWraGq2JwLyOgUOBcPwmQ7lByu+t34e9q
        A9TEptEBw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i58NW-0002AH-L5; Tue, 03 Sep 2019 12:57:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: xfs: use the iomap writeback code v2
Date:   Tue,  3 Sep 2019 14:57:38 +0200
Message-Id: <20190903125743.2970-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series cleans up the xfs writepage code and then lifts it to
fs/iomap/ so that it could be use by other file systems.  I've been
wanting to [do] this for a while so that I could eventually convert gfs2
over to it, but I never got to it.  Now Damien has a new zonefs file
system for semi-raw access to zoned block devices that would like to use
the iomap code instead of reinventing it, so I finally had to do the
work.

Changes since v1:
 - rebased to latest iomap-for-next
 - fix up a comment to use iomap instead of imap
 - update a commit log
