Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687A4CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 17:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22FF32184C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 17:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h6bQGMPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfJVR7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 13:59:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfJVR7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 13:59:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MHxCD8049970;
        Tue, 22 Oct 2019 17:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9bgPX7Wv0GD1q7S2Q/EgSPdCb5RWtO6EfLvETelJE6M=;
 b=h6bQGMPSUrUPBhCmWMvizLI2vHdGnnUCa5OZdRziuQI3vsOzOcTS9vTd3/+w3Y+XXgUT
 sFoJ1xPGabQKFNVM1O6945lfsVXNZcpFpU8dc0BP7q7W9gRq1l+k047wRVZmzfwNWyxw
 GF2IQMmec5is6WiXrJ81wDVwRSaqD2zpTDdXiifzW4vHqWbVe0OAX+WvSovwDs3duKEt
 3Jpa7q8bPXkuypPChrlybZfr7fJeLDHGptQ+MojBgjaMI9G4qxcBmHgNrcM/A1gm1jF4
 W00wmxO7ES3ZtpZjhDVuZTncAdtQIwfkSd4T775QjvvqWDHse24P7Jdm3NRbVbMM2O4J TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qr9sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 17:59:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MHr5nF111133;
        Tue, 22 Oct 2019 17:59:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vt2hdgpxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 17:59:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MHxSHL001500;
        Tue, 22 Oct 2019 17:59:29 GMT
Received: from localhost (/10.159.235.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 10:59:28 -0700
Date:   Tue, 22 Oct 2019 10:59:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: convert xbitmap to interval tree
Message-ID: <20191022175927.GO913374@magnolia>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063977028.2913318.2884583474654943260.stgit@magnolia>
 <20191022133847.GC51627@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022133847.GC51627@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 09:38:47AM -0400, Brian Foster wrote:
> On Wed, Oct 09, 2019 at 09:49:30AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the xbitmap code to use interval trees instead of linked lists.
> > This reduces the amount of coding required to handle the disunion
> > operation and in the future will make it easier to set bits in arbitrary
> > order yet later be able to extract maximally sized extents, which we'll
> > need for rebuilding certain structures.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Looks mostly straightforward provided my lack of knowledge on interval
> trees. A few random comments..
> 
> >  fs/xfs/Kconfig                 |    1 
> >  fs/xfs/scrub/agheader_repair.c |    4 -
> >  fs/xfs/scrub/bitmap.c          |  292 +++++++++++++++++-----------------------
> >  fs/xfs/scrub/bitmap.h          |   13 +-
> >  4 files changed, 135 insertions(+), 175 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> > index 1041f17f6bb6..e1da103bce78 100644
> > --- a/fs/xfs/scrub/bitmap.c
> > +++ b/fs/xfs/scrub/bitmap.c
> > @@ -12,30 +12,105 @@
> >  #include "xfs_btree.h"
> >  #include "scrub/bitmap.h"
> >  
> > -#define for_each_xbitmap_extent(bex, n, bitmap) \
> > -	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
> > +#define for_each_xbitmap_extent(itn, n, bitmap) \
> > +	rbtree_postorder_for_each_entry_safe((itn), (n), \
> > +			&(bitmap)->root.rb_root, rb)
> >  
> 
> I'm not familiar with the interval tree, but the header for this rbtree_
> macro mentions it is unsafe with respect to rbtree_erase(). Is that a
> concern for any of the users that might call interval_tree_remove()? It
> looks like that calls down into rb_erase_augmented(), but it's not clear
> to me if that's a problem..

It's not clear to me either, but the xbitmap iteration functions have
the implicit requirement that you can't edit the xbitmap while walking
it, so I'll add that to the documentation.

Note that none of the callers in my dev tree do that; the agheader
repair code uses disunion to get around that limitation.

As for xbitmap_destroy... yeah, I think that should use a
interval_tree_iter_first loop and not the for_* macro, since a tree
rebalance could upset things.

> > -/*
> > - * Set a range of this bitmap.  Caller must ensure the range is not set.
> > - *
> > - * This is the logical equivalent of bitmap |= mask(start, len).
> > - */
> > +/* Clear a range of this bitmap. */
> > +static void
> > +__xbitmap_clear(
> > +	struct xbitmap			*bitmap,
> > +	uint64_t			start,
> > +	uint64_t			last)
> > +{
> > +	struct interval_tree_node	*itn;
> > +
> > +	while ((itn = interval_tree_iter_first(&bitmap->root, start, last))) {
> > +		if (itn->start < start) {
> > +			/* overlaps with the left side of the clearing range */
> > +			interval_tree_remove(itn, &bitmap->root);
> > +			itn->last = start - 1;
> > +			interval_tree_insert(itn, &bitmap->root);
> > +		} else if (itn->last > last) {
> > +			/* overlaps with the right side of the clearing range */
> > +			interval_tree_remove(itn, &bitmap->root);
> > +			itn->start = last + 1;
> > +			interval_tree_insert(itn, &bitmap->root);
> > +			break;
> > +		} else {
> > +			/* in the middle of the clearing range */
> > +			interval_tree_remove(itn, &bitmap->root);
> > +			kmem_free(itn);
> > +		}
> > +	}
> > +}
> > +
> > +/* Clear a range of this bitmap. */
> > +void
> > +xbitmap_clear(
> > +	struct xbitmap			*bitmap,
> > +	uint64_t			start,
> > +	uint64_t			len)
> > +{
> > +	__xbitmap_clear(bitmap, start, start + len - 1);
> > +}
> 
> It seems unnecessary to split the functions like this just to preserve
> the interface. Could we have the other __xbitmap_clear() caller just
> calculate the len itself and call xbitmap_clear() instead?

Ok.

> > +
> > +/* Set a range of this bitmap. */
> >  int
> >  xbitmap_set(
> > -	struct xbitmap		*bitmap,
> > -	uint64_t		start,
> > -	uint64_t		len)
> > +	struct xbitmap			*bitmap,
> > +	uint64_t			start,
> > +	uint64_t			len)
> >  {
> > -	struct xbitmap_range	*bmr;
> > +	struct interval_tree_node	*left;
> > +	struct interval_tree_node	*right;
> > +	uint64_t			last = start + len - 1;
> >  
> > -	bmr = kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
> > -	if (!bmr)
> > -		return -ENOMEM;
> > +	/* Is this whole range already set? */
> > +	left = interval_tree_iter_first(&bitmap->root, start, last);
> > +	if (left && left->start <= start && left->last >= last)
> > +		return 0;
> >  
> > -	INIT_LIST_HEAD(&bmr->list);
> > -	bmr->start = start;
> > -	bmr->len = len;
> > -	list_add_tail(&bmr->list, &bitmap->list);
> > +	/* Clear out everything in the range we want to set. */
> > +	xbitmap_clear(bitmap, start, len);
> > +
> > +	/* Do we have a left-adjacent extent? */
> > +	left = interval_tree_iter_first(&bitmap->root, start - 1, start - 1);
> > +	if (left && left->last + 1 != start)
> > +		left = NULL;
> > +
> > +	/* Do we have a right-adjacent extent? */
> > +	right = interval_tree_iter_first(&bitmap->root, last + 1, last + 1);
> > +	if (right && right->start != last + 1)
> > +		right = NULL;
> 
> If we just cleared the range to set above, shouldn't these left/right
> checks always return an adjacent extent or NULL? It seems harmless,
> FWIW, but I'm curious if the logic is necessary.

They should be; I'll turn them into ASSERTs.  Thanks for reading this
series!

--D

> Brian
> 
> > +
> > +	if (left && right) {
> > +		/* combine left and right adjacent extent */
> > +		interval_tree_remove(left, &bitmap->root);
> > +		interval_tree_remove(right, &bitmap->root);
> > +		left->last = right->last;
> > +		interval_tree_insert(left, &bitmap->root);
> > +		kmem_free(right);
> > +	} else if (left) {
> > +		/* combine with left extent */
> > +		interval_tree_remove(left, &bitmap->root);
> > +		left->last = last;
> > +		interval_tree_insert(left, &bitmap->root);
> > +	} else if (right) {
> > +		/* combine with right extent */
> > +		interval_tree_remove(right, &bitmap->root);
> > +		right->start = start;
> > +		interval_tree_insert(right, &bitmap->root);
> > +	} else {
> > +		/* add an extent */
> > +		left = kmem_alloc(sizeof(struct interval_tree_node),
> > +				KM_MAYFAIL);
> > +		if (!left)
> > +			return -ENOMEM;
> > +		left->start = start;
> > +		left->last = last;
> > +		interval_tree_insert(left, &bitmap->root);
> > +	}
> >  
> >  	return 0;
> >  }
> > @@ -43,14 +118,13 @@ xbitmap_set(
> >  /* Free everything related to this bitmap. */
> >  void
> >  xbitmap_destroy(
> > -	struct xbitmap		*bitmap)
> > +	struct xbitmap			*bitmap)
> >  {
> > -	struct xbitmap_range	*bmr;
> > -	struct xbitmap_range	*n;
> > +	struct interval_tree_node	*itn, *p;
> >  
> > -	for_each_xbitmap_extent(bmr, n, bitmap) {
> > -		list_del(&bmr->list);
> > -		kmem_free(bmr);
> > +	for_each_xbitmap_extent(itn, p, bitmap) {
> > +		interval_tree_remove(itn, &bitmap->root);
> > +		kfree(itn);
> >  	}
> >  }
> >  
> > @@ -59,27 +133,7 @@ void
> >  xbitmap_init(
> >  	struct xbitmap		*bitmap)
> >  {
> > -	INIT_LIST_HEAD(&bitmap->list);
> > -}
> > -
> > -/* Compare two btree extents. */
> > -static int
> > -xbitmap_range_cmp(
> > -	void			*priv,
> > -	struct list_head	*a,
> > -	struct list_head	*b)
> > -{
> > -	struct xbitmap_range	*ap;
> > -	struct xbitmap_range	*bp;
> > -
> > -	ap = container_of(a, struct xbitmap_range, list);
> > -	bp = container_of(b, struct xbitmap_range, list);
> > -
> > -	if (ap->start > bp->start)
> > -		return 1;
> > -	if (ap->start < bp->start)
> > -		return -1;
> > -	return 0;
> > +	bitmap->root = RB_ROOT_CACHED;
> >  }
> >  
> >  /*
> > @@ -96,118 +150,19 @@ xbitmap_range_cmp(
> >   *
> >   * This is the logical equivalent of bitmap &= ~sub.
> >   */
> > -#define LEFT_ALIGNED	(1 << 0)
> > -#define RIGHT_ALIGNED	(1 << 1)
> > -int
> > +void
> >  xbitmap_disunion(
> > -	struct xbitmap		*bitmap,
> > -	struct xbitmap		*sub)
> > +	struct xbitmap			*bitmap,
> > +	struct xbitmap			*sub)
> >  {
> > -	struct list_head	*lp;
> > -	struct xbitmap_range	*br;
> > -	struct xbitmap_range	*new_br;
> > -	struct xbitmap_range	*sub_br;
> > -	uint64_t		sub_start;
> > -	uint64_t		sub_len;
> > -	int			state;
> > -	int			error = 0;
> > -
> > -	if (list_empty(&bitmap->list) || list_empty(&sub->list))
> > -		return 0;
> > -	ASSERT(!list_empty(&sub->list));
> > -
> > -	list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
> > -	list_sort(NULL, &sub->list, xbitmap_range_cmp);
> > -
> > -	/*
> > -	 * Now that we've sorted both lists, we iterate bitmap once, rolling
> > -	 * forward through sub and/or bitmap as necessary until we find an
> > -	 * overlap or reach the end of either list.  We do not reset lp to the
> > -	 * head of bitmap nor do we reset sub_br to the head of sub.  The
> > -	 * list traversal is similar to merge sort, but we're deleting
> > -	 * instead.  In this manner we avoid O(n^2) operations.
> > -	 */
> > -	sub_br = list_first_entry(&sub->list, struct xbitmap_range,
> > -			list);
> > -	lp = bitmap->list.next;
> > -	while (lp != &bitmap->list) {
> > -		br = list_entry(lp, struct xbitmap_range, list);
> > -
> > -		/*
> > -		 * Advance sub_br and/or br until we find a pair that
> > -		 * intersect or we run out of extents.
> > -		 */
> > -		while (sub_br->start + sub_br->len <= br->start) {
> > -			if (list_is_last(&sub_br->list, &sub->list))
> > -				goto out;
> > -			sub_br = list_next_entry(sub_br, list);
> > -		}
> > -		if (sub_br->start >= br->start + br->len) {
> > -			lp = lp->next;
> > -			continue;
> > -		}
> > +	struct interval_tree_node	*itn, *n;
> >  
> > -		/* trim sub_br to fit the extent we have */
> > -		sub_start = sub_br->start;
> > -		sub_len = sub_br->len;
> > -		if (sub_br->start < br->start) {
> > -			sub_len -= br->start - sub_br->start;
> > -			sub_start = br->start;
> > -		}
> > -		if (sub_len > br->len)
> > -			sub_len = br->len;
> > -
> > -		state = 0;
> > -		if (sub_start == br->start)
> > -			state |= LEFT_ALIGNED;
> > -		if (sub_start + sub_len == br->start + br->len)
> > -			state |= RIGHT_ALIGNED;
> > -		switch (state) {
> > -		case LEFT_ALIGNED:
> > -			/* Coincides with only the left. */
> > -			br->start += sub_len;
> > -			br->len -= sub_len;
> > -			break;
> > -		case RIGHT_ALIGNED:
> > -			/* Coincides with only the right. */
> > -			br->len -= sub_len;
> > -			lp = lp->next;
> > -			break;
> > -		case LEFT_ALIGNED | RIGHT_ALIGNED:
> > -			/* Total overlap, just delete ex. */
> > -			lp = lp->next;
> > -			list_del(&br->list);
> > -			kmem_free(br);
> > -			break;
> > -		case 0:
> > -			/*
> > -			 * Deleting from the middle: add the new right extent
> > -			 * and then shrink the left extent.
> > -			 */
> > -			new_br = kmem_alloc(sizeof(struct xbitmap_range),
> > -					KM_MAYFAIL);
> > -			if (!new_br) {
> > -				error = -ENOMEM;
> > -				goto out;
> > -			}
> > -			INIT_LIST_HEAD(&new_br->list);
> > -			new_br->start = sub_start + sub_len;
> > -			new_br->len = br->start + br->len - new_br->start;
> > -			list_add(&new_br->list, &br->list);
> > -			br->len = sub_start - br->start;
> > -			lp = lp->next;
> > -			break;
> > -		default:
> > -			ASSERT(0);
> > -			break;
> > -		}
> > -	}
> > +	if (xbitmap_empty(bitmap) || xbitmap_empty(sub))
> > +		return;
> >  
> > -out:
> > -	return error;
> > +	for_each_xbitmap_extent(itn, n, sub)
> > +		__xbitmap_clear(bitmap, itn->start, itn->last);
> >  }
> > -#undef LEFT_ALIGNED
> > -#undef RIGHT_ALIGNED
> >  
> >  /*
> >   * Record all btree blocks seen while iterating all records of a btree.
> > @@ -303,14 +258,13 @@ xbitmap_set_btblocks(
> >  /* How many bits are set in this bitmap? */
> >  uint64_t
> >  xbitmap_hweight(
> > -	struct xbitmap		*bitmap)
> > +	struct xbitmap			*bitmap)
> >  {
> > -	struct xbitmap_range	*bmr;
> > -	struct xbitmap_range	*n;
> > -	uint64_t		ret = 0;
> > +	struct interval_tree_node	*itn, *n;
> > +	uint64_t			ret = 0;
> >  
> > -	for_each_xbitmap_extent(bmr, n, bitmap)
> > -		ret += bmr->len;
> > +	for_each_xbitmap_extent(itn, n, bitmap)
> > +		ret += itn->last - itn->start + 1;
> >  
> >  	return ret;
> >  }
> > @@ -318,15 +272,15 @@ xbitmap_hweight(
> >  /* Call a function for every run of set bits in this bitmap. */
> >  int
> >  xbitmap_iter_set(
> > -	struct xbitmap		*bitmap,
> > -	xbitmap_walk_run_fn	fn,
> > -	void			*priv)
> > +	struct xbitmap			*bitmap,
> > +	xbitmap_walk_run_fn		fn,
> > +	void				*priv)
> >  {
> > -	struct xbitmap_range	*bex, *n;
> > -	int			error;
> > +	struct interval_tree_node	*itn, *n;
> > +	int				error;
> >  
> > -	for_each_xbitmap_extent(bex, n, bitmap) {
> > -		error = fn(bex->start, bex->len, priv);
> > +	for_each_xbitmap_extent(itn, n, bitmap) {
> > +		error = fn(itn->start, itn->last - itn->start + 1, priv);
> >  		if (error)
> >  			break;
> >  	}
> > @@ -370,3 +324,11 @@ xbitmap_iter_set_bits(
> >  
> >  	return xbitmap_iter_set(bitmap, xbitmap_walk_bits_in_run, &wb);
> >  }
> > +
> > +/* Does this bitmap have no bits set at all? */
> > +bool
> > +xbitmap_empty(
> > +	struct xbitmap		*bitmap)
> > +{
> > +	return bitmap->root.rb_root.rb_node == NULL;
> > +}
> > diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> > index 27fde5b4a753..6be596e60ac8 100644
> > --- a/fs/xfs/scrub/bitmap.h
> > +++ b/fs/xfs/scrub/bitmap.h
> > @@ -6,21 +6,18 @@
> >  #ifndef __XFS_SCRUB_BITMAP_H__
> >  #define __XFS_SCRUB_BITMAP_H__
> >  
> > -struct xbitmap_range {
> > -	struct list_head	list;
> > -	uint64_t		start;
> > -	uint64_t		len;
> > -};
> > +#include <linux/interval_tree.h>
> >  
> >  struct xbitmap {
> > -	struct list_head	list;
> > +	struct rb_root_cached	root;
> >  };
> >  
> >  void xbitmap_init(struct xbitmap *bitmap);
> >  void xbitmap_destroy(struct xbitmap *bitmap);
> >  
> > +void xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len);
> >  int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
> > -int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
> > +void xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
> >  int xbitmap_set_btcur_path(struct xbitmap *bitmap,
> >  		struct xfs_btree_cur *cur);
> >  int xbitmap_set_btblocks(struct xbitmap *bitmap,
> > @@ -42,4 +39,6 @@ typedef int (*xbitmap_walk_bit_fn)(uint64_t bit, void *priv);
> >  int xbitmap_iter_set_bits(struct xbitmap *bitmap, xbitmap_walk_bit_fn fn,
> >  		void *priv);
> >  
> > +bool xbitmap_empty(struct xbitmap *bitmap);
> > +
> >  #endif	/* __XFS_SCRUB_BITMAP_H__ */
> > 
> 
