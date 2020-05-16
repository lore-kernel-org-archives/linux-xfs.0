Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB814C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94E520756
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d+8SU3Zw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgEPSK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 14:10:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgEPSK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 14:10:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GI4u0Z075606;
        Sat, 16 May 2020 18:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UhBnCJoHCCGHoUeEZ8nuoUKqRPs71NODjJXOhJ1VHvY=;
 b=d+8SU3ZwKH9fpSpdkKIYCcpeICnsA9mMFM/wJ41xLgFyrrpmaOMnXSIgctrewPNbqPCX
 nO2+8/SKxfmKQKBSgGq9rJYB7uH1ZxsdIPQibqTLNE/O760z3wQKG72eue+xGgoeKJ2F
 h6hENuBeauH+2XsfU0Rcqbw1BXoH7SbjaYe/1/EzwLYdAfX12KyfF904YVeUkjZsK4Sg
 7FyPOlozLKwjXWWQjXwy3KJjSehOM9Ts7n9ZumBb3Z/wnoFmcLBpuzsCBZZTu4qdSnPp
 Y3KP8b/NNLgSEnVPO4rwXPwaJ/jj/Sxa4H5Za5hEyQuQndRslPck56IACyPJIOxI6tPs fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tn1ch9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 18:10:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GI8nBB067854;
        Sat, 16 May 2020 18:10:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312801bq8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 18:10:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GIAn2G005995;
        Sat, 16 May 2020 18:10:49 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 11:10:49 -0700
Date:   Sat, 16 May 2020 11:10:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: cleanup xfs_idestroy_fork
Message-ID: <20200516181048.GG6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-7-hch@lst.de>
 <20200512185435.GL37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512185435.GL37029@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=5 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=5 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 02:54:35PM -0400, Brian Foster wrote:
> On Sun, May 10, 2020 at 09:24:04AM +0200, Christoph Hellwig wrote:
> > Move freeing the dynamically allocated attr and COW fork, as well
> > as zeroing the pointers where actually needed into the callers, and
> > just pass the xfs_ifork structure to xfs_idestroy_fork.  Simplify
> > the kmem_free calls by not checking for NULL first, and not zeroing
> > the pointers in structure that are about to be freed (either the
> > ifork or the containing inode in case of the data fork).
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
> >  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c | 36 +++++++++-------------------------
> >  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
> >  fs/xfs/xfs_attr_inactive.c     |  7 +++++--
> >  fs/xfs/xfs_icache.c            | 15 ++++++++------
> >  6 files changed, 28 insertions(+), 41 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 6562f2bcd15cc..577cc20e03170 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -495,38 +495,20 @@ xfs_idata_realloc(
> >  
> >  void
> >  xfs_idestroy_fork(
> > -	xfs_inode_t	*ip,
> > -	int		whichfork)
> > +	struct xfs_ifork	*ifp)
> >  {
> > -	struct xfs_ifork	*ifp;
> > -
> > -	ifp = XFS_IFORK_PTR(ip, whichfork);
> > -	if (ifp->if_broot != NULL) {
> > -		kmem_free(ifp->if_broot);
> > -		ifp->if_broot = NULL;
> > -	}
> > +	kmem_free(ifp->if_broot);
> 
> I think this function should still reset the pointers within the ifp
> that it frees (if_broot and if_data below), particularly as long as
> there are multiple callers that pass the data fork because it is not
> immediately/independently freed. IOW, it's not clear if something
> happens to reset i_mode between when xfs_inode_from_disk() might fail
> and destroy the data fork, and when the inode is ultimately freed and we
> look at i_mode to determine whether to destroy the data fork.

/me agrees, let's not leave a potential UAF landmine here.

--D

> Brian
> 
> >  
> >  	/*
> > -	 * If the format is local, then we can't have an extents
> > -	 * array so just look for an inline data array.  If we're
> > -	 * not local then we may or may not have an extents list,
> > -	 * so check and free it up if we do.
> > +	 * If the format is local, then we can't have an extents array so just
> > +	 * look for an inline data array.  If we're not local then we may or may
> > +	 * not have an extents list, so check and free it up if we do.
> >  	 */
> >  	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
> > -		if (ifp->if_u1.if_data != NULL) {
> > -			kmem_free(ifp->if_u1.if_data);
> > -			ifp->if_u1.if_data = NULL;
> > -		}
> > -	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
> > -		xfs_iext_destroy(ifp);
> > -	}
> > -
> > -	if (whichfork == XFS_ATTR_FORK) {
> > -		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> > -		ip->i_afp = NULL;
> > -	} else if (whichfork == XFS_COW_FORK) {
> > -		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> > -		ip->i_cowfp = NULL;
> > +		kmem_free(ifp->if_u1.if_data);
> > +	} else if (ifp->if_flags & XFS_IFEXTENTS) {
> > +		if (ifp->if_height)
> > +			xfs_iext_destroy(ifp);
> >  	}
> >  }
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index d849cca103edd..a4953e95c4f3f 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -86,7 +86,7 @@ int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> >  int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
> >  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
> >  				struct xfs_inode_log_item *, int);
> > -void		xfs_idestroy_fork(struct xfs_inode *, int);
> > +void		xfs_idestroy_fork(struct xfs_ifork *ifp);
> >  void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
> >  				int whichfork);
> >  void		xfs_iroot_realloc(struct xfs_inode *, int, int);
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index 00ffc46c0bf71..bfad669e6b2f8 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -388,8 +388,11 @@ xfs_attr_inactive(
> >  	xfs_trans_cancel(trans);
> >  out_destroy_fork:
> >  	/* kill the in-core attr fork before we drop the inode lock */
> > -	if (dp->i_afp)
> > -		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
> > +	if (dp->i_afp) {
> > +		xfs_idestroy_fork(dp->i_afp);
> > +		kmem_cache_free(xfs_ifork_zone, dp->i_afp);
> > +		dp->i_afp = NULL;
> > +	}
> >  	if (lock_mode)
> >  		xfs_iunlock(dp, lock_mode);
> >  	return error;
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index c09b3e9eab1da..d806d3bfa8936 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -87,15 +87,18 @@ xfs_inode_free_callback(
> >  	case S_IFREG:
> >  	case S_IFDIR:
> >  	case S_IFLNK:
> > -		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> > +		xfs_idestroy_fork(&ip->i_df);
> >  		break;
> >  	}
> >  
> > -	if (ip->i_afp)
> > -		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> > -	if (ip->i_cowfp)
> > -		xfs_idestroy_fork(ip, XFS_COW_FORK);
> > -
> > +	if (ip->i_afp) {
> > +		xfs_idestroy_fork(ip->i_afp);
> > +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> > +	}
> > +	if (ip->i_cowfp) {
> > +		xfs_idestroy_fork(ip->i_cowfp);
> > +		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> > +	}
> >  	if (ip->i_itemp) {
> >  		ASSERT(!test_bit(XFS_LI_IN_AIL,
> >  				 &ip->i_itemp->ili_item.li_flags));
> > -- 
> > 2.26.2
> > 
> 
