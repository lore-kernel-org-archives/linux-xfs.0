Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE80C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075D0613C8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGNXt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:49:29 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44309 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhGNXt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 19:49:29 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3F0C280B96D;
        Thu, 15 Jul 2021 09:46:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3oaI-006cYx-O4; Thu, 15 Jul 2021 09:46:34 +1000
Date:   Thu, 15 Jul 2021 09:46:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
Message-ID: <20210714234634.GE664593@dread.disaster.area>
References: <162629791767.487242.2747879614157558075.stgit@magnolia>
 <162629792874.487242.7435632593936391745.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162629792874.487242.7435632593936391745.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=cS7Dh47mJAfxhnrG1N4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:25:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During a realtime grow operation, we run a single transaction for each
> rt bitmap block added to the filesystem.  This means that each step has
> to be careful to increase sb_rblocks appropriately.
> 
> Fix the integer overflow error in this calculation that can happen when
> the extent size is very large.  Found by running growfs to add a rt
> volume to a filesystem formatted with a 1g rt extent size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Much easier to read now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
