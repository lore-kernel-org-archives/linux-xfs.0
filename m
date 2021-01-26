Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636B7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B34220663
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbhAZXEj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:04:39 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:32838 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbhAZUrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 15:47:09 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6B43782786D;
        Wed, 27 Jan 2021 07:46:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4VE4-002jo2-AB; Wed, 27 Jan 2021 07:46:12 +1100
Date:   Wed, 27 Jan 2021 07:46:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2.1 1/3] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210126204612.GJ4662@dread.disaster.area>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142798840.2173328.10025204233532508235.stgit@magnolia>
 <20210126050452.GS7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126050452.GS7698@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=K6JhFTHLg1kxFctkR_wA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 09:04:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Increase the parallelism level for pwork clients to the workqueue
> defaults so that we can take advantage of computers with a lot of CPUs
> and a lot of hardware.  On fast systems this will speed up quotacheck by
> a large factor, and the following posteof/cowblocks cleanup series will
> use the functionality presented in this patch to run garbage collection
> as quickly as possible.
> 
> We do this by switching the pwork workqueue to unbounded, since the
> current user (quotacheck) runs lengthy scans for each work item and we
> don't care about dispatching the work on a warm cpu cache or anything
> like that.  Also set WQ_SYSFS so that we can monitor where the wq is
> running.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2.1: document the workqueue knobs, kill the nr_threads argument to
> pwork, and convert it to unbounded all in one patch
> ---
>  Documentation/admin-guide/xfs.rst |   33 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iwalk.c                |    5 +----
>  fs/xfs/xfs_pwork.c                |   25 +++++--------------------
>  fs/xfs/xfs_pwork.h                |    4 +---
>  4 files changed, 40 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 86de8a1ad91c..5fd14556c6fe 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -495,3 +495,36 @@ the class and error context. For example, the default values for
>  "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
>  to "fail immediately" behaviour. This is done because ENODEV is a fatal,
>  unrecoverable error no matter how many times the metadata IO is retried.
> +
> +Workqueue Concurrency
> +=====================
> +
> +XFS uses kernel workqueues to parallelize metadata update processes.  This
> +enables it to take advantage of storage hardware that can service many IO
> +operations simultaneously.
> +
> +The control knobs for a filesystem's workqueues are organized by task at hand
> +and the short name of the data device.  They all can be found in:
> +
> +  /sys/bus/workqueue/devices/${task}!${device}
> +
> +================  ===========
> +  Task            Description
> +================  ===========
> +  xfs_iwalk-$pid  Inode scans of the entire filesystem. Currently limited to
> +                  mount time quotacheck.
> +================  ===========
> +
> +For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
> +found in /sys/bus/workqueue/devices/xfs_iwalk-1111!nvme0n1/.
> +
> +The interesting knobs for XFS workqueues are as follows:
> +
> +============     ===========
> +  Knob           Description
> +============     ===========
> +  max_active     Maximum number of background threads that can be started to
> +                 run the work.
> +  cpumask        CPUs upon which the threads are allowed to run.
> +  nice           Relative priority of scheduling the threads.  These are the
> +                 same nice levels that can be applied to userspace processes.

I'd suggest that a comment be added here along the lines of:

This interface exposes an internal implementation detail of XFS, and
as such is explicitly not part of any userspace API/ABI guarantee
the kernel may give userspace. These are undocumented features of
the generic workqueue implementation XFS uses for concurrency, and
they are provided here purely for diagnostic and tuning purposes and
may change at any time in the future.

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
