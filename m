Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A824C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAD42067D
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pLPa6R9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgGYAqQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:46:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48428 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYAqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:46:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P0bsg2056773
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ao2Mh8U/3Lv46RLhSNfH+sWxGTG07+kybcFgmfHybD8=;
 b=pLPa6R9aFEF/qAECR7FK/7WHz+MnOeLbYn8Vgc46m1s7rkR/oHKnkC9Ks7ZEKDKv4/jO
 C9UiRLdB2XDJPeNNgCZTMDplf41By/foZePSJMD39WJ+kRvily1XsLAgnqNjxi1lE1Z8
 PGIfCXuJKh1+mRTKNw+AxDm9HAvzJijx04dkXzfsxae3a6qIfN85vZjgmWbiwCYEtNnw
 o03UCKtLpENp/Yly7Z0bUJKEBhS8wQDXHl/YFMfJeFuX4S229hyJsOksguKmH2X3sNiD
 DG6idzm4alY47dANivMgsbM9y5ZO731bEcPiK9v76fJOLZ45TREpRTiiQO0DbG07bq1/ Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32d6kt5wwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:46:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P0iM8P187215
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:46:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32ga9cr6eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:46:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P0kEs3028666
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:46:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:46:13 -0700
Date:   Fri, 24 Jul 2020 17:46:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 10/25] xfs: Refactor xfs_attr_rmtval_remove
Message-ID: <20200725004612.GX3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-11-allison.henderson@oracle.com>
 <20200721233118.GH3151642@magnolia>
 <20200722002446.GM3151642@magnolia>
 <a9c10934-c918-079e-69c0-1912ff6026ec@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9c10934-c918-079e-69c0-1912ff6026ec@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 24, 2020 at 05:08:13PM -0700, Allison Collins wrote:
> 
> 
> On 7/21/20 5:24 PM, Darrick J. Wong wrote:
> > On Tue, Jul 21, 2020 at 04:31:18PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 20, 2020 at 05:15:51PM -0700, Allison Collins wrote:
> > > > Refactor xfs_attr_rmtval_remove to add helper function
> > > > __xfs_attr_rmtval_remove. We will use this later when we introduce
> > > > delayed attributes.  This function will eventually replace
> > > > xfs_attr_rmtval_remove
> > > > 
> > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >   fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
> > > >   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
> > > >   2 files changed, 37 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > > index 4d51969..9b4c173 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > > @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
> > > >   	xfs_dablk_t		lblkno;
> > > >   	int			blkcnt;
> > > >   	int			error = 0;
> > > > -	int			done = 0;
> > > > +	int			retval = 0;
> > > >   	trace_xfs_attr_rmtval_remove(args);
> > > > @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
> > > >   	 */
> > > >   	lblkno = args->rmtblkno;
> > > >   	blkcnt = args->rmtblkcnt;
> > > 
> > > Er... I think these local variables can go away here, right?
> > > 
> > > --D
> > > 
> > > > -	while (!done) {
> > > > -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> > > > -				    XFS_BMAPI_ATTRFORK, 1, &done);
> > > > -		if (error)
> > > > -			return error;
> > > > -		error = xfs_defer_finish(&args->trans);
> > > > -		if (error)
> > > > -			return error;
> > > > +	do {
> > > > +		retval = __xfs_attr_rmtval_remove(args);
> > > > +		if (retval && retval != EAGAIN)
> > 
> > Also this has to be -EAGAIN.  Amazingly, nothing in fstests blew up on
> > this.
> Ok, will fix! If you are running with the full set, it wouldnt trip over
> anything because this whole function is removed by the end of the series.

It's already in for-next, with numerous minor corrections for Carlos'
kmem series.  You might want to have a quick look around at the diff
between xfs-5.9-merge-5 and xfs-5.9-merge-6 just in case I missed
something...

--D

> Allison
> 
> > 
> > --D
> > 
> > > > +			return retval;
> > > >   		/*
> > > >   		 * Close out trans and start the next one in the chain.
> > > > @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
> > > >   		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > >   		if (error)
> > > >   			return error;
> > > > -	}
> > > > +	} while (retval == -EAGAIN);
> > > > +
> > > >   	return 0;
> > > >   }
> > > > +
> > > > +/*
> > > > + * Remove the value associated with an attribute by deleting the out-of-line
> > > > + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > > > + * transaction and re-call the function
> > > > + */
> > > > +int
> > > > +__xfs_attr_rmtval_remove(
> > > > +	struct xfs_da_args	*args)
> > > > +{
> > > > +	int			error, done;
> > > > +
> > > > +	/*
> > > > +	 * Unmap value blocks for this attr.
> > > > +	 */
> > > > +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> > > > +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	error = xfs_defer_finish(&args->trans);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	if (!done)
> > > > +		return -EAGAIN;
> > > > +
> > > > +	return error;
> > > > +}
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > > index 3616e88..9eee615 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > > @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > >   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > > >   		xfs_buf_flags_t incore_flags);
> > > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > > > +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > > -- 
> > > > 2.7.4
> > > > 
