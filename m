Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE688C4BA2F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 22:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895B621D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 22:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgBZWjh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:39:37 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33532 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 17:39:36 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BC0C47EAC37;
        Thu, 27 Feb 2020 09:39:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j75L3-0004c0-7R; Thu, 27 Feb 2020 09:39:33 +1100
Date:   Thu, 27 Feb 2020 09:39:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
Message-ID: <20200226223933.GB10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-17-allison.henderson@oracle.com>
 <20200225092122.GK10776@dread.disaster.area>
 <b0167c4e-7703-1805-7b58-42096fcee90a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0167c4e-7703-1805-7b58-42096fcee90a@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=83F1_AdjyauxFyC8JW4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 07:13:42PM -0700, Allison Collins wrote:
> On 2/25/20 2:21 AM, Dave Chinner wrote:
> > Heh. This is an example of exactly why I think this should be
> > factored into functions first. Move all the code you just
> > re-indented into xfs_attr_set_shortform(), and the goto disappears
> > because this code becomes:
> > 
> > 	if (xfs_attr_is_shortform(dp))
> > 		return xfs_attr_set_shortform(dp, args);
> > 
> > add_leaf:
> > 
> > That massively improves the readability of the code - it separates
> > the operation implementation from the decision logic nice and
> > cleanly, and lends itself to being implemented in the delayed attr
> > state machine without needing gotos at all.
> Sure, I actually had it more like that in the last version.  I flipped it
> around because I thought it would help people understand what the
> refactoring was for if they could see it in context with the states. But if
> the other way is more helpful, its easy to put back.  Will move :-)

In general, factoring first is best. Factoring should not change
behaviour, nor change the actual code much. Then when the logic
surrounding the new function gets changed later on, it's much easier
to see and understand the logic changes as they aren't hidden
amongst mass code movements (like re-indenting).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
