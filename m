Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDD7C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C2D92067D
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qsV712FM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVSKR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:10:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfKVSKQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:10:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMI4JMs113243;
        Fri, 22 Nov 2019 18:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dgbBIcNfuO322iTFNXUounWNnF1aDtQGKprcNqqCPxo=;
 b=qsV712FMb1bQXaFAg24z6Db2Dl28HybMXIqLe/AZAVSCz0PSEaUKtG6SCrEWP3DNgpwb
 S7YEQzwlXnRNM5wwhIjgc29nmgC9B4AI8umCM1NrpJkNud3GUWNj0iY0nZ0zY5uWw8QG
 jTREa+NjI2j4WqJAB3JNpfU+LmwIZd8qc79QcK8S8cFDO7jeGfBHbFZTp0BUwDSIJ7U8
 PfQO/4zgT3PLqjcYyzD5iXnuvN+TDebZM/yN9M+5Ft5LzUbxDYQeEGBTA4bqszHEjlov
 aXfU+v/qSl8Y7J6djXYBU1KaAEAiaJzc/tABscEbPDphEwZXlGteVBFMcog7XGmO4fJS IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8huc6mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 18:10:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMI48sd132633;
        Fri, 22 Nov 2019 18:10:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wec2992mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 18:10:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAMIAAPT017140;
        Fri, 22 Nov 2019 18:10:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 10:10:10 -0800
Date:   Fri, 22 Nov 2019 10:10:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <20191122181009.GI6219@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556683.3692735.8136460417251028810.stgit@magnolia>
 <20191120142047.GC15542@bfoster>
 <20191120164323.GJ6219@magnolia>
 <20191121132603.GA20602@bfoster>
 <20191122005313.GB6219@magnolia>
 <20191122115700.GA30710@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122115700.GA30710@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 06:57:00AM -0500, Brian Foster wrote:
> On Thu, Nov 21, 2019 at 04:53:13PM -0800, Darrick J. Wong wrote:
> > On Thu, Nov 21, 2019 at 08:26:03AM -0500, Brian Foster wrote:
> > > On Wed, Nov 20, 2019 at 08:43:23AM -0800, Darrick J. Wong wrote:
> > > > On Wed, Nov 20, 2019 at 09:20:47AM -0500, Brian Foster wrote:
> > > > > On Thu, Nov 14, 2019 at 10:19:26AM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Whenever we encounter a corrupt AG header, we should report that to the
> > > > > > health monitoring system for later reporting.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
> > > > > >  fs/xfs/libxfs/xfs_health.h   |    6 ++++++
> > > > > >  fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
> > > > > >  fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
> > > > > >  fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
> > > > > >  fs/xfs/libxfs/xfs_sb.c       |    2 ++
> > > > > >  fs/xfs/xfs_health.c          |   17 +++++++++++++++++
> > > > > >  fs/xfs/xfs_inode.c           |    9 +++++++++
> > > > > >  8 files changed, 51 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > index c284e10af491..e75e3ae6c912 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > @@ -26,6 +26,7 @@
> > > > > >  #include "xfs_log.h"
> > > > > >  #include "xfs_ag_resv.h"
> > > > > >  #include "xfs_bmap.h"
> > > > > > +#include "xfs_health.h"
> > > > > >  
> > > > > >  extern kmem_zone_t	*xfs_bmap_free_item_zone;
> > > > > >  
> > > > > > @@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
> > > > > >  			mp, tp, mp->m_ddev_targp,
> > > > > >  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
> > > > > >  			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
> > > > > > +	if (xfs_metadata_is_sick(error))
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
> > > > > 
> > > > > Any reason we couldn't do some of these in verifiers? I'm assuming we'd
> > > > > still need calls in various external corruption checks, but at least we
> > > > > wouldn't add a requirement to check all future buffer reads, etc.
> > > > 
> > > > I thought about that.  It would be wonderful if C had a syntactically
> > > > slick method to package a function + execution scope and pass that
> > > > through other functions to be called later. :)
> > > > 
> > > > For the per-AG stuff it wouldn't be hard to make the verifier functions
> > > > derive the AG number and call xfs_agno_mark_sick directly in the
> > > > verifier.  For per-inode metadata, we'd have to find a way to pass the
> > > > struct xfs_inode pointer to the verifier, which means that we'd have to
> > > > add that to struct xfs_buf.
> > > > 
> > > > xfs_buf is ~384 bytes so maybe adding another pointer for read context
> > > > wouldn't be terrible?  That would add a fair amount of ugly special
> > > > casing in the btree code to decide if we have an inode to pass through,
> > > > though it would solve the problem of the bmbt verifier not being able to
> > > > check the owner field in the btree block header.
> > > > 
> > > > OTOH that's 8 bytes of overhead that we can never get rid of even though
> > > > we only really need it the first time the buffer gets read in from disk.
> > > > 
> > > > Thoughts?
> > > > 
> > > 
> > > That doesn't seem too unreasonable, but I guess I'd have to think about
> > > it some more. Maybe it's worth defining a private pointer in the buffer
> > > that callers can use to pass specific context to verifiers for health
> > > processing. I suppose such a field could also be conditionally defined
> > > on scrub enabled kernels (at least initially), so the overhead would be
> > > opt-in.
> > 
> > Looking further into this, what if we could did something like the
> > following:
> > 
> > struct xfs_buf_verify {
> > 	const struct xfs_buf_ops	*ops;
> > 	struct xfs_inode		*ip;
> > 	unsigned int			sick_flags;
> > 	/* whatever else */
> > };
> > 
> > ...then we change the _read_buf and _trans_read_buf functions to take as
> > the final argument a (struct xfs_buf_verify *).  In the xfs_buf_reverify
> > cases, we can pass this context straight through to the ->read_verify
> > function.
> > 
> > To handle the !DONE case where the buffer read completion can happen
> > asynchronously, we change the b_ops field definition to:
> > 
> > 	union {
> > 		struct xfs_buf_ops	*b_ops;
> > 		struct xfs_buf_verify	*b_vctx;
> > 	};
> > 
> > Next we define a new XBF_HAVE_VERIFY_CTX flag that means b_vctx is
> > active and not ops.  xfs_buf_read_map can set the flag and b_vctx for
> > any synchronous (!XBF_ASYNC) read because we know the caller will be
> > asleep waiting for b_iowait and therefore cannot kill the verifier
> > context structure.  Once we get to xfs_buf_ioend we can set b_ops, drop
> > the XBF_H_V_C flag, and call ->verify_read.
> > 
> > Now we actually /can/ pass the inode pointer into the verifier, along
> > with pretty much anything else we can think of.
> > 
> > Does that sound reasonable?  Or totally heinous? :)
> > 
> 
> That sounds reasonable to me and potentially a nice way to mitigate
> additional overhead. I suppose we'd also need a means to abstract the
> various contextual data fed into the type-specific verifiers (i.e., does
> the verifier care about inode health state? perag? both?).

For an initial RFC I think I could start with adding some trivial
helpers to initialize the xfs_buf_verify structure, so that it's a
little more obvious what the intended usage patterns are.

> Would you
> plan to do that with higher level wrappers and/or perhaps use similar
> union/flag magic in the xfs_buf_verify context to indicate which state
> an instance happens to provide? It might be worth a quick and dirty RFC
> to answer these questions with a couple examples and get any API
> feedback before running through the full set of verifiers..

Yeah.  I think I'll do a quick RFC to implement the bmbt owner check or
something.

--D

> Brian
> 
> > > Anyways, I think for this series it might be reasonable to push things
> > > down into verifiers opportunistically where we can do so without any
> > > core mechanism changes. We can follow up with changes to do the rest if
> > > we can come up with something elegant.
> > 
> > Ok.  I think I will try to implement such a beast for 5.6 and then put
> > this series after it.
> > 
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  	xfs_buf_set_ref(bp, XFS_AGFL_REF);
> > > > > > @@ -722,6 +725,7 @@ xfs_alloc_update_counters(
> > > > > >  	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
> > > > > >  		     be32_to_cpu(agf->agf_length))) {
> > > > > >  		xfs_buf_corruption_error(agbp);
> > > > > > +		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
> > > > > >  		return -EFSCORRUPTED;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -2952,6 +2956,8 @@ xfs_read_agf(
> > > > > >  			mp, tp, mp->m_ddev_targp,
> > > > > >  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> > > > > >  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > > > > > +	if (xfs_metadata_is_sick(error))
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  	if (!*bpp)
> > > > > > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > > > > > index 3657a9cb8490..ce8954a10c66 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_health.h
> > > > > > +++ b/fs/xfs/libxfs/xfs_health.h
> > > > > > @@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> > > > > >  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
> > > > > >  		unsigned int *checked);
> > > > > >  
> > > > > > +void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > > > > +		unsigned int mask);
> > > > > >  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> > > > > >  void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
> > > > > >  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> > > > > > @@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
> > > > > >  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> > > > > >  void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
> > > > > >  
> > > > > > +#define xfs_metadata_is_sick(error) \
> > > > > > +	(unlikely((error) == -EFSCORRUPTED || (error) == -EIO || \
> > > > > > +		  (error) == -EFSBADCRC))
> > > > > 
> > > > > Why is -EIO considered sick? My understanding is that once something is
> > > > > marked sick, scrub is the only way to clear that state. -EIO can be
> > > > > transient, so afaict that means we could mark a persistent in-core state
> > > > > based on a transient/resolved issue.
> > > > 
> > > > I think it sounds reasonable that if the fs hits a metadata IO error
> > > > then the administrator should scrub that data structure to make sure
> > > > it's ok, and if so, clear the sick state.
> > > > 
> > > 
> > > I'm not totally convinced... I thought we had configurations where I/O
> > > errors can be reasonably expected and recovered from. For example,
> > > consider the thin provisioning + infinite metadata writeback error retry
> > > mechanism. IIRC, the whole purpose of that was to facilitate the use
> > > case where the thin pool runs out of space, but the admin wants some
> > > window of time to expand and keep the filesystem alive.
> > 
> > Aha, I just realized that it's not clear from the macro definition that
> > I was only intending it to be called from the read path.
> > 
> > Though I guess there's always the possibility that the PFY trips over
> > the PCIE cable in the datacenter and XFS hits an EIO, but the disk will
> > be fine a moment later when he shoves it back in.  The disk media is
> > fine, and by that point either we returned read error to userspace or
> > the transaction got cancelled and it's too late to do anything anyway.
> > 
> > I'll drop the EIO check for now and we'll see if I get around to
> > revisiting it.
> > 
> > > I don't necessarily think it's a bad thing to suggest a scrub any time
> > > errors have occurred, but for something like the above where an
> > > environment may have been thoroughly tested and verified through that
> > > particular error->expand sequence, it seems that flagging bits as sick
> > > might be unnecessarily ominous.
> > 
> > <shrug> Yeah, (sick && !checked) is a weird passive-aggressive state
> > like that.
> > 
> > > > Though I realized just now that if scrub isn't enabled then it's an
> > > > unfixable dead end so the EIO check should be gated on
> > > > CONFIG_XFS_ONLINE_SCRUB=y.
> > > > 
> > > 
> > > Yeah, that was my initial concern..
> > > 
> > > > > Along similar lines, what's the expected behavior in the event of any of
> > > > > these errors for a kernel that might not support
> > > > > CONFIG_XFS_ONLINE_[SCRUB|REPAIR]? Just set the states that are never
> > > > > used for anything? If so, that seems Ok I suppose.. but it's a little
> > > > > awkward if we'd see the tracepoints and such associated with the state
> > > > > changes.
> > > > 
> > > > Even if scrub is disabled, the kernel will still set the sick state, and
> > > > later the administrator can query the filesystem with xfs_spaceman to
> > > > observe that sick state.
> > > > 
> > > 
> > > Ok, so it's intended to be a valid health state independent of scrub.
> > > That seems reasonable in principle and can always be used to indicate
> > > offline repair is necessary too.
> > 
> > Yes.
> > 
> > > > In the future, I will also use the per-AG sick states to steer
> > > > allocations away from known problematic AGs to try to avoid
> > > > unexpected shutdown in the middle of a transaction.
> > > > 
> > > 
> > > Hmm.. I'm a little curious about how much we should steer away from
> > > traditional behavior on kernels that might not support scrub. I suppose
> > > I could see arguments for going either way, but this is getting a bit
> > > ahead of this patch anyways. ;)
> > 
> > Yeah.  I /do/ have prototype patches buried in my dev tree but they are
> > too ugly not to let all the magic smoke out.  What really happens is
> > that when we hit a corruption error, we mark the AG as offline.  Then
> > the sysadmin can run xfs_scrub to fix it (which would set th AG back
> > online) or I guess we could have a spaceman -x command to force it back
> > online.
> > 
> > I always build in /some/ kind of manual override somewhere... :)
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > 
> > > > > Brian
> > > > > 
> > > > > > +
> > > > > >  #endif	/* __XFS_HEALTH_H__ */
> > > > > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > > > > index 988cde7744e6..c401512a4350 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > > > > @@ -27,6 +27,7 @@
> > > > > >  #include "xfs_trace.h"
> > > > > >  #include "xfs_log.h"
> > > > > >  #include "xfs_rmap.h"
> > > > > > +#include "xfs_health.h"
> > > > > >  
> > > > > >  /*
> > > > > >   * Lookup a record by ino in the btree given by cur.
> > > > > > @@ -2635,6 +2636,8 @@ xfs_read_agi(
> > > > > >  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > > > > >  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
> > > > > >  			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
> > > > > > +	if (xfs_metadata_is_sick(error))
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  	if (tp)
> > > > > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > > > > index d7d702ee4d1a..25c87834e42a 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > > > > @@ -22,6 +22,7 @@
> > > > > >  #include "xfs_bit.h"
> > > > > >  #include "xfs_refcount.h"
> > > > > >  #include "xfs_rmap.h"
> > > > > > +#include "xfs_health.h"
> > > > > >  
> > > > > >  /* Allowable refcount adjustment amounts. */
> > > > > >  enum xfs_refc_adjust_op {
> > > > > > @@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
> > > > > >  				XFS_ALLOC_FLAG_FREEING, &agbp);
> > > > > >  		if (error)
> > > > > >  			return error;
> > > > > > -		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > > > > +		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > > > > +			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> > > > > >  			return -EFSCORRUPTED;
> > > > > > +		}
> > > > > >  
> > > > > >  		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> > > > > >  		if (!rcur) {
> > > > > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > > > > index ff9412f113c4..a54a3c129cce 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > > > > @@ -21,6 +21,7 @@
> > > > > >  #include "xfs_errortag.h"
> > > > > >  #include "xfs_error.h"
> > > > > >  #include "xfs_inode.h"
> > > > > > +#include "xfs_health.h"
> > > > > >  
> > > > > >  /*
> > > > > >   * Lookup the first record less than or equal to [bno, len, owner, offset]
> > > > > > @@ -2400,8 +2401,10 @@ xfs_rmap_finish_one(
> > > > > >  		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> > > > > >  		if (error)
> > > > > >  			return error;
> > > > > > -		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > > > > +		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > > > > +			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> > > > > >  			return -EFSCORRUPTED;
> > > > > > +		}
> > > > > >  
> > > > > >  		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> > > > > >  		if (!rcur) {
> > > > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > > > index 0ac69751fe85..4a923545465d 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > > > @@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
> > > > > >  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > > > > >  			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > > > > >  			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > > > > > +	if (xfs_metadata_is_sick(error))
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
> > > > > >  	if (error)
> > > > > >  		return error;
> > > > > >  	xfs_buf_set_ref(bp, XFS_SSB_REF);
> > > > > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > > > > index 860dc70c99e7..36c32b108b39 100644
> > > > > > --- a/fs/xfs/xfs_health.c
> > > > > > +++ b/fs/xfs/xfs_health.c
> > > > > > @@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
> > > > > >  	spin_unlock(&mp->m_sb_lock);
> > > > > >  }
> > > > > >  
> > > > > > +/* Mark unhealthy per-ag metadata given a raw AG number. */
> > > > > > +void
> > > > > > +xfs_agno_mark_sick(
> > > > > > +	struct xfs_mount	*mp,
> > > > > > +	xfs_agnumber_t		agno,
> > > > > > +	unsigned int		mask)
> > > > > > +{
> > > > > > +	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
> > > > > > +
> > > > > > +	/* per-ag structure not set up yet? */
> > > > > > +	if (!pag)
> > > > > > +		return;
> > > > > > +
> > > > > > +	xfs_ag_mark_sick(pag, mask);
> > > > > > +	xfs_perag_put(pag);
> > > > > > +}
> > > > > > +
> > > > > >  /* Mark unhealthy per-ag metadata. */
> > > > > >  void
> > > > > >  xfs_ag_mark_sick(
> > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > > index 401da197f012..a2812cea748d 100644
> > > > > > --- a/fs/xfs/xfs_inode.c
> > > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > > @@ -35,6 +35,7 @@
> > > > > >  #include "xfs_log.h"
> > > > > >  #include "xfs_bmap_btree.h"
> > > > > >  #include "xfs_reflink.h"
> > > > > > +#include "xfs_health.h"
> > > > > >  
> > > > > >  kmem_zone_t *xfs_inode_zone;
> > > > > >  
> > > > > > @@ -787,6 +788,8 @@ xfs_ialloc(
> > > > > >  	 */
> > > > > >  	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
> > > > > >  		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> > > > > > +		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
> > > > > > +				XFS_SICK_AG_INOBT);
> > > > > >  		return -EFSCORRUPTED;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -2137,6 +2140,7 @@ xfs_iunlink_update_bucket(
> > > > > >  	 */
> > > > > >  	if (old_value == new_agino) {
> > > > > >  		xfs_buf_corruption_error(agibp);
> > > > > > +		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
> > > > > >  		return -EFSCORRUPTED;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -2203,6 +2207,7 @@ xfs_iunlink_update_inode(
> > > > > >  	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> > > > > >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > > > > >  				sizeof(*dip), __this_address);
> > > > > > +		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > > > > >  		error = -EFSCORRUPTED;
> > > > > >  		goto out;
> > > > > >  	}
> > > > > > @@ -2217,6 +2222,7 @@ xfs_iunlink_update_inode(
> > > > > >  		if (next_agino != NULLAGINO) {
> > > > > >  			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> > > > > >  					dip, sizeof(*dip), __this_address);
> > > > > > +			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > > > > >  			error = -EFSCORRUPTED;
> > > > > >  		}
> > > > > >  		goto out;
> > > > > > @@ -2271,6 +2277,7 @@ xfs_iunlink(
> > > > > >  	if (next_agino == agino ||
> > > > > >  	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> > > > > >  		xfs_buf_corruption_error(agibp);
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > > >  		return -EFSCORRUPTED;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -2408,6 +2415,7 @@ xfs_iunlink_map_prev(
> > > > > >  			XFS_CORRUPTION_ERROR(__func__,
> > > > > >  					XFS_ERRLEVEL_LOW, mp,
> > > > > >  					*dipp, sizeof(**dipp));
> > > > > > +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> > > > > >  			error = -EFSCORRUPTED;
> > > > > >  			return error;
> > > > > >  		}
> > > > > > @@ -2454,6 +2462,7 @@ xfs_iunlink_remove(
> > > > > >  	if (!xfs_verify_agino(mp, agno, head_agino)) {
> > > > > >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > > > > >  				agi, sizeof(*agi));
> > > > > > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > > >  		return -EFSCORRUPTED;
> > > > > >  	}
> > > > > >  
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
