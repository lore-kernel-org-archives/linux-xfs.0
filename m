Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDAEC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6499D21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g6JIXlL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBTBxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:53:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBTBxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:53:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1mK83172143;
        Thu, 20 Feb 2020 01:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=W41LUw2jgqRnCGHjLC4PD7bjpleVx15087/N9QqN0Xs=;
 b=g6JIXlL8+WMpVVFgumdkFU2vLlcd5FFZpBlm6lNGMfB6k/i+nukR6W8MPARTv6O9pwqY
 X7S/6tTnxLPDOr2TY0lzFmTU2OQwBYIJcAziwZ2JQIBDmEZwrnntbQWVxIT3OBP9zBfx
 13dD282Hu4fjCepEaB2GCuL8CUz0KEnVT1Q+955jbq5VBWiOVsWDNM2IwfVzKZQ+OSTC
 1n+F/EQtbRC/NBaEgC8ESEOoWizZJnEOcqBp+3v7ouak+aRMakgXyf5jyal4ycjHkIw/
 9fj+EfB9FcMTehnl81Oq0VkQX1ESzWb+wQ7j6hZjRgFoX+Id1XxaDSNIT80Hlo+JlZKs 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y8ud16t78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:53:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1lmTp156366;
        Thu, 20 Feb 2020 01:53:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y8ud4qb6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:53:20 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1rId5000985;
        Thu, 20 Feb 2020 01:53:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:53:18 -0800
Date:   Wed, 19 Feb 2020 17:53:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/14] xfsprogs: make buffer functions return error codes
Message-ID: <20200220015317.GQ9506@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:29PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Let's fix all the xfs read/get buffer functions to return the usual
> integer error codes and pass the buffer pointer as a out-argument.  This
> makes it so that we can return useful error output instead of making
> callers infer ENOMEM or EAGAIN or whatever other reality they crave from
> the NULL pointer that they get when things don't go perfectly.
> 
> FWIW, all XBF_TRYLOCK callers must now trigger retries if they receive
> EAGAIN.  This may lead to a slight behavioral change in that TRYLOCK
> callers will no longer retry for things like ENOMEM, though I didn't see
> any obvious changes in user-visible behavior when running fstests.
> 
> After finishing the error code conversion, we straighten out the TRYLOCK
> callers to remove all this null pointer checks in favor of explicit
> EAGAIN checks; and then we change the buffer IO/corruption error
> reporting so that we report whoever called the buffer code even when
> reading a buffer in transaction context.
> 
> The userspace port of the kernel patchset was very difficult, so I am
> submitting this series to avoid dumping the work on Eric.

I should've noted that the "xfsprogs: refactor buffer function names"
series applies against 5.5; this series is a backport of the second half
of the kernel 5.6 merge.  I didn't send that part because I didn't feel
that it was significant enough to increase the patchbomb spew.

SO... the order is:

1. "refactor buffer function names", which is the thread before this one
2. "sync with 5.6", available at [1]
3. "make buffer functions return error codes", which is this one

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tag/?h=libxfs-5.6-sync_2020-02-19

> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=buf-return-errorcodes
