Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D27C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31D72214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPLzz3jR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfKHABi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:01:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKHABi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:01:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7NxCBe130026;
        Fri, 8 Nov 2019 00:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ghNoZfZz1GFRJy2VOCwrdEAlm91YMVN2jekcvtXqPrA=;
 b=UPLzz3jRZUuRw5BxPatXtMnb3NbI1g6mnCenREBqR6YxzMV0TU67F+JqwJ3hwBxkJWhU
 3QgWPrHGz+LM9J5p6ADiUu3l0/7+koZaSoFzJjg3y7xHK1D96tjRpg4FuY6RDW4nIb+R
 gGw3vQ8x4J/51N8J7+GT9qlE4BnuiHWDsPg4qEzKpurdCvSRnOR1HYotk4sypbmnk7o6
 fdYT75syVuZazYzoX5BD1cQ9Owvxn12WMbipuGmZ38D6lHZkLWy1KUtmDBWZEFRpLoYN
 0eTPKDQC9u8hroqDXcPhKffwr8D5ZTspV7AJDOJZmJCEev8ytokGa/ocGqY2ExGKSHUl Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w11r8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:01:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7NxFAa016518;
        Fri, 8 Nov 2019 00:01:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wjhktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:01:25 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA801MXa021738;
        Fri, 8 Nov 2019 00:01:23 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:01:22 -0800
Date:   Thu, 7 Nov 2019 16:01:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191108000117.GN6219@magnolia>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
 <157309572922.45542.2780240623887540291.stgit@magnolia>
 <20191107182542.GC2682@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182542.GC2682@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=453
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070221
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=532 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070221
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 10:25:42AM -0800, Christoph Hellwig wrote:
> >  	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
> > -	if (!bp) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
> > +	if (XFS_IS_CORRUPT(tp->t_mountp, !bp)) {
> >  		return -EFSCORRUPTED;
> >  	}
> 
> We can kill the braces here now.  Same for various other spots later
> down.
> 
> > +	if (XFS_IS_CORRUPT(mp,
> > +			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
> 
> Somewhat strange indentation here.
> 
> >  	ASSERT(map && *map);
> > @@ -2566,14 +2551,16 @@ xfs_dabuf_map(
> >  		nirecs = 1;
> >  	}
> >  
> > -	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
> > -		/* Caller ok with no mapping. */
> > -		if (mappedbno == -2) {
> > -			error = -1;
> > -			goto out;
> > -		}
> > +	covers_blocks = xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb);
> > +
> > +	/* Caller ok with no mapping. */
> > +	if (mappedbno == -2 && !covers_blocks) {
> > +		error = -1;
> > +		goto out;
> > +	}
> >  
> > -		/* Caller expected a mapping, so abort. */
> > +	/* Caller expected a mapping, so abort. */
> > +	if (XFS_IS_CORRUPT(mp, !covers_blocks)) {
> 
> Why the restructure here?
> 
> This could have just become:
> 
> 		if (!XFS_IS_CORRUPT(mp != -2)) {
> 			error = -1;
> 			goto out;
> 		}
> 
> not that I really like the current structure, but that change seems bit
> out of place in these semi-mechanical fixups, and once we touch the
> structure of this function and its callers there is so much more to
> fix..
> 
> > index 7b845c052fb4..e1b9de6c7437 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -87,6 +87,10 @@ struct xfs_ifork {
> >  #define XFS_IFORK_MAXEXT(ip, w) \
> >  	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
> >  
> > +#define XFS_IFORK_MAPS_BLOCKS(ip, w) \
> > +		(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
> > +		 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
> 
> Why the double indentation?  Also maybe XFS_IFORK_FORMAT_MAPS_BLOCKS
> is a better name?  Or maybe even turn it into an inline function with
> a less shouting name?  Also the addition of this helper is probably
> worth being split into a separate patch.

Ugh.  I tried writing this as a static inline function but gcc then
tries to parse the function, which requires struct xfs_inode to be
defined prior to the helper.  That in turn trips over files that include
xfs_inode_fork.h before they include xfs_inode.h, which is exacerbated
by struct xfs_inode requiring struct xfs_ifork which means that it's a
circular dependency mess.

So for now it's a macro because that's probably more efficient than
requiring a function call for a two line predicate, and less confusing
than stuffing it in xfs_inode.h.

Dave suggested xfs_ifork_has_extents as a shorter name.

--D

> > +		    head_block >= tail_block || head_cycle != (tail_cycle + 1)))
> 
> no need for the inner most braces here if you touch the line anyway.
