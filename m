Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B74C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB66F6113C
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbhGTFyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 01:54:45 -0400
Received: from verein.lst.de ([213.95.11.211]:53898 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242043AbhGTFyk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jul 2021 01:54:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9741468AFE; Tue, 20 Jul 2021 08:35:17 +0200 (CEST)
Date:   Tue, 20 Jul 2021 08:35:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210720063517.GB14747@lst.de>
References: <20210712111426.83004-1-hch@lst.de> <20210712111426.83004-2-hch@lst.de> <20210715171549.GV22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715171549.GV22402@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 10:15:49AM -0700, Darrick J. Wong wrote:
> > +	if (flags & XFS_ALL_QUOTA_ACCT)
> > +		xfs_info(mp, "disabling of quota accounting not supported.");
> 
> Why not return EOPNOTSUPP here?  We're not going to turn off accounting,
> so we're not doing what the admin asked.

Because what the user usually wants is to disable visible effects of
quota, and we still give that.  The fact that we keep accounting underneath
isn't quite as relevant as there is no different user behavior, just a little
overhead.

[snipping the rest of the full quote..]
