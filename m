Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B3EC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF073206D5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qxw4heP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgEXRQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 13:16:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43036 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXRQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 13:16:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHBgm5052338;
        Sun, 24 May 2020 17:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=494sAw+prgb2LyGofFtTuE+2UE0j65fTz6aJBnXzF/g=;
 b=qxw4heP40UtrWLdQv5f3hy0s7ifKAgIu8oi6qEgJDpYs11Nhv7+TNALc1KJKhjDO3t8+
 Khn/UALYRl6CBLi2hmQwyeR5nuKVYE+2tVRBVqCHVnqnsLW7e9mD3ES1htCtEXx/JGBs
 cdpPeFwuLmTJuduQXFefBoD//quvDnrJTGlCdbdLQmegbX9cvfkduU9xTShorihyjatD
 DlnsjzLYxo+2bAmYBZrcXw5zwJlcHfdhRlzBPWTlm/Jx3O1hPIt+omSIxG6bKzaGpLeB
 zFK4JgEkMFbtVrvqAHFtCDFG7A8Px8S0XByvb2sEEYh7pJTJubGx2R27WakP1IrKg78Y rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316vfn335q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 24 May 2020 17:16:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHCePU055357;
        Sun, 24 May 2020 17:16:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 317dru61xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 May 2020 17:16:32 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04OHGUet007866;
        Sun, 24 May 2020 17:16:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 May 2020 10:16:30 -0700
Date:   Sun, 24 May 2020 10:16:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200524171629.GH8230@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025258515.493629.3176219395358340970.stgit@magnolia>
 <20200524091446.GA6703@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524091446.GA6703@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=977 adultscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005240143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 02:14:46AM -0700, Christoph Hellwig wrote:
> I really, really hate the pointless use of shits where the
> multiplication makes it obvious what is going on, and still allows
> the compiler to opimize it in whatever way it wants.

<grumble> Fine, I'll change it back....

--D
