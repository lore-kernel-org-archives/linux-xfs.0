Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7508FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA7D6199F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCVXN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 19:13:28 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:34345 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229871AbhCVXNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 19:13:08 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 814CF6497F;
        Tue, 23 Mar 2021 10:13:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOTjN-005cNL-WF; Tue, 23 Mar 2021 10:13:06 +1100
Date:   Tue, 23 Mar 2021 10:13:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: prevent metadata files from being inactivated
Message-ID: <20210322231305.GY63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543194600.1947934.584103655060069020.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543194600.1947934.584103655060069020.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=yLyBRMhiUT5DfQuF88wA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:05:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Files containing metadata (quota records, rt bitmap and summary info)
> are fully managed by the filesystem, which means that all resource
> cleanup must be explicit, not automatic.  This means that they should
> never be subjected automatic to post-eof truncation, nor should they be
> freed automatically even if the link count drops to zero.
> 
> In other words, xfs_inactive() should leave these files alone.  Add the
> necessary predicate functions to make this happen.  This adds a second
> layer of prevention for the kinds of fs corruption that was fixed by
> commit f4c32e87de7d.  If we ever decide to support removing metadata
> files, we should make all those metadata updates explicit.
> 
> Rearrange the order of #includes to fix compiler errors, since
> xfs_mount.h is supposed to be included before xfs_inode.h
> 
> Followup-to: f4c32e87de7d ("xfs: fix realtime bitmap/summary file truncation when growing rt volume")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
