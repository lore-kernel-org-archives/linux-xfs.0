Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7ABC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE47D2074B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhA0HaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:30:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317635AbhA0A2s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 19:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CB12067B;
        Tue, 26 Jan 2021 23:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611703933;
        bh=8mfKoUcRkIArBRQccIZns8uNwDk+mQR7s3CjXVif1Ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rUqZfDrQAh1aXcoYeqEa1vAyHV3tHtTXfs4hRa8EXyBuQ2FUaiPjDx32WVndFW490
         kOPHFyLZs47ikTo1VpUS2kznzNbUQrKqeqLHOUUVlf3AKMzdz8utteVEDRsyTqMyMC
         dUgrPg93rYxpu0MK315+F/iWxPOZwa93Mfk4jP9vNnlSREAI0B4w+qm1WsUJWb52Px
         lTv8qpZ5XHr/KpigJXS0BrBOeBdkqdDTe3WAcNOST2Q2/rFUoM+SxgtEw6Hry/Bq2o
         ru2BiqiP53GD9FkYU5xPe6ZKkyPTeFrCbZU0m4h9WcaxDXxDrUaD2WxL/3K4F85Dxn
         KKtFATrE/JEMg==
Date:   Tue, 26 Jan 2021 15:32:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2.1 1/3] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210126233212.GC7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142798840.2173328.10025204233532508235.stgit@magnolia>
 <20210126050452.GS7698@magnolia>
 <20210126204612.GJ4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126204612.GJ4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 07:46:12AM +1100, Dave Chinner wrote:
> On Mon, Jan 25, 2021 at 09:04:52PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Increase the parallelism level for pwork clients to the workqueue
> > defaults so that we can take advantage of computers with a lot of CPUs
> > and a lot of hardware.  On fast systems this will speed up quotacheck by
> > a large factor, and the following posteof/cowblocks cleanup series will
> > use the functionality presented in this patch to run garbage collection
> > as quickly as possible.
> > 
> > We do this by switching the pwork workqueue to unbounded, since the
> > current user (quotacheck) runs lengthy scans for each work item and we
> > don't care about dispatching the work on a warm cpu cache or anything
> > like that.  Also set WQ_SYSFS so that we can monitor where the wq is
> > running.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2.1: document the workqueue knobs, kill the nr_threads argument to
> > pwork, and convert it to unbounded all in one patch
> > ---
> >  Documentation/admin-guide/xfs.rst |   33 +++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_iwalk.c                |    5 +----
> >  fs/xfs/xfs_pwork.c                |   25 +++++--------------------
> >  fs/xfs/xfs_pwork.h                |    4 +---
> >  4 files changed, 40 insertions(+), 27 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> > index 86de8a1ad91c..5fd14556c6fe 100644
> > --- a/Documentation/admin-guide/xfs.rst
> > +++ b/Documentation/admin-guide/xfs.rst
> > @@ -495,3 +495,36 @@ the class and error context. For example, the default values for
> >  "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
> >  to "fail immediately" behaviour. This is done because ENODEV is a fatal,
> >  unrecoverable error no matter how many times the metadata IO is retried.
> > +
> > +Workqueue Concurrency
> > +=====================
> > +
> > +XFS uses kernel workqueues to parallelize metadata update processes.  This
> > +enables it to take advantage of storage hardware that can service many IO
> > +operations simultaneously.
> > +
> > +The control knobs for a filesystem's workqueues are organized by task at hand
> > +and the short name of the data device.  They all can be found in:
> > +
> > +  /sys/bus/workqueue/devices/${task}!${device}
> > +
> > +================  ===========
> > +  Task            Description
> > +================  ===========
> > +  xfs_iwalk-$pid  Inode scans of the entire filesystem. Currently limited to
> > +                  mount time quotacheck.
> > +================  ===========
> > +
> > +For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
> > +found in /sys/bus/workqueue/devices/xfs_iwalk-1111!nvme0n1/.
> > +
> > +The interesting knobs for XFS workqueues are as follows:
> > +
> > +============     ===========
> > +  Knob           Description
> > +============     ===========
> > +  max_active     Maximum number of background threads that can be started to
> > +                 run the work.
> > +  cpumask        CPUs upon which the threads are allowed to run.
> > +  nice           Relative priority of scheduling the threads.  These are the
> > +                 same nice levels that can be applied to userspace processes.
> 
> I'd suggest that a comment be added here along the lines of:
> 
> This interface exposes an internal implementation detail of XFS, and
> as such is explicitly not part of any userspace API/ABI guarantee
> the kernel may give userspace. These are undocumented features of
> the generic workqueue implementation XFS uses for concurrency, and
> they are provided here purely for diagnostic and tuning purposes and
> may change at any time in the future.
> 
> Otherwise looks ok.

Done, thanks for taking a look at this.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
