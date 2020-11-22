Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8CDC5519F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 20:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D800520760
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 20:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o75oJunv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgKVUQ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 15:16:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37446 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgKVUQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 15:16:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMKFstb024090
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 20:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=41A7SOvptP5711FwJ4VVgJ67NHmRemT+4KfgdpuAHzs=;
 b=o75oJunvh0GyHHOfGZjimAylLR6gheliR2LQJyvFzg5QZY10JV/rFKMayQJ9/l5Yeoq9
 GDjAsm7/lQCRbLts5N4ol4oDcjPw5RIsRLB1V5GzQfN6EtD8AknkRAIePiHy+mc8lTjJ
 aNTcJRPYkryRRRa7rLDR22vIw0K9DLtYLQ86NJ0Ghe9vTKUp2hL+nmyi/3DrIrqgExco
 dVvGqWlgqFW3DidpTuY7oQaGXIUhPzX5Wc4dAxYBS65yOYRLssM8haPvQiuZ08JflGqH
 X+bmeeNV5vPP02LJpAcBhE94A95C4nczMciKSpevp9m5P+0z4URWwuOqlspA/scpnwL1 Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdajwvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 20:16:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMK9ii8174624
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 20:14:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ycnpv6at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 20:14:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AMKEQmC006875
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 20:14:26 GMT
Received: from loom (/81.187.191.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Nov 2020 12:14:25 -0800
From:   Nick Alcock <nick.alcock@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: XFS: corruption detected in 5.9.10, upgrading from 5.9.6: (partial) panic log
References: <87lfetme3f.fsf@esperi.org.uk> <20201122193711.GA7880@magnolia>
Emacs:  don't cry -- it won't help.
Date:   Sun, 22 Nov 2020 20:14:24 +0000
In-Reply-To: <20201122193711.GA7880@magnolia> (Darrick J. Wong's message of
        "Sun, 22 Nov 2020 11:37:11 -0800")
Message-ID: <87ft51m9nj.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=744 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=755 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011220148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22 Nov 2020, Darrick J. Wong stated:

> On Sun, Nov 22, 2020 at 06:38:28PM +0000, Nick Alcock wrote:
>> So I just tried to reboot my x86 server box from 5.9.6 to 5.9.10 and my
>
> Sorry about that, there was a bad patch in -rc4 that got sucked into
> 5.9.9 because it had a fixes tag.  The revert is already upstream:
>
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?id=eb8409071a1d47e3593cfe077107ac46853182ab

Thanks! Will give it a try soon :)

(Solved in a couple of hours on a Sunday and all I had to do was mail
off a photo. As I always say about free software, especially while
feeling guilty about my own response times... you can't pay for service
like this!)

... and no I don't know why I didn't think to check the master branch
for obvious related reversions in fs/xfs. I'll do that next time before
bothering other people.
