Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FB4C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BEA720706
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NSxifaB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfKVPiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:38:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48330 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVPiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 10:38:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMFTJOi175271;
        Fri, 22 Nov 2019 15:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=nkEWNlgdMACSWA46AmgCdKLu2/5XmogYQEyDhR6pKDo=;
 b=NSxifaB1Tx0KRLJyqOzsWP3rWgz0ECtFWnmiYBeJiF/EMR/+QpLkSOm3kg1aQmdW4YRk
 eGXO7mtLdlh0gA7BIFrNIpfu49D5s5GwVFfIYukPwBAO12uespVkDOLakPhQiZtmRSqN
 6xLxRcnGR270ZnAcT2ufUsQOQJiUhnqcSjygh/8cr1jiH706gMkglVt21b1gNytJ94eQ
 Wv0kMmKZFIIXoTaR3WCIvRLkEq1KztHPsCkf7bsrNbO/vBMEAf1gCRxjTXwMOU6zMQ0G
 d8xviXfTJtV2wvr8NwdQWkaeKX3la/K1XRw70qzXNC82gSXbxQIpnckUdwyswmq7WiM9 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hubc4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 15:38:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMFT5Qn148023;
        Fri, 22 Nov 2019 15:38:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2we8yg1y8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 15:38:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMFcBvN026504;
        Fri, 22 Nov 2019 15:38:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 07:38:11 -0800
Date:   Fri, 22 Nov 2019 07:38:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191122153807.GD6219@magnolia>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-2-preichl@redhat.com>
 <20191121231838.GH4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121231838.GH4614@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 10:18:38AM +1100, Dave Chinner wrote:
> On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> 
> This is mixing an explanation about why the change is being made
> and what was considered when making decisions about the change.
> 
> e.g. my first questions on looking at the patch were:
> 
> 	- why do we need to break up the discards into 2GB chunks?
> 	- why 2GB?

Yeah, I'm wondering that too.

> 	- why not use libblkid to query the maximum discard size
> 	  and use that as the step size instead?

FWIW my SATA SSDs the discard-max is 2G whereas on the NVME it's 2T.  I
guess firmwares have gotten 1000x better in the past few years, possibly
because of the hundred or so 10x programmers that they've all been hiring.

> 	- is there any performance impact from breaking up large
> 	  discards that might be optimised by the kernel into many
> 	  overlapping async operations into small, synchronous
> 	  discards?

Also:
What is the end goal that you have in mind?  Is the progress reporting
the ultimate goal?  Or is it to break up the BLKDISCARD calls so that
someone can ^C a mkfs operation and not have it just sit there
continuing to run?

--D

> i.e. the reviewer can read what the patch does, but that deosn't
> explain why the patch does this. Hence it's a good idea to explain
> the problem being solved or the feature requirements that have lead
> to the changes in the patch....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
