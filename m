Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A44C2BA83
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 17:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A86206ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 17:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cbQ3qHzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgBMRMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 12:12:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53290 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgBMRME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 12:12:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DH9ZQj140885;
        Thu, 13 Feb 2020 17:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8KGS4q7VV149p7y9JS2MT05PE/wqL9CgygSD2XZ70tQ=;
 b=cbQ3qHzCQAAoirI0F9aWBVK8G0RkorNzS4gSuNIzSk1+ySbH4DN5xruMws6qkTrblSu2
 QYroMzO4pUCgl2AZsFhngPsW1tXt++i0fgqd79XE7gvjWxzF7mitCMmfNPNUbCF9jVxz
 QMQNT5wWXThTHJyqNWs0eqGSE9nT0H7fCB1RuvlnIDwaGZja/sNpWFrmzh1UmYA5wNbI
 mX2GF3qLlk0PLs7hDNKGK0QtWBQIiS9isLAbP8xyWEhqGFib6O3siiOUVrqKEKUSwWtv
 Z+4wV+8oijDxBuMKrSAXCHQn3BzkrJSwzLUgCvutaX3FKqGRrBd9KU3lDp8Edcdoqrok qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y2jx6m5qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 17:11:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DH7RgC065577;
        Thu, 13 Feb 2020 17:11:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y4k379uuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 17:11:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01DHBogd032238;
        Thu, 13 Feb 2020 17:11:50 GMT
Received: from localhost (/10.159.225.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Feb 2020 09:11:48 -0800
Date:   Thu, 13 Feb 2020 09:11:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     Dave Chinner <david@fromorbit.com>, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, renxudong1@huawei.com,
        "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Questions about XFS abnormal img mount test
Message-ID: <20200213171146.GD6870@magnolia>
References: <ea7db6e3-8a3a-a66d-710c-4854c4e5126c@huawei.com>
 <20200211011538.GC10776@dread.disaster.area>
 <852729bc-729a-3ec5-bd85-f2b445ab07e3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <852729bc-729a-3ec5-bd85-f2b445ab07e3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 04:33:38PM +0800, zhengbin (A) wrote:
> 
> On 2020/2/11 9:15, Dave Chinner wrote:
> > On Mon, Feb 10, 2020 at 11:02:08AM +0800, zhengbin (A) wrote:
> >> ### question
> >> We recently used fuzz(hydra) to test 4.19 stable XFS and automatically generate tmp.img (XFS v5 format, but some metadata is wrong)
> > So you create impossible situations in the on-disk format, then
> > recalculate the CRC to make appear valid to the filesystem?
> >
> >> Test as follows:
> >> mount tmp.img tmpdir
> >> cp file tmpdir
> >> sync  --> stuck
> >>
> >> ### cause analysis
> >> This is because tmp.img (only 1 AG) has some problems. Using xfs_repair detect information as follows:
> > Please use at least 2 AGs for your fuzzer images. There's no point
> > in testing single AG filesystems because:
> > 	a) they are not supported
> Maybe we can add a check in mount? If there is only 1 AG, refuse to mount?

No, that will break existing users.  Single AG filesystems exist in a
weird gray area where they're not supported but they're not explicitly
prohibited either.

--D

> > 	b) there is no redundant information in the filesysetm to
> > 	   be able to detect a vast range of potential corruptions.
> >
> >> agf_freeblks 0, counted 3224 in ag 0
> >> agf_longest 536874136, counted 3224 in ag 0 
> >> sb_fdblocks 613, counted 3228
> > So the AGF verifier is missing these checks:
> >
> > a) agf_longest < agf_freeblks
> > b) agf_freeblks < sb_dblocks / sb_agcount
> > c) agf_freeblks < sb_fdblocks
> 
> b is not ok,
> 
> ie: disk is 10G, mkfs.xfs -d agsize=3G, so there will be 4 AG, while the last AG is 1G.
> 
> sb_dblocks is 10G, while the first AG's  agf_freeblks is 3G > 10G/4=2.5G
> 
> >
> > and probably some other things as well. Can you please add these
> > checks to xfs_agf_verify() (and any other obvious bounds tests that
> > are missing) and submit the patch for inclusion?
> I will send a patch
> > Cheers,
> >
> > Dave.
> 
