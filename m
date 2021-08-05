Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F71C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F836052B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhHEFhL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:37:11 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44915 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhHEFhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:37:11 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9F73A80C399;
        Thu,  5 Aug 2021 15:36:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBW3r-00Egcs-59; Thu, 05 Aug 2021 15:36:55 +1000
Date:   Thu, 5 Aug 2021 15:36:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 09/14] xfs: inactivate inodes any time we try to free
 speculative preallocations
Message-ID: <20210805053655.GZ2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812923242.2589546.4318604170788681871.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812923242.2589546.4318604170788681871.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=WAq_ZzWtNSwtsuj6JUMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:07:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Other parts of XFS have learned to call xfs_blockgc_free_{space,quota}
> to try to free speculative preallocations when space is tight.  This
> means that file writes, transaction reservation failures, quota limit
> enforcement, and the EOFBLOCKS ioctl all call this function to free
> space when things are tight.
> 
> Since inode inactivation is now a background task, this means that the
> filesystem can be hanging on to unlinked but not yet freed space.  Add
> this to the list of things that xfs_blockgc_free_* makes writer threads
> scan for when they cannot reserve space.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Yup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
