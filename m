Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D3DC55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DF422261
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hXUyvW4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKNKr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKNKrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:47:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEA9C0613D1;
        Sat, 14 Nov 2020 02:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j03LPiNtSqozf2yV7ydBvh8jhN2izm91Ek0S3bi3B8k=; b=hXUyvW4F2WaX0+i1cIcmrcnG6w
        GP0aUOuCfNQucTh4K8UfVcTUsqPYxnbwP2kjRw/Z8PQp727zLzgjvSvaOgDRg9oNijoJAnPotmsAu
        eWEV4QG1wAToynbo9khyr1P7eUQV6jyDDfsHlDHZpKtC4F1PrPgxxS54jRW0uGUxOj6L5OFL59lAs
        fKYf2aDQukYt4inG8s9feNV92YcBdoIP5O35g7Qm9G/pwP+uJHDqSamZJ+1ctSPJrektf59V1MJ4f
        8OT5oZh0/bzKDhBjlo8WdK6n4dah2h3DpodTkeM7j1QBw8W+UxQE7c8mH1JAJMd8WcNjL5H4ZqHJ0
        3WBzYDcA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdt61-0003QL-F3; Sat, 14 Nov 2020 10:47:53 +0000
Date:   Sat, 14 Nov 2020 10:47:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fsstress: get rid of attr_list
Message-ID: <20201114104753.GG11074@infradead.org>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505550232.1389938.14087037220733512558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505550232.1389938.14087037220733512558.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of the loop to check if the attr existed can't we just check
for the ENODATA return value from removexattr?

Also I think with this series we can drop the libattr dependency
for xfstests, can't we?
