Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D1DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 05:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358554AbiATFSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jan 2022 00:18:49 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43217 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236290AbiATFSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jan 2022 00:18:49 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6B21210C277B;
        Thu, 20 Jan 2022 16:18:46 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nAPqP-001xGJ-Vl; Thu, 20 Jan 2022 16:18:46 +1100
Date:   Thu, 20 Jan 2022 16:18:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220120051845.GG59729@dread.disaster.area>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120003636.GF13563@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61e8f0b7
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=htVLzlCoyyC1mfYpE6oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 19, 2022 at 04:36:36PM -0800, Darrick J. Wong wrote:
> OTOH I tried to figure out how to deal with the lockless list that those
> inodes are put on, and I couldn't figure out how to get them off the
> list safely, so that might be a dead end.  If you have any ideas I'm all
> ears. :)

You can't get them off the middle of the llist without adding
locking to all the llist operations. I chose llist because it's
lockless primitives matched the "add single/remove all" pattern of
batch processing that the per-cpu inactive queue implementation
required.  Hence if you want to do anything other that "single
add/remove all" with the inactive queue, you're going to have to
replace it with a different queue implementation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
