Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AE5C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AEC220721
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEUJCv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 05:02:51 -0400
Received: from verein.lst.de ([213.95.11.211]:53754 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgEUJCu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 May 2020 05:02:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DEEC868BEB; Thu, 21 May 2020 11:02:48 +0200 (CEST)
Date:   Thu, 21 May 2020 11:02:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: remove flags argument from xfs_inode_ag_walk
Message-ID: <20200521090248.GA8252@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993914950.976105.8586367797907212993.stgit@magnolia> <20200520063825.GE2742@lst.de> <20200520183627.GX17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520183627.GX17627@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 11:36:27AM -0700, Darrick J. Wong wrote:
> > > -		if (flags & SYNC_WAIT)
> > > +		if (wait)
> > >  			ret = -EAGAIN;
> > >  		return ret;
> > 
> > Just me, but I'd prefer an explicit:
> > 
> > 		if (wait)
> > 			return -EAGAIN;
> > 		return 0;
> > 
> > here.  Not really new in this patch, but if you touch this area anyway..
> 
> How about 'return wait ? -EAGAIN : 0;' ?

Yikes.  Why does everyone hate the nice, explicit and readable if
statements?
