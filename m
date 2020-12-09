Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCE7C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C081323C1A
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgLISLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:11:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgLISLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 13:11:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9I5wvl021566;
        Wed, 9 Dec 2020 18:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mYa5ZLdgtQDZhCBzc7PE8uwwprpwmGfi+U3GF0sAlS0=;
 b=oKBAoddWLxuPsk7SPwIikTk29Jdn5Qjsbbu8iIg+TcLkWtcwvRC4z84inrDCPZjOaCbX
 tTCUY3zQ3l6YhKpRJSzqdnGWm8GDQA7WLUiRZ00Cm4yFUP2Oz8/K1aZSHszcCSNQPAsz
 QtrH/ruqXe+Gzg8/F8XTS9rMwELKsshphmBd0Q2NPt6oXlewnPJNU6BNNP0et8lfYUmx
 xZZRwmGy7aJbPvIZlzumTfOYUoFz4Wv8c5NLo7AA/wz5emXoO4sIj8rCZXLkedDHfvho
 hkt7R83I9bIfnfll0vvvaGx3xJm639ZjxFjyZdUrvzwTmvKjuWFOPwtZJ6XEGXlE42Mb Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825m9m7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 18:10:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9IAr3Q065129;
        Wed, 9 Dec 2020 18:10:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksqfffr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 18:10:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9IAvVe014817;
        Wed, 9 Dec 2020 18:10:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 10:10:57 -0800
Date:   Wed, 9 Dec 2020 10:10:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201209181056.GK1943235@magnolia>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
 <20201209180400.GB28047@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209180400.GB28047@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 09, 2020 at 06:04:00PM +0000, Christoph Hellwig wrote:
> Who is going to set this flag?  If the kernel ever sets it that is
> a good way to totally brick systems if it happens on the root file
> system.

So far the only user is xfs_db, when xfs_admin tells it to upgrade a v5
filesystem and we want/need to force the fs through xfs_repair:

https://lore.kernel.org/linux-xfs/160679383892.447856.12907477074923729733.stgit@magnolia/T/#mad4ee9c757051692f33a993a348f4e4e61ac098b
https://lore.kernel.org/linux-xfs/160679383892.447856.12907477074923729733.stgit@magnolia/T/#mb6ef416f9626d87610625e069f516945783a5c13

I don't think there's ever going to be a use case for the kernel setting
the feature flag on a mounted fs -- if some error is fixable we should
just have online repair fix it; or if it's truly catastrophic we don't
want to write the disk at all.

--D
