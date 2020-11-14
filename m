Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346DBC4742C
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 02:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F302225E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 02:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CbdpPBVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKNCF3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 21:05:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55898 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgKNCF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 21:05:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE253dS004695
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kQiVpfiR905/pX3oTWDNGokri+/Ey8zCeSeFm8U35KM=;
 b=CbdpPBVML6dsaQyDQVrUIhzuf8vGsZyajuc4ZNrM2F9fc5bZb9lgSWl/hICyd3HQtBIr
 1BssrzTtS0HQIxJIz2e2jVL0f8baBzO8WWzkV2fV+ijzXxLGbZWCL2/fwrVmqxenZaE9
 Xo4NcDlxmIDjc/twLpCHZBG131XnnJcKbvFo1Rb3scUNWcka4yVSYSPWMYNRQxCRwgkO
 Xq7ShldJwZrwUVqG/V5OhopNys8xp+S6SxV2IFec9AgZCZXq4rir8rfEV87IjFGbQkbZ
 m2fgs6my55plaNsKtbaOiuFreGrGbcBK9UToOWPaHbAxcA8IFbkSKiu/az7AVImwXYic fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34t4rag350-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:05:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE215SO122793
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:03:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g5tx26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:03:27 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE23QH4010127
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:03:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 18:03:25 -0800
Date:   Fri, 13 Nov 2020 18:03:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 06/10] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20201114020325.GO9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-7-allison.henderson@oracle.com>
 <20201110201523.GF9695@magnolia>
 <2f9cc387-fca2-7978-76e5-235e095740bc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f9cc387-fca2-7978-76e5-235e095740bc@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140011
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 12, 2020 at 06:27:38PM -0700, Allison Henderson wrote:
> 
> 
> On 11/10/20 1:15 PM, Darrick J. Wong wrote:
> > On Thu, Oct 22, 2020 at 11:34:31PM -0700, Allison Henderson wrote:
> > > From: Allison Collins <allison.henderson@oracle.com>
> > > 
> > > These routines to set up and start a new deferred attribute operations.
> > > These functions are meant to be called by any routine needing to
> > > initiate a deferred attribute operation as opposed to the existing
> > > inline operations. New helper function xfs_attr_item_init also added.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >   fs/xfs/libxfs/xfs_attr.h |  2 ++
> > >   2 files changed, 56 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 760383c..7fe5554 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -25,6 +25,7 @@
> > >   #include "xfs_trans_space.h"
> > >   #include "xfs_trace.h"
> > >   #include "xfs_attr_item.h"
> > > +#include "xfs_attr.h"
> > >   /*
> > >    * xfs_attr.c
> > > @@ -643,6 +644,59 @@ xfs_attr_set(
> > >   	goto out_unlock;
> > >   }
> > > +STATIC int
> > > +xfs_attr_item_init(
> > > +	struct xfs_da_args	*args,
> > > +	unsigned int		op_flags,	/* op flag (set or remove) */
> > > +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> > > +{
> > > +
> > > +	struct xfs_attr_item	*new;
> > > +
> > > +	new = kmem_alloc_large(sizeof(struct xfs_attr_item), KM_NOFS);
> > 
> > I don't think we need _large allocations for struct xfs_attr_item, right?
> I will try it and see, I think it should be ok, one of the new test cases
> I'm using does try to progressively add larger and larger attrs. If it
> doesnt work, I'll make a note of it though.

Ok.  Note that kmem_alloc will only return heap objects from memory
that's directly addressable by the kerneli (and can't be larger than a
page), whereas kmem_alloc_large can fall back to virtually mapped
memory, which is scarce on 32-bit systems.

--D

> > 
> > > +	memset(new, 0, sizeof(struct xfs_attr_item));
> > 
> > Use kmem_zalloc and you won't have to memset.  Better yet, zalloc will
> > get you memory that's been pre-zeroed in the background.
> > 
> > > +	new->xattri_op_flags = op_flags;
> > > +	new->xattri_dac.da_args = args;
> > > +
> > > +	*attr = new;
> > > +	return 0;
> > > +}
> > > +
> > > +/* Sets an attribute for an inode as a deferred operation */
> > > +int
> > > +xfs_attr_set_deferred(
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +	struct xfs_attr_item	*new;
> > > +	int			error = 0;
> > > +
> > > +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> > > +
> > > +	return 0;
> > > +}
> > 
> > The changes in "xfs: enable delayed attributes" should be moved to this
> > patch so that these new functions immediately have callers.
> Sure, will merge those patches together then
> 
> > 
> > (Also see the reply I sent to the next patch, which will avoid weird
> > regressions if someone's bisect lands in the middle of this series...)
> > 
> > --D
> > 
> > > +
> > > +/* Removes an attribute for an inode as a deferred operation */
> > > +int
> > > +xfs_attr_remove_deferred(
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +
> > > +	struct xfs_attr_item	*new;
> > > +	int			error;
> > > +
> > > +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >   /*========================================================================
> > >    * External routines when attribute list is inside the inode
> > >    *========================================================================*/
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 5b4a1ca..8a08411 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -307,5 +307,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
> > >   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> > >   			      struct xfs_da_args *args);
> > >   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> > > +int xfs_attr_set_deferred(struct xfs_da_args *args);
> > > +int xfs_attr_remove_deferred(struct xfs_da_args *args);
> > >   #endif	/* __XFS_ATTR_H__ */
> > > -- 
> > > 2.7.4
> > > 
