Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB578C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C73502082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jOjcIit/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgGAXTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:19:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgGAXTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:19:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061N2ELA092938;
        Wed, 1 Jul 2020 23:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=p8PF0Bj/snD4plaLSYND5F9wZsKMNrUsA0akYm0QYEE=;
 b=jOjcIit/qQabAp0QoW5RDqr6FKbQidGIupDtgx2sgD+ZGhIAI9GngECk4qtvYNXXcRff
 5SwY5HXfbKMDs0bZxDn2HGAf6qB0v42wvzkjukOrGkXB3IWqDKto75CCKbzyKkmKECpm
 bVQ9Wemua5AblkkvqJ5ZPiIjkd47IQZ26i3fZ/8zIJfc/XnI7ySBRaEiZuOLOtJjfJQx
 dII1FvAX+nmHp1TN2Kq224wNSlh7rw5ScBmwKq9HK5IGCePMZR2isYXNNTYH1hzR46PN
 ZTegIXFiuD752sITBfk7B+C0tDeLBUj4/Rt2nd8NPXbYwcR83yao/kzQaRbzfzUhWqFz Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrndb4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 23:19:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061MwlDA067356;
        Wed, 1 Jul 2020 23:19:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52kwj2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 23:19:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061NJBkp032600;
        Wed, 1 Jul 2020 23:19:11 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 23:19:11 +0000
Date:   Wed, 1 Jul 2020 16:19:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200701231910.GQ7625@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
 <20200701225053.GA2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701225053.GA2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:50:53AM +1000, Dave Chinner wrote:
> On Tue, Jun 30, 2020 at 08:42:16AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the incore dq_flags to figure out the dquot type.  This is the first
> > step towards removing xfs_disk_dquot from the incore dquot.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
> >  fs/xfs/scrub/quota.c           |    4 ----
> >  fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_dquot.h             |    2 ++
> >  fs/xfs/xfs_dquot_item.c        |    6 ++++--
> >  fs/xfs/xfs_qm.c                |    4 ++--
> >  fs/xfs/xfs_qm.h                |    2 +-
> >  fs/xfs/xfs_qm_syscalls.c       |    9 +++------
> >  8 files changed, 45 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> > index 56d9dd787e7b..459023b0a304 100644
> > --- a/fs/xfs/libxfs/xfs_quota_defs.h
> > +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> > @@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
> >  
> >  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
> >  
> > +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> 
> That's used as an on-disk flags mask. Perhaps XFS_DQF_ONDISK_MASK?

Well, based on Christoph's suggestions I broke the incore dquot flags
(XFS_DQ_*) apart from the ondisk dquot flags (XFS_DQFLAG_*).  Not sure
if that's really better, but at least the namespaces are separate now.

> > +
> >  #define XFS_DQ_FLAGS \
> >  	{ XFS_DQ_USER,		"USER" }, \
> >  	{ XFS_DQ_PROJ,		"PROJ" }, \
> > diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> > index 905a34558361..710659d3fa28 100644
> > --- a/fs/xfs/scrub/quota.c
> > +++ b/fs/xfs/scrub/quota.c
> > @@ -108,10 +108,6 @@ xchk_quota_item(
> >  
> >  	sqi->last_id = id;
> >  
> > -	/* Did we get the dquot type we wanted? */
> > -	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
> > -		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> > -
> >  	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
> >  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> >  
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 46c8ca83c04d..59d1bce34a98 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -561,6 +561,16 @@ xfs_dquot_from_disk(
> >  	return 0;
> >  }
> >  
> > +/* Copy the in-core quota fields into the on-disk buffer. */
> > +void
> > +xfs_dquot_to_disk(
> > +	struct xfs_disk_dquot	*ddqp,
> > +	struct xfs_dquot	*dqp)
> > +{
> > +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> > +	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
> > +}
> > +
> >  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> >  static int
> >  xfs_qm_dqread_alloc(
> > @@ -1108,6 +1118,17 @@ xfs_qm_dqflush_done(
> >  	xfs_dqfunlock(dqp);
> >  }
> >  
> > +/* Check incore dquot for errors before we flush. */
> > +static xfs_failaddr_t
> > +xfs_qm_dqflush_check(
> > +	struct xfs_dquot	*dqp)
> > +{
> > +	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
> > +		return __this_address;
> 
> This only checks the low 8 bits in dq_flags, which is a 32 bit
> field. If we ever renumber the dq flags and the dquot types end up
> outside the LSB, this code will break.
> 
> I don't really see a need to micro-optimise the code so much it
> leaves landmines like this in the code...

Ok. Fixed.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
