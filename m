Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1591C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E522072C
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="val8OBCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgEWA1y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 20:27:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731182AbgEWA1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 20:27:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0HiRg018811;
        Sat, 23 May 2020 00:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xyoDk6skD58S87zY/clT5MdU8pgyN0/O6EozA4Jx200=;
 b=val8OBCA4HE6Rf78b/dply3pNk3tVJSgZbmhtlTCJn61aTnNUNfKqliZcCRVyP0nwxSy
 2qpYm2sHPpFKgru49+cgEQN3191TcjXfjb5qIP14FGl83Q9121UYMwCP5dPCaPyojCSb
 cuemNfZ5Wh2ukviBvTi7xekghIBvjfWMLCGm3SNbC/f0xZ0iWOf1j1iuyxTKsGFVrqA5
 cem5AzBYkpkPkGEMvMZN/A2tbTWVbxOM5QQaXg4OzvwoI5oEe8EOKytK/Yry0uMXRYzp
 m6/2QBMJx817WRf1N5i8sXGL63HsR0RqzBm7KoDlToUco5B6B8kWsalvkKP05rd9Bzkl UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316qrvr5rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 00:27:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0HIHG062666;
        Sat, 23 May 2020 00:27:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3g5mn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 00:27:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N0RgJG014859;
        Sat, 23 May 2020 00:27:42 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 17:27:42 -0700
Date:   Fri, 22 May 2020 17:27:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200523002741.GD8230@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011598984.76931.15076402801787913960.stgit@magnolia>
 <20200522112722.GA50656@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522112722.GA50656@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=1 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 07:27:22AM -0400, Brian Foster wrote:
> On Thu, May 21, 2020 at 07:53:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're estimating a new speculative preallocation length for an
> > extending write, we should walk backwards through the extent list to
> > determine the number of number of blocks that are physically and
> > logically contiguous with the write offset, and use that as an input to
> > the preallocation size computation.
> > 
> > This way, preallocation length is truly measured by the effectiveness of
> > the allocator in giving us contiguous allocations without being
> > influenced by the state of a given extent.  This fixes both the problem
> > where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> > the unnecessary shrinkage of preallocation when delalloc extents are
> > turned into unwritten extents.
> > 
> > This was found as a regression in xfs/014 after changing delalloc writes
> > to create unwritten extents during writeback.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_iomap.c |   37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index ac970b13b1f8..6a308af93893 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
> >  	loff_t			count,
> >  	struct xfs_iext_cursor	*icur)
> >  {
> > +	struct xfs_iext_cursor	ncur = *icur; /* struct copy */
> > +	struct xfs_bmbt_irec	prev, got;
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > -	struct xfs_bmbt_irec	prev;
> > -	int			shift = 0;
> >  	int64_t			freesp;
> >  	xfs_fsblock_t		qblocks;
> > -	int			qshift = 0;
> >  	xfs_fsblock_t		alloc_blocks = 0;
> > +	xfs_extlen_t		plen;
> > +	int			shift = 0;
> > +	int			qshift = 0;
> >  
> >  	if (offset + count <= XFS_ISIZE(ip))
> >  		return 0;
> > @@ -413,16 +415,27 @@ xfs_iomap_prealloc_size(
> >  	 * preallocation size.
> >  	 *
> >  	 * If the extent is a hole, then preallocation is essentially disabled.
> > -	 * Otherwise we take the size of the preceding data extent as the basis
> > -	 * for the preallocation size. If the size of the extent is greater than
> > -	 * half the maximum extent length, then use the current offset as the
> > -	 * basis. This ensures that for large files the preallocation size
> > -	 * always extends to MAXEXTLEN rather than falling short due to things
> > -	 * like stripe unit/width alignment of real extents.
> > +	 * Otherwise we take the size of the preceding data extents as the basis
> > +	 * for the preallocation size. Note that we don't care if the previous
> > +	 * extents are written or not.
> > +	 *
> > +	 * If the size of the extents is greater than half the maximum extent
> > +	 * length, then use the current offset as the basis. This ensures that
> > +	 * for large files the preallocation size always extends to MAXEXTLEN
> > +	 * rather than falling short due to things like stripe unit/width
> > +	 * alignment of real extents.
> >  	 */
> > -	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> > -		alloc_blocks = prev.br_blockcount << 1;
> > -	else
> > +	plen = prev.br_blockcount;
> 
> If prev is initialized by peeking the previous extent, then it looks
> like the first iteration of this loop compares the immediately previous
> extent with itself..

D'oh.  I misported that when I was munging patches around.  Since we
copy *icur to ncur, we can replace the previous peek against icur with a
call to xfs_iext_prev_extent on ncur.

> > +	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> > +		if (plen > MAXEXTLEN / 2 ||
> > +		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
> > +		    got.br_startblock + got.br_blockcount != prev.br_startblock)
> 
> We should probably check for nullstartblock (delalloc) extents
> explicitly here rather than rely on the calculation to fail.

Ok.

> > +			break;
> > +		plen += got.br_blockcount;
> 
> 
> 
> > +		prev = got;
> > +	}
> > +	alloc_blocks = plen * 2;
> 
> Why do we replace the bit shifts with division/multiplication? I'd
> prefer to see the former for obvious power of 2 operations, even if this
> happens to be 32-bit arithmetic. I don't see any particular reason to
> change it in this patch.

Fair enough.  Thanks for catching those things.

--D

> Brian
> 
> > +	if (alloc_blocks > MAXEXTLEN)
> >  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
> >  	if (!alloc_blocks)
> >  		goto check_writeio;
> > 
> 
