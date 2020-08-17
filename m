Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3781AC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1275C20772
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qqtMzb25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgHQGxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgHQGxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:53:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECEAC061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ojI/CbjgRWjxHX+6jNrLlqFxSrT3MN5Non7i45V3Dak=; b=qqtMzb25ypwKm6fJvqnpsusB5P
        KR6gcxEXpOFo49z6euqum0faKRf8nyGfXqki30ytQDzB4M7WiHeqFSSJmk9uRvh85VasM8T6lAfE+
        ICwxstL+z6/UVcy9C/Fo6RFNqMOPxVStVfCd9s5K7oEYpna7Ynl27s5M7KqK+56EhRBvL3PZTN9+p
        Efm+7gHQsqIFZsD13P17xCVqIQdyTV5whmZWTNgmx7WoudTkwgbJ2QrOAO3iVu9f25n4klIX+elAw
        YH+R8j1zd4s1Du1p8TytvUIPyjiupQuck+tRmBcmx32War1ABnyJyNTzPmTIfxlCcphWtVFrP9ie0
        idfLjRBQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z1R-0006Yp-Bp; Mon, 17 Aug 2020 06:53:33 +0000
Date:   Mon, 17 Aug 2020 07:53:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_db: fix nlink usage in check
Message-ID: <20200817065333.GC23516@infradead.org>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736124295.3063459.16896525594275470708.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736124295.3063459.16896525594275470708.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> process_inode uses a local convenience variable to abstract the
> differences between the ondisk nlink fields in a v1 inode and a v2
> inode.  Use this variable for checking and reporting errors.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
