Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66665C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE8F20727
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEWWfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 18:35:44 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36189 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgEWWfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 18:35:44 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 406F65AAD8A;
        Sun, 24 May 2020 08:35:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcck1-0000rT-PB; Sun, 24 May 2020 08:35:41 +1000
Date:   Sun, 24 May 2020 08:35:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs: allow multiple reclaimers per AG
Message-ID: <20200523223541.GJ2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-16-david@fromorbit.com>
 <20200522231007.GS8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522231007.GS8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2iPkPHWTKe8d4yacwtUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 04:10:07PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Inode reclaim will still throttle direct reclaim on the per-ag
> > reclaim locks. This is no longer necessary as reclaim can run
> > non-blocking now. Hence we can remove these locks so that we don't
> > arbitrarily block reclaimers just because there are more direct
> > reclaimers than there are AGs.
> > 
> > This can result in multiple reclaimers working on the same range of
> > an AG, but this doesn't cause any apparent issues. Optimising the
> > spread of concurrent reclaimers for best efficiency can be done in a
> > future patchset.
> 
> "Future patchset" as in "not in the 9 patches that I have left to read"?

Yes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
