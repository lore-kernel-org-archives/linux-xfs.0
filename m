Return-Path: <SRS0=R00r=7M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4172BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 May 2020 01:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03829206C3
	for <linux-xfs@archiver.kernel.org>; Sat, 30 May 2020 01:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IigMXBic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgE3BQt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 May 2020 21:16:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgE3BQs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 May 2020 21:16:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04U1C5Rp053899;
        Sat, 30 May 2020 01:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s8yfj2PwNrc0V26OcSrupSAvpXg9kmJN9Rc1tgd5WwE=;
 b=IigMXBicvSWV0MsPHU0f2Ih5NYrT+yk4VhUcWAepGM7Z7xZ/2uon19KyBK+ihtQqZo8m
 PVbO2mKQ68Pj3A2Sxk7Ej6Y5U2pQJk1PnyW07/W+ivWtQpVTARk2RwSCzAKYdwSfhT+g
 /RnOwCnGdIl9NxnZ5iMjr6sEVziNXjuoGQ7PyVTugAnU+MBsxyYuf442r9TziFXWeO6r
 SS02VPrqMuI/vNW5Ig7DYFwmay6kbUqaV3ZDP2tWGrKGoOxFC8FV1eptlK0/kLvA3Y+K
 YfwzDqh/v3wQC1C5QxyyGuHvD/eFcT2ojsUf+c5bWzSYTMlUgg2WIL3iR3TRw78C3nvO AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 318xbkd57s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 30 May 2020 01:16:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04U1DkRQ037189;
        Sat, 30 May 2020 01:16:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31a9kv2jxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 May 2020 01:16:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04U1GftK020735;
        Sat, 30 May 2020 01:16:41 GMT
Received: from localhost (/10.159.144.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 18:16:40 -0700
Date:   Fri, 29 May 2020 18:16:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: transfer freed blocks to blk res when lazy
 accounting
Message-ID: <20200530011639.GB2162697@magnolia>
References: <20200522171828.53440-1-bfoster@redhat.com>
 <20200523013614.GE8230@magnolia>
 <20200526181629.GE5462@bfoster>
 <20200526211154.GI252930@magnolia>
 <20200527122752.GD12014@bfoster>
 <20200527153146.GJ252930@magnolia>
 <20200528130519.GC16657@bfoster>
 <20200528172922.GQ8230@magnolia>
 <20200529113335.GA21335@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529113335.GA21335@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005300006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=1 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005300006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 29, 2020 at 07:33:35AM -0400, Brian Foster wrote:
> On Thu, May 28, 2020 at 10:29:22AM -0700, Darrick J. Wong wrote:
> > On Thu, May 28, 2020 at 09:05:19AM -0400, Brian Foster wrote:
> > > On Wed, May 27, 2020 at 08:31:46AM -0700, Darrick J. Wong wrote:
> > > > On Wed, May 27, 2020 at 08:27:52AM -0400, Brian Foster wrote:
> > > > > On Tue, May 26, 2020 at 02:11:54PM -0700, Darrick J. Wong wrote:
> > > > > > On Tue, May 26, 2020 at 02:16:29PM -0400, Brian Foster wrote:
> > > > > > > On Fri, May 22, 2020 at 06:36:14PM -0700, Darrick J. Wong wrote:
> > > > > > > > On Fri, May 22, 2020 at 01:18:28PM -0400, Brian Foster wrote:
> > > > > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > > > > ---
> > > > > > > > > 
> > > > > > > > > Darrick mentioned on IRC a few days ago that he'd seen an issue that
> > > > > > > > > looked similar to the problem with the rmapbt based extent swap
> > > > > > > > > algorithm when the associated inodes happen to bounce between extent and
> > > > > > > > > btree format. That problem caused repeated bmapbt block allocations and
> > > > > > > > > frees that exhausted the transaction block reservation across the
> > > > > > > > > sequence of transaction rolls. The workaround for that was to use an
> > > > > > > > > oversized block reservation, but that is not a generic or efficient
> > > > > > > > > solution.
> > > > > > > > > 
> > > > > > > > > I was originally playing around with some hacks to set an optional base
> > > > > > > > > block reservation on the transaction that we would attempt to replenish
> > > > > > > > > across transaction roll sequences as the block reservation depletes, but
> > > > > > > > > eventually noticed that there isn't much difference between stuffing
> > > > > > > > > block frees in the transaction reservation counter vs. the delta counter
> > > > > > > > > when lazy sb accounting is enabled (which is required for v5 supers). As
> > > > > > > > > such, the following patch seems to address the rmapbt issue in my
> > > > > > > > > isolated tests.
> > > > > > > > > 
> > > > > > > > > I think one tradeoff with this logic is that chains of rolling/freeing
> > > > > > > > > transactions would now aggregate freed space until the final transaction
> > > > > > > > > commits vs. as transactions roll. It's not immediately clear to me how
> > > > > > > > > much of an issue that is, but it sounds a bit dicey when considering
> > > > > > > > > things like truncates of large files. This behavior could still be tied
> > > > > > > > > to a transaction flag to restrict its use to situations like rmapbt
> > > > > > > > > swapext, however. Anyways, this is mostly untested outside of the extent
> > > > > > > > > swap use case so I wanted to throw this on the list as an RFC for now
> > > > > > > > > and see if anybody has thoughts or other ideas.
> > > > > > > > 
> > > > > > > > Hmm, well, this /would/ fix the immediate problem of running out of
> > > > > > > > block reservation, but I wonder if there are other weird subtleties.
> > > > > > > > If we're nearly out of space and we're mounted with -odiscard and the
> > > > > > > > disk is really slow at processing discard, can we encounter weird
> > > > > > > > failure cases where we end up stuck waiting for the extent busy tree to
> > > > > > > > say that one of our pingponged blocks is ok to use again?
> > > > > > > > 
> > > > > > > 
> > > > > > > Yeah, I think something like that could happen. I don't think it should
> > > > > > > be a failure scenario though as the busy extent list should involve a
> > > > > > > log force and retry in the worst case. Either way, we could always
> > > > > > > mitigate risk by making this an optional accounting mode for particular
> > > > > > > (extent swap) transactions...
> > > > > > 
> > > > > > Hmmm... OTOH I wonder how many people really run fsr?  Even I don't...
> > > > > > :)
> > > > > > 
> > > > > > > > In the meantime, I noticed that xfs/227 on a pmem fs (or possibly
> > > > > > > > anything with synchronous writes?) and reflink+rmap enabled seemed to
> > > > > > > > fail pretty consistently.  In a hastily done and incomprehensi{ve,ble}
> > > > > > > > survey I noted that I couldn't make the disastrous pingpong happen if
> > > > > > > > there were more than ~4 blocks in the bmapbt, so maybe this would help
> > > > > > > > there.
> > > > > > > > 
> > > > > > > 
> > > > > > > Do you mean with this patch or with current upstream? I don't see
> > > > > > > xfs/227 failures on my current setups (this patch passed a weekend auto
> > > > > > > test run), but I'll have to retry with something synchronous...
> > > > > > 
> > > > > > It happens semi-frequently with current upstream, and all the time with
> > > > > > the atomic file swap series.
> > > > > > 
> > > > > 
> > > > > I repeated on a box using ramdisk devices and still don't reproduce
> > > > > after 30+ iters, FWIW. Perhaps it depends on pmem for some reason.
> > > > 
> > > > Ah.  Yes, it does depend on the synchronous file io nature of pmem.  I
> > > > /think/ you could simulate the same thing (which is to say the lack of
> > > > delalloc writes) by mounting with -osync.
> > > > 
> > > 
> > > Ok. I ran a similar test w/ -osync and still couldn't reproduce, fwiw.
> > > 
> > > > > > > BTW, is xfs/227 related to the problem you had mentioned on IRC? I
> > > > > > > wasn't quite sure what operation was involved with whatever error report
> > > > > > > you had. xfs/227 looks like an xfs_fsr test, so I'd have thought the
> > > > > > > upstream workaround would have addressed that.. (though I see some attr
> > > > > > > ops in there as well so perhaps this is related to the attr fork..?).
> > > > > > 
> > > > > > It's related, but only in the sense that the "zomg hundreds of thousands
> > > > > > of intents sitting around in memory" were a side effect of creating a
> > > > > > test that creates two files with ~50000 extents and fsr'ing them.
> > > > > > 
> > > > > 
> > > > > Ok, well I'm a little confused then... do we have a user report of a
> > > > > block reservation exhaustion problem or is the primary issue the
> > > > > occasional failure of xfs/227?
> > > > 
> > > > The primary issue is the occasional failure of x/227 on the maintainer's
> > > > testing system. :P
> > > > 
> > > 
> > > Ok.
> > > 
> > > > The secondary issue is sporadic undiagnosed internal complaints which
> > > > are nearly impossible to do much triage on, due to an amazingly s****y
> > > > iscsi network that drops so much traffic you can't collect any
> > > > telemetry.
> > > > 
> > > 
> > > Heh.
> > > 
> > > In any event, I can't reproduce so I don't have enough information to
> > > determine whether there's value in this kind of fix. It's more efficient
> > > than the current approach for rmapbt swapext, but reserving an extra
> > > fixed number of blocks for forks that straddle smaller format boundaries
> > > isn't that terrible either for a one-off case IMO. Let me know if you
> > > happen to get more information and/or can effectively give this a test
> > > with any of your sporadic reproducers...
> > 
> > Yes!  I've finally figured out how this can trigger.
> > 
> > Let's say for demonstration purposes that IFORK_MAXEXT for both files is
> > 20.  File A is a 42 block file with 21 extents:
> > 
> > AABBCCDDEEFFGGHHIIJJKKLLMMNNOOPPQQRRSSTTUU
> > 
> > File B is a 42 block file with 20 extents:
> > 
> > VWWXXYYZZaabbccddeeffgghhiijjkkllmmnnooppp
> > 
> > File A has MAXEXT+1 extents, which means that each unmap-remap cycle
> > will cycle it between btree and extents format.  File B has fewer than
> > MAXEXT extents, so it won't cycle.  The block reservation computation
> > for the rmap-based swap does this:
> > 
> > 	/*
> > 	 * Conceptually this shouldn't affect the shape of either bmbt,
> > 	 * but since we atomically move extents one by one, we reserve
> > 	 * enough space to rebuild both trees.
> > 	 */
> > 	resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> > 	resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > 
> > 	/*
> > 	 * Handle the corner case where either inode might straddle the
> > 	 * btree format boundary. If so, the inode could bounce between
> > 	 * btree <-> extent format on unmap -> remap cycles, freeing and
> > 	 * allocating a bmapbt block each time.
> > 	 */
> > 	if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > 		resblks += XFS_IFORK_MAXEXT(ip, w);
> > 	if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > 		resblks += XFS_IFORK_MAXEXT(tip, w);
> > 
> > Let's say the filesystem is small enough that XFS_SWAP_RMAP_SPACE_RES()
> > returns 7 for both file A and file B, because 21 bmap records will fit
> > in a single bmbt block; the max bmbt height is 5; 21 rmap records will
> > fit in a single rmapbt block; and the max rmapbt height is 2.  The total
> > block reservation is therefore 7 + 7 + 20 = 34.
> > 
> > But now let's look at what the rmap swap operation actually does.  It
> > walks both files in order of increasing file offset, swapping the length
> > of the longest contiguous mapping for both files starting at the offset.
> > 
> > This scenario is the worst case for the rmap swap because the extents
> > are just offset enough that we have to perform single-block swaps for
> > every file offset except the last two: A[0] <-> v, A[1] <-> W[0], B[0]
> > <-> W[1], etc.  This means that file A cycles between btree and extents
> > format 41 times, but we only reserved 34 blocks and so run out 4/5 of
> > the way through.
> > 
> 
> Ah, I see. So the extra block res calculation is off in that it assumes
> a swap per extent, but the reality is we can perform many more
> (sub-extent) swaps than that if extent offsets are staggered.

Yes.

> > What we really need in the ping-pong case is to add the number of swaps
> > we're going to make to resblks.  This is what I have now done for the
> > atomic file update series.
> > 
> 
> Makes sense, but that's not necessarily a straightforward calculation is
> it?

<shrug> I built one for the atomic file updates series.  It's a little
stupid that we end up walking the extent list twice, but for /that/ use
case it's worth it to ensure correct operation and proper quota
accounting.  And since it works on subranges of files, we can't just use
di_nblocks/di_nextents as a rough guess....

(Granted its worth it not to cause fs shutdowns either...)

> > There also seems to be the potential for pingpong behavior if the number
> > of bmap records is exactly the maximum number of bmbt records per block
> > + 1 -- we start with two bmbt blocks, combine them when we remove the
> > record, but then we have to re-expand the bmbt when we add a record
> > back.
> > 
> 
> Indeed. The above and things like this are what make me wonder if it
> would be better to use a "reserve freed blocks" accounting mode on this
> transaction and not have to artificially bump the reservation at all.

<nod> That would be a much simpler solution to the pingpong problem.

> A simplified alternative could be to try and explicitly replenish the
> block reservation after each swap and the transaction is rolled to a
> clean state. The risk with that is it introduces a legitimate -ENOSPC
> error path mid operation. OTOH, we should only be talking about a single
> block at a time so it should be rare. Perhaps we could even (ab)use the
> reserve pool since technically this is cycling between allocating and
> freeing blocks. FWIW, at a quick glance it looks like xfs_fsr copies
> file data before swapping extents, so I'd expect that would leave the
> file in a coherent state even if the swap was interrupted.

For fsr yes that's true.  I think that could be a reasonable and
performant approach for the defrag case.  The heavyweight stuff would be
suited for atomic file changes, since everyone knows that's a hard ask
for any filesystem.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > The tertiary(?) issue is that "fortunately" the atomic file update
> > > > series + fsx have proven good at testing the weaknesses of the block
> > > > reservation calculations for swap extents.
> > > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > > --D
> > > > > > 
> > > > > > > Brian
> > > > > > > 
> > > > > > > > In unrelated news, I also tried fixing the log recovery defer ops chain
> > > > > > > > transactions to absorb the unused block reservations that the
> > > > > > > > xfs_*i_item_recover functions created, but that just made fdblocks be
> > > > > > > > wrong.  But it didn't otherwise blow up! :P
> > > > > > > > 
> > > > > > > > --D
> > > > > > > > 
> > > > > > > > > Brian
> > > > > > > > > 
> > > > > > > > >  fs/xfs/xfs_bmap_util.c | 11 -----------
> > > > > > > > >  fs/xfs/xfs_trans.c     |  4 ++++
> > > > > > > > >  2 files changed, 4 insertions(+), 11 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > > > > > > index f37f5cc4b19f..74b3bad6c414 100644
> > > > > > > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > > > > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > > > > > > @@ -1628,17 +1628,6 @@ xfs_swap_extents(
> > > > > > > > >  		 */
> > > > > > > > >  		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> > > > > > > > >  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > > > > > > > > -
> > > > > > > > > -		/*
> > > > > > > > > -		 * Handle the corner case where either inode might straddle the
> > > > > > > > > -		 * btree format boundary. If so, the inode could bounce between
> > > > > > > > > -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > > > > > > > > -		 * allocating a bmapbt block each time.
> > > > > > > > > -		 */
> > > > > > > > > -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > > > > > > > > -			resblks += XFS_IFORK_MAXEXT(ip, w);
> > > > > > > > > -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > > > > > > > > -			resblks += XFS_IFORK_MAXEXT(tip, w);
> > > > > > > > >  	}
> > > > > > > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > > > > > > > >  	if (error)
> > > > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > > > index 28b983ff8b11..b421d27445c1 100644
> > > > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > > > @@ -370,6 +370,10 @@ xfs_trans_mod_sb(
> > > > > > > > >  			tp->t_blk_res_used += (uint)-delta;
> > > > > > > > >  			if (tp->t_blk_res_used > tp->t_blk_res)
> > > > > > > > >  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > > > > > > +		} else if (delta > 0 &&
> > > > > > > > > +			   xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > > > > > > +			tp->t_blk_res += delta;
> > > > > > > > > +			delta = 0;
> > > > > > > > >  		}
> > > > > > > > >  		tp->t_fdblocks_delta += delta;
> > > > > > > > >  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > > > > > > > -- 
> > > > > > > > > 2.21.1
> > > > > > > > > 
> > > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
