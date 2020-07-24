Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C97DC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 19:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC312070B
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 19:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgVPcnfx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGXTWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 15:22:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGXTWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 15:22:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OJ7ZOn128973;
        Fri, 24 Jul 2020 19:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6o4P7f3jEHoOlOwl4rL0uCOl7525o/Pzc78JCfuBlhw=;
 b=KgVPcnfxW/7p4QTxdpBbokHnhJGZ1UZZJBt0C+BYsVK1ZniVyRxORg9xCrZMShe6J2Wz
 Ay1mRmIIq9nEaGryLi/M+FTkZI1RLowSCwaaWnP81zx5jX3k68ySvgjIdJs8G9WvNJZi
 4kKijBZK+4jWm49ISOdH5/l4bdSpc2ymGBRHTkTaFFvd9u2PSAx5BCWc1n78uffdR9iX
 hreOC7NPy2QLiR0oNfzmnyGX92YRgeZcy839KuwjRdn3hJt//9pa1KCXDtSBplokyr/P
 +XS7OM/dD687+Uz1aWw4CDGpAr0p6skG+O+SfsePE2oxcSJF1oJdBHCJ9M4GBcp4xna2 WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32d6kt528n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 19:21:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OJFF8j160508;
        Fri, 24 Jul 2020 19:21:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32g49qbhqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 19:21:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06OJLiQQ002700;
        Fri, 24 Jul 2020 19:21:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 12:21:44 -0700
Date:   Fri, 24 Jul 2020 12:21:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [DEVEL] libxfs update timing for xfsprogs 5.8.0
Message-ID: <20200724192142.GK7625@magnolia>
References: <1088d142-1e80-aaac-62eb-2b01f0fc9c63@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1088d142-1e80-aaac-62eb-2b01f0fc9c63@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 24, 2020 at 12:08:21PM -0700, Eric Sandeen wrote:
> At one point there was a little discussion about whether it might
> be better to defer libxfs/ syncing to later in the release, rather
> than doing it at the beginning.  I'm happy to do it either way.
> 
> Do we have a preference for 5.8.0, would one be better than the other
> for anyone working on major xfsprogs updates?
> 
> (Darrick probably already has his work staged on top of a libxfs
> sync, so there's that ...)

I wouldn't mind if the xfs_repair quotacheck stuff went in before the
libxfs sync... :)

--D

> -Eric
