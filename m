Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD5FC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45188206EB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E88zyFIY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgEDW5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:57:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgEDW5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:57:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Mlo8F141689
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=n0MI7jKRwGoov32p3f63vgwonfrF3VKwpZZ/+e8Xoy8=;
 b=E88zyFIYvBZA/N9TA5FRHALIwDfgg7yCFFRcS1rMcPHPBuhXebK8fF8xc/ZS9JzmGVTx
 jVpk0zaq2XFre7+vFbIprpnQ8bxT37dtFd5jv2j5VU8hwX7TyUak1OiZd065HKKNsVuB
 NkBd3VjpYbzZY2soQxC3XyNvB8vtJLSSauteKKtB7tcPl4LJ9OyfwSoW9k6GZBg8Jyj4
 UL5bRxGXHC+5TBql8s30OGrMFoMwcHmHCTL4JuUPJQFzbweKz9GkuFT1Zr1RjtgMBhdk
 neWe/tGKEs8ODldiKP2S/Enu7XiVUEQgwQat2TUJBjq9UbjGilLxnOcwdUaw9YCHK1bo oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r1sn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:57:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MmUa7111953
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:57:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30sjjx45c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:57:05 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044Mv4U8022692
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:57:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:57:04 -0700
Date:   Mon, 4 May 2020 15:57:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200504225703.GB5716@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
 <20200504174125.GD13783@magnolia>
 <7b551e24-1da1-384a-b679-609865402921@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b551e24-1da1-384a-b679-609865402921@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 03:53:25PM -0700, Allison Collins wrote:
> 
> 
> On 5/4/20 10:41 AM, Darrick J. Wong wrote:
> > On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
> > > This function is similar to xfs_attr_rmtval_remove, but adapted to
> > > return EAGAIN for new transactions. We will use this later when we
> > > introduce delayed attributes.  This function will eventually replace
> > > xfs_attr_rmtval_remove
> > 
> > Like Brian suggested, this changelog could probably just say that we're
> > hoisting the loop body into a separate function so that delayed attrs
> > can manage the transaction rolling.
> > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
> > >   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
> > >   2 files changed, 37 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index 4d51969..02d1a44 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
> > >   	xfs_dablk_t		lblkno;
> > >   	int			blkcnt;
> > >   	int			error = 0;
> > > -	int			done = 0;
> > > +	int			retval = 0;
> > >   	trace_xfs_attr_rmtval_remove(args);
> > > @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
> > >   	 */
> > >   	lblkno = args->rmtblkno;
> > >   	blkcnt = args->rmtblkcnt;
> > > -	while (!done) {
> > > -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> > > -				    XFS_BMAPI_ATTRFORK, 1, &done);
> > > -		if (error)
> > > -			return error;
> > > -		error = xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			return error;
> > > +	do {
> > > +		retval = __xfs_attr_rmtval_remove(args);
> > > +		if (retval && retval != EAGAIN)
> > > +			return retval;
> > >   		/*
> > >   		 * Close out trans and start the next one in the chain.
> > > @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
> > >   		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > >   		if (error)
> > >   			return error;
> > > -	}
> > > +	} while (retval == -EAGAIN);
> > > +
> > >   	return 0;
> > >   }
> > > +
> > > +/*
> > > + * Remove the value associated with an attribute by deleting the out-of-line
> > > + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > > + * transaction and recall the function
> > 
> > recall the function...?
> > 
> > Oh.  "re-call" the function.
> Will fix
> 
> > 
> > > + */
> > > +int
> > > +__xfs_attr_rmtval_remove(
> > 
> > xfs_attr_rmtval_remove_extent() ?
> Well, this would be the third rename for this function though. Initially I
> think we named it xfs_attr_rmtval_unmap, and then later we changed it to
> __xfs_attr_rmtval_remove.  Ultimatly, it really doesn't matter what the name
> is, because it's going to get renamed at the end of the set anyway.
> Eventually it replaces the calling function and becomes
> xfs_attr_rmtval_remove.
> 
> So the name it gets here is just sort of a transient name, and it doesnt
> effect much in the greater scheme of things.  If people really feel strongly
> about it though, it wont hurt much to change it again.  I do try to point
> out the history of it though to avoid too much churn.  :-)

Heh, ok.  /I/ don't care that much. :)

--D

> Allison
> 
> > 
> > --D
> > 
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +	int			error, done;
> > > +
> > > +	/*
> > > +	 * Unmap value blocks for this attr.
> > > +	 */
> > > +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> > > +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_defer_finish(&args->trans);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (!done)
> > > +		return -EAGAIN;
> > > +
> > > +	return error;
> > > +}
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > index eff5f95..ee3337b 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > >   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > >   		xfs_buf_flags_t incore_flags);
> > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > > +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > -- 
> > > 2.7.4
> > > 
