Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E66C3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D724A2084E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgCECnd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:43:33 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43855 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgCECnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:43:33 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3BF687EA0E5;
        Thu,  5 Mar 2020 13:43:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9gTy-0006Jk-LJ; Thu, 05 Mar 2020 13:43:30 +1100
Date:   Thu, 5 Mar 2020 13:43:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: convert btree cursor ag private member name
Message-ID: <20200305024330.GH10776@dread.disaster.area>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-3-david@fromorbit.com>
 <20200305023141.GQ8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305023141.GQ8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=yodMamlOd2oJP2kfEp4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:31:41PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 05, 2020 at 12:45:32PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > bc_private.a -> bc_ag conversion via script:
> > 
> > `sed -i 's/bc_private\.a/bc_ag/g' fs/xfs/*[ch] fs/xfs/*/*[ch]`
> 
> Just out of curiosity, does the following cocci script do this more
> cleanly:
> 
> @@
> expression cur
> @@
> 
> - cur->bc_private.a
> + cur->bc_ag
> 
> <EOF>
> 
> Coccinelle does know how to do some kernel-style cleanups of the lines
> it touches, though I admit that the spatch format is /really/ hard to
> understand (and I barely grok it).  When it works, it's a wonderful
> refactoring tool.

No idea. I don't understand the cocci syntax, and I'm not about to
audit 250+ automated changes to see if it does anything different to
a simple sed regex. Nor am I expecting reviewers to manually check
every single one of these conversions - I expect them to understand
what basic unix tools sed and regexes do and be able to extrapolate
from there. :)

And, really, I don't want to have to sink an hour or two into making
some tool I have no idea how to use to do what took me about 10s to
implement and execute. Indeed, I don't even have cocci installed on
any of my machines, so I'd be starting from "how the hell do I even
run this thing"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
