Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4042C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C1C613D0
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFBCMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:12:42 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:39226 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229708AbhFBCMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 22:12:40 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D1B101140BC6;
        Wed,  2 Jun 2021 12:10:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loGLP-007w04-76; Wed, 02 Jun 2021 12:10:55 +1000
Date:   Wed, 2 Jun 2021 12:10:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 13/14] xfs: merge xfs_reclaim_inodes_ag into
 xfs_inode_walk_ag
Message-ID: <20210602021055.GS664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259522416.662681.8769645421908758261.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259522416.662681.8769645421908758261.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=m5abP49yq49H4SsfE2QA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:53:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Merge these two inode walk loops together, since they're pretty similar
> now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |  151 +++++++++++++--------------------------------------
>  fs/xfs/xfs_icache.h |    7 ++
>  2 files changed, 45 insertions(+), 113 deletions(-)

At last! Nice work.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -1678,6 +1577,14 @@ xfs_blockgc_free_quota(
>  
>  /* XFS Incore Inode Walking Code */

FWIW, if we are using "icwalk" as the namespace, I keep saying
"inode cache walk" in my head. Perhaps update this comment somewhere
to match the namespace?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
