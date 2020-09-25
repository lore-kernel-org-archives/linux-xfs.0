Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F299C4727D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 15:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31CA021D91
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 15:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BRLMeKww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgIYP4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 11:56:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38838 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgIYP4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 11:56:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PFdbxr161059;
        Fri, 25 Sep 2020 15:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lkECeSgZm6eI7SYLe0uaVYHv697IxM74ow8OfuQw6SA=;
 b=BRLMeKwwvL+ssv7eM2gBc9OdP5osEyCfJDA5D76kBcrojObhxSakHkw/+PmClvgacCdM
 dEpA8MIyHsh1xaNBnE095JlWcrJtCDNdObZhLyItmUyGqZ+1Lh7vgPGgSS9iYhpdbl1m
 olH9umiQK4WCVIjVuDq6fR5iMcziDd0y11DW33H8fmrOoh2y+SBRfOp13CUkk5NjPwYw
 S91VqkT4+Aib9EY2gGo5Ed0G8n15Vxz6eBSGvqj8xoE4noseO2fzSHb/40932mjTghWX
 xxVbUF8QetUHK1qbVlKzcJRSQ4eaQ8jgwZIDA3VSXl92GFNz+VRwIgBPSGmeUGj+Yio7 Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpubd5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 15:56:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PFfWgE093740;
        Fri, 25 Sep 2020 15:54:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nux4n2sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 15:54:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08PFs9AQ015397;
        Fri, 25 Sep 2020 15:54:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 08:54:09 -0700
Date:   Fri, 25 Sep 2020 08:54:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
Message-ID: <20200925155410.GK7955@magnolia>
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com>
 <20200924172600.GG7955@magnolia>
 <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
 <20200924174913.GI7955@magnolia>
 <bebb2448-2b0e-6a39-79b2-18b6fb8811ee@redhat.com>
 <f5dddb95-100d-2497-40d5-8ff1e8ae2617@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5dddb95-100d-2497-40d5-8ff1e8ae2617@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 25, 2020 at 09:50:45AM -0500, Eric Sandeen wrote:
> On 9/25/20 8:40 AM, Pavel Reichl wrote:
> > Thanks for discussion, if I get it right, the only thing to change is to add the date when mount options will me removed (September 2025)?
> 
> Please also add a comment above the moved mount options indicating that
> all options below the comment are slated for deprecation.
> 
> Not sure if Darrick had anything else.  Are we happy w/ the kernel logging?

Yeah, I'm fine with it. :)

--D
