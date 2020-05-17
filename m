Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BAFC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F34BF207ED
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgEQH6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 03:58:12 -0400
Received: from verein.lst.de ([213.95.11.211]:34277 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgEQH6M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 03:58:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5165968C4E; Sun, 17 May 2020 09:58:10 +0200 (CEST)
Date:   Sun, 17 May 2020 09:58:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200517075810.GB30453@lst.de>
References: <20200508063423.482370-1-hch@lst.de> <20200508063423.482370-10-hch@lst.de> <20200516174927.GY6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516174927.GY6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 10:49:27AM -0700, Darrick J. Wong wrote:
> > +int
> > +xfs_ifork_verify_local_data(
> >  	struct xfs_inode	*ip)
> >  {

> > +	if (fa) {
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> > +			ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
> 
> Needs more indent, but I could fix this on merge...

Sure.  It seems like that is the only outstanding comment on this series,
so maybe you should just pick it up and I shouldn't bother to resend it?
