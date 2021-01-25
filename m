Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AAFC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0C9229C4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbhAYXIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732129AbhAYXH6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 18:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1F6227BF;
        Mon, 25 Jan 2021 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611616036;
        bh=+8+4oZVyPgHyJQpHrryE5eMLpSgChfB9UY8ZGh1R/n8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2yvUu5xyCv2IpvncK3vxMeqcWOx0l/owBEoMT3U9HDpTiK05mRRxN4A8MeNQFGR9
         zQ8iIDlOpdzGZWO77PFpz38FQWSrc02Nzi2nXvQMlK1GYlNVaiSlSAuKIosPWHSqsb
         tREgQvqT4RrVgBto+qzkas7Sv5h63ey9mvOADEPknnYEQ8UsWtLp1MLSOYEECSMbVc
         TgOjDRbZmL4/Pw7nJ9wVkfz6ull9X0GWvmDuCjWk1PPQE0k6HO1t+rHAGl9Rg97E6C
         JnNvnzx4cAYiNgQQQUpmxDs8nh9DfImXruZRnZGgvLQ53r50krsJV7GZeukKR67qdR
         rAgvR0bZ/WFCg==
Date:   Mon, 25 Jan 2021 15:07:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210125230716.GF7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142798840.2173328.10025204233532508235.stgit@magnolia>
 <20210124095717.GH670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124095717.GH670331@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:57:17AM +0000, Christoph Hellwig wrote:
> On Sat, Jan 23, 2021 at 10:53:08AM -0800, Darrick J. Wong wrote:
> >  	ASSERT(agno < mp->m_sb.sb_agcount);
> >  	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
> >  
> > -	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
> > -	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
> > -			nr_threads);
> > +	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk", 0);
> 
> 
> Why not drop the last argument to xfs_pwork_init as well?  Also I don't
> think this makes sense as a standalone step without the changes in the
> next patch.

Ok, I'll combine these two.

--D
