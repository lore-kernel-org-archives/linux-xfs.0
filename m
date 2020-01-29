Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3338C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 16:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E5520716
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 16:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PaYJ5QNV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgA2QCv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 11:02:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgA2QCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 11:02:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TFsLUm005659;
        Wed, 29 Jan 2020 16:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dhkozl5pQKQXmHfM32v8Mb/y9BXyyEyM2a89Ktu+Ouo=;
 b=PaYJ5QNVVCRwQdP3/BXKhenDi221t+THNYC+KxbAUUubwhcpP2+sePy+7ZLw+SnFsaXH
 hKV1yYtFnys8a+4bAu/NYv5+VHc+cVDPZmmsLVRUR1qY8p4gRrREHa9f5LO+iEtzVvpD
 U6ZcOgQ7toYTwH4rai5UGBY25J8xUp1892I/WS7B2wobN6jYwFaycS9rpGq0cMfsaxEe
 Yf7kOIrUhmt25qeNzPQKObs9bIV2AS6wmYR65C2R1vhvLyfTXRo6iG0F+ABFJ83QCVl+
 44L+yCyqvHhCx8NxNYhHR/i5Zbkpc7yTMlSqRVIqOfvwdqsQF8mVFDRDtiOk1D4t7pG6 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xreare9n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 16:02:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TFsTfu096917;
        Wed, 29 Jan 2020 16:02:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xtmra0x04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 16:02:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00TG2hAd019847;
        Wed, 29 Jan 2020 16:02:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jan 2020 08:02:43 -0800
Date:   Wed, 29 Jan 2020 08:02:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: stop generating platform_defs.h V2
Message-ID: <20200129160242.GT3447196@magnolia>
References: <20200129064923.43088-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129064923.43088-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=664
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=724 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 07:49:18AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series gets rid of the need to generate platform_defs.h from
> autoconf.  Let me know what you think.
> 
> Changes since v1:
>  - check for bytes, not bits

Gonna be lazy and:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

for the series rather than indivdually tagging each patch.

--D

