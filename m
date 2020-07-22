Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23CFC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A79EC2077D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:24:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JyWZdLJe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgGVAYv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 20:24:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56748 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgGVAYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 20:24:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M0IQ6Z007108
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 00:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ys3LmywLMjKgB0nhEmHdSSnYV7Ba/hfFezci9pyBXtg=;
 b=JyWZdLJe0BIpEwUy2Q5V3s4pAur1luEy013j4KGL+O+tMW9Mzi/SfbrUBo5Rqx+82SCc
 EjVxN5b/2ueDoUP6QjtvBcuAIZ5Q3unvrd2uyTnvritibYx+k2xkPqmjkmspDKjdA7aW
 pqiEl1g4LJzD78bc8AMnqKQ8C4lqgOqKTE3NpPpoeqvgSVPtPusk0gQGp4sB7w3xvb30
 o+0XuzbJTah3hKjYVvo4dC7sdbVyAzDLu/vEwKbPiUDRLNLVaIdq3MYSCdV8DDMrR+dA
 RG+kuA3PXB053CO5hOAKUdjMyxUvjjauB1ui9rBMcyZJSXcMUSyyimvCnpB+LMn9y+5n Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32d6ksmgbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 00:24:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M0J26u005883
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 00:24:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32e7xrrs4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 00:24:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06M0OmAb017549
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 00:24:48 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 17:24:48 -0700
Date:   Tue, 21 Jul 2020 17:24:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 10/25] xfs: Refactor xfs_attr_rmtval_remove
Message-ID: <20200722002446.GM3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-11-allison.henderson@oracle.com>
 <20200721233118.GH3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721233118.GH3151642@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 21, 2020 at 04:31:18PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:51PM -0700, Allison Collins wrote:
> > Refactor xfs_attr_rmtval_remove to add helper function
> > __xfs_attr_rmtval_remove. We will use this later when we introduce
> > delayed attributes.  This function will eventually replace
> > xfs_attr_rmtval_remove
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
> >  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
> >  2 files changed, 37 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > index 4d51969..9b4c173 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
> >  	xfs_dablk_t		lblkno;
> >  	int			blkcnt;
> >  	int			error = 0;
> > -	int			done = 0;
> > +	int			retval = 0;
> >  
> >  	trace_xfs_attr_rmtval_remove(args);
> >  
> > @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
> >  	 */
> >  	lblkno = args->rmtblkno;
> >  	blkcnt = args->rmtblkcnt;
> 
> Er... I think these local variables can go away here, right?
> 
> --D
> 
> > -	while (!done) {
> > -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> > -				    XFS_BMAPI_ATTRFORK, 1, &done);
> > -		if (error)
> > -			return error;
> > -		error = xfs_defer_finish(&args->trans);
> > -		if (error)
> > -			return error;
> > +	do {
> > +		retval = __xfs_attr_rmtval_remove(args);
> > +		if (retval && retval != EAGAIN)

Also this has to be -EAGAIN.  Amazingly, nothing in fstests blew up on
this.

--D

> > +			return retval;
> >  
> >  		/*
> >  		 * Close out trans and start the next one in the chain.
> > @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
> >  		error = xfs_trans_roll_inode(&args->trans, args->dp);
> >  		if (error)
> >  			return error;
> > -	}
> > +	} while (retval == -EAGAIN);
> > +
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Remove the value associated with an attribute by deleting the out-of-line
> > + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > + * transaction and re-call the function
> > + */
> > +int
> > +__xfs_attr_rmtval_remove(
> > +	struct xfs_da_args	*args)
> > +{
> > +	int			error, done;
> > +
> > +	/*
> > +	 * Unmap value blocks for this attr.
> > +	 */
> > +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> > +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_defer_finish(&args->trans);
> > +	if (error)
> > +		return error;
> > +
> > +	if (!done)
> > +		return -EAGAIN;
> > +
> > +	return error;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > index 3616e88..9eee615 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> >  		xfs_buf_flags_t incore_flags);
> >  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >  #endif /* __XFS_ATTR_REMOTE_H__ */
> > -- 
> > 2.7.4
> > 
