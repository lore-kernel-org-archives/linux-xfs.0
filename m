Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0426C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 04:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A781E206D7
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 04:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IiA3c/fj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKNECl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 23:02:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfKNECk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 23:02:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAE3xAWd165147;
        Thu, 14 Nov 2019 04:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Iw7U+HGuNRgfljDzRmZDsmFdgXcqY3Wy7F4xshoKmVc=;
 b=IiA3c/fjJEWwvCDUpeDgSnbcPgCz+DWKeNrMh/oMIdL3pCT2qUh5fQVMlR2CrUimVnn6
 kJ/07R0IKyPUJ3zyLW34h79LnUW5DxPpHWR5gQl6TEevvaWXrBM+Kiacs6KU8bO+tUyM
 r0Bx/xpVUVeK0KKbdIBVoQk1upvf+Q+ZXHaOZLLEP8OFmsKQdMrSGKBcr0FmIjVCmgD3
 fp3NT6oq5gNc7q0C1P8c7CAWOCE3hcYmKJCKrqpXR4bUst/XR3TgVHIynej2FQMQ2KI/
 v5ByIKE2tAm94AAUOAQPEAv/l4HFoXEJpuR198hF4CAMcfzqUd06MEG5aH0zO0FfgoUE 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvu0myt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 04:02:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAE3sGL2018369;
        Thu, 14 Nov 2019 04:02:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w8v2fy9jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 04:02:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAE42XsY015113;
        Thu, 14 Nov 2019 04:02:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 20:02:33 -0800
Date:   Wed, 13 Nov 2019 20:02:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191114040232.GI6219@magnolia>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-5-preichl@redhat.com>
 <20191114013843.GZ4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114013843.GZ4614@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 12:38:43PM +1100, Dave Chinner wrote:
> On Tue, Nov 12, 2019 at 10:33:09PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c |  5 ++---
> >  fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
> >  fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
> >  fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
> >  4 files changed, 39 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 271cca13565b..da6642488177 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -741,8 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
> >  
> >  /*
> >   * Turning off quotas.
> > - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> > - *    the superblock for the quota flags: sector size
> > + * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
> 
> Still needs the comment about the superblock. i.e. the initial
> quota-off transaction modifies the quota flags in the superblock, so
> it has to reserve space for that as well. Essentially the text of
> the comment is iterating all the items that get modified in the
> transaction and are accounted for in the function.
> 
> Everything else looks fine, though. :)

Well I /was/ about to stage the whole series for reals, so ... I'll just
fix the comments on the way in.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
