Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D35C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E87C6102A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFCBkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhFCBkk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 21:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2CD261057;
        Thu,  3 Jun 2021 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622684337;
        bh=G8gU9GLaUOdz9P2A7I9v2cIulytm0BiM7jUN1ddig/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVzER2FWPICLjkY8CRInbjD4pGenARPrZ2xvxpasrmRxmtVua8olE59Jtm6YMWvZR
         EhCcE+S4LLEOGM8ihvxNSOLuT6Ll8s1H7KwXJ6MlBqJON8y02XEvpYvK89i9RMQmJp
         ipcNFq/5xcpW9OlOhV2rIyRDE60l5+RIn/ihXiJmK2ZAJUTHju6Sf146zQx77I+ffM
         bMSLis9vph0qHaEGkX4hHXMOJBQbwNTxR/8jgCBI5uVi+rj/h3AP2Sd135E4UBQd5W
         hq8nUf1t1nxpILFoFZtIaMmOSG3/9CvyxUMgl8I9lkNzebP2T1qNZIcOhLLndH9+pl
         E1cW9+Fr+b7gQ==
Date:   Wed, 2 Jun 2021 18:38:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 08/15] xfs: remove iter_flags parameter from
 xfs_inode_walk_*
Message-ID: <20210603013856.GS26380@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
 <162267274125.2375284.12510919349339700753.stgit@locust>
 <20210603010949.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603010949.GG664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 11:09:49AM +1000, Dave Chinner wrote:
> On Wed, Jun 02, 2021 at 03:25:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The sole iter_flags is XFS_INODE_WALK_INEW_WAIT, and there are no users.
> > Remove the flag, and the parameter, and all the code that used it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   33 ++++++++++++---------------------
> >  fs/xfs/xfs_icache.h |    5 -----
> >  2 files changed, 12 insertions(+), 26 deletions(-)
> 
> Pretty sure I rvb'd this last time, but....

Doh, I missed that.  Sorry. :(

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
