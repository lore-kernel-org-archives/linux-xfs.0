Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62757C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C9C23406
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgLGUY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 15:24:27 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53790 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgLGUY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 15:24:27 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9450F58C371;
        Tue,  8 Dec 2020 07:23:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmN2v-001Ynn-4H; Tue, 08 Dec 2020 07:23:45 +1100
Date:   Tue, 8 Dec 2020 07:23:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 6/6] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201207202345.GT3913616@dread.disaster.area>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-7-hsiangkao@redhat.com>
 <20201207135719.GG29249@lst.de>
 <20201207142448.GD2817641@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207142448.GD2817641@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=N4heMFBJOfxopoWtWNsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:24:48PM +0800, Gao Xiang wrote:
> On Mon, Dec 07, 2020 at 02:57:19PM +0100, Christoph Hellwig wrote:
> > > +		error = xfs_ialloc_ag_alloc(*tpp, agbp);
> > > +		if (error < 0) {
> > >  			xfs_trans_brelse(*tpp, agbp);
> > >  
> > >  			if (error == -ENOSPC)
> > >  				error = 0;
> > >  			break;
> > > +		} else if (error == 0) {
> > 
> > No need for the else after the break.
> 
> Personally, I'd like to save a line by using "} else if {"
> for such case (and tell readers about these two judgments),
> and for any cases, compilers will do their best.

And extra line is not an issue, and the convention we use everywhere
is to elide the "else" whereever possible. e.g. we do:

	if (foo)
		return false;
	if (!bar)
		return true;
	if (baz)
		return false;
	return true;

Rather than if() {} else if() {} else if() {} else {}. The elses in
these cases mainly obfuscate the actual logic flow...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
