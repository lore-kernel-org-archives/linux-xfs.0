Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C43C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA5420748
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgEVDbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:31:10 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:39555 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgEVDbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:31:10 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 5FCFCD58B27;
        Fri, 22 May 2020 13:31:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyOk-0002S4-TF; Fri, 22 May 2020 13:31:02 +1000
Date:   Fri, 22 May 2020 13:31:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200522033102.GD2040@dread.disaster.area>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011600308.76931.7853207930055232164.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011600308.76931.7853207930055232164.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=lffDJvp6K5msEZD2q3IA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Observation: yesterday I forced a 4kB file create workload
to use unwritten extents by setting an extent size hint. That caused
about 4,500 xfs-conv kworker threads to be spawned by the workload
which had 16 userspace processes creating files...

I expect that any sort of "create lots of small files" worklaod is
going to cause xfs-conv kworker explosions, so be prepared for users
to start reporting kworker explosions with this in place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
