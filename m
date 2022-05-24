Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C715C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 04:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiEXEK5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 00:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiEXEK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 00:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F5954AD
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 21:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63056B815FC
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 04:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3402C385AA;
        Tue, 24 May 2022 04:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653365452;
        bh=8Fl9QQu5dwHHVR8JV2DwRsfOuwxpH19nEU3XG5QjfS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XakldCdnTATeKP+Bl9uucCBNTA6FFxNOsBpwRyZoZReTFtTtynKigU15PERGStxti
         daVlKIFcPPNSCaYEn80CfRyUCCqdZRa7psCh/VKDC+ApQHbBb1ZbKOykuN0tIUSHtu
         uVFsVeMBD9iC1WjmyFSRk9s7U1lEnsa8wE10DPgbZK0tRVyTMJzw22htgUoN8vDxZn
         KYECbb+KhxtRaH4p3Kc1TowW2DhxvhiDjTkUqHzjPeTyq+pQ+jkz78WKi4+IH7cGta
         s1Vog5P+HaiwW80772nHuYunedHwojs/P5NQKhcsglEK38N5izYdZvhupICQN50lte
         WxfPr/AqsAx0Q==
Date:   Mon, 23 May 2022 21:10:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't assert fail on perag references on
 teardown
Message-ID: <Yoxay0fUZlWJKkjP@magnolia>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-3-david@fromorbit.com>
 <YoxVdipmKR4PHUyH@magnolia>
 <20220524040015.GZ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524040015.GZ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 02:00:15PM +1000, Dave Chinner wrote:
> On Mon, May 23, 2022 at 08:48:06PM -0700, Darrick J. Wong wrote:
> > On Tue, May 24, 2022 at 12:21:57PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Not fatal, the assert is there to catch developer attention. I'm
> > > seeing this occasionally during recoveryloop testing after a
> > > shutdown, and I don't want this to stop an overnight recoveryloop
> > > run as it is currently doing.
> > > 
> > > Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
> > > corruption report into the log and cause a test failure that way,
> > > but it won't stop the machine dead.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > > index 1e4ee042d52f..3e920cf1b454 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.c
> > > +++ b/fs/xfs/libxfs/xfs_ag.c
> > > @@ -173,7 +173,6 @@ __xfs_free_perag(
> > >  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
> > >  
> > >  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> > > -	ASSERT(atomic_read(&pag->pag_ref) == 0);
> > 
> > Er, shouldn't this also be converted to XFS_IS_CORRUPT?  That's what the
> > commit message said...
> 
> That's in the RCU callback context and we never get here when the
> ASSERT fires. i.e. the assert in xfs_free_perag fires before we
> queue the rcu callback to free this, so checking it here is kinda
> redundant.
> 
> i.e. it's not where this issue is being caught - it's
> being caught by the check below (in xfs_free_perag()) where the
> conversion to XFS_IS_CORRUPT is done....

Ah, right.  Ok then,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> 
> > >  	kmem_free(pag);
> > >  }
> > >  
> > > @@ -192,7 +191,7 @@ xfs_free_perag(
> > >  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> > >  		spin_unlock(&mp->m_perag_lock);
> > >  		ASSERT(pag);
> > > -		ASSERT(atomic_read(&pag->pag_ref) == 0);
> > > +		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
> > >  
> > >  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
> > >  		xfs_iunlink_destroy(pag);
> > > -- 
> > > 2.35.1
> > > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
