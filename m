Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E9CC0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02DF206C1
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgLGQja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:39:30 -0500
Received: from verein.lst.de ([213.95.11.211]:42630 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgLGQj3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 11:39:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B5C0F67373; Mon,  7 Dec 2020 17:38:46 +0100 (CET)
Date:   Mon, 7 Dec 2020 17:38:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 5/6] xfs: spilt xfs_dialloc() into 2 functions
Message-ID: <20201207163846.GA11140@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-6-hsiangkao@redhat.com> <20201207135642.GF29249@lst.de> <20201207143300.GE2817641@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207143300.GE2817641@xiangao.remote.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:33:00PM +0800, Gao Xiang wrote:
> Hi Christoph,
> 
> On Mon, Dec 07, 2020 at 02:56:42PM +0100, Christoph Hellwig wrote:
> > >  		if (pag->pagi_freecount) {
> > >  			xfs_perag_put(pag);
> > > +			*IO_agbp = agbp;
> > > +			return 0;
> > 
> > I think assigning *IO_agbp would benefit from a little consolidation.
> > Set it to NULL in the normal unsuccessful return, and add a found_ag
> > label that assigns agbp and returns 0.
> 
> Just to confirm the main idea, I think it might be:
> 
> *IO_agbp = NULL;  at first,
> 
> and combine all such assignment
> > > +			*IO_agbp = agbp;
> > > +			return 0;
> >
> 
> into a new found_ag lebel, and use goto found_ag; for such cases.
> Do I understand correctly? If that is correct, will update
> in the next version.

I would also move

	*IO_agbp = NULL;

to just before the

	return error;

to match the assignment for the successful case, but that isn't
the important part.  I think the important part is to have on
central place for the sucessful return.
