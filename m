Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCCFC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53E10207E8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2mwAC+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgI1RQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:16:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60694 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgI1RQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 13:16:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHA1kB074302;
        Mon, 28 Sep 2020 17:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7wOJgzXxBdBE5GTWle/ayjL89MjRycSkvUf4v5cdp8Q=;
 b=O2mwAC+0bqLoqnMdgDsMo826zOGmY4NgXJAAD+o+G8IiUr1lroRo6R1Ot9RZu1uAqTcT
 iqMqx7L5hEsJxU0YqNykRpJ940GhKPtOEHDdIQ5NdyX3kIt3aTJG3l/5/mm9nJWj6QKQ
 KubedsubSS044Ua2twMzBU0O14vIVv3/yeigfTH5Ao75XjRRW7qscC42LC+T4StFqk7F
 ASsy5VrMIS5Wyq7l+0AkX14Pm4RT0GGZXbW5P7SvZ4sIH4vC621qZsHPF0zAxiUfria6
 AEKPZ9dB8YKH4BVju690GeQVkK0hiXwclMqha3jkdzHeM51E40jEBmzjPUZmmS7UKiOO pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33su5apcwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 17:16:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHAgPJ120055;
        Mon, 28 Sep 2020 17:16:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdqfyb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 17:16:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SHG0NH016534;
        Mon, 28 Sep 2020 17:16:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 10:15:59 -0700
Date:   Mon, 28 Sep 2020 10:15:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 4/4] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20200928171558.GC49547@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125009361.174438.2579393022515355249.stgit@magnolia>
 <20200928055230.GF14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928055230.GF14422@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 03:52:30PM +1000, Dave Chinner wrote:
> On Sun, Sep 27, 2020 at 04:41:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When xfs_defer_capture extracts the deferred ops and transaction state
> > from a transaction, it should record the transaction reservation type
> > from the old transaction so that when we continue the dfops chain, we
> > still use the same reservation parameters.
> > 
> > This avoids a potential failure vector by ensuring that we never ask for
> > more log reservation space than we would have asked for had the system
> > not gone down.
> 
> Nope, it does not do that.
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c |    5 +++++
> >  fs/xfs/libxfs/xfs_defer.h |    1 +
> >  fs/xfs/xfs_log_recover.c  |    4 ++--
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 85d70f1edc1c..c53443252389 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -577,6 +577,11 @@ xfs_defer_capture(
> >  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
> >  	tp->t_blk_res = tp->t_blk_res_used;
> >  
> > +	/* Preserve the transaction reservation type. */
> > +	dfc->dfc_tres.tr_logres = tp->t_log_res;
> > +	dfc->dfc_tres.tr_logcount = tp->t_log_count;
> > +	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> 
> This means every child deferop takes a full tp->t_log_count
> reservation, whilst in memory the child reservation would ahve been
> handled by the parent via the log ticket unit count being
> decremented by one. Hence child deferops -never- run with the same
> maximal reservation that their parents held.
> 
> The difference is that at runtime we are rolling transaction which
> regrant space from the initial reservation of (tp->t_log_count *
> tp->t_log_res) made a run time. i.e. the first child deferop that
> runs has a total log space grant of ((tp->t_log_count - 1)
> * tp->t_log_res), the second it is "- 2", and so on right down to
> when the log ticket runs out of initial reservation and so it goes
> to reserving a single unit (tp->t_log_res) at a time.
> 
> Hence both the intents being recovered and all their children are
> over-reserving log space by using the default log count for the
> &M_RES(mp)->tr_itruncate reservation. Even if we ignore the initial
> reservation being incorrect, the child reservations of the same size
> as the parent are definitely incorrect. They really should be
> allowed only a single unit reservation, and if the transaction rolls
> to process defer ops, it needs to regrant new log space during the
> commit process.
> 
> Hence I think this can only be correct as:
> 
> 	dfc->dfc_tres.tr_log_count = 1;
> 
> Regardless of how many units the parent recovery reservation
> obtained. (Which I also think can only be correct as 1 because we
> don't know how many units of reservation space the parent had
> consumed when it was logged.)

Can we reach down into the transaction's xlog_ticket.t_cnt to find out
how many were left?

Hm.  Maybe that doesn't matter, seeing as recovery basically
single-steps through whatever it salvaged from the log, I think it's
better for recovery to regrant every time it rolls the transaction
because the amount of space required for a single step will (once we get
the logres part sorted out) never be larger than the sum of the logres
of all transactions that were running when we crashed.

It also occurs to me (esp. given the earlier conversation about the
transaction reservations used to recover intents) that in general we
might need to finish one item to push the tail forward to free up space,
so therefore log recovery should try to use as few resources as
possible.

Well, I'll try hardcoding logcount=1 and see what happens. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
