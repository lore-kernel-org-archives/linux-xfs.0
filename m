Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A53BC33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24258206D5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALbFWyr6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgAQXGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 18:06:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgAQXGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 18:06:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HN3hc4012151;
        Fri, 17 Jan 2020 23:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LZSYHZBKVLgxVhijI2MhHcurQEzzg9XjGQDofRzhCVk=;
 b=ALbFWyr6l1pnNdjtIdHDwrMZqFjXyn84pbTza8xVeFrydJnSo/Obba29iTcGqxYDAkyr
 9593i3XzdNsB3jrW7SmCDU1zQUZ+y/jwBDBYR3VnZXDxUM/ve8w1ANIyoaag5gZLqEI5
 6moUex8UMk1yUjFykjDQG2446gmOCCZfgEB0LW8wiCPBt3PltzyDcyZWRD5xS6Kl4SHq
 gYvvlPudmmLNZdQRAzx+qDLiV/tb54ueoYvz6Sgy+O+GdiPqVu3nsU7SubLF4m07FX6H
 IP3gJoftsdcjQpnoe3pL0uiWwjyg3jgTNm+2ihY1aFijc+OwDTTuYJ8sbdRu5zN8bN08 MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74subnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 23:05:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HN5d6a194839;
        Fri, 17 Jan 2020 23:05:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xk24ftkcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 23:05:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00HN5vKG002042;
        Fri, 17 Jan 2020 23:05:57 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 15:05:57 -0800
Date:   Fri, 17 Jan 2020 15:05:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200117230556.GV8247@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924228165.3029431.1835481566077971155.stgit@magnolia>
 <20200117065957.GC26438@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117065957.GC26438@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:59:57PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 16, 2020 at 10:24:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
> > caller passed TRYLOCK and we weren't able to get the lock; and change
> > the callers to recognize this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |   31 +++++++++++++++----------------
> >  fs/xfs/libxfs/xfs_bmap.c  |    9 +++++----
> >  fs/xfs/xfs_filestream.c   |   11 ++++++-----
> >  3 files changed, 26 insertions(+), 25 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 83273975df77..26f3e4db84e0 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2502,13 +2502,15 @@ xfs_alloc_fix_freelist(
> >  
> >  	if (!pag->pagf_init) {
> >  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> > -		if (error)
> > -			goto out_no_agbp;
> > -		if (!pag->pagf_init) {
> > +		if (error == -EAGAIN) {
> > +			/* Couldn't lock the AGF so skip this AG. */
> >  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> >  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> > -			goto out_agbp_relse;
> > +			error = 0;
> > +			goto out_no_agbp;
> >  		}
> > +		if (error)
> > +			goto out_no_agbp;
> 
> I wonder if something like:
> 
> 		if (error) {
> 			if (error == -EAGAIN) {
> 				/* Couldn't lock the AGF so skip this AG. */
> 	 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> 	 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> 				error = 0;
> 			}
> 			goto out_no_agbp;
> 		}
> 
> would be a little nicer here?

> > @@ -2533,13 +2535,15 @@ xfs_alloc_fix_freelist(
> >  	 */
> >  	if (!agbp) {
> >  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> > -		if (error)
> > -			goto out_no_agbp;
> > -		if (!agbp) {
> > +		if (error == -EAGAIN) {
> > +			/* Couldn't lock the AGF so skip this AG. */
> >  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> >  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> > +			error = 0;
> >  			goto out_no_agbp;
> >  		}
> > +		if (error)
> > +			goto out_no_agbp;
> >  	}
> 
> Same here.  Also shouldn't those asserts just move into
> xfs_alloc_read_agf or go away now that we have a proper return value
> and not the magic NULL buffer?

I'll move the assert into xfs_alloc_read_agf, so these all turn into:

if (error) {
	if (error == -EAGAIN)
		error = 0;
	goto next ag;
}

> 
> > +	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
> > +	if (error)
> >  		return error;
> > +	xfs_trans_brelse(tp, bp);
> >  	return 0;
> 
> Maybe simplify this further to:
> 
> 	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
> 	if (!error)
> 		xfs_trans_brelse(tp, bp);
> 	return error;

Ok.

> > @@ -2958,12 +2962,9 @@ xfs_read_agf(
> >  	trace_xfs_read_agf(mp, agno);
> >  
> >  	ASSERT(agno != NULLAGNUMBER);
> > -	error = xfs_trans_read_buf(
> > -			mp, tp, mp->m_ddev_targp,
> > +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> 
> This hunk should probably go into the patch that changed the
> xfs_trans_read_buf return value instead.

Ok.

> > +		if (error == -EAGAIN) {
> > +			/* Couldn't lock the AGF, so skip this AG. */
> >  			*notinit = 1;
> > +			error = 0;
> >  			goto out;
> >  		}
> > +		if (error)
> > +			goto out;
> 
> Should probably be:
> 
> 		if (error) {
> 			if (error == -EAGAIN) {
> 				/* Couldn't lock the AGF, so skip this AG. */
> 	 			*notinit = 1;
> 				error = 0;
> 			}
>  			goto out;

Fixed.

--D
