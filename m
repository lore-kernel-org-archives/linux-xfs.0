Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C62C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9879235FC
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CU5EhG2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIWHtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWHtM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:49:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC57C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vKnWFSWOPfu4X0Ehj8llISfppztHMxK0qXOJU62ZAzo=; b=CU5EhG2h5yGZyMKSk1gEtM0kdG
        94PoWoEe9a8F4NQtMyY9+5gqaXa/Co5UE2bV0o7gfKKScbPqUmWH7e3VWtqQDZC4Zertxv357zfpN
        OE3M1nJHeGasdzS+PctGY1VlySizaEwk4x/7kY/+YbPOII3oJYwowfeYB4G7EwEqOP8jDt/whMcd+
        bABeILQ03LPHpL2KDAO5F52cyE/70q0y/45WUJmchwHSJ67wUGB4L5n2BZdFFdoS7caUM3yjZcLYi
        s1qvU3BrOOek3wLVaG18d+m2elnYnharacn+gNO5y00wv5qDm8Ugz8PNHgXoG7P5XBExdTLYjt/xw
        Swr74eJA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKzWY-0001LS-GA; Wed, 23 Sep 2020 07:49:10 +0000
Date:   Wed, 23 Sep 2020 08:49:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: xfs_defer_capture should absorb remaining block
 reservation
Message-ID: <20200923074910.GB31918@infradead.org>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031335340.3624461.9858183522513375436.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031335340.3624461.9858183522513375436.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should absorb the remaining block reservation so
> that when we continue the dfops chain, we still have those blocks to
> use.
> 
> This adds the requirement that every log intent item recovery function
> must be careful to reserve enough blocks to handle both itself and all
> defer ops that it can queue.  On the other hand, this enables us to do
> away with the handwaving block estimation nonsense that was going on in
> xlog_finish_defer_ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
