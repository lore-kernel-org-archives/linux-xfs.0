Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05239C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA013613E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhFCBOB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:14:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38434 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhFCBOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 21:14:01 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 23BC966B3E;
        Thu,  3 Jun 2021 11:12:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lobuB-008Inr-Le; Thu, 03 Jun 2021 11:12:15 +1000
Date:   Thu, 3 Jun 2021 11:12:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 09/15] xfs: remove indirect calls from
 xfs_inode_walk{,_ag}
Message-ID: <20210603011215.GH664593@dread.disaster.area>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
 <162267274676.2375284.4741896598250655117.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162267274676.2375284.4741896598250655117.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=XiO2yUqUup3v8koaGG0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 03:25:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that there is a 1:1 mapping between the execute and goal
> parameters that are passed to xfs_inode_walk_ag:
> 
> 	xfs_blockgc_scan_inode <=> XFS_ICWALK_BLOCKGC
> 	xfs_dqrele_inode <=> XFS_ICWALK_DQRELE
> 
> Because of this exact correspondence, we don't need the execute function
> pointer and can replace it with a direct call.
> 
> For the price of a forward static declaration, we can eliminate the
> indirect function call.  This likely has a negligible impact on
> performance (since the execute function runs transactions), but it also
> simplifies the function signature.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   60 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 24 deletions(-)

Cleans up nicely :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
