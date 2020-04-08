Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307F4C2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 15:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7A1206F7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 15:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cQ7reSfs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgDHPjO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:39:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgDHPjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 11:39:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038Fd7H1068447;
        Wed, 8 Apr 2020 15:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=N+zPW2frEoFE7ZGidceFwuUhXAs12Yz2O/zB6JdUx1w=;
 b=cQ7reSfsWOMI+QTvcKo9YC9v1JlRE5HKLYUisl0hQBJZpUd88yo1BmSet81yW5eC85ch
 Rl9Ted+L7viyjR5BTM1t8lizppo0mxL4FZZgSOpvXZI83pptllWwZ/uW2iIhqTDa++d+
 AwvsyMBZaTLO6ILU+dAQ4llbBhH/KVrDHfNah6C1jvJLFfZxdTkfVvbr0z6o3TFa3Uie
 zh/XIRR7llnbswQL5tWn6X58PhrSzKNWSGOxNgZT2bwC48Gnbu69KZAccxxcXfpxnG+V
 Ug18GBvM3fe9E2lKGJRuuRwUPs6pJDEgyd3KQqlOn6/VW3nC8b6+zuIILRR/OT2JnQlz MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 309gw4878s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 15:39:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038FbeL2062328;
        Wed, 8 Apr 2020 15:39:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3091m48ef7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 15:39:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038Fd06U027589;
        Wed, 8 Apr 2020 15:39:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 08:39:00 -0700
Date:   Wed, 8 Apr 2020 08:38:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200408153854.GI6742@magnolia>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200406170603.GD6742@magnolia>
 <20200406233002.GD21885@dread.disaster.area>
 <2451772.FeN4kIriKq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2451772.FeN4kIriKq@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=2 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=2 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 06:13:45PM +0530, Chandan Rajendra wrote:
> On Tuesday, April 7, 2020 5:00 AM Dave Chinner wrote: 
> > On Mon, Apr 06, 2020 at 10:06:03AM -0700, Darrick J. Wong wrote:
> > > On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> > > > XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> > > > which
> > > > 1. Creates 1,000,000 255-byte sized xattrs,
> > > > 2. Deletes 50% of these xattrs in an alternating manner,
> > > > 3. Tries to create 400,000 new 255-byte sized xattrs
> > > > causes the following message to be printed on the console,
> > > > 
> > > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > > > 
> > > > This indicates that we overflowed the 16-bits wide xattr extent counter.
> > > > 
> > > > I have been informed that there are instances where a single file has
> > > >  > 100 million hardlinks. With parent pointers being stored in xattr,
> > > > we will overflow the 16-bits wide xattr extent counter when large
> > > > number of hardlinks are created.
> > > > 
> > > > Hence this commit extends xattr extent counter to 32-bits. It also introduces
> > > > an incompat flag to prevent older kernels from mounting newer filesystems with
> > > > 32-bit wide xattr extent counter.
> > > > 
> > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
> > > >  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
> > > >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> > > >  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
> > > >  fs/xfs/libxfs/xfs_types.h      |  4 ++--
> > > >  fs/xfs/scrub/inode.c           |  7 ++++---
> > > >  fs/xfs/xfs_inode_item.c        |  3 ++-
> > > >  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
> > > >  8 files changed, 63 insertions(+), 27 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > > index 045556e78ee2c..0a4266b0d46e1 100644
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> > > >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> > > >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> > > >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > > > +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> > > 
> > > If you're going to introduce an INCOMPAT feature, please also use the
> > > opportunity to convert xattrs to something resembling the dir v3 format,
> > > where we index free space within each block so that we can speed up attr
> > > setting with 100 million attrs.
> > 
> > Not necessary. Chandan has already spent a lot of time investigating
> > that - I suggested doing the investigation probably a year ago when
> > he was looking for stuff to do knowing that this could be a problem
> > parent pointers hit. Long story short - there's no degradation in
> > performance in the dabtree out to tens of millions of records with
> > different fixed size or random sized attributes, nor does various
> > combinations of insert/lookup/remove/replace operations seem to
> > impact the tree performance at scale. IOWs, we hit the 16 bit extent
> > limits of the attribute trees without finding any degradation in
> > performance.
> 
> My benchmarking was limited to working with a maximum of 1,000,000 xattrs. I
> will address the review comments provided on this patchset and then run the
> benchmarks once again ... but this time I will increase the upper limit to 100
> million xattrs (since we will have a 32-bit extent counter). I will post the
> results of the benchmarking (along with the benchmarking programs/scripts) to
> the mailing list before I post the patchset itself.

Ok.  Thanks for doing that work. :)

--D

> -- 
> chandan
> 
> 
> 
