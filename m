Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D02C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA572076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GthZHFOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgEXJSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6275C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=jUmcjrUXTDLXCab+WEM4WRM76Zy5iF0Io1To4/r2eyY=; b=GthZHFOqUyjGzYu5Zryn+/5JuY
        RIoTMoarPkCf+ZcQiQzmP8BkiHNNeBt9d3++6pqJgWTXf3rAHLEwng5PhVqHxQABvpaB64UVHl+oh
        9YOSj/7saoTrdA6u2G5NaDJ5X0jvDirUrpIdRET89Q6tPTOZhrm92eLywZPWg2vISnbMSLO1BnRQt
        GnKJZ/Z+n78GodvsmWUvScDeaNs1+faWOUNfhhaGP3aoGqviWVn0zRdaMhDMofDtyUV3vA1lU5fkj
        5UxrLgF5aw8nY86JjlDCTgX5NFEXQqWbJZT9GCAsGHwPY9lBtL8vy7S/K2jGTX/mmOjQoBxgd/RR2
        U6zrr3fQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmlc-0004ph-Ax
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: kill of struct xfs_icdinode
Date:   Sun, 24 May 2020 11:17:43 +0200
Message-Id: <20200524091757.128995-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series finally remove struct xfs_icdinode, which contained
the leftovers of the on-disk inode in the in-core inode by moving
the fields into struct xfs_inode itself.
