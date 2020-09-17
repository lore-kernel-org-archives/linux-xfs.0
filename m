Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D93C2D0E3
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 18:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4118206B2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 18:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jD4KuLTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIQSwi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:52:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIQSwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 14:52:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HG3siJ083484;
        Thu, 17 Sep 2020 16:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5nCHMqCDDuOJbmUFxnoQcyA6VOcDV0ryXaHOMGCU39U=;
 b=jD4KuLTSeziq0wpV+kGocElBigXYurRvBTu3spreIX0WSJm6/OkfbF/7DBA/mNuCfw0G
 qHESz0wSosfO7emU3ofNx2eKphGPqVgJ4u9GYxoX8butDvNzYyaf1rL+kR1wmK0957UU
 FHgqXD1ySj2KTrc5LHq1VB9k1aqP27+/c2AhUg6e1selU5vV/N8jhBf4WrmnFewydDXU
 Kmn2AN1f2mFByfAacG8D5/hdtdD6BurGZ0Kp7rxmLLRPA+DVI6a9XX/Hvm2FO5AhcptJ
 Xjt5JI8T9Zm4FVFRI4S39j+0XhqWznJhqUTBF8tS6i4P9Q9BVRS+b9pNZYezyAEzwpt2 GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrra9u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:05:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFjoYk048601;
        Thu, 17 Sep 2020 16:03:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h88brtrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:03:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HG37D8029274;
        Thu, 17 Sep 2020 16:03:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:03:06 +0000
Date:   Thu, 17 Sep 2020 09:03:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: refactor _xfs_check calls to the scratch
 device
Message-ID: <20200917160304.GB7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013428386.2923511.798805055641192515.stgit@magnolia>
 <20200917075856.GN26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917075856.GN26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:58:56AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 06:44:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use _scratch_xfs_check, not _xfs_check $SCRATCH_DEV.
> 
> This looks ok:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But shouldn't we finally kill off all xfs_check alls instead? :)

I will some day, but I keep finding more bugs and missed stuff in
xfs_repair. :(

--D
