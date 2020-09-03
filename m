Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699A4C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3550E2065F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hBtIDuka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgICIw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgICIwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 04:52:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EACC061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 01:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=hBtIDukaxPW0Wc1AJJa7EOcVaG
        T9K6Bc8HASAY8V4JgJqPBBdwZO1N5KF7ZbjVU3HP8kv+DUVSzd1EkI0zmpBPK9Gg7mCIu0XHxPuJs
        8j3QO1I06CCn7dSEq2oD0wz31WlFLlAiVfKA19JTdWnvHmYurKzT05n7jLKnKQ0UYkd3Gr/evTOP7
        6di+Xi1OWTh0g5ia+I28Tpjz7nQpkXP2yOiQi+LQBqjseK9O2IV/AQ/rkkWf1fKhyEZzsgdXujoIJ
        hlss07dXEEmok9X14PenGbDg7UjOfwrbjk8XiN7l+qjhpM4NoAcsgiWGK48UoqszKvgsLe7zMc0/1
        BOP3JcPA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkzE-0002ln-Nz; Thu, 03 Sep 2020 08:52:52 +0000
Date:   Thu, 3 Sep 2020 09:52:52 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/4] xfs: remove typedef xfs_attr_sf_entry_t
Message-ID: <20200903085252.GA10584@infradead.org>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-2-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
