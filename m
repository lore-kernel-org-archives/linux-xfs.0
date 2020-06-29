Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BF8C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C8620781
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TkNIqm5a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgF2XVu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:21:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37354 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgF2XVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 19:21:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN7wmd041804;
        Mon, 29 Jun 2020 23:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5piXfMsG++hKTKkLY2MtQ7+7i3dqWzo1qq6yGMi+ymY=;
 b=TkNIqm5ao53yDowW9EPD8th6ji2O91KD16m8k0yMnqrP6xzZz0AAINIkC1Qjik/ydmZz
 pOugDkxjVBfoFlkTnuKbDkf1xQowPbCemClOrKaRXcqV1nKMYE7T6NkNpK4gHdOyen//
 znzs4ZoMMYIrT8REUYIlu+UGCNOnF8wU4cHhZI+fm8eav/YNiizwDSwXxqS5cT1+k21F
 2TIhOdfyan03qAApA4k+FmXN7Mb+ldc51OkISRAC4z5S/fSaGn/by3zgQTAdXO2jFKT6
 zg2SXVEMRgxL1YeASvwZb2a/cdgGcw0oJtiQ/2XA7Ltk2a19n0LWuNtNziVyTM/Z7vTo iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31wwhrh7vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 23:21:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN8UIL180900;
        Mon, 29 Jun 2020 23:21:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvrfdh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 23:21:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05TNLgnS020187;
        Mon, 29 Jun 2020 23:21:42 GMT
Received: from localhost (/10.159.231.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 23:21:41 +0000
Date:   Mon, 29 Jun 2020 16:21:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200629232140.GV7606@magnolia>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835912.1065505.9943855193663354771.stgit@magnolia>
 <20200629122228.GB10449@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629122228.GB10449@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 29, 2020 at 08:22:28AM -0400, Brian Foster wrote:
> On Thu, Jun 25, 2020 at 01:52:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In commit 9851fd79bfb1, we added a slight amount of slack to the free
> > space btrees being reconstructed so that the initial fix_freelist call
> > (which is run against a totally empty AGFL) would never have to split
> > either free space btree in order to populate the free list.
> > 
> > The new btree bulk loading code in xfs_repair can re-create this
> > situation because it can set the slack values to zero if the filesystem
> > is very full.  However, these days repair has the infrastructure needed
> > to ensure that overestimations of the btree block counts end up on the
> > AGFL or get freed back into the filesystem at the end of phase 5.
> > 
> > Fix this problem by reserving blocks to a separate AGFL block
> > reservation, and checking that between this new reservation and any
> > overages in the bnobt/cntbt fakeroots, we have enough blocks sitting
> > around to populate the AGFL with the minimum number of blocks it needs
> > to handle a split in the bno/cnt/rmap btrees.
> > 
> > Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> > of the reservation steps in phase 5, so the extra allocation should not
> > cause repair to fail if it can't find blocks for btrees.
> > 
> > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/agbtree.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 68 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/repair/agbtree.c b/repair/agbtree.c
> > index 339b1489..7a4f316c 100644
> > --- a/repair/agbtree.c
> > +++ b/repair/agbtree.c
> ...
> > @@ -262,25 +286,59 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
> ...
> > +
> > +		/*
> > +		 * Now try to fill the bnobt/cntbt cursors with extra blocks to
> > +		 * populate the AGFL.  If we don't get all the blocks we want,
> > +		 * stop trying to fill the AGFL.
> > +		 */
> > +		wanted = (int64_t)btr_bno->bload.nr_blocks +
> > +				(min_agfl_len / 2) - bno_blocks;
> > +		if (wanted > 0 && fill_agfl) {
> > +			got = reserve_agblocks(sc->mp, agno, btr_bno, wanted);
> > +			if (wanted > got)
> > +				fill_agfl = false;
> > +			btr_bno->bload.nr_blocks += got;
> > +		}
> > +
> > +		wanted = (int64_t)btr_cnt->bload.nr_blocks +
> > +				(min_agfl_len / 2) - cnt_blocks;
> > +		if (wanted > 0 && fill_agfl) {
> > +			got = reserve_agblocks(sc->mp, agno, btr_cnt, wanted);
> > +			if (wanted > got)
> > +				fill_agfl = false;
> > +			btr_cnt->bload.nr_blocks += got;
> > +		}
> 
> It's a little hard to follow this with the nr_blocks sampling and
> whatnot, but I think I get the idea. What's the reason for splitting the
> AGFL res requirement evenly across the two cursors? These AGFL blocks
> all fall into the same overflow pool, right? I was wondering why we
> couldn't just attach the overflow to one, or check one for the full res
> and then the other if more blocks are needed.

I chose to stuff the excess blocks into the bnobt and cntbt bulkload
cursors to avoid having to initialize a semi-phony "bulkload cursor" for
the agfl, and I decided to split them evenly between the two cursors so
that I wouldn't have someday to deal with a bug report about how one
cursor somehow ran out of blocks but the other one had plenty more.

> In thinking about it a bit more, wouldn't the whole algorithm be more
> simple if we reserved the min AGFL requirement first, optionally passed
> 'agfl_res' to reserve_btblocks() such that subsequent reservations can
> steal from it (and then fail if it depletes), then stuff what's left in
> one (or both, if there's a reason for that) of the cursors at the end?

Hmm.  I hadn't thought about that.  In general I wanted the AGFL
reservations to go last because I'd rather we set off with an underfull
AGFL than totally fail because we couldn't get blocks for the
bnobt/cntbt, but I suppose you're right that we could steal from it as
needed to prevent repair failure.

So, uh, I could rework this patch to create a phony agfl bulk load
cursor, fill it before the loop, steal blocks from it to fill the
bnobt/cntbt to satisfy failed allocations, and then dump any remainders
into the bnobt/cntbt cursors afterwards.  How does that sound?

--D

> Brian
> 
> >  
> >  		/* Ok, now how many free space records do we have? */
> >  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> >  	} while (1);
> > -
> > -	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> > -			(cnt_blocks - btr_cnt->bload.nr_blocks);
> >  }
> >  
> >  /* Rebuild the free space btrees. */
> > 
> 
