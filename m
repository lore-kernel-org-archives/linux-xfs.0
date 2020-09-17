Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC76EC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 15:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BFC22210
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 15:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0n/UwNZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIQP7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:59:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgIQP7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 11:59:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFj8oo113659;
        Thu, 17 Sep 2020 15:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hwUrswj24HzngvcxHTdgEdyfpRjx7dESa+0TQhuf1d8=;
 b=K0n/UwNZSOkMZWd+XntdKgFSjrwlbJ2w14KSsatsPLzfxW3d+TJPKIKbs72fu02XxN66
 fOYhpOfdzSjyUYGNHKkNXni4usXoFE2RARMzAuAHAwrFzL9hRc3bst3DbfrToK8Yy47t
 IQyFUHIdrfYK6yZXbaee1vVgAqwFaYiER8L99H9dA1vMEUYJ8Y4Ii1ZJecGeVv1/qRLa
 A8xnCENRmuFJTg6r7NwOLiIFgAfxxKdBCR4ZxcBvFPX6Mg5HWskbdLu0ntEQ6lgvywJX
 HyrerQyq/Ht6lmiBCM68AuokQwSJI7cpQ5+MmRIhmRj5L+nbpLH96Ddvyd00zAek2YkH ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9mj5xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 15:57:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFkL2I067178;
        Thu, 17 Sep 2020 15:57:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33khpn99vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 15:57:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HFvmFr016280;
        Thu, 17 Sep 2020 15:57:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 15:57:48 +0000
Date:   Thu, 17 Sep 2020 08:57:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs/031: make sure we don't set rtinherit=1 on mkfs
Message-ID: <20200917155747.GZ7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013420779.2923511.9462939883966946313.stgit@magnolia>
 <20200917075351.GE26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917075351.GE26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:53:51AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 06:43:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > mkfs.xfs does not support setting rtinherit on the root directory /and/
> > pre-populating the filesystem with protofiles, so don't run this test if
> > rtinherit is in the mkfs options.
> 
> That is a bit of a weird limitation.  Any reason we can't fix this in
> mkfs instead?

Userspace doesn't implement the rt allocator at all, and the last few
times I've tried to do any serious surgery in the protofile code, Dave
grumbled that we should just kill it off instead.

Do people actually /use/ protofile support?  Do they like it?  Or would
they rather have an option like mke2fs -D, where you point it at a
directory and it uses ftw to copy-in all the files in that directory
tree, attributes and all?

(I guess I could propose deprecating it and see who pops out. :P)

--D
