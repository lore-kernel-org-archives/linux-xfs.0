Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0A5C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF1B20872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xl0x5AiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgIQRp5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:45:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgIQRoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 13:44:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HHf8vx076313;
        Thu, 17 Sep 2020 17:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Nfp6bGWsm7n7xpaGE+VpRYK3Xm6YnVp1/p0AbC9Hq6w=;
 b=xl0x5AiJQlpaoZIROTjXDbhs94pRFkZCEGklS65RZMrYxjCFOWmVojmpMuvP9iAbc32c
 +BSKfYMgKuzfND7lBGzvFTIZpIZZ3ypfmNUbhvxlHM1zxF8Whb5AUz51EMKP2KJGKRb5
 7wtZlAFDwRu/z1+Nq5QBcYoBcrNn6SMIgv1s0ihQdw1Ndx+QrdSfFotU+9jDsHDej2oR
 iMKiKHvn9RBNw8buifjRkyuRyZCII/PMvrEnADoyANeR0XV5cDeapwmiB3SyAOcmgZX3
 fVmsfvLAZeqHW5fO6MMjdTpS0KW8h2UNuYB7up53wYF8/+rwXkLpm2MIJseC8W4f+XPV 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dvf6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 17:44:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HHeE84135781;
        Thu, 17 Sep 2020 17:42:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm358s0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 17:42:07 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HHg6xI010906;
        Thu, 17 Sep 2020 17:42:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 17:42:06 +0000
Date:   Thu, 17 Sep 2020 10:42:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't free rt blocks when we're doing a REMAP
 bunmapi call
Message-ID: <20200917174204.GI7955@magnolia>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331319.3624286.3971628628820322437.stgit@magnolia>
 <20200917081134.GD26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917081134.GD26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:11:34AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:28:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
> > to be unmapped from the given file fork without the extent being freed.
> > We do this for non-rt files, but we forgot to do this for realtime
> > files.  So far this isn't a big deal since nobody makes a bunmapi call
> > to a rt file with the REMAP flag set, but don't leave a logic bomb.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 1b0a01b06a05..e8cd0012a017 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5057,9 +5057,12 @@ xfs_bmap_del_extent_real(
> >  				  &mod);
> >  		ASSERT(mod == 0);
> >  
> > -		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
> > -		if (error)
> > -			goto done;
> > +		if (!(bflags & XFS_BMAPI_REMAP)) {
> > +			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
> > +			if (error)
> > +				goto done;
> > +		}
> > +
> >  		do_fx = 0;
> >  		nblks = len * mp->m_sb.sb_rextsize;
> >  		qfield = XFS_TRANS_DQ_RTBCOUNT;
> 
> We also don't need to calculate bno for this case.

Fixed.

--D
