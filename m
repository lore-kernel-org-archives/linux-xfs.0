Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D964C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E33207FB
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JnefT5Oc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgHQGyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQGyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:54:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B02BC061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IL+umwX9fa23/U+dSJmTaU3X1M3WfQq4TF/WynU9cGE=; b=JnefT5Oct+FGJyxFR0EC/EP7DK
        olnhU40z0a6A1vg2rNdhFdw1aj9ZfzjRh/9EPO5WWinrTH8aUZhWaGD8D2A8RvYeh7Yorl+ZsKusF
        iEXq6YccZC9RcKfAll3CGccUCP1B1mLiOVjJDs8DPh4K2rPkryUV2lQYrze739yRADxoQDPlkjQZt
        GlJJdeVeF1iSoIoQIqu58idMMIFfyOACtT15ZvpOZL1kbuby5xIjEwCFe+A3fU9uD1qO/hsEdzyap
        q3/+b3IOwhX+2t0LWhGH/Yf/jm7f3e0ejx1oOqSjubmeFt4D7VS6rEV6nDYKz60kqRqwNmTSwW6vX
        kPn1L2EA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z2g-0006cH-A9; Mon, 17 Aug 2020 06:54:50 +0000
Date:   Mon, 17 Aug 2020 07:54:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: allow setting dax flag on root directory
Message-ID: <20200817065450.GF23516@infradead.org>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736126408.3063459.10843086291491627861.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736126408.3063459.10843086291491627861.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach mkfs to set the DAX flag on the root directory so that all new
> files can be created in dax mode.  This is a complement to removing the
> mount option.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
