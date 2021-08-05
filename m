Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1F6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7506E61008
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhHEFaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:30:24 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:42986 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230215AbhHEFaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:30:23 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D52FC84796;
        Thu,  5 Aug 2021 15:30:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBVxH-00EgYA-BF; Thu, 05 Aug 2021 15:30:07 +1000
Date:   Thu, 5 Aug 2021 15:30:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 04/14] xfs: detach dquots from inode if we don't need to
 inactivate it
Message-ID: <20210805053007.GV2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812920492.2589546.4151674542483312030.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812920492.2589546.4151674542483312030.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=I-fL-Nuy-AGTJk7gFpQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:06:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we don't need to inactivate an inode, we can detach the dquots and
> move on to reclamation.  This isn't strictly required here; it's a
> preparation patch for deferred inactivation per reviewer request[1] to
> move the creation of xfs_inode_needs_inactivation into a separate
> change.  Eventually this !need_inactive chunk will turn into the code
> path for inodes that skip xfs_inactive and go straight to memory
> reclaim.
> 
> [1] https://lore.kernel.org/linux-xfs/20210609012838.GW2945738@locust/T/#mca6d958521cb88bbc1bfe1a30767203328d410b5
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
