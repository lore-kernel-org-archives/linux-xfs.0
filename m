Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569FAC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA03024844
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oYbHlSOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgJ1VfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:35:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35732 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgJ1VfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:35:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SGJEHk045421;
        Wed, 28 Oct 2020 16:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UUXDEozMvn119ez0JVw8YFtu/Rn2KiPlU5o3S6MHI+E=;
 b=oYbHlSOndU6lRxUKQSB9iZsJXorulLCesj0Hev2iyLysb4OGWmMdV5dRukXiZqlU1kmB
 Tnhi7pZudAGQP4MF6b7DPYd4FVtI8cJw/UxzKrSwy1lMoYbP7VUrw/3bXD7F7oayMMhp
 22QMW4MmYAFvYyC6+s1y8ECfADRlHzmxbcKxGbCPMEXx5wqGAkh6cyOE9TXebXeL3mHH
 AXdt3hICX9s1Wg1Lu4m80uUU/c5AR+k88tz4SGP2oL0T/Bg8KIFFHzB/oL2ckoOlDXrO
 0k2y+SLwXwHZl7QILT27ORMQttDKEeNyBBOkm7+SksfPa7wj0PLs3nySmtrfS37rzCwM Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sb0kfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 16:27:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SGKUWX063791;
        Wed, 28 Oct 2020 16:27:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwunsfx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 16:27:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09SGRPXr025819;
        Wed, 28 Oct 2020 16:27:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 09:27:25 -0700
Date:   Wed, 28 Oct 2020 09:27:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 9/9] common/populate: make sure _scratch_xfs_populate
 puts its files on the data device
Message-ID: <20201028162724.GC1061252@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534741.1202316.10109027018039105023.stgit@magnolia>
 <20201028074446.GI2750@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074446.GI2750@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:44:46AM +0000, Christoph Hellwig wrote:
> On Tue, Oct 27, 2020 at 12:02:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that _scratch_xfs_populate always installs its files on the
> > data device even if the test config selects rt by default.
> 
> Can you explain why this is important (preferably also in a comment in
> the source)?

Ok.  I'll change it to this:

	# We cannot directly force the filesystem to create the metadata
	# structures we want; we can only achieve this indirectly by carefully
	# crafting files and a directory tree.  Therefore, we must have exact
	# control over the layout and device selection of all files created.
	# Clear the rtinherit flag on the root directory so that files are
	# always created on the data volume regardless of MKFS_OPTIONS.
	# We can set the realtime flag when needed.
	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT

--D
