Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EB0C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 19:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A29461008
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 19:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhHKTWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 15:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhHKTWA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 15:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEFC60F21;
        Wed, 11 Aug 2021 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628709696;
        bh=NVtktVz5upE8wg5oAQkNnSd+7hC2D9P7eIamtDdnRDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QiQImpkYeXWEvbJGRXE42H72aGAbA1wJMcOOiO+9VSKBqUlC0veW13NtEETQhEvhz
         kxqFwwn1APL294wGJ/BR3/0d/h0ljJO2+tRLZrt/oUMcnPTgVt1qEGeMy7cGQWYzCN
         hZjnbJ3eLyUGjzI+jlFHZ6gknn9yLW+ZWeGk2qpHYxeu4AKP5Tp6dQCsQiOtcl0zjr
         HHYiYQM/lckOPSDFcMpXcgqEKdDp/QqWBME/UevBpX5gPL7FnDewa+RfkvlPvYc9f+
         PjZQMkohTHafmMN6QgZhNKOvm4fmz1m1ZR4LqMVxNBxTMAUCc0d81er8MRB2dMSwqx
         izSQnChcBXg2w==
Date:   Wed, 11 Aug 2021 12:21:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the xfs tree
Message-ID: <20210811192135.GU3601466@magnolia>
References: <20210811074913.48605817@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811074913.48605817@canb.auug.org.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 07:49:13AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   0f3901673631 ("xfs: Rename __xfs_attr_rmtval_remove")
>   da8ca45da62e ("xfs: add attr state machine tracepoints")
> 
> are missing a Signed-off-by from their committer.

These should be fixed in today's for-next branch; thanks for letting me
know.

I have also spent this morning fixing some logic errors in my checkpatch
script (which basically does the same as the ones you sent me last time
this happened) and correcting a bug in the pre-push hook that resulted
in it not running. :/

--D

> 
> -- 
> Cheers,
> Stephen Rothwell


