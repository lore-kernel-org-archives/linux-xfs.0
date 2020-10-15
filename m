Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7967EC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17C6F2080A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X98Ta7E/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389660AbgJOSpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:45:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 14:45:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FITsql166740;
        Thu, 15 Oct 2020 18:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YMNfalhLZwt7IvovaWxqhSQfL2u5fAv3YM9voerrhRk=;
 b=X98Ta7E/iMxWYs6yYsJ3E218YwC8XIK6p/MJz6p3GB9vBkANkZtuGB30+s5zFp0eRu04
 1nzdpV1UPAMaPY0eVTEUXvVvoPKE0hoFmPLRw+TYEDACsFZDJIoJktBvlYxK6ewNXHjO
 rIFm6Sj70d4hX1W2Tcz+mnKg++y92WRrO8yWXZaQN0OFuPS6uHbwRek0K9jd5b8ib+nx
 fuT5XVH4ZXKAw4FaVEJAx4atIGiI0GMUxHpcYwnCFjL5p8qVc58V3Y3Bls1UwLlNzzx3
 gFblL3iFNw5UjYjWUYOuVEvbiTHsC/f9yNexuBx5iabZUVQ+Tzaizsl+zUGxYDjZPvx9 wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaemrks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:45:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FIUewh079997;
        Thu, 15 Oct 2020 18:45:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pw0rqae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 18:45:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FIjkhF009827;
        Thu, 15 Oct 2020 18:45:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 11:45:46 -0700
Date:   Thu, 15 Oct 2020 11:45:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20201015184545.GC9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-9-chandanrlinux@gmail.com>
 <20201015083945.GH5902@infradead.org>
 <1680655.hsWa3aTUJI@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1680655.hsWa3aTUJI@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> On Thursday 15 October 2020 2:09:45 PM IST Christoph Hellwig wrote:
> > This patch demonstrates very well why I think having these magic
> > defines and the comments in a header makes no sense.
> > 
> > > +/*
> > > + * Remapping an extent involves unmapping the existing extent and mapping in the
> > > + * new extent.
> > > + *
> > > + * When unmapping, an extent containing the entire unmap range can be split into
> > > + * two extents,
> > > + * i.e. | Old extent | hole | Old extent |
> > > + * Hence extent count increases by 1.
> > > + *
> > > + * Mapping in the new extent into the destination file can increase the extent
> > > + * count by 1.
> > > + */
> > > +#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> > > +	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> > > +
> > >  /*
> > >   * Fork handling.
> > >   */
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index 4f0198f636ad..c9f9ff68b5bb 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
> > >  			goto out_cancel;
> > >  	}
> > >  
> > > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > > +			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
> > > +	if (error)
> > > +		goto out_cancel;
> > > +
> > 
> > This is a completely mess.
> > 
> > If OTOH xfs_reflink_remap_extent had a local variable for the potential
> > max number of extents, which is incremented near the initialization
> > of smap_real and dmap_written, with a nice comment near to each
> > increment it would make complete sense to the reader.
> >
> 
> How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> worst case value of 2? A write spanning the entirety of an unwritten extent
> does not change the extent count. Similarly, If there are no extents in the
> data fork spanning the file range mapped by an extent in the cow
> fork, moving the extent from cow fork to data fork increases the extent count
> by just 1 and not by the worst case count of 2.

Probably not a huge deal, since at worst we bail out of reflink early
and userspace can just decide to fall back to a pagecache copy or
whatever.  It'd be harder to deal with if this was the cow path where we
long ago returned from write() and even writeback...

...though now that I think about it, what /does/ happens if
_reflink_end_cow trips over this?  I wonder if inodes need to be able to
reserve extent count for later, but ... hgnghghg that seems hard to
reason about.

--D

> 
> 
> -- 
> chandan
> 
> 
> 
