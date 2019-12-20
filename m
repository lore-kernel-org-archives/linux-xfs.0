Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13745C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 20:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D0A20866
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 20:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jD59C8nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTUTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 15:19:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLTUTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Dec 2019 15:19:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBKKJJkM036376;
        Fri, 20 Dec 2019 20:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oA7C7tWOBJRNhORI64ZoEQyEcZ9zhKWPkSOado/tdlo=;
 b=jD59C8nxib+w//PonJ4t3fPZ/j/93gId+OtUyBu4xlC43+WAFxKHETyTJA+XVDyJ7bkl
 BumNpaxQvxTQihAeZTrKI9rdtCZXH8zbRgJ1Mg0j2s6n4OF0zIQzX2FukFT6vjIU5mnP
 b/xT22ZmjwcgYVo3b35eKcevoeuQco+CALe0370bu80QYfE/5UKgYBzpMwYFq3bkm7w4
 /NqYBftySvwW1x5k6NgdF8QOgy+IIPjpnkIUtL2cEXCyeK3VpjXzO681MY2Ptn7gt+29
 zL6mbL2+H6bnPvvv/z3AL+OaGHMloTo6/FAHWW5lKnUmD3Eb999tMnPHbm+eCCPZ71wB NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x01knts05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 20:19:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBKKEADa096077;
        Fri, 20 Dec 2019 20:17:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x0pccdw4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 20:17:19 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBKKHIor014154;
        Fri, 20 Dec 2019 20:17:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Dec 2019 12:17:18 -0800
Date:   Fri, 20 Dec 2019 12:17:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191220201717.GQ7489@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
 <20191218121033.GA63809@bfoster>
 <20191218211540.GB7489@magnolia>
 <20191219115550.GA6995@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219115550.GA6995@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9477 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912200152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9477 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912200153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 19, 2019 at 06:55:50AM -0500, Brian Foster wrote:
> On Wed, Dec 18, 2019 at 01:15:40PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 18, 2019 at 07:10:33AM -0500, Brian Foster wrote:
> > > On Tue, Dec 17, 2019 at 06:37:26PM -0800, Darrick J. Wong wrote:
> > > > On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
> > > > > The insert range operation uses a unique transaction and ilock cycle
> > > > > for the extent split and each extent shift iteration of the overall
> > > > > operation. While this works, it is risks racing with other
> > > > > operations in subtle ways such as COW writeback modifying an extent
> > > > > tree in the middle of a shift operation.
> > > > > 
> > > > > To avoid this problem, make insert range atomic with respect to
> > > > > ilock. Hold the ilock across the entire operation, replace the
> > > > > individual transactions with a single rolling transaction sequence
> > > > > and relog the inode to keep it moving in the log. This guarantees
> > > > > that nothing else can change the extent mapping of an inode while
> > > > > an insert range operation is in progress.
> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
> > > > >  1 file changed, 13 insertions(+), 19 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > > index 829ab1a804c9..555c8b49a223 100644
> > > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > > @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
> > > > >  	if (error)
> > > > >  		return error;
> > > > >  
> > > > > -	/*
> > > > > -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > > > -	 * is not the starting block of extent, we need to split the extent at
> > > > > -	 * stop_fsb.
> > > > > -	 */
> > > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > > > >  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > > > >  	if (error)
> > > > >  		return error;
> > > > >  
> > > > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > > > +	xfs_trans_ijoin(tp, ip, 0);
> > > > >  
> > > > > +	/*
> > > > > +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > > > +	 * is not the starting block of extent, we need to split the extent at
> > > > > +	 * stop_fsb.
> > > > > +	 */
> > > > >  	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> > > > >  	if (error)
> > > > >  		goto out_trans_cancel;
> > > > >  
> > > > > -	error = xfs_trans_commit(tp);
> > > > > -	if (error)
> > > > > -		return error;
> > > > > -
> > > > > -	while (!error && !done) {
> > > > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> > > > > -					&tp);
> > > > 
> > > > I'm a little concerned about the livelock potential here, if there are a lot of
> > > > other threads that have eaten all the transaction reservation and are trying to
> > > > get our ILOCK, while at the same time this thread has the ILOCK and is trying
> > > > to roll the transaction to move another extent, having already rolled the
> > > > transaction more than logcount times.
> > > > 
> > > 
> > > My understanding is that the regrant mechanism is intended to deal with
> > > that scenario. Even after the initial (res * logcount) reservation is
> > > consumed, a regrant is different from an initial reservation in that the
> > > reservation head is unconditionally updated with a new reservation unit.
> > > We do wait on the write head in regrant, but IIUC that should be limited
> > > to the pool of already allocated transactions (and is woken before the
> > > reserve head waiters IIRC). I suppose something like this might be
> > > possible in theory if we were blocked on regrant and the entirety of
> > > remaining log space was consumed by transactions waiting on our ilock,
> > > but I think that is highly unlikely since we also hold the iolock here.
> > 
> > True.  The only time I saw this happen was with buffered COW writeback
> > completions (which hold lock other than ILOCK), which should have been
> > fixed by the patch I made to put all the writeback items to a single
> > inode queue and run /one/ worker thread to process them all.  So maybe
> > my fears are unfounded nowadays. :)
> > 
> 
> Ok. If I'm following correctly, that goes back to this[1] commit. The
> commit log describes a situation where we basically have unbound,
> concurrent attempts to do to COW remappings on writeback completion.
> That leads to heavy ilock contention and the potential for deadlocks
> between log reservation and inode locks. Out of curiosity, was that old
> scheme bad enough to reproduce that kind of deadlock or was the deadlock
> description based on code analysis?

It was bad enough to cause an internal complaint about log livelock. :(

I think directio completions might suffer from the same class of problem
though, since we allow concurrent dio writes and dio doesn't do any of
the ioend batching that we do with buffered write ioends.

I think fixing directio is going to be a tougher nut to crack because it
means that in the non-overwrite case we can't really do the ioend
completion processing from the dio submitter thread.

It might also be nice to find a way to unify the ioend paths since they
both do "convert unwritten and do cow remapping" on the entire range,
and diverge only once that's done.

> I am a bit curious how "deadlock avoidant" the current transaction
> rolling/regrant mechanism is intended to be on its own vs. how much
> responsibility is beared by the implementation of certain operations
> (like truncate holding IOLOCK and assuming that sufficiently restricts
> object access). ISTM that it's technically possible for this lockup
> state to occur, but it relies on something unusual like the above where
> we allow enough unbound (open reservation -> lock) concurrency on a
> single metadata object to exhaust all log space.
> 
> [1] cb357bf3d1 ("xfs: implement per-inode writeback completion queues")

<nod> So far I haven't seen anyone in practice managing to hit a
thread-happy directio cow remap deadlock, though I think triggering it
should be as simple as turning on alwayscow and coaxing an aio stress
tester into issuing a lot of random writes.

> > The only other place I can think of that does a lot of transaction
> > rolling on a single inode is online repair, and it always holds all
> > three exclusive locks.
> > 
> 
> So I guess that should similarly hold off transaction reservation from
> userspace intended to modify the particular inode, provided the XFS
> internals play nice (re: your workqueue fix above).

Yeah.  ISTR the scrub setup functions flush dirty pages and drain
directios before taking the ILOCK, so it should never be picking any
fights with writeback. :)

> > > Also note that this approach is based on the current truncate algorithm,
> > > which is probably a better barometer of potential for this kind of issue
> > > as it is a less specialized operation. I'd argue that if this is safe
> > > enough for truncate, it should be safe enough for range shifting.
> > 
> > Hehehe.
> > 
> > > > I think the extent shifting loop starts with the highest offset mapping and
> > > > shifts it up and continues in order of decreasing offset until it gets to
> > > >  @stop_fsb, correct?
> > > > 
> > > 
> > > Yep, for insert range at least.
> > > 
> > > > Can we use "alloc trans; ilock; move; commit" for every extent higher than the
> > > > one that crosses @stop_fsb, and use "alloc trans; ilock; split; roll;
> > > > insert_extents; commit" to deal with that one extent that crosses @stop_fsb?
> > > > tr_write pre-reserves enough space to that the roll won't need to get more,
> > > > which would eliminate that potential problem, I think.
> > > > 
> > > 
> > > We'd have to reorder the extent split for that kind of approach, which I
> > > think you've noted in the sequence above, as the race window is between
> > > the split and subsequent shift. Otherwise I think that would work.
> > > 
> > > That said, I'd prefer not to introduce the extra complexity and
> > > functional variance unless it were absolutely necessary, and it's not
> > > clear to me that it is. If it is, we'd probably have seen similar issues
> > > in truncate and should target a fix there before worrying about range
> > > shift.
> > 
> > Ok.  Looking back through lore I don't see any complaints about insert
> > range, so I guess it's fine.
> > 
> 
> Ok, thanks.
> 
> Brian
> 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > +	do {
> > > > > +		error = xfs_trans_roll_inode(&tp, ip);
> > > > >  		if (error)
> > > > > -			break;
> > > > > +			goto out_trans_cancel;
> > > > >  
> > > > > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > > >  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> > > > >  				&done, stop_fsb);
> > > > >  		if (error)
> > > > >  			goto out_trans_cancel;
> > > > > +	} while (!done);
> > > > >  
> > > > > -		error = xfs_trans_commit(tp);
> > > > > -	}
> > > > > -
> > > > > +	error = xfs_trans_commit(tp);
> > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > >  	return error;
> > > > >  
> > > > >  out_trans_cancel:
> > > > >  	xfs_trans_cancel(tp);
> > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > >  	return error;
> > > > >  }
> > > > >  
> > > > > -- 
> > > > > 2.20.1
> > > > > 
> > > > 
> > > 
> > 
> 
