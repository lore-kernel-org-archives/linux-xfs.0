Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8ABC3A59E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 22:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1813A20828
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 22:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfIBWhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 18:37:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47434 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727551AbfIBWhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 18:37:01 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0252B3612B0;
        Tue,  3 Sep 2019 08:36:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i4uwT-0003dL-RB; Tue, 03 Sep 2019 08:36:57 +1000
Date:   Tue, 3 Sep 2019 08:36:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] man: document the new allocation group geometry
 ioctl
Message-ID: <20190902223657.GT1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633310832.1215978.10494838202211430225.stgit@magnolia>
 <20190830055347.GH1119@dread.disaster.area>
 <20190830204849.GH5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830204849.GH5354@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=ax-INJZtQGbedQw1ur0A:9 a=GDpnGq4VQ1OP3iox:21
        a=PE-x1VzdD30KTsX1:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 01:48:49PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 30, 2019 at 03:53:47PM +1000, Dave Chinner wrote:
> > On Tue, Aug 20, 2019 at 01:31:48PM -0700, Darrick J. Wong wrote:
> > > +	uint64_t  ag_reserved[12];
> > 
> > Where's the flags field for feature versioning? Please don't tell me
> > we merged an ioctl structure without a flags or version field in
> > it...
> 
> Yes, we did, though the "reserved fields are always zeroed" enables us
> to retroactively define this to v0 of the structure.

OK, but this is an input/output structure, not an output-only
structure, so the flags field needs to cover what features the
caller might be expecting the kernel to return, too.,,

> > > +};
> > > +.fi
> > > +.in
> > > +.TP
> > > +.I ag_number
> > > +The number of allocation group that the caller wishes to learn about.
> > 
> > "the index of"....
> > 
> > "The number of" is easily confused with a quantity....
> > 
> > Is this an input or an output?
> 
> Purely an input.
> 
> "The caller must set this field to the index of the allocation group
> that the caller wishes to learn about." ?

*nod*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
