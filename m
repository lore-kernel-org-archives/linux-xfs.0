Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F499C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiE0B0Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiE0B0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:26:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 127B712D35
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:26:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 572BA53459F;
        Fri, 27 May 2022 11:26:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOk5-00Gq6z-E2; Fri, 27 May 2022 11:26:17 +1000
Date:   Fri, 27 May 2022 11:26:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 1/5] xfs: don't log every time we clear the log incompat
 flags
Message-ID: <20220527012617.GO1098723@dread.disaster.area>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
 <165337058586.994444.2832013222792677840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337058586.994444.2832013222792677840.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=629028bb
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Xj4VDV31wpOpgkdWjaEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:36:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's no need to spam the logs every time we clear the log incompat
> flags -- if someone is periodically using one of these features, they'll
> be cleared every time the log tries to clean itself, which can get
> pretty chatty:
> 
> $ dmesg | grep -i clear
> [ 5363.894711] XFS (sdd): Clearing log incompat feature flags.
> [ 5365.157516] XFS (sdd): Clearing log incompat feature flags.
> [ 5369.388543] XFS (sdd): Clearing log incompat feature flags.
> [ 5371.281246] XFS (sdd): Clearing log incompat feature flags.
> 
> These aren't high value messages either -- nothing's gone wrong, and
> nobody's trying anything tricky.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Make sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
