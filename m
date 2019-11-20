Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A41AC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B238208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfKTSUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:20:38 -0500
Received: from verein.lst.de ([213.95.11.211]:41626 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbfKTSUi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Nov 2019 13:20:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F41C968B05; Wed, 20 Nov 2019 19:20:35 +0100 (CET)
Date:   Wed, 20 Nov 2019 19:20:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling
 conventions
Message-ID: <20191120182035.GA11912@lst.de>
References: <20191120111727.16119-1-hch@lst.de> <20191120111727.16119-4-hch@lst.de> <20191120181708.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120181708.GM6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 10:17:08AM -0800, Darrick J. Wong wrote:
> > -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> > -				&mapp, &nmap);
> > +	error = xfs_dabuf_map(dp, bno,
> > +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> > +			whichfork, &mapp, &nmap);
> >  	if (error) {
> >  		/* mapping a hole is not an error, but we don't continue */
> > -		if (error == -1)
> > +		if (error == -ENOENT)
> 
> Shouldn't this turn into:
> 
> if (error || !nmap)
> 	goto out_free;
> 
> Otherwise looks ok to me.

Yes, it should.  Looks like that hunk got lost in the reshuffle.
