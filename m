Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F0BC4743D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D6461108
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFGBt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 21:49:28 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34670 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhFGBt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jun 2021 21:49:28 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 0E27A10A5DC;
        Mon,  7 Jun 2021 11:47:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq4Ma-009psW-AH; Mon, 07 Jun 2021 11:47:36 +1000
Date:   Mon, 7 Jun 2021 11:47:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename struct xfs_eofblocks to xfs_icwalk
Message-ID: <20210607014736.GE664593@dread.disaster.area>
References: <162300206433.1202657.5753685964265403056.stgit@locust>
 <162300207545.1202657.10696106148369657206.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300207545.1202657.10696106148369657206.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=x-1A3xQwgrdcal6iZAsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:54:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfs_eofblocks structure is no longer well-named -- nowadays it
> provides optional filtering criteria to any walk of the incore inode
> cache.  Only one of the cache walk goals has anything to do with
> clearing of speculative post-EOF preallocations, so change the name to
> be more appropriate.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
