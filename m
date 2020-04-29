Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B002C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 23:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626E4206D9
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 23:09:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gyHAeOd+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgD2XJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 19:09:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgD2XJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 19:09:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TN3LAO012313
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AeD5MobCzC3H3hqrSKJG+vSgzn0jOoOuAgHTgX4nssU=;
 b=gyHAeOd+AmBDcGDys/OvUOxzvDQMDqOzE5kwNhYKwF6/J3+wZ5AJiUE4uWZ+Qbq2snnX
 B7eI8JMwkuhOar9FGfzYb5RMBe8SZjdWGqLK9f+emZnxCNHfCqhFt//DLqLeQd0fcHEN
 Xlb/2J1oBEW7kDkKYT+12y4sdPuARrtHN65oVdZsdHmNxYm5WZNRFgoxfYHjcA6imzm6
 dfpIWbcnwobcHOW6ih3qTsOIw/khlEHYQIUxImK4Vj902uTSnBNZaHdxBCQR9zjPSjFm
 Vq/by5b7u7aHlyRDqgPHfpi2wNTbdblyeRGBTr8ftrFZTgluB3hKuwk7s1brbjFK+xns dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0dxb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:09:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TN7Kfs035005
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:09:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30my0jfnmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:09:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TN9Bs7004316
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:09:11 GMT
Received: from localhost (/10.159.128.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 16:09:11 -0700
Date:   Wed, 29 Apr 2020 16:09:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 10/20] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200429230909.GW6742@magnolia>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-11-allison.henderson@oracle.com>
 <20200429230540.GV6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429230540.GV6742@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 04:05:40PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 03, 2020 at 03:12:19PM -0700, Allison Collins wrote:
> > This function is similar to xfs_attr_rmtval_remove, but adapted to
> > return EAGAIN for new transactions. We will use this later when we
> > introduce delayed attributes.  This function will eventually replace
> > xfs_attr_rmtval_remove
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
> Seems reasonable, but oh my the transaction roll hoisting is complex...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Err... whooops.  I meant to send this for patch 13.  Maybe I should just
wait for v9 to appear on the list...

--D

> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
> >  2 files changed, 26 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > index 4d51969..fd4be9d 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > @@ -711,3 +711,28 @@ xfs_attr_rmtval_remove(
> >  	}
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Remove the value associated with an attribute by deleting the out-of-line
> > + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > + * transaction and recall the function
> > + */
> > +int
> > +__xfs_attr_rmtval_remove(
> > +	struct xfs_da_args	*args)
> > +{
> > +	int	error, done;
> > +
> > +	/*
> > +	 * Unmap value blocks for this attr.
> > +	 */
> > +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> > +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> > +	if (error)
> > +		return error;
> > +
> > +	if (!done)
> > +		return -EAGAIN;
> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > index eff5f95..ee3337b 100644
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
