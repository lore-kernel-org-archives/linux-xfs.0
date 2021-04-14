Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18111C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22C361166
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349099AbhDNGLc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhDNGLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:11:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96471C061574
        for <linux-xfs@vger.kernel.org>; Tue, 13 Apr 2021 23:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=df/32Q6BssynM62RuNW7+Lr2+g
        4x3fONvMOPk12dAL8nklPitmqwCF7gtI3GZ83fyTm8MgHKq55/+bTaLIrrjfG4DG6Qe9MKuC+d9AC
        Cs4rBRd7piKwGn6OWo84fcfPc5fNDBpKiJrlwdUtHTvVWAbKkcfv5la9iD83IxJ1MPo5hH98jmtpf
        aBCKepLviuixUbHGDAxa/IeMHOoziBM/RDQVuIQrBY2XOxdZMM4bMStWMAoK68NBPRfztCBH0ovem
        Wdsgem9pDRDflgmIor+p9PobUywz/WCgPqFcvKWjgoIUOCQhEbsE+PK+efpwSSrkmsY/ytrUlFK5u
        nhzcbySQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYjq-006j16-HX; Wed, 14 Apr 2021 06:11:01 +0000
Date:   Wed, 14 Apr 2021 07:10:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_admin: pick up log arguments correctly
Message-ID: <20210414061058.GB1602505@infradead.org>
References: <161834764606.2607077.6884775882008256887.stgit@magnolia>
 <161834765914.2607077.678191068662384784.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161834765914.2607077.678191068662384784.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
