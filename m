Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D512C34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53C8424656
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBSED4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:03:56 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59266 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbgBSED4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:03:56 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9D76C7EB18D;
        Wed, 19 Feb 2020 15:03:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4GaY-0005ja-2l; Wed, 19 Feb 2020 15:03:54 +1100
Date:   Wed, 19 Feb 2020 15:03:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 05/31] xfs: use strndup_user in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200219040354.GJ10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-6-hch@lst.de>
 <20200217221538.GJ10776@dread.disaster.area>
 <20200218152432.GB21275@lst.de>
 <20200219003816.GC9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219003816.GC9506@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=g7DWc3qY4QalcS12rlAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:38:16PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 18, 2020 at 04:24:32PM +0100, Christoph Hellwig wrote:
> > On Tue, Feb 18, 2020 at 09:15:39AM +1100, Dave Chinner wrote:
> > > >  
> > > > -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> > > > -				ops[i].am_attrname, MAXNAMELEN);
> > > > -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> > > > -			error = -ERANGE;
> > > > -		if (ops[i].am_error < 0)
> > > > +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> > > > +		if (IS_ERR(attr_name)) {
> > > > +			ops[i].am_error = PTR_ERR(attr_name);
> > > >  			break;
> > > > +		}
> > > 
> > > This changes the error returned for an invalid attr name length from
> > > -ERANGE to either -EINVAL or -EFAULT. Can you please document that
> > > in the commit message. This change requires updates to the 
> > > path_to_handle(3) man page shipped in xfsprogs in the xfslibs-dev
> > > package (xfsprogs::man/man3/handle.3) to document the differences in
> > > return values.
> > 
> > I can't find that man page documenting -ERANGE at all..
> 
> Should we add both to the errors list, then?  Seeing as (I think?) the
> kernel can actually return this...

IMO, yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
