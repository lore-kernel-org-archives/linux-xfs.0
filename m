Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9902DC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 17:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60897650A3
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 17:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCERtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 12:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhCERtm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Mar 2021 12:49:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EEF064DEC;
        Fri,  5 Mar 2021 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614966582;
        bh=8k3riGrwEt5J8zXbZg2HzRTVL3/O/76RJfrTZQKmbf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L2wFYTZAXhpORyAeX+fbjU/F2YN3hWcjmE+Y8iKBQ8m+TT9ojp+GqGSDGtOle7o3M
         d3F+maMCo/ZRBkhkOOnL90mEO4pgQcLribmB1XIcCtTzcO2bqLTDVxGSf2UphYBeow
         gn3GZfafajlq7efHoQPmjVWemlXuDNAhxtGQ96zmrv28KeQm6Zw2p5FOQwlvyhWfbo
         HuZhIX7L2XE1KoOHvMXaz/pITIp9m9dsVtY5G7TmDziKQINZL9nFDm47p3TvpTSDIr
         yl0Tac0iSAC5XtQh1lB6XkBjR2ZKBT7UOXjnfpmH7/woViqIkzG60+s//4zD4wQpsA
         o0UPXr0Q8ghmA==
Date:   Fri, 5 Mar 2021 09:49:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix uninitialized variables in
 xrep_calc_ag_resblks
Message-ID: <20210305174941.GH3419940@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472412192.3421582.514508996639938538.stgit@magnolia>
 <20210305082300.GA2567783@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305082300.GA2567783@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 08:23:00AM +0000, Christoph Hellwig wrote:
> On Tue, Mar 02, 2021 at 02:28:42PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we can't read the AGF header, we never actually set a value for
> > freelen and usedlen.  These two variables are used to make the worst
> > case estimate of btree size, so it's safe to set them to the AG size as
> > a fallback.
> 
> Do we actually want to continue with the rest of the funtion at all
> in this case?

We do, because this function computes the amount of block reservation to
feed to xfs_trans_alloc when userspace said it wants us to try to repair
something AG-related.

Although... I suppose we don't really need a block reservation to repair
superblocks and AG headers, so we could special-case those four scrub
types to return 0.

(OTOH this is all mostly academic because repair requires rmapbt, which
means that the fs won't even mount with a busted AGF...)

--D
