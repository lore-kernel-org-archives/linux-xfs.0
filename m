Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FADC35DF2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67372467A
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgBYGa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:30:26 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47009 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbgBYGa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 01:30:26 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F238A3A29E8;
        Tue, 25 Feb 2020 17:30:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6Tjb-00073b-FZ; Tue, 25 Feb 2020 17:30:23 +1100
Date:   Tue, 25 Feb 2020 17:30:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20200225063023.GF10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <20200225005718.GC10776@dread.disaster.area>
 <5de019d4-d19f-315d-0299-3926c49cf150@oracle.com>
 <20200225040652.GD10776@dread.disaster.area>
 <d3fdea13-ff1d-ed69-8005-60193c2d2e53@oracle.com>
 <20200225042707.GF6740@magnolia>
 <dd6caf11-0286-3a4a-02b0-2661c3900148@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6caf11-0286-3a4a-02b0-2661c3900148@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 11:07:37PM -0700, Allison Collins wrote:
> It's based on for-next at this point.  Both these sets are pretty big, so
> it's a lot to chase if he's not interested in slowing down to work with the
> combination of them.  If folks would like to see the combination set before
> moving forward, I'd be happy to try and put that together.  Otherwise, it
> can wait too.  Let me know.  Thanks!

I'd simply rebase it on top of christoph's patchset based on the
fact it's likely to be merged before this one. Christoph posted a
git tree link, just pull that down and use that as the topic branch
you rebase onto....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
