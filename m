Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C061FC33CB3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986D224671
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LuNXNDCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgAOQVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:21:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOQVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 11:21:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FG3MVh171324;
        Wed, 15 Jan 2020 16:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=L9krt3OnZbLw/Qn92cS3R/uyp35gwKBo/4V2E49xxJA=;
 b=LuNXNDCrgQlGsXyROwBg8D8XcpTTRsOZp8rVpVcS7LAvJNXoU8emCsSzt8fe/5/LULEf
 riPC67cJS2Oujg4VLAFK+v66R0DRGx5dQfb3JvIxxj0yajKWkLs8pnvP7GNp98Y18oEt
 HKLE+KTBEmCwgSFRATWnRmKMUcC3McT2UMiAe3g6OvZ3/B78I0CRoLaYhWNbSp49StBt
 K+s2J9Oc4pajtpUsD8QAIPFRN5ppU0qicTkdrK5B/AqfED4JwPijD9vdVVTF4MT17alS
 0144jNyIXDKenem+V7RQ+TfpbCCx1Ip8l62vnfXu/gTQk8kBzB8c+LNewRAU0y4JIyVE Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yn4nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:21:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FG3fGF057179;
        Wed, 15 Jan 2020 16:21:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xj1apnrqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:21:33 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FGLRQ9030627;
        Wed, 15 Jan 2020 16:21:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 08:21:27 -0800
Date:   Wed, 15 Jan 2020 08:21:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Tulak <jtulak@redhat.com>, Baihua Lu <lubaihua0331@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: xfs/191 failures?
Message-ID: <20200115162126.GY8247@magnolia>
References: <20200115150802.GA425@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115150802.GA425@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=851
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=903 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 07:08:02AM -0800, Christoph Hellwig wrote:
> Hi Jan and Baihua,
> 
> the xfs/191 test case has been failing for me basically since it
> was added.  Does it succeed for anyone with an upstream kernel
> and xfsprogs?

It never succeeds here.

--D

> Here is my diff between the golden and the actual
> output:

> --- /root/xfstests/tests/xfs/191-input-validation.out	2016-09-21 20:34:14.961574921 +0000
> +++ /root/xfstests/results//xfs/191-input-validation.out.bad	2020-01-15 15:05:25.580935340 +0000
> @@ -1,2 +1,13 @@
>  QA output created by 191-input-validation
>  silence is golden
> +pass -n size=2b /dev/vdc
> +pass -d agsize=8192b /dev/vdc
> +pass -d agsize=65536s /dev/vdc
> +pass -d su=0,sw=64 /dev/vdc
> +pass -d su=4096s,sw=64 /dev/vdc
> +pass -d su=4096b,sw=64 /dev/vdc
> +pass -l su=10b /dev/vdc
> +fail -n log=15 /dev/vdc
> +fail -r rtdev=/mnt/test/191-input-validation.img /dev/vdc
> +fail -r size=65536,rtdev=/mnt/test/191-input-validation.img /dev/vdc
> +fail -i log=10 /dev/vdc
