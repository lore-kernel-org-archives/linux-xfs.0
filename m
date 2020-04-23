Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF42C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 16:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567CC20704
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 16:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QamyleUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgDWQZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 12:25:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729407AbgDWQZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 12:25:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NGMVAG164757;
        Thu, 23 Apr 2020 16:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Akak30jo9YMEXXT4hTCrySYkhktam6kTf/0xIMhzRik=;
 b=QamyleUieBzVQgIOAWZc8JSFfsP1V+jRbq/yZO573QfDjAKYhrywZmylOfxZto5eGSZK
 sfRNG4t01puuzVy82/InOvQ+jTvx1g9NXTRpSp26KhgMa7X5XA6e+/1NTu5AWPOjeIvx
 gzhafzM8n7JeNXMvrVLn+EQ+y35lqLTdawee9gWDQnrzEs5n+Pya2GXHHCkAjE5cwOkq
 12JsVfHA/EfwkSNi/RrTRb3OEh3PqQUOjMHJHdtFqKY06ptXs8HHmIPgUogvE4BcaxtX
 APnYWX6AUinaEY0jLByJ8uDdxOLr+dqf7pSiPLiJX/g6TNxyb+pVKsvfg3tbV8ZLwoCj Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30jvq4vkhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 16:25:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NGMest035012;
        Thu, 23 Apr 2020 16:23:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30gbbmg5nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 16:23:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NGN8hE031382;
        Thu, 23 Apr 2020 16:23:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 09:23:08 -0700
Date:   Thu, 23 Apr 2020 09:23:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] 64bit timestamps
Message-ID: <20200423162306.GL6742@magnolia>
References: <20200422230307.GH6742@magnolia>
 <CAOQ4uxgeVZ8AYB-a7fXhKgh1GfCSfJL761a=Yot0jp4M56z_KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgeVZ8AYB-a7fXhKgh1GfCSfJL761a=Yot0jp4M56z_KA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 09:23:51AM +0300, Amir Goldstein wrote:
> On Thu, Apr 23, 2020 at 2:03 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Hi all,
> >
> > Here's a thread to talk about the remainder of 64-bit timestamp support
> > on XFS.  I have a series[1] that redefines the inode timestamps to be
> > 64-bit nanosecond counters and decreases the accuracy of the ondisk
> > quota timers to 4s so that both will last until 2446.
> >
> > --D
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime
> 
> This looks great.
> 
> What's the plan w.r.t. enabling bigtime on existing fs?
> In the end, it is just a administrative flag saying "point of no return".
> Everyone do realize that fixing y2038 by requiring to reformat
> existing filesystems is unacceptable for most of the deployments out there,
> right?

Ah, right, I neglected to post a link to the userspace counterpart:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

xfs_admin will be able to flip on the feature flag, after which the
kernel will start upgrading files to use the bigtime format.

--D

> Thanks,
> Amir.
