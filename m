Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF865C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 00:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E7820663
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 00:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJjeO8Nl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGIAzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 20:55:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgGIAzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 20:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594256140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oM1uC9sWZ0abh9OU+qgayi0MaWQOFY4GEZmsR+Cz2EY=;
        b=iJjeO8NljsJ1RmoopU3etVmx9sMwqv9ADFQ1YUxnSBLYpOwzgHcNrNF0lKYqEKe8FiQvkH
        Mz2YgVC17gYVSRIEzSK6WgZb91EsIxm5jSBta0fVPkgxouj4bn74988Yxg0EbbxFTlxNGT
        BVr3Ns1YRi6lKKDj3lYNSqLqLKU8RXQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-gdyEXQb9Oe2jywu5pkO_UQ-1; Wed, 08 Jul 2020 20:55:39 -0400
X-MC-Unique: gdyEXQb9Oe2jywu5pkO_UQ-1
Received: by mail-pl1-f199.google.com with SMTP id p14so203692plq.19
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2020 17:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oM1uC9sWZ0abh9OU+qgayi0MaWQOFY4GEZmsR+Cz2EY=;
        b=QCJRBPyS+3kYVYlooUvDBsq0oh4Yr9arg+Zl6fNyTB2waBpem8tB6FystAfeN3h59k
         67OGk6kwVIRB/7GVB7bkseoal7V0lgN23+2Qo5OsR4JEXCRwNhl9fkYtaBj6tKTekLQy
         rWAnzKRHcJ7GZttdLbS57cojCEEVkdU1spmqPC0uXcWi9OXpueiirhlaEZjZTPmB1Khe
         NVmHmZfZMIHAbCqMHE8T75/yeqf+eHh8x6eELXeRXOlYT/N72I4IOTW1yT68l952jUbZ
         yLvx3o+fpyYsycOJiYMnWJGYBlUloURbZeZJBTs3i8WvfPSC/xgYMcZxDXA1XAmaXddo
         qmew==
X-Gm-Message-State: AOAM533oInQ4lsS54v/7FrqVKU3iYHdm2GxM6zP0eHPqdDQaTkUctE5J
        /hCCMhh4K+YyZ7doO25BBVoVqyQBdlXMto3j/fCcZUMcuv8edw/YtZJKy98w3+xEcezWoD6+tbW
        /h5IeovcBFSXXvzslf7N0
X-Received: by 2002:a17:902:968b:: with SMTP id n11mr51018326plp.331.1594256137522;
        Wed, 08 Jul 2020 17:55:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuxvc67BJOEjOH91jRAjlcM56yqfpnC69fglx/EmpqDjzUyp5yU783++hRBDEacVeDIWP6GQ==
X-Received: by 2002:a17:902:968b:: with SMTP id n11mr51018311plp.331.1594256137102;
        Wed, 08 Jul 2020 17:55:37 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q6sm832633pfg.76.2020.07.08.17.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 17:55:36 -0700 (PDT)
Date:   Thu, 9 Jul 2020 08:55:26 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200709005526.GC15249@xiangao.remote.csb>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708233311.GP2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708233311.GP2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 09:33:11AM +1000, Dave Chinner wrote:
> On Tue, Jul 07, 2020 at 09:57:41PM +0800, Gao Xiang wrote:
> > Currently, we use AGI buffer lock to protect in-memory linked list for
> > unlinked inodes but since it's not necessary to modify AGI unless the
> > head of the unlinked list is modified. So let's removing the AGI buffer
> > modification dependency if possible, including 1) adding another per-AG
> > dedicated lock to protect the whole list and 2) inserting unlinked
> > inodes from tail.
> > 
> > For 2), the tail of bucket 0 is now recorded in perag for xfs_iunlink()
> > to use. xfs_iunlink_remove() still support old multiple short bucket
> > lists for recovery code.
> 
> I would split this into two separate patches. One to move to a perag
> based locking strategy, another to change from head to tail
> addition as they are largely independent algorithmic changes.

Yes, that is much better from the perspective of spilting patches and
I thought that before. It seems that is like 2 steps but the proposed
target solution is as a whole (in other words, 2 steps are code-related)
and I'm not sure how large these code is sharable or can be inherited
but rather than introduce some code in patch 2 and then remove immediately
and turn into a new code in patch 3). I'm not sure how large logic could
be sharable between these 2 dependent steps so I didn't do that.

I will spilt patches in the next RFC version to make a try.

> 
> > Note that some paths take AGI lock in its transaction in advance,
> > so the proper locking order is only AGI lock -> unlinked list lock.
> 
> These paths should be documented in the commit message as well
> as in code comments so the reviewer is aware of those code paths
> and can verify that your assumptions about locking order are
> correct.

Yeah, It has been documented in the following.

+xfs_iunlink(
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_perag	*pag;
+	struct xfs_inode	*pip;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		next_agino;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	pag = xfs_perag_get(mp, agno);
 
 	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
+	 * some paths (e.g. xfs_create_tmpfile) could take AGI lock
+	 * in this transaction in advance and the only locking order
+	 * AGI buf lock -> pag_unlinked_mutex is safe.

> 
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c       | 251 ++++++++++++++++++++-------------------
> >  fs/xfs/xfs_log_recover.c |   6 +
> >  fs/xfs/xfs_mount.c       |   3 +
> >  fs/xfs/xfs_mount.h       |   3 +
> >  4 files changed, 144 insertions(+), 119 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 10565fa5ace4..d33e5b198534 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1994,182 +1994,195 @@ xfs_iunlink_update_bucket(
> >  }
> >  
> >  /*
> > - * Always insert at the head, so we only have to do a next inode lookup to
> > - * update it's prev pointer. The AGI bucket will point at the one we are
> > - * inserting.
> > + * This is called when the inode's link count has gone to 0 or we are creating
> > + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> > + *
> > + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> > + * list when the inode is freed.
> >   */
> > -static int
> > -xfs_iunlink_insert_inode(
> 
> Hmmm. Flattening the code also make the patch harder to follow as it
> combines code movement/rearrangement with algorithmic changes.  We
> try to separate out code movement/rearrangement into their own
> patches so that the movement is easy to verify by itself.
> 
> Also, the helper functions help document the separation of the
> unlinked list manipulations from the from setup and locking
> requirements for the list manipulations, and this largely undoes all
> that. I added these helpers because it completely untangled the mess
> that was present before the RFC patchset I posted. THat is, I
> couldn't easily modify the existing code because it interleaved
> the locking, the backref hash manipulations and
> the on-disk list manipulations in ways I found difficult to
> understand and manage. Short, simple, clear functions are much
> better than long, multiple operation functions...
> 
> i.e. this:
> 
> xfs_iunlink()
> {
> 
> 	get locks
> 	do list insert
> 	drop locks
> }
> 
> Is better for understanding, maintenance and future modification
> than:
> 
> xfs_iunlink()
> {
> 
> 	get perag
> 	lock perag
> 	look at tail of list
> 	if (empty) {
> 		unlock perag
> 		read/lock AGI
> 		lock perag
> 		look at tail of list
> 		if (empty)
> 			do head insert
> 			goto out
> 	}
> 	do tail insert
> out:
> 	update inode/pag tails
> 	unlock
> 	drop perag
> }
> 
> It's trivial for a reader to understand what the first version of
> xfs_iunlink() is going to do without needing to understand the
> intraccies of the locking strategies. However, it takes time and
> effort to undestand exactly waht the second one is doing because
> it's not clear where lock ends and list modifications start, nor
> what the locking rules are for the different modifications that are
> being made. Essentially, it goes back to the complex
> locking-intertwined-with-modification-algorithm problem the current
> TOT code has.
> 
> I'd much prefer to see something like this:
> 
> /*
>  * Inode allocation in the O_TMPFILE path defines the AGI/unlinked
>  * list lock order as being AGI->perag unlinked list lock. We are
>  * inverting it here as the fast path tail addition does not need to
>  * modify the AGI at all. Hence we only need the AGI lock if the
>  * tail is empty, but if we fail to get it without blocking then we
>  * need to fall back to the slower, correct lock order.
>  */
> xfs_iunlink_insert_lock()
> {
> 	get perag;
> 	lock_perag();
> 	if (!tail empty)
> 		return;
> 	if (trylock AGI)
> 		return;

(adding some notes here, this patch doesn't use try lock here
 finally but unlock perag and take AGI and relock and recheck tail_empty....
 since the tail non-empty is rare...)

> 
> 	/*
> 	 * Slow path, need to lock AGI first. Don't even bother
> 	 * rechecking tail pointers or trying to optimise for
> 	 * minimal AGI lock hold time as racing unlink list mods
> 	 * will all block on the perag lock once we take that. They
> 	 * will then hit the !tail empty fast path and not require
> 	 * the AGI lock at all.
> 	 */
> 	lock AGI
> 	lock_perag()
> 	return;
> }
> 
> The non-AGI locking fast path is slightly different in the remove
> case, so we'll have a slightly different helper function in that
> case which checks where the inode being removed is in the list.
> 
> In both cases, though, the unlock should be the same:
> 
> xfs_iunlink_unlock()
> {
> 	/* Does not unlock AGI, ever. commit does that. */
> 	unlock perag
> 	put perag
> }
> 
> This keeps the list locking completely separate from the list
> manipulations and allows us to document the locking constraints and
> reasons for why it is or isn't optimised for specific conditions
> without cluttering up the list manipulations code.

Yeah, the _lock and _unlock pair is helpful, I will go for this direction.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

