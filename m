Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92D1C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4862388E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbhAUJcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:32:06 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:35742 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728727AbhAUJcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 04:32:01 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 087721020D8;
        Thu, 21 Jan 2021 20:30:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l2WIZ-000p72-PS; Thu, 21 Jan 2021 20:30:39 +1100
Date:   Thu, 21 Jan 2021 20:30:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        avi@scylladb.com, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/11] iomap: pass a flags argument to iomap_dio_rw
Message-ID: <20210121093039.GA4662@dread.disaster.area>
References: <20210121085906.322712-1-hch@lst.de>
 <20210121085906.322712-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121085906.322712-10-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=in2YdIHcAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=kypa4a0X8yUtskfPNVQA:9 a=CjuIK1q_8ugA:10
        a=jvJaD-jWAXz1fu1h5wd8:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 09:59:04AM +0100, Christoph Hellwig wrote:
> Pass a set of flags to iomap_dio_rw instead of the boolean
> wait_for_completion argument.  The IOMAP_DIO_FORCE_WAIT flag
> replaces the wait_for_completion, but only needs to be passed
> when the iocb isn't synchronous to start with to simplify the
> callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/btrfs/file.c       |  7 +++----
>  fs/ext4/file.c        |  5 ++---
>  fs/gfs2/file.c        |  7 ++-----
>  fs/iomap/direct-io.c  | 11 +++++------
>  fs/xfs/xfs_file.c     |  7 +++----
>  fs/zonefs/super.c     |  4 ++--
>  include/linux/iomap.h | 10 ++++++++--
>  7 files changed, 25 insertions(+), 26 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
