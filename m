Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE95C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE24022ADF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbhAXJ6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhAXJ6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:58:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7338AC061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BFDVwAhCCfnjn66kLmK6CnVcM8Z/lXThM40g03sNG+0=; b=OMrAKUBUIl/cBkyfwmHLwKV4RW
        gPkycNVJeoRoYbfkfZFE0hgKguQj+ReuxEVmWjKl++mhTxiHLZx3jygpBbWje92NSzu0/hRevJ5KK
        XM6l3CWdWuqkazHE+FaDAtNrzzf3Lvg58bqENMyr3MaC/3LmZtb1A4WwWcO02Ma7j/fA5rmAEA8pY
        iQWEtDo6MtjNLnPevQW/vk4QIgyoXTJ1aHIUXSzHN4n/aFG6KjEuCnkvy2TtWZ3eXuhrMLGJ4ew40
        TQapldx+/t4D40UQu3p0KQF0UFbwWEkfCisDU98Ziz4oQ7D6m7g8No/R+WApiEArHh7xdb/r7tpWu
        qGIK6tuw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3c8z-002phQ-EQ; Sun, 24 Jan 2021 09:57:29 +0000
Date:   Sun, 24 Jan 2021 09:57:17 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210124095717.GH670331@infradead.org>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142798840.2173328.10025204233532508235.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142798840.2173328.10025204233532508235.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:53:08AM -0800, Darrick J. Wong wrote:
>  	ASSERT(agno < mp->m_sb.sb_agcount);
>  	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
> -	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
> -	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
> -			nr_threads);
> +	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk", 0);


Why not drop the last argument to xfs_pwork_init as well?  Also I don't
think this makes sense as a standalone step without the changes in the
next patch.
