Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0337AC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D3A208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iPDfAcxt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIWQbT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:31:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:31:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGTGDT147995;
        Wed, 23 Sep 2020 16:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/XaaXghfAh1B9EB3kp07iAhOlelDDk3F14MLhETe1ig=;
 b=iPDfAcxtSesu+riJjvaXiUoG9di7aauTNoWNZNZ5uh1CGsYe2M1M8xfWOvp9d5pJySEk
 CJlTXJUARyw/tJL+pcUV95NIkGGvK3i2AHXSG0QQXp/wu9uNKsBiLqqhssbaPIGuytW6
 GqJ7MJMsNg1vVZ799t9JruxmgE00Bbt5maZnMrOq1NaAjlyoclZnX5dF+VKxSFP6CmMJ
 ymAuKVbWX6P5uYSQTdCrFP7KUA7vlWV2ctJT6Hpq25Ah9cWFItYngmjdbzot/f6jyfMv
 gSYdIviJRmG/x28ejKl94mNBZvRfblbDLfHS0tsgdRp+/iMrdfz35LmyFqor2/UR4XBO Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33q5rghwmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:30:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGKO69031355;
        Wed, 23 Sep 2020 16:30:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33nujpt41x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:30:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NGU5uv027103;
        Wed, 23 Sep 2020 16:30:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:30:05 -0700
Date:   Wed, 23 Sep 2020 09:30:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RFC PATCH 0/3]xfs: random fixes for disk quota
Message-ID: <20200923163004.GS7955@magnolia>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=3 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:03:59PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Hi all,
> 
> This patchset include random fixes and code cleanups for disk quota.
> In order to make it easier to track, I bundle them up and put all
> the scattered patches into a single patchset.

FWIW I've applied the second patch, so you can drop it from the next
resend.

--D

> Kaixu Xia (3):
>   xfs: directly return if the delta equal to zero
>   xfs: remove the unused parameter id from xfs_qm_dqattach_one
>   xfs: only do dqget or dqhold for the specified dquots
> 
>  fs/xfs/xfs_qm.c          | 24 +++++++++---------------
>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>  2 files changed, 15 insertions(+), 21 deletions(-)
> 
> -- 
> 2.20.0
> 
