Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B34C34031
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6793B24654
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JRBsArv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBSAvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:51:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSAvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 19:51:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0UuoZ124123;
        Wed, 19 Feb 2020 00:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mYww33MxHPc/o1d3cYpyeWrOae84VBAVZmavG9Tbdw8=;
 b=JRBsArv7ozYURGjwGDtbTmwPclEKjzKP+YUptPUKFpVERsrmXfX54eZ8yg5e9e4AGSEa
 qpwQbBfIDKbbttnvg1H/qjPgBq3P/wXKflb0TG7BkUpOB+9J7LvbS7hlHf+QpN7IpYw+
 356xJ4fpickFrCFXtcSPZsPaC+BkQEaVRu5p9+trSQ7BduxBoRWQhkvwBPw+HF/9p6vG
 +NnOTrZGUMTI/sVT1gGMCIJ8v6ky5C7F+JSdbLBKY0ovOQcLEVt8vL5D/RJ4FQL5rHUq
 2GxrlWH/I60FLZF84Cz7C3rFnCG9mR2x05imPSr6ituAYWxJmjxItOwNR4B5GyVEwJFQ 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y7aq5w0pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:51:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0SdT3152260;
        Wed, 19 Feb 2020 00:49:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y82c2dppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:49:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J0nE9k027360;
        Wed, 19 Feb 2020 00:49:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:49:14 -0800
Date:   Tue, 18 Feb 2020 16:49:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 01/31] xfs: reject invalid flags combinations in
 XFS_IOC_ATTRLIST_BY_HANDLE
Message-ID: <20200219004912.GF9506@magnolia>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-2-hch@lst.de>
 <20200217214832.GF10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217214832.GF10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 08:48:32AM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 01:59:27PM +0100, Christoph Hellwig wrote:
> > While the flags field in the ABI and the on-disk format allows for
> > multiple namespace flags, that is a logically invalid combination and
> > listing multiple namespace flags will return no results as no attr
> > can have both set.  Reject this case early with -EINVAL.
> 
> Had a bit of a hard time deciphering this. Perhaps:
> 
> While the flags field in the ABI and the on-disk format allows for
> multiple namespace flags, an attribute can only exist in a single
> namespace at a time. Hence asking to list attributes that exist
> in multiple namespaces simultaneously is a logically invalid
> request and will return no results. Reject this case early with
> -EINVAL.

I like this description a bit better too.  With that fixed up,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Other than that, the code is good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
