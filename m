Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148D0C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C55FE22C9E
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393991AbhARTlC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437597AbhARTko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 14:40:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA83DC061574
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 11:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZM3Mn34c/QtQVk6s1yluGDT5Fmuv7yafvEKVvI+PlVA=; b=gfVJa4R6aPASFFKEFQGWgWE8F1
        MOhS+5uUmC1Kep5PuxTPdAgmj1l/voiTS/F31529rDTxV0xYDMdcKtZSiMgnGW8xb2aWg+up0Yb6h
        v4qRbUrMjzaOAStH9YmSdkOFc71LLDh6ZkF/5N8vbbUxFbpBloMLK15eIz+14ay34oNL+FarH3E0R
        zUQfsLjWmls5hh7rAZE8G0lA0aJ70k2GkfMpGPpP6yb0JmEZk7yFxqYqt7g7rqDSOBjZKbQbL7AgN
        rdaLu07spjo5yrv+zN2QoirGDtLuo03UXRWe0TNs33iznFXTtBzyVnCEIku5MQUEdhXFxoQSdHSCm
        k8+bcB9g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1aNa-00DJ30-VO; Mon, 18 Jan 2021 19:39:59 +0000
Date:   Mon, 18 Jan 2021 19:39:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210118193958.GA3171275@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
 <20210114215453.GG1164246@magnolia>
 <20210118173412.GA3134885@infradead.org>
 <20210118193718.GI3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118193718.GI3134581@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:37:18AM -0800, Darrick J. Wong wrote:
> Ah, I see, you're asking why don't I make xfs_inode_walk responsible for
> deciding what to do about EAGAIN, instead of open-coding that in the
> ->execute function.  That would be a nice cleanup since the walk
> function already has special casing for EFSCORRUPTED.
> 
> If I read you correctly, the relevant part of xfs_inode_walk becomes:
> 
> 	error = execute(batch[i]...);
> 	xfs_irele(batch[i]);
> 	if (error == -EAGAIN) {
> 		if (args->flags & EOF_SYNC)
> 			skipped++;
> 		continue;
> 	}
> 
> and the relevant part of xfs_inode_free_eofblocks becomes:
> 
> 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
> 		return -EAGAIN;
> 
> I think that would work, and afaict it won't cause any serious problems
> with the deferred inactivation series.

Exactly!
