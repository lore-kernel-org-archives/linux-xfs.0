Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA0CC11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A3A2465D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z341OJv1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgBTP5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:57:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbgBTP5k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:57:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KFmCE7104013;
        Thu, 20 Feb 2020 15:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ysvpCeungGMFKQ6/JejCuk93uBbEynZucLZ26lmoAkQ=;
 b=Z341OJv1bIGmyPh80RqPqDcdiUk0Vg2HkoRr+/BG9A5pvOkljaG5fJxISW8G0UIAPEyg
 O3dtPGEDNGHH03AqJgKeL6+F4P5MDlBMo82IPy0OIbNS55u1kCR5A8FegjIEzkRvFyG6
 LAZPbK199w22aWfXUgnIo0qqnQ0u3n6A4g3sHREEnvnLiCjMiFFHRzTr1RBo3hVNaDh4
 f9YrxHDOWrc4MsDZlyf4p3uLVedjuB9dtYrQuZxPKWY7BGgrvLEMZ86Mz5vEE9ppdQvG
 8zJwaYcePvecmWyBSBO2H+dc9QhIJee3ALM+lp4SJ7GmxuShmlKBp+j9dmBVf7oGhAQP +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud1amrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 15:57:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KFmGKM162483;
        Thu, 20 Feb 2020 15:57:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udd1wjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 15:57:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01KFvW6f026819;
        Thu, 20 Feb 2020 15:57:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 07:57:32 -0800
Date:   Thu, 20 Feb 2020 07:57:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     sds@tycho.nsa.gov, paul@paul-moore.com, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
Message-ID: <20200220155731.GU9506@magnolia>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220153234.152426-1-richard_c_haines@btinternet.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1011 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 03:32:33PM +0000, Richard Haines wrote:
> Added these quota command types for SELinux checks on XFS quotas. I picked
> those I thought useful. The selinux-testsuite will have tests for these
> permission checks on XFS.
> 
> One point to note: XFS does not call dquot_quota_on() to trigger
> security_quota_on(), therefore the 'file quotaon' permission is not tested
> for SELinux

Is that a feature or a bug? :)

(It sounds like a bug to me, but let's see if anyone complains...)

--D

> Richard Haines (1):
>   selinux: Add xfs quota command types
> 
>  security/selinux/hooks.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> -- 
> 2.24.1
> 
