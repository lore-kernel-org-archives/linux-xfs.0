Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E2CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E54D2072C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2Ti++HM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgETSid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 14:38:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETSid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 14:38:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIVaiB024140;
        Wed, 20 May 2020 18:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YnoEwv1qvHrv7sS7psDxJQO6xS7PDyB8nPtvSHPOshA=;
 b=H2Ti++HM8rzH/UWQ65CaT3rzZ27SI5dRM4jn+HI7a7eLYgHDpyMi0uAPSZA6jt19iCya
 T6yM/BSMO9CwYVIy1kCSwaFFB8p7/Zvu/LNVm+FBVpVMuKtfstGbZonzQNH3FKVLgIZZ
 rbG1Pbeq8Sz5oCl+xVNkL0FxPwvCdjQ7iAaiZHvASfk//3AFcX6OxuS7hobEhzigStNp
 l8+c+d8XmuVghflqyf9AkyX42UWIwdpuHCGUL7jZ8EpFT09wYWCM/XXZJFLN6LVO3Asv
 OMMWzoMaGUWvYiVlDQQ6O5OTzDRQtJ2FLcClQ4p5bDqc1IDgn+hij01p6WLzxr+KkxNT +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rb9wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 18:38:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIX9mq063921;
        Wed, 20 May 2020 18:36:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t38defh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 18:36:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KIaSFN009515;
        Wed, 20 May 2020 18:36:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 11:36:28 -0700
Date:   Wed, 20 May 2020 11:36:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: remove flags argument from xfs_inode_ag_walk
Message-ID: <20200520183627.GX17627@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
 <158993914950.976105.8586367797907212993.stgit@magnolia>
 <20200520063825.GE2742@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520063825.GE2742@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:38:25AM +0200, Christoph Hellwig wrote:
> On Tue, May 19, 2020 at 06:45:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The incore inode walk code passes a flags argument and a pointer from
> > the xfs_inode_ag_iterator caller all the way to the iteration function.
> > We can reduce the function complexity by passing flags through the
> > private pointer.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_icache.c      |   38 ++++++++++++++------------------------
> >  fs/xfs/xfs_icache.h      |    4 ++--
> >  fs/xfs/xfs_qm_syscalls.c |   25 +++++++++++++++++--------
> >  3 files changed, 33 insertions(+), 34 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index e716b19879c6..87b98bfdf27d 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -790,9 +790,7 @@ STATIC int
> >  xfs_inode_ag_walk(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_perag	*pag,
> > -	int			(*execute)(struct xfs_inode *ip, int flags,
> > -					   void *args),
> > -	int			flags,
> > +	int			(*execute)(struct xfs_inode *ip, void *args),
> >  	void			*args,
> >  	int			tag,
> >  	int			iter_flags)
> > @@ -868,7 +866,7 @@ xfs_inode_ag_walk(
> >  			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
> >  			    xfs_iflags_test(batch[i], XFS_INEW))
> >  				xfs_inew_wait(batch[i]);
> > -			error = execute(batch[i], flags, args);
> > +			error = execute(batch[i], args);
> >  			xfs_irele(batch[i]);
> >  			if (error == -EAGAIN) {
> >  				skipped++;
> > @@ -972,9 +970,7 @@ int
> >  xfs_inode_ag_iterator(
> >  	struct xfs_mount	*mp,
> >  	int			iter_flags,
> > -	int			(*execute)(struct xfs_inode *ip, int flags,
> > -					   void *args),
> > -	int			flags,
> > +	int			(*execute)(struct xfs_inode *ip, void *args),
> >  	void			*args,
> >  	int			tag)
> >  {
> > @@ -986,7 +982,7 @@ xfs_inode_ag_iterator(
> >  	ag = 0;
> >  	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
> >  		ag = pag->pag_agno + 1;
> > -		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
> > +		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
> >  				iter_flags);
> >  		xfs_perag_put(pag);
> >  		if (error) {
> > @@ -1443,12 +1439,14 @@ xfs_inode_match_id_union(
> >  STATIC int
> >  xfs_inode_free_eofblocks(
> >  	struct xfs_inode	*ip,
> > -	int			flags,
> >  	void			*args)
> >  {
> > -	int ret = 0;
> > -	struct xfs_eofblocks *eofb = args;
> > -	int match;
> > +	struct xfs_eofblocks	*eofb = args;
> > +	bool			wait;
> > +	int			match;
> > +	int			ret = 0;
> > +
> > +	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
> 
> No need for the outer braces.

Fixed.

> > @@ -1484,7 +1481,7 @@ xfs_inode_free_eofblocks(
> >  	 * scanner moving and revisit the inode in a subsequent pass.
> >  	 */
> >  	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > -		if (flags & SYNC_WAIT)
> > +		if (wait)
> >  			ret = -EAGAIN;
> >  		return ret;
> 
> Just me, but I'd prefer an explicit:
> 
> 		if (wait)
> 			return -EAGAIN;
> 		return 0;
> 
> here.  Not really new in this patch, but if you touch this area anyway..

How about 'return wait ? -EAGAIN : 0;' ?

> > index a9460bdcca87..571ecb17b3bf 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -726,12 +726,17 @@ xfs_qm_scall_getquota_next(
> >  	return error;
> >  }
> >  
> > +struct xfs_dqrele {
> > +	uint		flags;
> > +};
> 
> > +	struct xfs_dqrele	dqr = {
> > +		.flags		= flags,
> > +	};
> 
> Instead of a new structure we could just take the address of flags and
> pass that to simplify the code a bit.

Fixed.

--D
