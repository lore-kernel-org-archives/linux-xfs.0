Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B93C4CEC9
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 16:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE09B2171F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 16:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L/hkMD2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfIQQjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 12:39:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfIQQjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Sep 2019 12:39:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HGcxxj187021;
        Tue, 17 Sep 2019 16:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tMpcYxjKpxRAVuSkaRn3UAy6CIrrNIx2H09pahTPpws=;
 b=L/hkMD2xuISGmAW8LcNvWBlXvExe/CzqAc15argPsKCX3V8QdFWK+DokPb95UJzzFO9k
 joSwipnPah5WPF1w1LKs1QHboXFloGzOosiV2+2ZOjUpDSaT0JUP8CiWenVffDJCegIP
 nYuV5xEzVWKHITEsPzz6+fOuvXootf3scdGCPUjGU6PUIVUUN4bh0SYfqKvGmbQJGaR0
 itqimkqmvnBK7Ctfj2ZtdAJVVG9wLjKzInNOoJ1hMiGwFOoW5H/ajugfK4GqkRaL7+N0
 ss2xmCtjB220kQTEw8PhR88XF0Hvglm3sStj7MhqiwDmxSifEWiVQSmG1Z267okAqisG bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v0r5pfrha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 16:39:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HGcsYl143288;
        Tue, 17 Sep 2019 16:39:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v2jjtgwxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 16:39:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8HGdZg7016287;
        Tue, 17 Sep 2019 16:39:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 09:39:34 -0700
Date:   Tue, 17 Sep 2019 09:39:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Xu, Yang" <xuyang2018.jy@cn.fujitsu.com>
Cc:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: question of xfs/148 and xfs/149
Message-ID: <20190917163933.GC736475@magnolia>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=997
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[add linux-xfs to cc]

On Tue, Sep 17, 2019 at 09:00:57AM +0000, Xu, Yang wrote:
> HI All
> 
> When I investigated xfs/030 failure on upstream kernel after mering
> xfstests commit d0e484ac699f ("check: wipe scratch devices between
> tests"), I found two similar cases(xfs/148,xfs/149).
> 
> xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
> xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair
> 
> But I don't find these two commands and know nothing about them.  If
> these commands have been obsoleted long time ago, I think we can
> remove the two cases. Or may I miss something?

<shrug> I think your analysis is correct, but let's see what the xfs
list thinks.

--D

> 
> Thanks
> Yang Xu
> 
> 
