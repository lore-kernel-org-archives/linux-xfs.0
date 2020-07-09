Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7E1C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 23:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D286D2070E
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 23:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l98WFi0b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgGIXkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 19:40:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgGIXkC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 19:40:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069NO2B8134149;
        Thu, 9 Jul 2020 23:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=W3eqyVWTO4GwuQLIgW5fM7o3yFEyU/qL5+lgxn/NNg0=;
 b=l98WFi0bD+wnw7HoagPKZnt+JcZrbq/rTmX+xIDvTHW73SW6cTZRoalB8ZWnFkNZojmv
 jtAl5zLOITTLiYk2pIjRtI4rbdjuz7AGnqkNF2MgQ4NETiRLOCUUlkjwZsLPqmbqOaY0
 nflWYVxMOrux3T4PPcOXDmBNAHyxVXrBkTXmfRL/FiPKln3CFpvDjJrAsj3V8IGL4f8Z
 944MOR4uCGLDet6JGoiIv+IBM/82iEBPguE6XwyWCN6Rb49ikkcy8wWGnoClEmZA+mP6
 BmnZAh95ARHyBgka3Dp3EaoLxDEI1DnwUySCrNJapXXqW6gmd2KYmZM/v2oI9kn6KmTD 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 325y0amm0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 23:39:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069NMRWS063274;
        Thu, 9 Jul 2020 23:37:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 325k417p7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 23:37:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069NbsVk018938;
        Thu, 9 Jul 2020 23:37:54 GMT
Received: from localhost (/10.159.229.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 16:37:54 -0700
Date:   Thu, 9 Jul 2020 16:37:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: split dquot flags
Message-ID: <20200709233753.GH7625@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
 <159398718001.425236.11382626384865972595.stgit@magnolia>
 <20200709134609.GD3860@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709134609.GD3860@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 02:46:09PM +0100, Christoph Hellwig wrote:
> On Sun, Jul 05, 2020 at 03:13:00PM -0700, Darrick J. Wong wrote:
> > +	dtype = ddq->d_flags & XFS_DDQFEAT_TYPE_MASK;
> > +	if (type && dtype != type)
> > +		return __this_address;
> > +	if (dtype != XFS_DDQFEAT_USER &&
> > +	    dtype != XFS_DDQFEAT_PROJ &&
> > +	    dtype != XFS_DDQFEAT_GROUP)
> >  		return __this_address;
> 
> Why not use hweight here?
>
> >  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
> > @@ -123,7 +128,7 @@ xfs_dqblk_repair(
> >  
> >  	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> >  	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> > -	dqb->dd_diskdq.d_flags = type;
> > +	dqb->dd_diskdq.d_flags = type & XFS_DDQFEAT_TYPE_MASK;
> 
> And this still mixes up the on-disk and in-memory flags.  I think they
> really need to be separated and kept entirely separate.
> 
> e.g. rename the d_flags field to d_type in both the on-disk and
> in-core inode, rename the values to XFS_DQTYPE_*, and then have a
> separate u8 d_flags just in the in-core inode for just the in-core
> values.

Rrrgh, fine, this is going to cause a lot of hell refactoring the whole
series a fourth time, but here I go...

--D
