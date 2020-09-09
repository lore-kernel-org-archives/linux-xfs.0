Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111FEC43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 19:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B337D218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 19:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KC5Fc9nn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIITMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 15:12:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIITMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 15:12:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089J4mdw156107;
        Wed, 9 Sep 2020 19:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fbUL8O06mrKB5fJUTc2RMvjDQTEGwJjxWIIvLYhhoJ4=;
 b=KC5Fc9nnQcfv90Sv0aftuiuy4vvvhWGIMAE5WY/3w+MBoIrFi+4lxwCML0Y+HrcJoP6Z
 rp9m/4xMLErh4K3ZcMHxb6n93gmApBNtWf/EoU63I2m2PkEq+c05RuhQsuiLWCLRCbpo
 OulASqeNFzmvfS4zxqa+eIx1+WVYN8HcaUgQiezks/abNkFhDBPiQ14hVVPMliBw16nA
 crCR3aUP0mKSne2d4HqizXvQb8EXsT1bON8ed5QKdD3MrglCAREv+6Z5sm7KKctfLIcp
 Gm0ag/TxPdTkXEMQi+ItNI2dCS6Ay9mQiFzrX9KjCPRhYKcSx034ysTiADBba9xkA6fy 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mm3ruq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 19:12:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089JAOHh178990;
        Wed, 9 Sep 2020 19:12:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33cmkyde6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 19:12:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 089JCG8v025449;
        Wed, 9 Sep 2020 19:12:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 12:12:16 -0700
Date:   Wed, 9 Sep 2020 12:12:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: set required parts of the realtime geometry
 before computing log geometry
Message-ID: <20200909191214.GN7955@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950111530.567664.7302518339658104292.stgit@magnolia>
 <20200908144040.GE6039@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908144040.GE6039@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 03:40:40PM +0100, Christoph Hellwig wrote:
> On Mon, Sep 07, 2020 at 10:51:55AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The minimum log size depends on the transaction reservation sizes, which
> > in turn depend on the realtime device geometry.  Therefore, we need to
> > set up some of the rt geometry before we can compute the real minimum
> > log size.
> > 
> > This fixes a problem where mkfs, given a small data device and a
> > realtime volume, formats a filesystem with a log that is too small to
> > pass the mount time log size checks.
> 
> Do we have a test for that?

Yeah, I'm going to do a huge fstests patchbomb after I come back from
vacation next week.  Sorry I didn't quite get to it in time.

--D

> Othewise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
