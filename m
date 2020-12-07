Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB08C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DC3235F9
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgLGOWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:22:23 -0500
Received: from verein.lst.de ([213.95.11.211]:42098 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgLGOWX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 09:22:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8396E67373; Mon,  7 Dec 2020 15:21:40 +0100 (CET)
Date:   Mon, 7 Dec 2020 15:21:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207142140.GA32764@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-4-hsiangkao@redhat.com> <20201207134941.GD29249@lst.de> <20201207141948.GB2817641@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207141948.GB2817641@xiangao.remote.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:19:48PM +0800, Gao Xiang wrote:
> > Maybe spell out parent_inode?  pino reminds of some of the weird Windows
> > code that start all variable names for pointers with a "p".
> 
> Ok, yet pino is somewhat common, as I saw it in f2fs and jffs2 before.
> I know you mean 'Hungarian naming conventions'.
> 
> If you don't like pino. How about parent_ino? since parent_inode occurs me
> about "struct inode *" or something like this (a pointer around some inode),
> rather than an inode number.

Yeah, parent_ino is what I mean to suggest anyway, sorry for the typo.
