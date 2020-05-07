Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C334FC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 20:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A19A020643
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 20:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgEGUsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 16:48:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49810 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgEGUsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 16:48:18 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 62997820701;
        Fri,  8 May 2020 06:48:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jWnRG-0008Ke-QP; Fri, 08 May 2020 06:48:14 +1000
Date:   Fri, 8 May 2020 06:48:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4.1 07/17] xfs: ratelimit unmount time per-buffer I/O
 error alert
Message-ID: <20200507204814.GP2040@dread.disaster.area>
References: <20200504141154.55887-8-bfoster@redhat.com>
 <20200506110548.4886-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506110548.4886-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=b6vIGKJyvY_NqqYFzr4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 07:05:48AM -0400, Brian Foster wrote:
> At unmount time, XFS emits an alert for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount.
> 
> Now that we have a ratelimit mechanism specifically for buffer
> alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
> Also lift the final repair message out of the loop so it always
> prints and assert that the metadata error handling code has shut
> down the fs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
> 
> v4.1:
> - Add comment to document dependency on external permanent error
>   processing.

Looks good now. Thanks!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
