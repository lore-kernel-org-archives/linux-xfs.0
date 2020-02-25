Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A248DC4BA06
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73B3B2075D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgBYXzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:55:21 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50374 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728865AbgBYXzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:55:20 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E254E3A2E4B;
        Wed, 26 Feb 2020 10:55:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6k2n-0004vO-H9; Wed, 26 Feb 2020 10:55:17 +1100
Date:   Wed, 26 Feb 2020 10:55:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 06/30] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200225235517.GQ10776@dread.disaster.area>
References: <20200225231012.735245-1-hch@lst.de>
 <20200225231012.735245-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-7-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=uw8rhjOf4DACVh24sUcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:48PM -0800, Christoph Hellwig wrote:
> Add a new helper to handle a single attr multi ioctl operation that
> can be shared between the native and compat ioctl implementation.
> 
> There is a slight change in heavior in that we don't break out of the

behaviour

> loop when copying in the attribute name fails.  The previous behavior
> was rather inconsistent here as it continued for any other kind of
> error, and that we don't clear the flags in the structure returned
> to userspace, a behavior only introduced as a bug fix in the last
> merge window.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   | 18 ++------
>  fs/xfs/xfs_ioctl32.c | 50 +++--------------------
>  3 files changed, 59 insertions(+), 106 deletions(-)

Other than the typo above, looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
