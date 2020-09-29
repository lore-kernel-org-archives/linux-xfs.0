Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35ADC4741F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 15:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B412145D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 15:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N/m1grai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgI2PgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:36:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgI2PgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 11:36:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TFT3Nd166389;
        Tue, 29 Sep 2020 15:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2U+rXkOKZKx4DNnghuybVR3BZMvSGGUkQq0ATSmZNWU=;
 b=N/m1graijkd2i63+zOL9rG/mHTsAzR49gre5sc9g2TE2bhCrFSN8NWr8oH/cz1QIQW2N
 vUdILVYUMUeUgsOsQjHu0wNtmgWLLHAlC4+1tgYhcUZCchIanXswMSWbZrldYrpRGJ6x
 xeaKvVqHijWezf0fXx7YXpRmvMEIAyqsozg/G0e6X/QJif7U57B77HckxoluJmMvebib
 S6QVdWtdYBDYdpD+vnmNLyBo2Yj6wsOGmVPqqe/OJwuXpd2Z11qFh5bwEPXoAnjmdJQw
 xd+8eiKN4RUxa1TVBSAraMw9kY1Pp0qacVyYTUqDpvY+t0tOxq4d29YcdASLJ53gvJpN mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9n3kbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 15:36:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TFUrAi176778;
        Tue, 29 Sep 2020 15:34:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33uv2e2kdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 15:34:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08TFYE0Q009247;
        Tue, 29 Sep 2020 15:34:15 GMT
Received: from localhost (/10.159.140.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 08:34:14 -0700
Date:   Tue, 29 Sep 2020 08:34:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: throw away totally bad clusters
Message-ID: <20200929153414.GG49547@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950115513.567790.16525509399719506379.stgit@magnolia>
 <20200908151526.GA15797@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908151526.GA15797@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=5 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 04:15:26PM +0100, Christoph Hellwig wrote:
> On Mon, Sep 07, 2020 at 10:52:35AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the filesystem supports sparse inodes, we detect that an entire
> > cluster buffer has no detectable inodes at all, and we can easily mark
> > that part of the inode chunk sparse, just drop the cluster buffer and
> > forget about it.  This makes repair less likely to go to great lengths
> > to try to save something that's totally unsalvageable.
> > 
> > This manifested in recs[2].free=zeroes in xfs/364, wherein the root
> > directory claimed to own block X and the inobt also claimed that X was
> > inodes; repair tried to create rmaps for both owners, and then the whole
> > mess blew up because the rmap code aborts on those kinds of anomalies.
> 
> How is the rmap.c chunk related to this?  The dino_chunks.c part looks
> fine, and the rmap.c at least not bad, but I don't understand how it
> fits here.

I think that's a stray paste error; the chunk can be dropped.

--D
