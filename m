Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE668C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 612A364F3F
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCOSzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 14:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhCOSy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:54:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7B6C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zjE7zvlSPg0+NGpwVV3DGG5qx7pOjvQLjkkulfCSGaY=; b=K7/+C2cLsXjRjRilx2IUXmBl5L
        bj6R5McMdh592o3MMrTbCNYFHMVbQB1TVUfkVFBd9Jl9I6QsHUW0HhFWhMGtO+0lhgfGWztd7glRz
        qIpK09S8hJ3aqEbltxXDGngrQhXPgXAwuRRrGsul32ept2ZzAycatvnC1WGL/ZDtVeB3N60wWabmA
        tNtSyg/gqR8kGztdee3tY0BO37/zaC/jPTalRm4SKx7t3QI5egYeFngCb+tcNUEE6MzY4FOk8Ow0M
        XnHqKjt3jIKPjsPcT0KiaZZ/QCBSqXxYgBd2SUQO+hS7ExgqKasKLPKSd+pXuvRbnlul2zn0L8Iv9
        vPqSRufg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLsMf-000cfo-BG; Mon, 15 Mar 2021 18:54:55 +0000
Date:   Mon, 15 Mar 2021 18:54:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: force inode inactivation and retry fs writes
 when there isn't space
Message-ID: <20210315185453.GE140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543198495.1947934.14544893595452477454.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543198495.1947934.14544893595452477454.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:25PM -0800, Darrick J. Wong wrote:
> +	error =  xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
>  			XFS_ICI_BLOCKGC_TAG);

Nit: strange double whitespace here.
