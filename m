Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F2DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 10:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E39F12073E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 10:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgENKfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 06:35:03 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:51291 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgENKfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 06:35:02 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 6C1891A7B9E
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2020 20:34:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jZBCY-0004nZ-E5
        for linux-xfs@vger.kernel.org; Thu, 14 May 2020 20:34:54 +1000
Date:   Thu, 14 May 2020 20:34:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] SSD optimised allocation policy
Message-ID: <20200514103454.GL2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=iGZ90GUeQp887gNlD3oA:9 a=VildSVriJ1iIfgXn:21 a=HfesRgxT8O0WivoY:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Topic:	SSD Optimised allocation policies

Scope:
	Performance
	Storage efficiency

Proposal:

Non-rotational storage is typically very fast. Our allocation
policies are all, fundamentally, based on very slow storage which
has extremely high latency between IO to different LBA regions. We
burn CPU to optimise for minimal seeks to minimise the expensive
physical movement of disk heads and platter rotation.

We know when the underlying storage is solid state - there's a
"non-rotational" field in the block device config that tells us the
storage doesn't need physical seek optimisation. We should make use
of that.

My proposal is that we look towards arranging the filesystem
allocation policies into CPU-optimised silos. We start by making
filesystems on SSDs with AG counts that are multiples of the CPU
count in the system (e.g. 4x the number of CPUs) to drive
parallelism at the allocation level, and then associate allocation
groups with specific CPUs in the system. Hence each CPU has a set of
allocation groups is selects between for the operations that are run
on it. Hence allocation is typically local to a specific CPU.
Optimisation proceeds from the basis of CPU locality optimisation,
not storage locality optimisation.

What this allows is processes on different CPUs to never contend for
allocation resources. Locality of objects just doesn't matter for
solid state storage, so we gain nothing by trying to group inodes,
directories, their metadata and data physically close together. We
want writes that happen at the same time to be physically close
together so we aggregate them into larger IOs, but we really
don't care about optimising write locality for best read performance
(i.e. must be contiguous for sequential access) for this storage.

Further, we can look at faster allocation strategies - we don't need
to find the "nearest" if we don't have a contiguous free extent to
allocate into, we just want the one that costs the least CPU to
find. This is because solid state storage is so fast that filesystem
performance is CPU limited, not storage limited. Hence we need to
think about allocation policies differently and start optimising
them for minimum CPU expenditure rather than best layout.

Other things to discuss include:
	- how do we convert metadata structures to write-once style
	  behaviour rather than overwrite in place?
	- extremely large block sizes for metadata (e.g. 4MB) to
	  align better with SSD erase block sizes
	- what parts of the allocation algorithms don't we need
	- are we better off with huge numbers of small AGs rather
	  than fewer large AGs?

-- 
Dave Chinner
david@fromorbit.com
