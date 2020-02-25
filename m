Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DF2C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 339982072D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgBYAtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:49:53 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40123 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbgBYAtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:49:53 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 54CD93A2512;
        Tue, 25 Feb 2020 11:49:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6OQ2-0004zu-Ay; Tue, 25 Feb 2020 11:49:50 +1100
Date:   Tue, 25 Feb 2020 11:49:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20200225004950.GB10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-2-allison.henderson@oracle.com>
 <CAOQ4uxhmsq9aDPPofS=UPrfcate=h-Jj_Qp95_7-N8_WuDCBTw@mail.gmail.com>
 <b7183c7e-e046-13f0-92a6-efa94e0ecfcc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7183c7e-e046-13f0-92a6-efa94e0ecfcc@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=K23P66ZRLK3JR6_WlsEA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 09:03:05AM -0700, Allison Collins wrote:
> On 2/23/20 2:34 AM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > A struct inititializer macro would have been nice, so code like this:
> > 
> > +       struct xfs_name         xname;
> > +
> > +       xfs_name_init(&xname, name);
> > 
> > Would become:
> > +       struct xfs_name         xname = XFS_NAME_STR_INIT(name);
> > 
> > As a matter of fact, in most of the cases a named local variable is
> > not needed at
> > all and the code could be written with an anonymous local struct variable macro:
> > 
> > +       error = xfs_attr_remove(XFS_I(inode), XFS_NAME_STR(name), flags);
> > 
> The macro does look nice.  I would be the third iteration of initializers
> that this patch has been through though.  Can I get a consensus of how many
> people like the macro?

Not me. All it means is that every time I look at this code I have
to go look at what that shouty macro does, then have to understand
it's being "smart and clever" to save a couple of lines of clear,
obviously correct code.

That's not an improvement.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
