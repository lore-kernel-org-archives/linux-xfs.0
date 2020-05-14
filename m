Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0C8C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 21:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9CB2065C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 21:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bKZeJRUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENVTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 17:19:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgENVTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 17:19:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ELGWRA158755;
        Thu, 14 May 2020 21:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=L0t4aT/HwDRbWSHdr21vkMEasB2zrbsIRLknP4A9ZEw=;
 b=bKZeJRUdr5BGBk08jb/Jie3qKCJuVsIQmE34t/Jkg1weRhuvSInKbeJqLVyIsmfKOO8y
 mOWs/YLzwr4hwI/go8jSPnWjAI7G/VGKmYAtw7mJu426RHLbbTWrNGWKfun2hZgrVj+y
 NTvuihw6kBQ1liJf20DgSWTvjTfn7quUXhW87oMzbINHXmozVnq7DPXRZYEEFfiq1+fr
 IzWhAUZy11hew+xpDYc42IoLBmhK6q9bSTMhBjFXd1AcoyF8h28R5t9lU5fmCZgdE+0Y
 HcMqm9R/wRwzwDAPRyGBVfseuhmIsaK6ciSrKikYaXL53st6v0Bh2ILhJ6vjeVSYwLEB ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3100yg56k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 21:18:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ELI6Uc180189;
        Thu, 14 May 2020 21:18:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100yddnfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 21:18:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04ELIvqe013128;
        Thu, 14 May 2020 21:18:57 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 14:18:57 -0700
Date:   Thu, 14 May 2020 14:18:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't allow SWAPEXT if we'd screw up quota
 accounting
Message-ID: <20200514211856.GM1984748@magnolia>
References: <20200514205442.GK6714@magnolia>
 <baec52a0-ca5f-80ac-5fd1-04d9d6f82b8d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baec52a0-ca5f-80ac-5fd1-04d9d6f82b8d@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 04:12:44PM -0500, Eric Sandeen wrote:
> On 5/14/20 3:54 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the old SWAPEXT ioctl doesn't know how to adjust quota ids,
> > bail out of the ids don't match and quotas are enabled.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> makes sense, I probably missed the discussion that presumably arrived
> at "ye gods trying to fix up the quota allocations is nigh impossible?"

No, it's not impossible[1], it's just the one person who replied also
declined to review it, so now I'm racing patches. :P

--D

[1] https://lore.kernel.org/linux-xfs/158864102885.182577.15936710415441871446.stgit@magnolia/

> And in the end, what's yet another -EINVAL return here, anyway? ;)
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  fs/xfs/xfs_bmap_util.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index cc23a3e23e2d..5e7da27c6e98 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1210,6 +1210,12 @@ xfs_swap_extents_check_format(
> >  	struct xfs_inode	*ip,	/* target inode */
> >  	struct xfs_inode	*tip)	/* tmp inode */
> >  {
> > +	/* User/group/project quota ids must match if quotas are enforced. */
> > +	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
> > +	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
> > +	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
> > +	     ip->i_d.di_projid != tip->i_d.di_projid))
> > +		return -EINVAL;
> >  
> >  	/* Should never get a local format */
> >  	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
> > 
