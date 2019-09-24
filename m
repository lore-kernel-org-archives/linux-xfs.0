Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71149C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 04:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C31B206C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 04:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfIXENi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 00:13:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50011 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbfIXENi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 00:13:38 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DDE7D43E2B3;
        Tue, 24 Sep 2019 14:13:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iCcCi-0007NP-8j; Tue, 24 Sep 2019 14:13:32 +1000
Date:   Tue, 24 Sep 2019 14:13:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190924041332.GE16973@dread.disaster.area>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190919150154.30302-1-billodo@redhat.com>
 <20190919170353.GA1646@infradead.org>
 <20190919172047.GA3806@redhat.com>
 <20190919173801.GA16294@infradead.org>
 <dbf196da-bede-6bbe-db3e-35d7040170d0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf196da-bede-6bbe-db3e-35d7040170d0@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=iqSqlA3UX--CzvYtrHQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 09:59:41AM -0500, Eric Sandeen wrote:
> On 9/19/19 12:38 PM, Christoph Hellwig wrote:
> > On Thu, Sep 19, 2019 at 12:20:47PM -0500, Bill O'Donnell wrote:
> >>>> @@ -391,7 +396,7 @@ xfs_buf_allocate_memory(
> >>>>  		struct page	*page;
> >>>>  		uint		retries = 0;
> >>>>  retry:
> >>>> -		page = alloc_page(gfp_mask);
> >>>> +		page = alloc_page(gfp_mask | kmflag_mask);
> >>>
> >>> alloc_page takes GFP_ flags, not KM_.  In fact sparse should have warned
> >>> about this.
> >>
> >> I wondered if the KM flag needed conversion to GFP, but saw no warning.
> > 
> > I'd be tempted to just do a manual memset after either kind of
> > allocation.
> 
> At some point I think Dave had suggested that at least when allocating pages,
> using the flag would be more efficient?

With some configurations pages come from the free lists pre-zeroed,
and so don't need zeroing to initialise them (e.g. when memory
poisoning is turned on, or pages are being zeroed on free). Hence if
you use __GFP_ZERO the it will only zero if the page obtained from
the freelist isn't already zero. The __GFP_ZERO call will also use
the most efficient method of zeroing the page for the platform via
clear_page() rather than memset()....

/me shrugs and doesn't really care either way....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
