Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94154C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 17:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBED2078D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 17:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5Bz1Qif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgFIRIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 13:08:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgFIRH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 13:07:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 059H2I3P006015;
        Tue, 9 Jun 2020 17:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xpFL5jDfLsYhDknvrgf3K6BgEqOcnB+tKyZ36fUprks=;
 b=E5Bz1QifWN8zOJUtzzCTF2IYPVZ1AoNrNiLjdtLNs8XJlBpckplZNpRhA8sx5Dha3UBs
 dWfsmDfTa5Lg2TLI6ubFrBbSVAi90erQiDilQnIPftGLDSGycVR0UTHtpe4fH7PbVd+3
 0K3vKQNMG7li+UR5y1JTJ6M96CZVtli2v+ztvljn89vcAEXEOhNIt5/xCe+chMV0MNWC
 0+/iZVF+ixuKQUk7OdTTv6PF5qGo1SsKKi+FroEyzPSps/qdZTjva5I1jJQQ9CHCGEpB
 rcv3JUFjMKM7rdlxmGTK7qHw8faqAfS/mKDNItfPbaNAQF/Z62RKy7pXDjIiu8mRH2vV 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jr636r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 17:07:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 059H7gYw173651;
        Tue, 9 Jun 2020 17:07:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31gn2x1fr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 17:07:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 059H7Zd4025123;
        Tue, 9 Jun 2020 17:07:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 10:07:35 -0700
Date:   Tue, 9 Jun 2020 10:07:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Message-ID: <20200609170734.GA11245@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200608162425.GC1334206@magnolia>
 <20200608163216.GD1334206@magnolia>
 <6293256.TnI8RiW99x@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6293256.TnI8RiW99x@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=1
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006090130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 07:52:48PM +0530, Chandan Babu R wrote:
> On Monday 8 June 2020 10:02:16 PM IST Darrick J. Wong wrote:
> > On Mon, Jun 08, 2020 at 09:24:25AM -0700, Darrick J. Wong wrote:
> > > On Sat, Jun 06, 2020 at 01:57:40PM +0530, Chandan Babu R wrote:
> > > > The following error message was noticed when a workload added one
> > > > million xattrs, deleted 50% of them and then inserted 400,000 new
> > > > xattrs.
> > > > 
> > > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > > 
> > > > The error message was printed during unmounting the filesystem. The
> > > > value printed under "total extents" indicates that we overflowed the
> > > > per-inode signed 16-bit xattr extent counter.
> > > > 
> > > > Instead of letting this silent corruption occur, this patch checks for
> > > > extent counter (both data and xattr) overflow before we assign the
> > > > new value to the corresponding in-memory extent counter.
> > > > 
> > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c       | 92 +++++++++++++++++++++++++++-------
> > > >  fs/xfs/libxfs/xfs_inode_fork.c | 29 +++++++++++
> > > >  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
> > > >  3 files changed, 104 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index edc63dba007f..798fca5c52af 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -906,7 +906,10 @@ xfs_bmap_local_to_extents(
> > > >  	xfs_iext_first(ifp, &icur);
> > > >  	xfs_iext_insert(ip, &icur, &rec, 0);
> > > >  
> > > > -	ifp->if_nextents = 1;
> > > > +	error = xfs_next_set(ip, whichfork, 1);
> > > > +	if (error)
> > > > +		goto done;
> > > 
> > > Are you sure that if_nextents == 0 is a precondition here?  Technically
> > > speaking, this turns an assignment into an increment operation.
> > > 
> > > > +
> > > >  	ip->i_d.di_nblocks = 1;
> > > >  	xfs_trans_mod_dquot_byino(tp, ip,
> > > >  		XFS_TRANS_DQ_BCOUNT, 1L);
> > > > @@ -1594,7 +1597,10 @@ xfs_bmap_add_extent_delay_real(
> > > >  		xfs_iext_remove(bma->ip, &bma->icur, state);
> > > >  		xfs_iext_prev(ifp, &bma->icur);
> > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
> > > > -		ifp->if_nextents--;
> > > > +
> > > > +		error = xfs_next_set(bma->ip, whichfork, -1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (bma->cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -1698,7 +1704,10 @@ xfs_bmap_add_extent_delay_real(
> > > >  		PREV.br_startblock = new->br_startblock;
> > > >  		PREV.br_state = new->br_state;
> > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (bma->cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -1764,7 +1773,10 @@ xfs_bmap_add_extent_delay_real(
> > > >  		 * The left neighbor is not contiguous.
> > > >  		 */
> > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (bma->cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -1851,7 +1863,10 @@ xfs_bmap_add_extent_delay_real(
> > > >  		 * The right neighbor is not contiguous.
> > > >  		 */
> > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (bma->cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -1937,7 +1952,10 @@ xfs_bmap_add_extent_delay_real(
> > > >  		xfs_iext_next(ifp, &bma->icur);
> > > >  		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
> > > >  		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (bma->cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -2141,7 +2159,11 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  		xfs_iext_remove(ip, icur, state);
> > > >  		xfs_iext_prev(ifp, icur);
> > > >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > > > -		ifp->if_nextents -= 2;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, -2);
> > > > +		if (error)
> > > > +			goto done;
> > > > +
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > >  		else {
> > > > @@ -2193,7 +2215,11 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  		xfs_iext_remove(ip, icur, state);
> > > >  		xfs_iext_prev(ifp, icur);
> > > >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > > > -		ifp->if_nextents--;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > +		if (error)
> > > > +			goto done;
> > > > +
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > >  		else {
> > > > @@ -2235,7 +2261,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  		xfs_iext_remove(ip, icur, state);
> > > >  		xfs_iext_prev(ifp, icur);
> > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > > -		ifp->if_nextents--;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -2343,7 +2372,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  
> > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -2419,7 +2451,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > >  		xfs_iext_next(ifp, icur);
> > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -2471,7 +2506,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > >  		xfs_iext_next(ifp, icur);
> > > >  		xfs_iext_insert(ip, icur, &r[1], state);
> > > >  		xfs_iext_insert(ip, icur, &r[0], state);
> > > > -		ifp->if_nextents += 2;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, 2);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL)
> > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > @@ -2787,7 +2825,10 @@ xfs_bmap_add_extent_hole_real(
> > > >  		xfs_iext_remove(ip, icur, state);
> > > >  		xfs_iext_prev(ifp, icur);
> > > >  		xfs_iext_update_extent(ip, state, icur, &left);
> > > > -		ifp->if_nextents--;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL) {
> > > >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > > > @@ -2886,7 +2927,10 @@ xfs_bmap_add_extent_hole_real(
> > > >  		 * Insert a new entry.
> > > >  		 */
> > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > -		ifp->if_nextents++;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		if (cur == NULL) {
> > > >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > > > @@ -5083,7 +5127,10 @@ xfs_bmap_del_extent_real(
> > > >  		 */
> > > >  		xfs_iext_remove(ip, icur, state);
> > > >  		xfs_iext_prev(ifp, icur);
> > > > -		ifp->if_nextents--;
> > > > +
> > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > +		if (error)
> > > > +			goto done;
> > > >  
> > > >  		flags |= XFS_ILOG_CORE;
> > > >  		if (!cur) {
> > > > @@ -5193,7 +5240,10 @@ xfs_bmap_del_extent_real(
> > > >  		} else
> > > >  			flags |= xfs_ilog_fext(whichfork);
> > > >  
> > > > -		ifp->if_nextents++;
> > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > +		if (error)
> > > > +			goto done;
> > > > +
> > > >  		xfs_iext_next(ifp, icur);
> > > >  		xfs_iext_insert(ip, icur, &new, state);
> > > >  		break;
> > > > @@ -5660,7 +5710,10 @@ xfs_bmse_merge(
> > > >  	 * Update the on-disk extent count, the btree if necessary and log the
> > > >  	 * inode.
> > > >  	 */
> > > > -	ifp->if_nextents--;
> > > > +	error = xfs_next_set(ip, whichfork, -1);
> > > > +	if (error)
> > > > +		goto done;
> > > > +
> > > >  	*logflags |= XFS_ILOG_CORE;
> > > >  	if (!cur) {
> > > >  		*logflags |= XFS_ILOG_DEXT;
> > > > @@ -6047,7 +6100,10 @@ xfs_bmap_split_extent(
> > > >  	/* Add new extent */
> > > >  	xfs_iext_next(ifp, &icur);
> > > >  	xfs_iext_insert(ip, &icur, &new, 0);
> > > > -	ifp->if_nextents++;
> > > > +
> > > > +	error = xfs_next_set(ip, whichfork, 1);
> > > > +	if (error)
> > > > +		goto del_cursor;
> > > >  
> > > >  	if (cur) {
> > > >  		error = xfs_bmbt_lookup_eq(cur, &new, &i);
> > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > index 28b366275ae0..3bf5a2c391bd 100644
> > > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > @@ -728,3 +728,32 @@ xfs_ifork_verify_local_attr(
> > > >  
> > > >  	return 0;
> > > >  }
> > > > +
> > > > +int
> > > > +xfs_next_set(
> > > 
> > > "next"... please choose an abbreviation that doesn't collide with a
> > > common English word.
> > > 
> > > > +	struct xfs_inode	*ip,
> > > > +	int			whichfork,
> > > > +	int			delta)
> > > 
> > > Delta?  I thought this was a setter function?
> > > 
> > > > +{
> > > > +	struct xfs_ifork	*ifp;
> > > > +	int64_t			nr_exts;
> > > > +	int64_t			max_exts;
> > > > +
> > > > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > > > +
> > > > +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> > > > +		max_exts = MAXEXTNUM;
> > > > +	else if (whichfork == XFS_ATTR_FORK)
> > > > +		max_exts = MAXAEXTNUM;
> > > > +	else
> > > > +		ASSERT(0);
> > > > +
> > > > +	nr_exts = ifp->if_nextents + delta;
> > > 
> > > Nope, it's a modify function all right.  Then it should be named:
> > > 
> > > xfs_nextents_mod(ip, whichfork, delta)
> > > 
> > > > +	if ((delta > 0 && nr_exts > max_exts)
> > > > +		|| (delta < 0 && nr_exts < 0))
> > > 
> > > Line these up, please.  e.g.,
> > > 
> > > 	if ((delta > 0 && nr_exts > max_exts) ||
> > >             (delta < 0 && nr_exts < 0))

HA even the maintainer gets it wrong. :(

> > > 
> > > --D
> > > 
> > > > +		return -EOVERFLOW;
> > 
> > Oh, also, shouldn't this be EFBIG ("File too big")?
> 
> True, EFBIG is more appropriate than EOVERFLOW in this case.
> 
> Darrick, I have one question. The purpose of this patch is to fix the zero day
> bug where we overflow extent counter silently and get to know about it only
> when flushing the incore inode to disk. Patches that come later in the series
> modify the extent count limits to 2^32 (for xattr fork) and 2^47 (for data
> fork). If this patch is not required to be sent to stable release, I will drop
> it from the series.

I would leave it in the series, unless you mean to send this as a
separate cleanup ahead of everything else?

Now that I think about it, this probably should become its own cleanup
series.  I just realized that if we error out EFBIG in the middle of a
bmap function, we're probably going to end up cancelling a dirty
transaction, which will cause an fs shutdown.  Since xfs cannot undo the
effects of a dirty transaction, we have to be able to error out earlier
in the transaction sequence so that we can back out to userspace without
affecting the filesystem.

IOWs, this means that any code path that could increase an inode's
extent count will have to check the the inode (after we take the ILOCK)
to make sure that it can accomodate however many more extents we're
adding.

static int
xfs_trans_inode_reserve_extent_count(ip, whichfork, nrtoadd)
{
	if (MAX{,A}EXTNUM - XFS_IFORK_PTR(ip, whichfork)->if_nextents < nrtoadd)
		return -EFBIG;
	return 0;
}

	error = xfs_trans_alloc(..., &tp);
	if (error)
		goto out;

	xfs_ilock(ip, XFS_ILOCK_EXCL);
	xfs_trans_ijoin(ip, 0);

	error = xfs_trans_inode_reserve_extent_count(ip, whichfork, nrtoadd)
	if (error)
		goto out;

	error = xfs_trans_reserve_quota_nblks(tp, ip, ...);
	if (error)
		goto out;

...or something like that.  And now suddenly this grows into its own
cleanup series. :/

> Also, I can't have a "fixes" tag because this is a zero
> day bug.

Everything is a zero day now... but establishing a base for this one is
probably not going to be easy since I bet the overflow has existed since
the beginning.

--D

> 
> > 
> > --D
> > 
> > > > +
> > > > +	ifp->if_nextents = nr_exts;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > index a4953e95c4f3..a84ae42ace79 100644
> > > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > @@ -173,4 +173,5 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> > > >  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> > > >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> > > >  
> > > > +int xfs_next_set(struct xfs_inode *ip, int whichfork, int delta);
> > > >  #endif	/* __XFS_INODE_FORK_H__ */
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
