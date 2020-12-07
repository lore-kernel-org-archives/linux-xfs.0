Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2E6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1809235DD
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgLGN6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:58:02 -0500
Received: from verein.lst.de ([213.95.11.211]:41956 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgLGN6C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:58:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0DEEB68AFE; Mon,  7 Dec 2020 14:57:20 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:57:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 6/6] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201207135719.GG29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-7-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-7-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		error = xfs_ialloc_ag_alloc(*tpp, agbp);
> +		if (error < 0) {
>  			xfs_trans_brelse(*tpp, agbp);
>  
>  			if (error == -ENOSPC)
>  				error = 0;
>  			break;
> +		} else if (error == 0) {

No need for the else after the break.
