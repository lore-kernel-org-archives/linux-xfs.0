Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3AAC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE85613C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhDTRhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233141AbhDTRhH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E907613C4;
        Tue, 20 Apr 2021 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618940195;
        bh=EINfUtLwjDfU3YHKQSvSOcvl/KZRbzI2/A7dluslhMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsonUfwQcCdLf2wJweSeB5aeEM2WDZG9m4ftdvjp9KLa6+QmSeDA+Kvy4SqJPH455
         tTzeDRNuABhHR0bmY8ZZ9ec+uGyxOYKc4Xc/sgraETKbTZdMwLCxpCwua2/kq5LT5g
         rfZx/9cA7IHg6c1qNTq1nIcm63bupqzVhVWqOLFpN3VGkn3OqESBkV7qe+vfUqVjrn
         QCax12P+gbzgI3GvssayIWFnBFqIPq0jSCGva9dHDzM6J3/qx7tNAXv/eLtSXmi2NU
         Oi3lacQ3y7dc9KGX/iqpCfShLk8PQS6LzlxoFJ4CiHTNJD/Kv0xFM/KZU7dMdaH1Nh
         izUgWP+3bXeXg==
Date:   Tue, 20 Apr 2021 10:36:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: RFC: don't allow disabling quota accounting on a mounted file
 system
Message-ID: <20210420173634.GO3122264@magnolia>
References: <20210420072256.2326268-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420072256.2326268-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 09:22:54AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> disabling quota accounting (vs just enforcement) on a running file system
> is a fundamentally race and hard to get right operation.  It also has
> very little practical use.
> 
> This causes xfs/007 xfs/106 xfs/220 xfs/304 xfs/305 to fail, as they
> specifically test this functionality.

What kind of failures do you get now?  Are they all a result of the
_ACCT flags never going away?  Which I guess means that tests expecting
to get ENOSYS after you turn off _ACCT will now no longer error out?

I've been wondering recently why we can't just apply "xfs: skip dquot
reservations if quota is inactive" and change dqpurge_all to relog the
quotaoff item if !xfs_log_item_in_current_chkpt to prevent tail pinning.
AFAICT we can log a qoffend and a new qoff (just like we do with regular
intents) and it won't have any bad effect on recovery.

--D

> 
> Note that the quotaitem log recovery code is left for to make sure we
> don't increase inconsistent recovery states.
> 
> Diffstat:
>  libxfs/xfs_quota_defs.h |   30 ----
>  libxfs/xfs_trans_resv.c |   30 ----
>  libxfs/xfs_trans_resv.h |    2 
>  scrub/quota.c           |    2 
>  xfs_dquot.c             |    3 
>  xfs_dquot_item.c        |  134 ---------------------
>  xfs_dquot_item.h        |   17 --
>  xfs_ioctl.c             |    2 
>  xfs_iops.c              |    4 
>  xfs_mount.c             |    4 
>  xfs_qm.c                |   28 ++--
>  xfs_qm.h                |    4 
>  xfs_qm_syscalls.c       |  300 ------------------------------------------------
>  xfs_quotaops.c          |   57 +++++----
>  xfs_super.c             |   51 +++-----
>  xfs_trans_dquot.c       |   49 -------
>  16 files changed, 84 insertions(+), 633 deletions(-)
