Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511D1C25B0C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245148AbiHIQ3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245151AbiHIQ27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:28:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C3237CF;
        Tue,  9 Aug 2022 09:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E97D1B81625;
        Tue,  9 Aug 2022 16:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86347C433C1;
        Tue,  9 Aug 2022 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660062501;
        bh=3mOaQUMYXaADmQedOzxTQIS47Vsdg62K5MRxgqfzDoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxCDVGHXWp/C/xaf9N3mD/OBkSFGweEdG7tYjVcuQT8eNQfx5Q1nS7Oz5cY2OiA2O
         9JUHW/laYZyQeXRqznun4L88bU9j7WtjG7G1tsbX/w5FcDTZGRQcWhSrrQYeFr9NGC
         kHXicyvhyYdom9xWsJ9e4HQ9qKRCbgPLcMgQv91Z0HyYfby7YCbTmU6wHWqZpX+WtI
         nLPC4COzjZ9JEWfpzuAZI6BwlrujOYWrR9+CjdVbpSqxcXRe8q0LK9zVwmE2ceXGPH
         46XgpmhKOwQDQE74AoUiaxcnvgvANzPzl0HuFl5KxvHC/3U6efp0ea6q+8eq8V2lLq
         U0/sz/FeQL93A==
Date:   Tue, 9 Aug 2022 09:28:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 0/4] xfs stable candidate patches for
 5.10.y (from v5.15)
Message-ID: <YvKLJMq+thXk6wsW@magnolia>
References: <20220809111708.92768-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809111708.92768-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 09, 2022 at 01:17:04PM +0200, Amir Goldstein wrote:
> Hi Darrick,
> 
> This is a small update of simple backports from v5.15 that shouldn't be
> too hard to review.
> 
> I rather take "remove support for disabling quota accounting" to 5.10.y
> even though it is not a proper bug fix, as a defensive measure and in
> order to match the expefctations of fstests from diabling quota.

I don't agree with making quotaoff a nop after 136 releases of the 5.10
series.  Turning off quota accounting on a running system might be
risky, but anyone who's using it in 5.10 most likely expects it to
continue working, infrequent warts and all.

> These backports survived the standard auto group soak for over 40 runs
> on the 5 test configs.
> 
> Please ACK.

Patches 2-4 are straightforward fixes, so:
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
> 
> Christoph Hellwig (1):
>   xfs: remove support for disabling quota accounting on a mounted file
>     system
> 
> Darrick J. Wong (1):
>   xfs: only set IOMAP_F_SHARED when providing a srcmap to a write
> 
> Dave Chinner (2):
>   mm: Add kvrealloc()
>   xfs: fix I_DONTCACHE
> 
>  fs/xfs/libxfs/xfs_trans_resv.c |  30 -----
>  fs/xfs/libxfs/xfs_trans_resv.h |   2 -
>  fs/xfs/xfs_dquot_item.c        | 134 ------------------
>  fs/xfs/xfs_dquot_item.h        |  17 ---
>  fs/xfs/xfs_icache.c            |   3 +-
>  fs/xfs/xfs_iomap.c             |   8 +-
>  fs/xfs/xfs_iops.c              |   2 +-
>  fs/xfs/xfs_log_recover.c       |   4 +-
>  fs/xfs/xfs_qm.c                |   2 +-
>  fs/xfs/xfs_qm.h                |   1 -
>  fs/xfs/xfs_qm_syscalls.c       | 240 ++-------------------------------
>  fs/xfs/xfs_trans_dquot.c       |  38 ------
>  include/linux/mm.h             |   2 +
>  mm/util.c                      |  15 +++
>  14 files changed, 40 insertions(+), 458 deletions(-)
> 
> -- 
> 2.25.1
> 
