Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E0EC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6686B20866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N3gGihd5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHaQoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:44:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgHaQoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:44:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGeIkQ051278;
        Mon, 31 Aug 2020 16:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=csn0q1IdyMGxPQOCq+qX21sXBPC1Nu9ftvLeMStVDaE=;
 b=N3gGihd584Rs0zacGDbYsIwgzU9HBqncerWMRkTte50Jw6Cv3zPhSTk83vHgDwMRfHu3
 Etq4xVPXKNaNJg7e5tdAvEsrPCyTaES1JyGHJd752nAWjo3ZyUlTOm8oU1o9HjYwntTn
 H915JsTyAGj3h8Qj61phDQWuHTnCbrg0MsEOUId7xOqQes8TRsRDbOMw7L9pcqo8oT71
 si1ZZYOpqdGjPDec4gSLqNdqRHY2tShvxzhuTNsDUjajZ7pvksTECY66vWEBaq2VvZLo
 UA7CsuXiVhc8bbrTxm0+h5zOmBAmV6BOLnlUkdidPa4Prtx7I5Yti/pwUWoygBgeBgG2 fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eyky9cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:44:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGevv7183511;
        Mon, 31 Aug 2020 16:44:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380sq90qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:44:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VGiWLK003569;
        Mon, 31 Aug 2020 16:44:32 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:44:32 -0700
Date:   Mon, 31 Aug 2020 09:44:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 01/10] xfs: Add helper for checking per-inode extent
 count overflow
Message-ID: <20200831164435.GO6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-2-chandanrlinux@gmail.com>
 <20200831160823.GG6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831160823.GG6096@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 09:08:23AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:40AM +0530, Chandan Babu R wrote:
> > XFS does not check for possible overflow of per-inode extent counter
> > fields when adding extents to either data or attr fork.
> > 
> > For e.g.
> > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> >    then delete 50% of them in an alternating manner.
> > 
> > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> >    extents to be created in the attr fork of the inode.
> > 
> >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > 
> > 3. The incore inode fork extent counter is a signed 32-bit
> >    quantity. However the on-disk extent counter is an unsigned 16-bit
> >    quantity and hence cannot hold 98511 extents.
> > 
> > 4. The following incorrect value is stored in the attr extent counter,
> >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> >    core.naextents = -32561
> > 
> > This commit adds a new helper function (i.e.
> > xfs_iext_count_may_overflow()) to check for overflow of the per-inode
> > data and xattr extent counters. Future patches will use this function to
> > make sure that an FS operation won't cause the extent counter to
> > overflow.
> > 
> > Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Seems reasonable so far...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 0cf853d42d62..3a084aea8f85 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -23,6 +23,7 @@
> >  #include "xfs_da_btree.h"
> >  #include "xfs_dir2_priv.h"
> >  #include "xfs_attr_leaf.h"
> > +#include "xfs_types.h"
> >  
> >  kmem_zone_t *xfs_ifork_zone;
> >  
> > @@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
> >  
> >  	return 0;
> >  }
> > +
> > +int
> > +xfs_iext_count_may_overflow(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	int			nr_to_add)
> > +{
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	uint64_t		max_exts;
> > +	uint64_t		nr_exts;
> > +
> > +	if (whichfork == XFS_COW_FORK)
> > +		return 0;
> > +
> > +	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> > +
> > +	nr_exts = ifp->if_nextents + nr_to_add;
> > +	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> > +		return -EFBIG;

Something I thought of after the fact -- can you add a new fault
injection point to lower the max extent count?  That way we can
facilitate the construction of fstests cases to check the operation of
the new predicate without having to spend lots of time constructing huge
fragmented files.

(There /are/ test cases somewhere, riiight? ;))

No need to add it here, you can tack it onto the end of the series as a
new patch.

--D

> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index a4953e95c4f3..0beb8e2a00be 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> >  
> >  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> > +int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> > +		int nr_to_add);
> >  
> >  #endif	/* __XFS_INODE_FORK_H__ */
> > -- 
> > 2.28.0
> > 
