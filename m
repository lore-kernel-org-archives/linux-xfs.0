Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040FBC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 19:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BF9204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 19:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0Ka/v5wz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbgHQTQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 15:16:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730650AbgHQPji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 11:39:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HFX69g186379;
        Mon, 17 Aug 2020 15:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Lx2Gwqz4FEMqluGhMSRDIm0QVCxH/Whg91v7yMKWPTA=;
 b=0Ka/v5wz2S6C6MgwjTIJBwwsPUlYeUwccBDUUqbzXB+blKpUzGiOG0ZVpXeMLAKyVMup
 eBBsxo1nN9twUOtEJf0+R7hTSNumkPWR/754cXh92iXs+lAoiN2sTzsNjVJcIqcjhK5o
 fbAeGEU2WPzbqOI9jYI5M6eC/OXgAJRKA1Zo1Q4f4PpKwzeBgSY1CXhufc2zJarsDQT2
 R4tQX3k3fglALioN2Bj2cJIEiqjtq41EGPpzdOKBDQKTLtNbOS81YIWNY63JXuCb41YC
 8UfmDieRNmzICsHnIfUseow9RvLRT3MPbd7NrUCr3H2JKFUPzbkaXQQR2K4wwJ2/IFjc +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bmyg20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 15:39:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HFYJqJ021685;
        Mon, 17 Aug 2020 15:39:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfqpnvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 15:39:30 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HFdNdc030620;
        Mon, 17 Aug 2020 15:39:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 08:39:23 -0700
Date:   Mon, 17 Aug 2020 08:39:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Get rid of kmem_realloc()
Message-ID: <20200817153922.GJ6096@magnolia>
References: <20200813142640.47923-1-cmaiolino@redhat.com>
 <20200817065533.GG23516@infradead.org>
 <20200817101716.mmcgbdpkimc6wvl7@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817101716.mmcgbdpkimc6wvl7@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=929
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=930 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 12:17:16PM +0200, Carlos Maiolino wrote:
> On Mon, Aug 17, 2020 at 07:55:33AM +0100, Christoph Hellwig wrote:
> > Both patches looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > although personally I would have simply sent them as a single patch.
> 
> Thanks Christoph. I have no preference, I just submitted the patches according
> to what I was doing, 'remove users, nothing broke? Remove functions', but I
> particularly have no preference, Darrick, if the patches need to be merged just
> give me a heads up.

Yes, the two patches are simple enough that they ought to be merged.

--D

> Cheers.
> 
> > 
> 
> -- 
> Carlos
> 
