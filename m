Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594E5C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0A420716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OtWAYFoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgCLORT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:17:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLORT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=EnUNmoVn6e/++MWQjOe5SS2NCidWX64Nc6/c0mGJ7FA=; b=OtWAYFoe5td4dpWsvv9mR39aur
        dIE2NtuZAW4GIBysaAB589uICLHY9ycxKxCcTpAHrsFx3n+Vxz7/hJSEUeCQx9Y/KtgNdWU0BBcat
        VyZLTr1NPEBU1HcKCbJQ4sXBKzwf5rcDo3qZcIMIrd4mYXItqNIKgtr5J77Uxc7D/VLiq4az2xNjl
        qRkDdTRPYNQl82pHGyPkSMfVYqmBzDXwLN5rx8ux0VLyYaWJUjcbfy4ozrzPsLBLz6FBIZzaD2Wax
        1Hu5MHLkmnX6BimCzYBnX/rjwpXEB6gADZRkB1vXRv2Eb9eWCbusJPBHaIC+4go7k8BdYeF+/RksF
        n+4bmOJw==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOeE-0001r6-Nq
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:17:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc xfsprogs cleanups
Date:   Thu, 12 Mar 2020 15:17:11 +0100
Message-Id: <20200312141715.550387-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

a bunch of random xfsprogs cleanup for things I found while porting
over the attr cleanups.
