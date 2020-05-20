Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F2FC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49D1C20823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgETVvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 17:51:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43881 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgETVvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 17:51:50 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 888AE7EBFC2;
        Thu, 21 May 2020 07:51:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbWcn-0000Iw-Nn; Thu, 21 May 2020 07:51:41 +1000
Date:   Thu, 21 May 2020 07:51:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove the m_active_trans counter
Message-ID: <20200520215141.GY2040@dread.disaster.area>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-3-david@fromorbit.com>
 <20200520204754.GF17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520204754.GF17627@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=rdrdTXMTSZ3-YEc_krUA:9 a=sZFD0maBXzKwO0U-:21 a=QIWLjJ39mVDCqO-R:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 01:47:54PM -0700, Darrick J. Wong wrote:
> On Wed, May 20, 2020 at 08:23:10AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's a global atomic counter, and we are hitting it at a rate of
> > half a million transactions a second, so it's bouncing the counter
> > cacheline all over the place on large machines. We don't actually
> > need it anymore - it used to be required because the VFS freeze code
> > could not track/prevent filesystem transactions that were running,
> > but that problem no longer exists.
> > 
> > Hence to remove the counter, we simply have to ensure that nothing
> > calls xfs_sync_sb() while we are trying to quiesce the filesytem.
> > That only happens if the log worker is still running when we call
> > xfs_quiesce_attr(). The log worker is cancelled at the end of
> > xfs_quiesce_attr() by calling xfs_log_quiesce(), so just call it
> > early here and then we can remove the counter altogether.
> > 
> > Concurrent create, 50 million inodes, identical 16p/16GB virtual
> > machines on different physical hosts. Machine A has twice the CPU
> > cores per socket of machine B:
> > 
> > 		unpatched	patched
> > machine A:	3m16s		2m00s
> > machine B:	4m04s		4m05s
> > 
> > Create rates:
> > 		unpatched	patched
> > machine A:	282k+/-31k	468k+/-21k
> > machine B:	231k+/-8k	233k+/-11k
> > 
> > Concurrent rm of same 50 million inodes:
> > 
> > 		unpatched	patched
> > machine A:	6m42s		2m33s
> > machine B:	4m47s		4m47s
> > 
> > The transaction rate on the fast machine went from just under
> > 300k/sec to 700k/sec, which indicates just how much of a bottleneck
> > this atomic counter was.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> /me kinda wonders why removing the counter entirely has so little effect
> on machine B, but seeing as I've been pondering killing this counter
> myself for years,

Because the transaction rate on machine B isn't high enough to that
the cacheline bouncing becomes a limiting factor.

Don't forget that the impact of cacheline bouncing is exponential -
there is a very small window where it goes from "none at all" to
"all the machine", and these two machines sit on either side of that
threshold. i.e. the older machine is too slow to hit that threshold,
the newer machine hits it easily.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
