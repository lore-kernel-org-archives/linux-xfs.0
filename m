Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDFAC4332B
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B0B6527D
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhCHXmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:42:35 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:40065 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230327AbhCHXmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 18:42:16 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 2BE931AE4DA;
        Tue,  9 Mar 2021 10:42:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJPVt-000Jg2-Kv; Tue, 09 Mar 2021 10:42:13 +1100
Date:   Tue, 9 Mar 2021 10:42:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v2.1 3/4] xfs: force log and push AIL to clear pinned
 inodes when aborting mount
Message-ID: <20210308234213.GB74031@dread.disaster.area>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875722.698643.971171271199400538.stgit@magnolia>
 <20210308044837.GN3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308044837.GN3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=aDJEt3hCFNa_DrGOJzsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 08:48:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we allocate quota inodes in the process of mounting a filesystem but
> then decide to abort the mount, it's possible that the quota inodes are
> sitting around pinned by the log.  Now that inode reclaim relies on the
> AIL to flush inodes, we have to force the log and push the AIL in
> between releasing the quota inodes and kicking off reclaim to tear down
> all the incore inodes.  Do this by extracting the bits we need from the
> unmount path and reusing them; as an added bonus, failed writes during
> a failed mount will not retry forever.
> 
> This was originally found during a fuzz test of metadata directories
> (xfs/1546), but the actual symptom was that reclaim hung up on the quota
> inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2.1: consolidate the comments.
> ---
>  fs/xfs/xfs_mount.c |   90 +++++++++++++++++++++++++---------------------------
>  1 file changed, 44 insertions(+), 46 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
