Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8887C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4637F21582
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LDOAo4/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbgJOSlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:41:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41148 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 14:41:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FISoOb174091;
        Thu, 15 Oct 2020 18:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FJb9RsrDx1+jbon9dkyoBBqlWk3CeaxMyX6nITP9IFM=;
 b=LDOAo4/LyWblGyFM3ndJGg2bXNimWt/vNpaoAVHCi6u0BGzz8s3aSGPHFnYa+EH84yhV
 gO4lUrWxTKIa3aCPsJA2cKs7Wvmf3wkD0wE4hhTcZf/RZWwgoSF8fbitOis75+EEMHDj
 Sw8jx3GGBNfBELR6Rh9jfvV/FKNqLAOFWWtQTW5WD33aottwhz6LoK7AB1TeJwePoIxB
 /IorUKcz7dW6RocPvDNuM1dnr8NULarhFHhk5qiWpbv0vkmAILd5HWnpMCyQylppF09F
 0QhBtd3rXVmZgbNiRT994yi02Bor/YGBfVYOsXmzX5vAjIWgUEnrS2s2SGIZdLOfDlJl UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 346g8gkjh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:41:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FIVLGX024801;
        Thu, 15 Oct 2020 18:41:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 343pv272vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 18:41:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FIf9gN022469;
        Thu, 15 Oct 2020 18:41:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 11:41:08 -0700
Date:   Thu, 15 Oct 2020 11:41:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 11/11] xfs: Introduce error injection to allocate only
 minlen size extents for files
Message-ID: <20201015184107.GB9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-12-chandanrlinux@gmail.com>
 <20201015084110.GJ5902@infradead.org>
 <3688628.2sUYEX9xRT@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3688628.2sUYEX9xRT@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 03:32:54PM +0530, Chandan Babu R wrote:
> On Thursday 15 October 2020 2:11:10 PM IST Christoph Hellwig wrote:
> > On Mon, Oct 12, 2020 at 02:59:38PM +0530, Chandan Babu R wrote:
> > > This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> > > helps userspace test programs to get xfs_bmap_btalloc() to always
> > > allocate minlen sized extents.
> > > 
> > > This is required for test programs which need a guarantee that minlen
> > > extents allocated for a file do not get merged with their existing
> > > neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> > > Directories, Xattrs and extension of realtime inodes need this since the
> > > file offset at which the extents are being allocated cannot be
> > > explicitly controlled from userspace.
> > > 
> > > One way to use this error tag is to,
> > > 1. Consume all of the free space by sequentially writing to a file.
> > > 2. Punch alternate blocks of the file. This causes CNTBT to contain
> > >    sufficient number of one block sized extent records.
> > > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > > After step 3, xfs_bmap_btalloc() will issue space allocation
> > > requests for minlen sized extents only.
> > > 
> > > ENOSPC error code is returned to userspace when there aren't any "one
> > > block sized" extents left in any of the AGs.
> > 
> > Can we figure out a way to only build the extra code for debug kernels?

Yeah, I was gonna say that too.  You're basically installing a new
allocator algorithm, but wow it scatters pieces of itself all over the
place. :/

--D

> > 
> 
> Ok. I will try to get this implemented.
> 
> -- 
> chandan
> 
> 
> 
