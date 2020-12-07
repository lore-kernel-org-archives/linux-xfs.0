Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B924AC0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F20C235F7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgLGNyT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:54:19 -0500
Received: from verein.lst.de ([213.95.11.211]:41938 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgLGNyT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:54:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C0D6467373; Mon,  7 Dec 2020 14:53:36 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:53:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Message-ID: <20201207135336.GE29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-5-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  
>  		if (ialloced) {
>  			/*
> +			 * We successfully allocated some inodes, roll the
> +			 * transaction so they can allocate one of the free
> +			 * inodes we just prepared for them.

Maybe:

			/*
			 * We successfully allocated space for an inode cluster
			 * in this AG.  Roll the transaction so that we can
			 * allocate one of the new inodes.
			 */

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
