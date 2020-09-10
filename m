Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E374C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2E520731
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s8PWxzHn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgIJFmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 01:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgIJFmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 01:42:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA46DC061573
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 22:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zIdCyu50W5cO8DXLxdVW1XOZTdgBT5Plz+jczPRZ9sE=; b=s8PWxzHnRhumcj66pGvtSY1vqB
        pT2Bfl2V5vNAxmnIGiw5s2IRiHBdUQc5wVoThotJYEhn5Fd9Lt5h9RqZpllmRK+dlZ0nmfORGou+9
        aVXWHkCkBmapmYvVmTFQ/0gRmjn/tLKlupgnOEcl4xiHvNNOMrm34EBMzqYe0fME9iPLDyrOp9qLR
        rf3mgtO4ZEMjUrlhagMn+zUQFz8fPVaGuUBxOIKNW0+bkhDG2Dobvg3aVvVjGxA1z4IxnAI2LQRy9
        N6db8CTCqMX7qkVRNYWEUSwlJ8JWVWQNgY8tBTekyx0Egb2zCzcOAp8CnVM3+axdONZK+HMvj3peI
        QkQy37jg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGFM6-0002Ao-8C; Thu, 10 Sep 2020 05:42:46 +0000
Date:   Thu, 10 Sep 2020 06:42:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: don't propagate RTINHERIT -> REALTIME when
 there is no rtdev
Message-ID: <20200910054246.GB7379@infradead.org>
References: <159971620202.1311472.11867327944494045509.stgit@magnolia>
 <159971621697.1311472.12347305476746590593.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159971621697.1311472.12347305476746590593.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 10:36:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While running generic/042 with -drtinherit=1 set in MKFS_OPTIONS, I
> observed that the kernel will gladly set the realtime flag on any file
> created on the loopback filesystem even though that filesystem doesn't
> actually have a realtime device attached.  This leads to verifier
> failures and doesn't make any sense, so be smarter about this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
