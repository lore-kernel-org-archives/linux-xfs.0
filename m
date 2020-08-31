Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98086C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7386220767
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="deHMxrZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHaQEC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgHaQEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:04:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B926C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2HvHQjt58igkcWegD0nRRdGxYdDUTXmQRC/5EfjRnVk=; b=deHMxrZXq718OiRUzacoo3JMaI
        qEH+tmdX0NwaSrtdIcih0Zy8td4spwBA0y1r4bnm1zvA4r8Tix5xf+6WlKjnKDQq9GeTxMbMzIOfq
        Zb8puvEcWrB+oj1O9aieyYsCtNupQGjk7lXBmjWLQtOEJHvNedMc0zc7EftWb71+4qdQ98KaU43Ml
        ExN60AnYAKjzsTQqSY9407/dvs1zMmFPvA+8g45n92aOyT2SYZTj91MgfLerc8Rpad/VbiwS5lRHl
        v4HjxgeUV3z4F6tsIZEoagaoEqd0SF0WRJ6NHs9h4YgXFH3tJYZHYZUPtQc22TF4zDuogXf4CKdfl
        lqhb2vSg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCmHm-0001wf-Ug; Mon, 31 Aug 2020 16:03:58 +0000
Date:   Mon, 31 Aug 2020 17:03:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 06/11] xfs: redefine xfs_timestamp_t
Message-ID: <20200831160358.GA7091@infradead.org>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885404651.3608006.10399319045770054721.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885404651.3608006.10399319045770054721.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redefine xfs_timestamp_t as a __be64 typedef in preparation for the
> bigtime functionality.  Preserve the legacy structure format so that we
> can let the compiler take care of masking and shifting.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I think it would make more sense if this patch and the next
patch were merged into the main one after them.
