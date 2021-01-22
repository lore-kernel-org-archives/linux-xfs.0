Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5AFC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4A423A9C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbhAVR1B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbhAVQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 11:47:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715DDC0613D6
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jan 2021 08:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=EyCKuoy9Xe2a7OBh2j60XGSQD0swzGxeMqVggN2mwvY=; b=Y3igfn8WsnnaDNlpw4nk9/urW2
        Bl3i5Vg4gmTgtJ97/423F5PmAb12m0BDKsVhYutZTzu5/OCcJ3vjolHPU0Nz4lcFuysekBZWbSIot
        xhyjW0j4SN9LsXfAJk5snLHegMwvRO/xm0NmgGCS2BXqJt5FXSaOgy1ZzP+EfyASpLBYyH/uh5QTS
        9L7QwiSfSYcy1RnZNPu+GqPFmr0m6P/bXD++cgTTKWSPWEqW3SxJNNxgmwvr+c9aLwFcjj0D+0be2
        5466E2Cnh1csKhg+TXvJVsYlHQTJwt2B+QkjH5dlZ8iF44fSl+mmIkjEh9Nihzf+Rtj1oby1EqZpQ
        14pnC3MQ==;
Received: from [2001:4bb8:188:1954:662b:86d3:ab5f:ac21] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2za8-000yVj-7T
        for linux-xfs@vger.kernel.org; Fri, 22 Jan 2021 16:46:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: avoid taking the iolock in fsync unless actually needed v2
Date:   Fri, 22 Jan 2021 17:46:41 +0100
Message-Id: <20210122164643.620257-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series avoids taking the iolock in fsync if there is no dirty
metadata.

Changes since v1:
 - add a comment explaining the ipincount check
