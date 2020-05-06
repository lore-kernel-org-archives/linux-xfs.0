Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C6EC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB373208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eZS5t/fi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgEFQef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 12:34:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37462 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729819AbgEFQee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 12:34:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GXCmv167753;
        Wed, 6 May 2020 16:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5LEwhYF1OKVjvVed8vUFYFGHgpFW0CUIE0ygUrUJRFg=;
 b=eZS5t/fiFMH4FmB3Pq0/4bIFdrzjG4EWiEk7gxvU5hVQLnRZVVM+mMJxswaSttpWuAL9
 uLeh4XlCwwyVm9RiWKFrDLJP8YjG4Nf1K98c29xgZUvinBtrM9KRAR+qkaeZatxVhGc8
 gJrkuPoddDj2c1/ChmuYu0MUsikbOHs41eDHXoJEWfTn5+KTrG+aZzTy6lOPYi/Zwa7N
 zNk1RW1lhn1XwHBHd8jPs/ecYOApFBOzR+AJ/BTW0fpUI0jhyyenR0EtuDpLIELkGYa4
 vjAsh04p6n0nDrNSEDkMbl/eLseScblHGHOrKE6pGSVmBgALzWAZ7+dpZYMTX8ZJBWGu Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq2jdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:34:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GWdRr050554;
        Wed, 6 May 2020 16:34:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30us7n44cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:34:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046GYPp2014582;
        Wed, 6 May 2020 16:34:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 09:34:24 -0700
Date:   Wed, 6 May 2020 09:34:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually account for quota changes in
 xfs_swap_extents
Message-ID: <20200506163424.GT5703@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102885.182577.15936710415441871446.stgit@magnolia>
 <20200506145728.GC7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506145728.GC7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 07:57:28AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:10:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Currently, xfs_swap_extents neither checks for sufficient quota
> > reservation nor does it actually update quota counts when swapping the
> > extent forks.  While the primary known user of extent swapping (xfs_fsr)
> > is careful to ensure that the user/group/project ids of both files
> > match, this is not required by the kernel.  Consequently, unprivileged
> > userspace can cause the quota counts to be incorrect.
> 
> Wouldn't be the right fix to enforce an id match?  I think that is a
> very sensible limitation.

One could do that, but at a cost of breaking any userspace program that
was using XFS_IOC_SWAPEXT and was not aware that the ids had to match
(possibly due to the lack of documentation...)

It was trivial enough to port this from the atomic file update series,
so I decided to post the least functionality-reducing version and see
what happens.

Thoughts?

--D
