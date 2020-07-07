Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632CEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA5520738
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M/Pq6FcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGGOJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:09:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGGOJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 10:09:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 067E6l80182473;
        Tue, 7 Jul 2020 14:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YuaR9DA5f3N8oOyG3PQ4NOuBl6Dnfyf/m+l0kWObVeA=;
 b=M/Pq6FcU/e44JmlhakefkkOQPL/gF1U2dt+IkBet8dQDAsMwhoiXJcLHJ4x4PNkLWsDA
 3PekEnUZqfQxWDyZyP7QZjEF0qFdoIpEZ9XfIUj6toWzwnUEO0qbTwv9vRLcKUdfiQMu
 ZmM2Lnn2zEFbLe4AvFf1hXddUKzqzX5LzF3wd4n0bCtbQWEH9yXik5CEVYKHHWx4rOe9
 nTdSkNY+y1edZXdYoFy8vBHqGiC0JShtHFSd1/PsoS3Hl12NmvVnwLldfMevs3bdMcit
 tkCsZEZFP8LKVsKtuIqfgmOGz/lUj1y65DEU2EUlpsfLiHhYEslsdEC6vNMipovJwdzX WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 323sxxryux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Jul 2020 14:09:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 067DwFE7040781;
        Tue, 7 Jul 2020 14:07:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3233px7a4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jul 2020 14:07:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 067E7An3010574;
        Tue, 7 Jul 2020 14:07:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 07:07:10 -0700
Date:   Tue, 7 Jul 2020 07:07:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200707140708.GK7606@magnolia>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362968.3579756.14752877317465395252.stgit@magnolia>
 <20200707125906.GB37141@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707125906.GB37141@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=5 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007070105
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 08:59:06AM -0400, Brian Foster wrote:
> On Thu, Jul 02, 2020 at 08:27:09AM -0700, Darrick J. Wong wrote:
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
> > Fix this problem by reserving extra blocks in the bnobt reservation, and
> > checking that there are enough overages in the bnobt/cntbt fakeroots to
> > populate the AGFL with the minimum number of blocks it needs to handle a
> > split in the bno/cnt/rmap btrees.
> > 
> > Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> > of the reservation steps in phase 5, so the extra allocation should not
> > cause repair to fail if it can't find blocks for btrees.
> > 
> > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/agbtree.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 44 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/repair/agbtree.c b/repair/agbtree.c
> > index de8015ec..9f64d54b 100644
> > --- a/repair/agbtree.c
> > +++ b/repair/agbtree.c
> ...
> > @@ -268,16 +288,33 @@ _("Unable to compute free space by length btree geometry, error %d.\n"), -error)
> >  				 btr_cnt->bload.nr_blocks;
> >  
> >  		/* We don't need any more blocks, so we're done. */
> > -		if (delta_bno >= 0 && delta_cnt >= 0) {
> > +		if (delta_bno >= 0 && delta_cnt >= 0 &&
> > +		    delta_bno + delta_cnt >= agfl_goal) {
> >  			*extra_blocks = delta_bno + delta_cnt;
> >  			break;
> >  		}
> >  
> >  		/* Allocate however many more blocks we need this time. */
> > -		if (delta_bno < 0)
> > +		if (delta_bno < 0) {
> >  			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
> > -		if (delta_cnt < 0)
> > +			delta_bno = 0;
> > +		}
> > +		if (delta_cnt < 0) {
> >  			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
> > +			delta_cnt = 0;
> > +		}
> > +
> > +		/*
> > +		 * Try to fill the bnobt cursor with extra blocks to populate
> > +		 * the AGFL.  If we don't get all the blocks we want, stop
> > +		 * trying to fill the AGFL because the AG is totally out of
> > +		 * space.
> > +		 */
> > +		agfl_wanted = agfl_goal - (delta_bno + delta_cnt);
> > +		if (agfl_wanted > 0 &&
> > +		    agfl_wanted != reserve_agblocks(sc->mp, agno, btr_bno,
> > +						    agfl_wanted))
> > +			agfl_goal = 0;
> 
> Nit: can we split off the function call so it's not embedded in the if
> condition? With that tweak:

It occurs to me that we don't care how much we fall short of the
requested allocation.  I could change reserve_agblocks to return true if
it got all the blocks it was asked to get, and then that becomes:

		if (agfl_wanted > 0 &&
		    !reserve_agblocks(sc->mp, agno, btr_bno, agfl_wanted)
			agfl_goal = 0;

How does that sound?

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  		/* Ok, now how many free space records do we have? */
> >  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > 
> 
