Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:30:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGSvWp177174
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:30:10 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0syh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:30:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGT1Yu062296
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:30:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u9k1vd1cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:30:09 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGU85C023293
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:30:08 GMT
Date: Mon, 12 Aug 2019 09:30:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 07/18] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
Message-ID: <20190812163007.GC7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-8-allison.henderson@oracle.com>
 <20190812160252.GV7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812160252.GV7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 09:02:52AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:15PM -0700, Allison Collins wrote:
> > Since delayed operations cannot roll transactions, factor
> > up the transaction handling into the calling function
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

No, not ok!

> > ---
> >  fs/xfs/libxfs/xfs_attr.c      | 10 ++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 72af8e2..f36c792 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -752,6 +752,11 @@ xfs_attr_leaf_addname(
> >  		error = xfs_attr3_leaf_flipflags(args);
> >  		if (error)
> >  			return error;
> > +		/*
> > +		 * Commit the flag value change and start the next trans in
> > +		 * series.
> > +		 */
> > +		error = xfs_trans_roll_inode(&args->trans, args->dp);

Lost error value here!

> >  
> >  		/*
> >  		 * Dismantle the "old" attribute/value pair by removing
> > @@ -1090,6 +1095,11 @@ xfs_attr_node_addname(
> >  		error = xfs_attr3_leaf_flipflags(args);
> >  		if (error)
> >  			goto out;
> > +		/*
> > +		 * Commit the flag value change and start the next trans in
> > +		 * series
> > +		 */
> > +		error = xfs_trans_roll_inode(&args->trans, args->dp);

And here!

--D

> >  
> >  		/*
> >  		 * Dismantle the "old" attribute/value pair by removing
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 8d2e11f..8a6f5df 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -2891,10 +2891,5 @@ xfs_attr3_leaf_flipflags(
> >  			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
> >  	}
> >  
> > -	/*
> > -	 * Commit the flag value change and start the next trans in series.
> > -	 */
> > -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> > -
> >  	return error;
> >  }
> > -- 
> > 2.7.4
> > 
