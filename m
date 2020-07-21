Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62802C433F2
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 18:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C336207DD
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 18:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XFvfug7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgGUScT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 14:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbgGUScI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 14:32:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E4C0619DA;
        Tue, 21 Jul 2020 11:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wjd9uUGiHUCjYx9puh8uha+RMiUWI8gxjnv7qGgpe28=; b=XFvfug7UE/CC5zFqkvgqCe0216
        VvJ8zyvmyUwmgvzrTDBTvgLWqwuItZpxjQrwu1dw89/Lhp2LFsFPUw8mSEaHzi5Ting9+66nRduHY
        kUR5iTNCr2Xje7OeEEegthbUmUjOTYsotgH0cJE+Ch403ZJ8ExcMyXkQ1Zz8SKczui6VCx2BS/Rsn
        2KbRwK9u7lgylkeIOqh3MN4jBVlIe6HmjVHYbRZkpEYaLn5u7hEYWZSBaB+yeYoiQBzcwAGYOJL5O
        rnGEnz4UdMYvFVCPD2PwuD5xvhvTyuTE4L08KY4dtfh/lVVybeLeYoEeLhwrK8uxiHA3jUjfL4vX/
        cKcImh3Q==;
Received: from [2001:4bb8:18c:2acc:5b1c:6483:bd6d:e406] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxx3X-00062K-3m; Tue, 21 Jul 2020 18:31:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: iomap write invalidation v2
Date:   Tue, 21 Jul 2020 20:31:54 +0200
Message-Id: <20200721183157.202276-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Changes since v1:
 - use -ENOTBLK for the direct to buffered I/O fallback everywhere
 - document the choice of -ENOTBLK better
 - update a comment in XFS
