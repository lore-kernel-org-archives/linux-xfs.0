Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB42C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492E220781
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iH1R55qT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgGAQUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:20:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgGAQUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:20:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061GCTSr154006;
        Wed, 1 Jul 2020 16:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Riod1eS6M2jQCCvqWMPe5gu4AbBBgjPHdK+qUUPbGa4=;
 b=iH1R55qTv8sV3Y75bXgo3P5mCfeAA7/0ahiF85LRUgZboKes+RjMWaw+KtVxJ7QQ3jEw
 vuCxvjJ+V4L/wWhrxvFQdMS42lJHODx4w6wMqLwvZbSuGoTM+75HuhEdL/XPHMezquOS
 onQNlXMWPMHpp1t+L/vX/gDaWfjQ0KBgmhwF/E6CLXlsN6HZO9ekQlgsMxfrGLgI49P9
 mRrWD3mhUCIKxYitiVhBAa82PyRla1rJ6nwPpJaQVyVGeTLxmC+HkJmvaD2aHIb6dhpR
 yU6NZCI2Q0Gwgb/mXUusak3k+KGDXsCzdn7k0Um9J11y+eWrkmNkNrIchvUrfepFujaO 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1e0cbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 16:20:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061GIbJb075625;
        Wed, 1 Jul 2020 16:20:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31xfvu79kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 16:20:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061GK03W006704;
        Wed, 1 Jul 2020 16:20:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 16:20:00 +0000
Date:   Wed, 1 Jul 2020 09:19:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200701161958.GT7606@magnolia>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835912.1065505.9943855193663354771.stgit@magnolia>
 <20200629122228.GB10449@bfoster>
 <20200629232140.GV7606@magnolia>
 <20200630105239.GA31056@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630105239.GA31056@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=5 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 06:52:39AM -0400, Brian Foster wrote:
> On Mon, Jun 29, 2020 at 04:21:40PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 29, 2020 at 08:22:28AM -0400, Brian Foster wrote:
> > > On Thu, Jun 25, 2020 at 01:52:39PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > In commit 9851fd79bfb1, we added a slight amount of slack to the free
> > > > space btrees being reconstructed so that the initial fix_freelist call
> > > > (which is run against a totally empty AGFL) would never have to split
> > > > either free space btree in order to populate the free list.
> > > > 
> > > > The new btree bulk loading code in xfs_repair can re-create this
> > > > situation because it can set the slack values to zero if the filesystem
> > > > is very full.  However, these days repair has the infrastructure needed
> > > > to ensure that overestimations of the btree block counts end up on the
> > > > AGFL or get freed back into the filesystem at the end of phase 5.
> > > > 
> > > > Fix this problem by reserving blocks to a separate AGFL block
> > > > reservation, and checking that between this new reservation and any
> > > > overages in the bnobt/cntbt fakeroots, we have enough blocks sitting
> > > > around to populate the AGFL with the minimum number of blocks it needs
> > > > to handle a split in the bno/cnt/rmap btrees.
> > > > 
> > > > Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> > > > of the reservation steps in phase 5, so the extra allocation should not
> > > > cause repair to fail if it can't find blocks for btrees.
> > > > 
> > > > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  repair/agbtree.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
> > > >  1 file changed, 68 insertions(+), 10 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/repair/agbtree.c b/repair/agbtree.c
> > > > index 339b1489..7a4f316c 100644
> > > > --- a/repair/agbtree.c
> > > > +++ b/repair/agbtree.c
> > > ...
> > > > @@ -262,25 +286,59 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
> > > ...
> > > > +
> > > > +		/*
> > > > +		 * Now try to fill the bnobt/cntbt cursors with extra blocks to
> > > > +		 * populate the AGFL.  If we don't get all the blocks we want,
> > > > +		 * stop trying to fill the AGFL.
> > > > +		 */
> > > > +		wanted = (int64_t)btr_bno->bload.nr_blocks +
> > > > +				(min_agfl_len / 2) - bno_blocks;
> > > > +		if (wanted > 0 && fill_agfl) {
> > > > +			got = reserve_agblocks(sc->mp, agno, btr_bno, wanted);
> > > > +			if (wanted > got)
> > > > +				fill_agfl = false;
> > > > +			btr_bno->bload.nr_blocks += got;
> > > > +		}
> > > > +
> > > > +		wanted = (int64_t)btr_cnt->bload.nr_blocks +
> > > > +				(min_agfl_len / 2) - cnt_blocks;
> > > > +		if (wanted > 0 && fill_agfl) {
> > > > +			got = reserve_agblocks(sc->mp, agno, btr_cnt, wanted);
> > > > +			if (wanted > got)
> > > > +				fill_agfl = false;
> > > > +			btr_cnt->bload.nr_blocks += got;
> > > > +		}
> > > 
> > > It's a little hard to follow this with the nr_blocks sampling and
> > > whatnot, but I think I get the idea. What's the reason for splitting the
> > > AGFL res requirement evenly across the two cursors? These AGFL blocks
> > > all fall into the same overflow pool, right? I was wondering why we
> > > couldn't just attach the overflow to one, or check one for the full res
> > > and then the other if more blocks are needed.
> > 
> > I chose to stuff the excess blocks into the bnobt and cntbt bulkload
> > cursors to avoid having to initialize a semi-phony "bulkload cursor" for
> > the agfl, and I decided to split them evenly between the two cursors so
> > that I wouldn't have someday to deal with a bug report about how one
> > cursor somehow ran out of blocks but the other one had plenty more.
> > 
> > > In thinking about it a bit more, wouldn't the whole algorithm be more
> > > simple if we reserved the min AGFL requirement first, optionally passed
> > > 'agfl_res' to reserve_btblocks() such that subsequent reservations can
> > > steal from it (and then fail if it depletes), then stuff what's left in
> > > one (or both, if there's a reason for that) of the cursors at the end?
> > 
> > Hmm.  I hadn't thought about that.  In general I wanted the AGFL
> > reservations to go last because I'd rather we set off with an underfull
> > AGFL than totally fail because we couldn't get blocks for the
> > bnobt/cntbt, but I suppose you're right that we could steal from it as
> > needed to prevent repair failure.
> > 
> > So, uh, I could rework this patch to create a phony agfl bulk load
> > cursor, fill it before the loop, steal blocks from it to fill the
> > bnobt/cntbt to satisfy failed allocations, and then dump any remainders
> > into the bnobt/cntbt cursors afterwards.  How does that sound?
> > 
> 
> Ok.. the whole phony cursor thing sounds a bit unfortunate. I was
> thinking we'd just have a reservation counter or some such, but in
> reality we'd need that to pass down into the block reservation code to
> acquire actual blocks for one, then we'd need new code to allocate said
> blocks from the phony agfl cursor rather than the in-core block lists,
> right? Perhaps it's not worth doing that if it doesn't reduce complexity
> as much as shuffle it around or even add a bit more... :/
> 
> I wonder if a reasonable simplification/tradeoff might be to just
> refactor the agfl logic in the current patch into a helper function that
> 1.) calculates the current overflow across both cursors and the current
> total agfl "wanted" requirement based on that 2.) performs a single
> reservation to try and accommodate on one of the cursors and 3.) adds a
> bit more to the comment to explain that we're just overloading the bnobt
> cursor (for example) for extra agfl res. Hm?

<shrug> The current patch more or less does this, albeit without the
explicit helper function in (1), and in (3) it splits the overload
between the two cursors instead of just the bnobt.  I'll see what that
looks like, since I came up with other cleanups for init_freespace_cursors.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  
> > > >  		/* Ok, now how many free space records do we have? */
> > > >  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > > >  	} while (1);
> > > > -
> > > > -	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> > > > -			(cnt_blocks - btr_cnt->bload.nr_blocks);
> > > >  }
> > > >  
> > > >  /* Rebuild the free space btrees. */
> > > > 
> > > 
> > 
> 
