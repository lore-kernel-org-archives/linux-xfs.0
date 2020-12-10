Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40D8C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A19723D4E
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbgLJFtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 00:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLJFtG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 00:49:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C36EC0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 21:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Qu2oEl4H0aSrFqZT94+826A7KYlRUz3X8l4GT1YaMLs=; b=ifUJ/EFxy1J2BwHye0aeL7hA3a
        2FX/JEd1WPUW93mcu75TEIgmjpy30apNDQq6vtDwVwnqBfN7PsjmzNUgNI5SnepdcEKXBmVwdHvZ4
        5U9r7tgaxEB9JxN6j0OPoVwqDrNPXBkPHmGyphg93hC4SHDtUDT59mJQuSBkgcLjHPijNcr3wlCio
        ZSeKU2DZIfoInh8os+brIuUjXFjS6UCLLV4ekbvdzen1WH4OTS4Zg55s2kUx0dOv9KmOyj2LO0ouE
        SPkReYl0h5dOGflKt9tQOEU/gSbXJO7hkodjTFnFrXjPvZEyaJQepvwcdbR8ZJXNXpcM6vNd8x3D6
        /vZvM7+A==;
Received: from [2001:4bb8:199:f14c:a24a:d231:8d9c:a947] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1knEoR-00042x-OL
        for linux-xfs@vger.kernel.org; Thu, 10 Dec 2020 05:48:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: two small setattr cleanups
Date:   Thu, 10 Dec 2020 06:48:19 +0100
Message-Id: <20201210054821.2704734-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains two cleanups to the setattr patch.  I did
those in preparation for supporting idmapped mounts in XFS, but
I think they are useful on their own.
