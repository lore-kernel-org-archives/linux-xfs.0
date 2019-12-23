Return-Path: <SRS0=dkq6=2N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDE9C2D0C0
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 12:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E4A62063A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 12:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+CKnu3k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfLWMMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 07:12:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28108 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726663AbfLWMMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Dec 2019 07:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577103172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hr4ZI/C/1qA+GNeOxjiGmOaltvld8fdulcBm+TgilPw=;
        b=O+CKnu3k6znuJNEHv977ZepGRGBbE96EWtKPb6v7J4328UHxk6fIrzq242N4cDP8Iu2YWh
        Upa7TIlAmUu3SjrR+g2NlbYJ367cD03Pzotv/a5BgOSOVcaj3HzHmfvhNbsJ6+oXhNJ9Dl
        XreoxZ+M2wcwxW+fkqExlGPHASN7Qfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-fFp6nFdJO3S299dosktwrQ-1; Mon, 23 Dec 2019 07:12:51 -0500
X-MC-Unique: fFp6nFdJO3S299dosktwrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E5998017DF;
        Mon, 23 Dec 2019 12:12:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB25960920;
        Mon, 23 Dec 2019 12:12:49 +0000 (UTC)
Date:   Mon, 23 Dec 2019 07:12:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191223121247.GA12481@bfoster>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
 <20191218121033.GA63809@bfoster>
 <20191218211540.GB7489@magnolia>
 <20191219115550.GA6995@bfoster>
 <20191220201717.GQ7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220201717.GQ7489@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 20, 2019 at 12:17:17PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 19, 2019 at 06:55:50AM -0500, Brian Foster wrote:
> > On Wed, Dec 18, 2019 at 01:15:40PM -0800, Darrick J. Wong wrote:
> > > On Wed, Dec 18, 2019 at 07:10:33AM -0500, Brian Foster wrote:
> > > > On Tue, Dec 17, 2019 at 06:37:26PM -0800, Darrick J. Wong wrote:
> > > > > On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
> > > > > > The insert range operation uses a unique transaction and ilock cycle
> > > > > > for the extent split and each extent shift iteration of the overall
> > > > > > operation. While this works, it is risks racing with other
> > > > > > operations in subtle ways such as COW writeback modifying an extent
> > > > > > tree in the middle of a shift operation.
> > > > > > 
> > > > > > To avoid this problem, make insert range atomic with respect to
> > > > > > ilock. Hold the ilock across the entire operation, replace the
> > > > > > individual transactions with a single rolling transaction sequence
> > > > > > and relog the inode to keep it moving in the log. This guarantees
> > > > > > that nothing else can change the extent mapping of an inode while
> > > > > > an insert range operation is in progress.
> > > > > > 
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > >  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
> > > > > >  1 file changed, 13 insertions(+), 19 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > > > index 829ab1a804c9..555c8b49a223 100644
> > > > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > > > @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  
> > > > > > -	/*
> > > > > > -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > > > > -	 * is not the starting block of extent, we need to split the extent at
> > > > > > -	 * stop_fsb.
> > > > > > -	 */
> > > > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > > > > >  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  
> > > > > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > > > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > > > > +	xfs_trans_ijoin(tp, ip, 0);
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > > > > +	 * is not the starting block of extent, we need to split the extent at
> > > > > > +	 * stop_fsb.
> > > > > > +	 */
> > > > > >  	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> > > > > >  	if (error)
> > > > > >  		goto out_trans_cancel;
> > > > > >  
> > > > > > -	error = xfs_trans_commit(tp);
> > > > > > -	if (error)
> > > > > > -		return error;
> > > > > > -
> > > > > > -	while (!error && !done) {
> > > > > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> > > > > > -					&tp);
> > > > > 
> > > > > I'm a little concerned about the livelock potential here, if there are a lot of
> > > > > other threads that have eaten all the transaction reservation and are trying to
> > > > > get our ILOCK, while at the same time this thread has the ILOCK and is trying
> > > > > to roll the transaction to move another extent, having already rolled the
> > > > > transaction more than logcount times.
> > > > > 
> > > > 
> > > > My understanding is that the regrant mechanism is intended to deal with
> > > > that scenario. Even after the initial (res * logcount) reservation is
> > > > consumed, a regrant is different from an initial reservation in that the
> > > > reservation head is unconditionally updated with a new reservation unit.
> > > > We do wait on the write head in regrant, but IIUC that should be limited
> > > > to the pool of already allocated transactions (and is woken before the
> > > > reserve head waiters IIRC). I suppose something like this might be
> > > > possible in theory if we were blocked on regrant and the entirety of
> > > > remaining log space was consumed by transactions waiting on our ilock,
> > > > but I think that is highly unlikely since we also hold the iolock here.
> > > 
> > > True.  The only time I saw this happen was with buffered COW writeback
> > > completions (which hold lock other than ILOCK), which should have been
> > > fixed by the patch I made to put all the writeback items to a single
> > > inode queue and run /one/ worker thread to process them all.  So maybe
> > > my fears are unfounded nowadays. :)
> > > 
> > 
> > Ok. If I'm following correctly, that goes back to this[1] commit. The
> > commit log describes a situation where we basically have unbound,
> > concurrent attempts to do to COW remappings on writeback completion.
> > That leads to heavy ilock contention and the potential for deadlocks
> > between log reservation and inode locks. Out of curiosity, was that old
> > scheme bad enough to reproduce that kind of deadlock or was the deadlock
> > description based on code analysis?
> 
> It was bad enough to cause an internal complaint about log livelock. :(
> 

Interesting..

> I think directio completions might suffer from the same class of problem
> though, since we allow concurrent dio writes and dio doesn't do any of
> the ioend batching that we do with buffered write ioends.
> 

Indeed, that makes sense since it sounds like a similar pattern.

> I think fixing directio is going to be a tougher nut to crack because it
> means that in the non-overwrite case we can't really do the ioend
> completion processing from the dio submitter thread.
> 

Hm.. yeah, but it might be a little strange to have highly concurrent
dio writers to the same inode, right? IOW, it seems like the risk there
more depends on foolishness of userspace rather than of our backend
implementation deciding to allocate more tasks in the event of
contention. That isn't to say we shouldn't think about ways to protect
ourselves from the former case..

> It might also be nice to find a way to unify the ioend paths since they
> both do "convert unwritten and do cow remapping" on the entire range,
> and diverge only once that's done.
> 
> > I am a bit curious how "deadlock avoidant" the current transaction
> > rolling/regrant mechanism is intended to be on its own vs. how much
> > responsibility is beared by the implementation of certain operations
> > (like truncate holding IOLOCK and assuming that sufficiently restricts
> > object access). ISTM that it's technically possible for this lockup
> > state to occur, but it relies on something unusual like the above where
> > we allow enough unbound (open reservation -> lock) concurrency on a
> > single metadata object to exhaust all log space.
> > 
> > [1] cb357bf3d1 ("xfs: implement per-inode writeback completion queues")
> 
> <nod> So far I haven't seen anyone in practice managing to hit a
> thread-happy directio cow remap deadlock, though I think triggering it
> should be as simple as turning on alwayscow and coaxing an aio stress
> tester into issuing a lot of random writes.
> 
> > > The only other place I can think of that does a lot of transaction
> > > rolling on a single inode is online repair, and it always holds all
> > > three exclusive locks.
> > > 
> > 
> > So I guess that should similarly hold off transaction reservation from
> > userspace intended to modify the particular inode, provided the XFS
> > internals play nice (re: your workqueue fix above).
> 
> Yeah.  ISTR the scrub setup functions flush dirty pages and drain
> directios before taking the ILOCK, so it should never be picking any
> fights with writeback. :)
> 

That seems to be the right thing to do, at least for now. It doesn't
look like truncate currently waits on dio. Extent shifting might by
virtue of eofblocks trimming I guess, but that isn't guaranteed.
Regardless, I think either operation could wait on dio without a problem
given that they already isolate the inode for I/O, force writeback, etc.
I suspect it's just not been a likely enough situation to have a heavy
enough I/O workload concurrent with truncating (or shifting) a file to
see this problem in traditional (i.e. unlike the "always COW" mode)
codepaths.

Brian

> > > > Also note that this approach is based on the current truncate algorithm,
> > > > which is probably a better barometer of potential for this kind of issue
> > > > as it is a less specialized operation. I'd argue that if this is safe
> > > > enough for truncate, it should be safe enough for range shifting.
> > > 
> > > Hehehe.
> > > 
> > > > > I think the extent shifting loop starts with the highest offset mapping and
> > > > > shifts it up and continues in order of decreasing offset until it gets to
> > > > >  @stop_fsb, correct?
> > > > > 
> > > > 
> > > > Yep, for insert range at least.
> > > > 
> > > > > Can we use "alloc trans; ilock; move; commit" for every extent higher than the
> > > > > one that crosses @stop_fsb, and use "alloc trans; ilock; split; roll;
> > > > > insert_extents; commit" to deal with that one extent that crosses @stop_fsb?
> > > > > tr_write pre-reserves enough space to that the roll won't need to get more,
> > > > > which would eliminate that potential problem, I think.
> > > > > 
> > > > 
> > > > We'd have to reorder the extent split for that kind of approach, which I
> > > > think you've noted in the sequence above, as the race window is between
> > > > the split and subsequent shift. Otherwise I think that would work.
> > > > 
> > > > That said, I'd prefer not to introduce the extra complexity and
> > > > functional variance unless it were absolutely necessary, and it's not
> > > > clear to me that it is. If it is, we'd probably have seen similar issues
> > > > in truncate and should target a fix there before worrying about range
> > > > shift.
> > > 
> > > Ok.  Looking back through lore I don't see any complaints about insert
> > > range, so I guess it's fine.
> > > 
> > 
> > Ok, thanks.
> > 
> > Brian
> > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > 
> > > > > > +	do {
> > > > > > +		error = xfs_trans_roll_inode(&tp, ip);
> > > > > >  		if (error)
> > > > > > -			break;
> > > > > > +			goto out_trans_cancel;
> > > > > >  
> > > > > > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > > > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > > > >  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> > > > > >  				&done, stop_fsb);
> > > > > >  		if (error)
> > > > > >  			goto out_trans_cancel;
> > > > > > +	} while (!done);
> > > > > >  
> > > > > > -		error = xfs_trans_commit(tp);
> > > > > > -	}
> > > > > > -
> > > > > > +	error = xfs_trans_commit(tp);
> > > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > >  	return error;
> > > > > >  
> > > > > >  out_trans_cancel:
> > > > > >  	xfs_trans_cancel(tp);
> > > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > >  	return error;
> > > > > >  }
> > > > > >  
> > > > > > -- 
> > > > > > 2.20.1
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

