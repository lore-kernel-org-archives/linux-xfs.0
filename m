Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D5FC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3764E22265
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="np276DQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgIQQDo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:03:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgIQQCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:02:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFibIL039657;
        Thu, 17 Sep 2020 16:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=I6wKPel7fBS64lY7M/0mQsn2yGpmxQdcoPxhmqElwHM=;
 b=np276DQ87XOAxSAXlDSUQQpg+Pa/OCx1W4OYggCy6cmow3OT6rwooOuWXZI6+Okmk8i3
 geKFuSU+wF+3h00I5jlqvO2WJQJy6O+k/p9p7Lq7X04/Nlhuu8mn6p5CnbTp3XMHLG5y
 Dox+Er3pOUQNXNjZmkSsu4mcs2GWQlwbxctmjokaJksjn2Xhn6g1oePro3ik9SGWx689
 uhCmhr7GuC9Xy+ZNzyiEzPKTrXxT+j6ndUjgDvx8afeVkrpkikXgCThNieZa6hij8f6d
 VzPA44L+z4hpWznxpDU2kFecg21ExkjSJEktpkEyqcKsI4mADVrEEMXIeCNmb/53VYDR /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91duvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:02:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFkMZD067345;
        Thu, 17 Sep 2020 16:02:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33khpn9h7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:02:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HG27Mg000923;
        Thu, 17 Sep 2020 16:02:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:02:07 +0000
Date:   Thu, 17 Sep 2020 09:02:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 13/24] generic/204: don't flood stdout with ENOSPC
 messages on an ENOSPC test
Message-ID: <20200917160206.GA7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013425839.2923511.10488499486430760605.stgit@magnolia>
 <20200917075635.GK26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917075635.GK26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:56:35AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 06:44:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > This test has been on and off my bad list for many years due to the fact
> > that it will spew potentially millions of "No space left on device"
> > errors if the file count calculations are wrong.  The calculations
> > should be correct for the XFS data device, but they don't apply to other
> > filesystems.
> > 
> > Therefore, filter out the ENOSPC messages when the files are not going
> > to be created on the xfs data device (e.g. ext4, xfs realtime, etc.)
> 
> Should this move to an xfs specific test instead?

I'm on the fence about that, but probably.  I've though that generic/
can have a test that formats a small fs and fills it with files until it
hits ENOSPC, and this test (with its weird calculations) can move to xfs/.

But I haven't been around long enough to know if there's a specific
reason why we calculate the number of files to create?  Is this test
really a regression test for some long-ago bug?  Or that weird noalloc
dir update mode thing that we ripped out last year?

--D
