Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F06C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13B42146E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z1VBleGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfLRVPs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:15:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfLRVPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:15:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILAEPj002364;
        Wed, 18 Dec 2019 21:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iCme6WgGG9i4DKQ3Kx1+KfzO+hqkZO6s7rhvzCJOICE=;
 b=Z1VBleGeGhLxvhfOiJnXrKOHt8Uflnu5HzUYfNcv5U38uWv/Un5BdUzKwgbTLwIVipWH
 lHq6DPbrcOiOt+8IQ7/KXq7YIWLyNjuGqAHT9WO0yE9hAeJQ7kFT6+Oe30TBhoB4unXf
 W8PI6TTXisoCwpN09psynwovAvYp6lcWBEk3Q1TVuoWryU9RVrYvj2MBTHc87JQe/62d
 sPxXrGjPc7WzYA883nFwmVyV22zU/gsLC4XFWGSXpkjdjU3luED3cTMpj37r7NvfOrBk
 VCglDCThrydXVg1EqiewV43sGjYzeUgpKHmmTvdm9rQi0cW+hyxosEd8nXdi5OrcNVqW RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wvqpqg72b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:15:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILAuTN186635;
        Wed, 18 Dec 2019 21:15:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wyut4847e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:15:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBILFfdp030847;
        Wed, 18 Dec 2019 21:15:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:15:41 -0800
Date:   Wed, 18 Dec 2019 13:15:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191218211540.GB7489@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
 <20191218121033.GA63809@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218121033.GA63809@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 07:10:33AM -0500, Brian Foster wrote:
> On Tue, Dec 17, 2019 at 06:37:26PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
> > > The insert range operation uses a unique transaction and ilock cycle
> > > for the extent split and each extent shift iteration of the overall
> > > operation. While this works, it is risks racing with other
> > > operations in subtle ways such as COW writeback modifying an extent
> > > tree in the middle of a shift operation.
> > > 
> > > To avoid this problem, make insert range atomic with respect to
> > > ilock. Hold the ilock across the entire operation, replace the
> > > individual transactions with a single rolling transaction sequence
> > > and relog the inode to keep it moving in the log. This guarantees
> > > that nothing else can change the extent mapping of an inode while
> > > an insert range operation is in progress.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
> > >  1 file changed, 13 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 829ab1a804c9..555c8b49a223 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	/*
> > > -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > -	 * is not the starting block of extent, we need to split the extent at
> > > -	 * stop_fsb.
> > > -	 */
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > >  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > >  	if (error)
> > >  		return error;
> > >  
> > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > +	xfs_trans_ijoin(tp, ip, 0);
> > >  
> > > +	/*
> > > +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > > +	 * is not the starting block of extent, we need to split the extent at
> > > +	 * stop_fsb.
> > > +	 */
> > >  	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > >  
> > > -	error = xfs_trans_commit(tp);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	while (!error && !done) {
> > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> > > -					&tp);
> > 
> > I'm a little concerned about the livelock potential here, if there are a lot of
> > other threads that have eaten all the transaction reservation and are trying to
> > get our ILOCK, while at the same time this thread has the ILOCK and is trying
> > to roll the transaction to move another extent, having already rolled the
> > transaction more than logcount times.
> > 
> 
> My understanding is that the regrant mechanism is intended to deal with
> that scenario. Even after the initial (res * logcount) reservation is
> consumed, a regrant is different from an initial reservation in that the
> reservation head is unconditionally updated with a new reservation unit.
> We do wait on the write head in regrant, but IIUC that should be limited
> to the pool of already allocated transactions (and is woken before the
> reserve head waiters IIRC). I suppose something like this might be
> possible in theory if we were blocked on regrant and the entirety of
> remaining log space was consumed by transactions waiting on our ilock,
> but I think that is highly unlikely since we also hold the iolock here.

True.  The only time I saw this happen was with buffered COW writeback
completions (which hold lock other than ILOCK), which should have been
fixed by the patch I made to put all the writeback items to a single
inode queue and run /one/ worker thread to process them all.  So maybe
my fears are unfounded nowadays. :)

The only other place I can think of that does a lot of transaction
rolling on a single inode is online repair, and it always holds all
three exclusive locks.

> Also note that this approach is based on the current truncate algorithm,
> which is probably a better barometer of potential for this kind of issue
> as it is a less specialized operation. I'd argue that if this is safe
> enough for truncate, it should be safe enough for range shifting.

Hehehe.

> > I think the extent shifting loop starts with the highest offset mapping and
> > shifts it up and continues in order of decreasing offset until it gets to
> >  @stop_fsb, correct?
> > 
> 
> Yep, for insert range at least.
> 
> > Can we use "alloc trans; ilock; move; commit" for every extent higher than the
> > one that crosses @stop_fsb, and use "alloc trans; ilock; split; roll;
> > insert_extents; commit" to deal with that one extent that crosses @stop_fsb?
> > tr_write pre-reserves enough space to that the roll won't need to get more,
> > which would eliminate that potential problem, I think.
> > 
> 
> We'd have to reorder the extent split for that kind of approach, which I
> think you've noted in the sequence above, as the race window is between
> the split and subsequent shift. Otherwise I think that would work.
> 
> That said, I'd prefer not to introduce the extra complexity and
> functional variance unless it were absolutely necessary, and it's not
> clear to me that it is. If it is, we'd probably have seen similar issues
> in truncate and should target a fix there before worrying about range
> shift.

Ok.  Looking back through lore I don't see any complaints about insert
range, so I guess it's fine.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Brian
> 
> > --D
> > 
> > > +	do {
> > > +		error = xfs_trans_roll_inode(&tp, ip);
> > >  		if (error)
> > > -			break;
> > > +			goto out_trans_cancel;
> > >  
> > > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > >  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> > >  				&done, stop_fsb);
> > >  		if (error)
> > >  			goto out_trans_cancel;
> > > +	} while (!done);
> > >  
> > > -		error = xfs_trans_commit(tp);
> > > -	}
> > > -
> > > +	error = xfs_trans_commit(tp);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > >  	return error;
> > >  
> > >  out_trans_cancel:
> > >  	xfs_trans_cancel(tp);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > >  	return error;
> > >  }
> > >  
> > > -- 
> > > 2.20.1
> > > 
> > 
> 
