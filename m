Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E184C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 06:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88422080C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 06:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqZV5GUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgIIGBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 02:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIGBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 02:01:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6950C061573;
        Tue,  8 Sep 2020 23:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=KqZV5GUVG5Yi95fslNkDvhBrTZ
        Lr3UkbjuEFNKSj28RDeRcZGhqW3/dHYpE13iYscjaSAnWpVOAEuvqFNxrEo4yqz8Wfea2V7LsfhDu
        ea4MCI/Eo4T7pIKxyz1KjD6r+63jjg3NJI9vi6xxTGFK+HnA6US8vQB6aKTHFyl5sg7dY9MELfC7L
        szmHbJUrBtUalgL+5HvfMgUUGQEuND/GibZMwN+95DOiox8XEXHSs30cRpPY+L0i05Tp73Oo1ZKYO
        785vbRLkb697yQ+GF2QjVKw4q4zTGvTmNKIf3B11y5tqpyjErwzbdl4y95NeHW8LUlVWNU0Z7qxC9
        t/QgLw+w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFtAo-00041V-Pd; Wed, 09 Sep 2020 06:01:38 +0000
Date:   Wed, 9 Sep 2020 07:01:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>
Subject: Re: [RESEND PATCH 1/1] block: Set same_page to false in
 __bio_try_merge_page if ret is false
Message-ID: <20200909060138.GB13647@infradead.org>
References: <bfee107c7d1075cab6ec297afbd3ace68955b836.1599620898.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfee107c7d1075cab6ec297afbd3ace68955b836.1599620898.git.riteshh@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
