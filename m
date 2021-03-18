Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692E6C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0724064EBD
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhCRWTb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhCRWTE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D01261574;
        Thu, 18 Mar 2021 22:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616105943;
        bh=YdUemmSHPPiic8wHVFYhEIKtIjaHgpyG0Vt3ilefaw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tx89noOO1i7wNlqGQjbC8ezANUkg/hj/cc0cNNyf0GRVUh0x8xVl15fehABldy4yb
         TkKwo0fNeiwKCq7RDRS8kyE9oEMPOPSGXdXwWPCnmQdhT5JzYx3FQpeh3Zbt1SMdpp
         zKmQsrZnjvBIEu8B7z/7/T4hkw0PF9wu3j3lh3qjD+83cEvyJDaZJ6gQ3ek2PruKvH
         xLfFJC5373iuRvnNzMfKMtj4gRJnRr2imgvq22q8EAYcdZ7tHJrhJtlvYyZM/xyvb8
         2vKYebqZ5u5L8dar/zk746VegYU/F9XGERdoiLSeeATkJ4VEI5hZihaZaTgX6h887G
         i5OSek+oEjq4A==
Date:   Thu, 18 Mar 2021 15:19:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210318221901.GN22100@magnolia>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318205536.GO63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 07:55:36AM +1100, Dave Chinner wrote:
> On Thu, Mar 18, 2021 at 12:17:06PM -0400, Brian Foster wrote:
> > perag reservation is enabled at mount time on a per AG basis. The
> > upcoming in-core allocation btree accounting mechanism needs to know
> > when reservation is enabled and that all perag AGF contexts are
> > initialized. As a preparation step, set a flag in the mount
> > structure and unconditionally initialize the pagf on all mounts
> > where at least one reservation is active.
> 
> I'm not sure this is a good idea. AFAICT, this means just about any
> filesystem with finobt, reflink and/or rmap will now typically read
> every AGF header in the filesystem at mount time. That means pretty
> much every v5 filesystem in production...

They already do that, because the AG headers are where we store the
btree block counts.

> We've always tried to avoid needing to reading all AG headers at
> mount time because that does not scale when we have really large
> filesystems (I'm talking petabytes here). We should only read AG
> headers if there is something not fully recovered during the mount
> (i.e. slow path) and not on every mount.
> 
> Needing to do a few thousand synchonous read IOs during mount makes
> mount very slow, and as such we always try to do dynamic
> instantiation of AG headers...  Testing I've done with exabyte scale
> filesystems (>10^6 AGs) show that it can take minutes for mount to
> run when each AG header needs to be read, and that's on SSDs where
> the individual read latency is only a couple of hundred
> microseconds. On spinning disks that can do 200 IOPS, we're
> potentially talking hours just to mount really large filesystems...

Is that with reflink enabled?  Reflink always scans the right edge of
the refcount btree at mount to clean out stale COW staging extents, and
(prior to the introduction of the inode btree counts feature last year)
we also ahad to walk the entire finobt to find out how big it is.

TBH I think the COW recovery and the AG block reservation pieces are
prime candidates for throwing at an xfs_pwork workqueue so we can
perform those scans in parallel.

> Hence I don't think that any algorithm that requires reading every
> AGF header in the filesystem at mount time on every v5 filesystem
> already out there in production (because finobt triggers this) is a
> particularly good idea...

Perhaps not, but the horse bolted 5 years ago. :/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
