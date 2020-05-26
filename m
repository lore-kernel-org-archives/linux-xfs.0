Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2315C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 21:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EF120888
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 21:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GNWcYMLG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgEZVME (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 17:12:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388900AbgEZVME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 17:12:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QLBZLC036938;
        Tue, 26 May 2020 21:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6tuSumlP6+kjsQ4wTUpq4MaHmxGblb2Rbpoq/VsWvoc=;
 b=GNWcYMLGisSZyrpEio3xxdEl5rbMCUjc+jVlj+aqhrUQub/J8gq/MaZt8fz+dNBrvHHv
 mwcoFc5tbuwW+usV4gqmcR5rYeX/SYCMd0pToEvlNQLdUIu4DLMPpufBKGwW1S+y88M6
 OTLwWAevh99M4TmO0tP+Aa648DpB+idx9zVwVD95iENpymu+KNgPFIVgnVWjv2l3mXe5
 Tqu3GqJP/KVwzvNnAgorcxIZLqtv6YSBnxpM3S9Iwo6db8FrFzBHujuSweAhhm1UdHO2
 QnFU52xahluOQ5VAhpXJgOKGUfEcFgMua/aSm9NpGDk6AwKa57ZzVoZnjLUHcxicGRPc Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8qv640-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 21:11:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QL7WEm127549;
        Tue, 26 May 2020 21:11:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 317dkt6a5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 21:11:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04QLBtxI009857;
        Tue, 26 May 2020 21:11:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 14:11:55 -0700
Date:   Tue, 26 May 2020 14:11:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: transfer freed blocks to blk res when lazy
 accounting
Message-ID: <20200526211154.GI252930@magnolia>
References: <20200522171828.53440-1-bfoster@redhat.com>
 <20200523013614.GE8230@magnolia>
 <20200526181629.GE5462@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526181629.GE5462@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=1 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=1
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005260164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 02:16:29PM -0400, Brian Foster wrote:
> On Fri, May 22, 2020 at 06:36:14PM -0700, Darrick J. Wong wrote:
> > On Fri, May 22, 2020 at 01:18:28PM -0400, Brian Foster wrote:
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Darrick mentioned on IRC a few days ago that he'd seen an issue that
> > > looked similar to the problem with the rmapbt based extent swap
> > > algorithm when the associated inodes happen to bounce between extent and
> > > btree format. That problem caused repeated bmapbt block allocations and
> > > frees that exhausted the transaction block reservation across the
> > > sequence of transaction rolls. The workaround for that was to use an
> > > oversized block reservation, but that is not a generic or efficient
> > > solution.
> > > 
> > > I was originally playing around with some hacks to set an optional base
> > > block reservation on the transaction that we would attempt to replenish
> > > across transaction roll sequences as the block reservation depletes, but
> > > eventually noticed that there isn't much difference between stuffing
> > > block frees in the transaction reservation counter vs. the delta counter
> > > when lazy sb accounting is enabled (which is required for v5 supers). As
> > > such, the following patch seems to address the rmapbt issue in my
> > > isolated tests.
> > > 
> > > I think one tradeoff with this logic is that chains of rolling/freeing
> > > transactions would now aggregate freed space until the final transaction
> > > commits vs. as transactions roll. It's not immediately clear to me how
> > > much of an issue that is, but it sounds a bit dicey when considering
> > > things like truncates of large files. This behavior could still be tied
> > > to a transaction flag to restrict its use to situations like rmapbt
> > > swapext, however. Anyways, this is mostly untested outside of the extent
> > > swap use case so I wanted to throw this on the list as an RFC for now
> > > and see if anybody has thoughts or other ideas.
> > 
> > Hmm, well, this /would/ fix the immediate problem of running out of
> > block reservation, but I wonder if there are other weird subtleties.
> > If we're nearly out of space and we're mounted with -odiscard and the
> > disk is really slow at processing discard, can we encounter weird
> > failure cases where we end up stuck waiting for the extent busy tree to
> > say that one of our pingponged blocks is ok to use again?
> > 
> 
> Yeah, I think something like that could happen. I don't think it should
> be a failure scenario though as the busy extent list should involve a
> log force and retry in the worst case. Either way, we could always
> mitigate risk by making this an optional accounting mode for particular
> (extent swap) transactions...

Hmmm... OTOH I wonder how many people really run fsr?  Even I don't...
:)

> > In the meantime, I noticed that xfs/227 on a pmem fs (or possibly
> > anything with synchronous writes?) and reflink+rmap enabled seemed to
> > fail pretty consistently.  In a hastily done and incomprehensi{ve,ble}
> > survey I noted that I couldn't make the disastrous pingpong happen if
> > there were more than ~4 blocks in the bmapbt, so maybe this would help
> > there.
> > 
> 
> Do you mean with this patch or with current upstream? I don't see
> xfs/227 failures on my current setups (this patch passed a weekend auto
> test run), but I'll have to retry with something synchronous...

It happens semi-frequently with current upstream, and all the time with
the atomic file swap series.

> BTW, is xfs/227 related to the problem you had mentioned on IRC? I
> wasn't quite sure what operation was involved with whatever error report
> you had. xfs/227 looks like an xfs_fsr test, so I'd have thought the
> upstream workaround would have addressed that.. (though I see some attr
> ops in there as well so perhaps this is related to the attr fork..?).

It's related, but only in the sense that the "zomg hundreds of thousands
of intents sitting around in memory" were a side effect of creating a
test that creates two files with ~50000 extents and fsr'ing them.

--D

> Brian
> 
> > In unrelated news, I also tried fixing the log recovery defer ops chain
> > transactions to absorb the unused block reservations that the
> > xfs_*i_item_recover functions created, but that just made fdblocks be
> > wrong.  But it didn't otherwise blow up! :P
> > 
> > --D
> > 
> > > Brian
> > > 
> > >  fs/xfs/xfs_bmap_util.c | 11 -----------
> > >  fs/xfs/xfs_trans.c     |  4 ++++
> > >  2 files changed, 4 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index f37f5cc4b19f..74b3bad6c414 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1628,17 +1628,6 @@ xfs_swap_extents(
> > >  		 */
> > >  		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> > >  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > > -
> > > -		/*
> > > -		 * Handle the corner case where either inode might straddle the
> > > -		 * btree format boundary. If so, the inode could bounce between
> > > -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > > -		 * allocating a bmapbt block each time.
> > > -		 */
> > > -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > > -			resblks += XFS_IFORK_MAXEXT(ip, w);
> > > -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > > -			resblks += XFS_IFORK_MAXEXT(tip, w);
> > >  	}
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > >  	if (error)
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 28b983ff8b11..b421d27445c1 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -370,6 +370,10 @@ xfs_trans_mod_sb(
> > >  			tp->t_blk_res_used += (uint)-delta;
> > >  			if (tp->t_blk_res_used > tp->t_blk_res)
> > >  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +		} else if (delta > 0 &&
> > > +			   xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > +			tp->t_blk_res += delta;
> > > +			delta = 0;
> > >  		}
> > >  		tp->t_fdblocks_delta += delta;
> > >  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
