Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D982C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078ED2311B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLFXZk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:25:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38876 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:25:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NJGcn048712;
        Sun, 6 Dec 2020 23:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vI2NBiCGlbYrcBYCIAYcdTt5rxULNqXm1qgJNwoXKIw=;
 b=F7CO/zu1WtuXr0lvAGU+ZMOX4tGYYIG28EUMhXcZ59OCfUNYQ+mBdOo5iV5XfNUDfnI/
 itXZtxrFw2WcOyGJppyker2uJ7GfNm3YUxJ5amusWLzkdDa+poDk7obwo/f9iB1Tjewa
 i64pQ7EAJJsq1AXzjw5LBT7KhqcKHBOWUliQycSupWUwcFtxKR84QsP6Vshkx7irlZ2L
 GFbqJxvUJRzsrGXG6CuTPOSy+W7vYHhQlej3jZj+j8Dv48PRUA6a/RkAUp1gInfwchvU
 tW9htmY+PDRJIkBg5zXZKGT490f55JMU/iLtGxMNZWphKlMzdSjVngvg70gnRzmNutoS oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqbk17j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:24:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NKMw8019226;
        Sun, 6 Dec 2020 23:24:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vps0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:24:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NOuTx020174;
        Sun, 6 Dec 2020 23:24:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:24:55 -0800
Date:   Sun, 6 Dec 2020 15:24:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
Message-ID: <20201206232454.GL629293@magnolia>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
 <160679383664.447787.14224539520566294960.stgit@magnolia>
 <20201201152548.GB1205666@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201152548.GB1205666@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 10:25:48AM -0500, Brian Foster wrote:
> On Mon, Nov 30, 2020 at 07:37:16PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a copy_file_range handler to XFS so that we can accelerate file
> > copies with reflink when the source and destination ranges are not
> > block-aligned.  We'll use the generic pagecache copy to handle the
> > unaligned edges and attempt to reflink the middle.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_file.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 99 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5b0f93f73837..9d1bb0dc30e2 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1119,6 +1119,104 @@ xfs_file_remap_range(
> >  	return remapped > 0 ? remapped : ret;
> >  }
> >  
> ...
> > +STATIC ssize_t
> > +xfs_file_copy_range(
> > +	struct file		*src_file,
> > +	loff_t			src_off,
> > +	struct file		*dst_file,
> > +	loff_t			dst_off,
> > +	size_t			len,
> > +	unsigned int		flags)
> > +{
> > +	struct inode		*inode_src = file_inode(src_file);
> > +	struct xfs_inode	*src = XFS_I(inode_src);
> > +	struct inode		*inode_dst = file_inode(dst_file);
> > +	struct xfs_inode	*dst = XFS_I(inode_dst);
> > +	struct xfs_mount	*mp = src->i_mount;
> > +	loff_t			copy_ret;
> > +	loff_t			next_block;
> > +	size_t			copy_len;
> > +	ssize_t			total_copied = 0;
> > +
> > +	/* Bypass all this if no copy acceleration is possible. */
> > +	if (!xfs_want_reflink_copy_range(src, src_off, dst, dst_off, len))
> > +		goto use_generic;
> > +
> > +	/* Use the regular copy until we're block aligned at the start. */
> > +	next_block = round_up(src_off + 1, mp->m_sb.sb_blocksize);
> 
> Why the +1? AFAICT this means we manually copy the first block if
> src_off does happen to be block aligned. Is this an assumption based on
> the caller attempting ->remap_file_range() first?

Yes.  The VFS always tries that first.

> BTW, if we do happen to be called in some (theoretical) corner case
> where remap doesn't work unrelated to alignment, it seems this would
> unconditionally break the manual copy into multiple parts (first block +
> the rest). It's not immediately clear to me if that's significant from a
> performance perspective,

I doubt it, since that's usually just copying around the pagecache.

> but I wonder if it would be nicer here to
> filter that out more explicitly. For example, run the remap checks on
> the block aligned offset/len first, or skip the remap if the caller has
> provided a block aligned start (i.e. hinting that remap failed for other
> reasons),

Yes, checking the block alignment is a good suggestion.  Will fix.

> or perhaps even implement this so it conditionally performs a
> short manual copy so the next retry would fall into ->remap_file_range()
> with aligned offsets, etc.

Hm.  That could be a thing too, though my opinion is that we should make
as much progress as we can before exiting the kernel.

--D

> Thoughts?
> 
> > +	copy_len = min_t(size_t, len, next_block - src_off);
> > +	if (copy_len > 0) {
> > +		copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
> > +					dst_off, copy_len, flags);
> > +		if (copy_ret < 0)
> > +			return copy_ret;
> > +
> > +		src_off += copy_ret;
> > +		dst_off += copy_ret;
> > +		len -= copy_ret;
> > +		total_copied += copy_ret;
> > +		if (copy_ret < copy_len || len == 0)
> > +			return total_copied;
> > +	}
> > +
> > +	/*
> > +	 * Now try to reflink as many full blocks as we can.  If the end of the
> > +	 * copy request wasn't block-aligned or the reflink fails, we'll just
> > +	 * fall into the generic copy to do the rest.
> > +	 */
> > +	copy_len = round_down(len, mp->m_sb.sb_blocksize);
> > +	if (copy_len > 0) {
> > +		copy_ret = xfs_file_remap_range(src_file, src_off, dst_file,
> > +				dst_off, copy_len, REMAP_FILE_CAN_SHORTEN);
> > +		if (copy_ret >= 0) {
> > +			src_off += copy_ret;
> > +			dst_off += copy_ret;
> > +			len -= copy_ret;
> > +			total_copied += copy_ret;
> > +			if (copy_ret < copy_len || len == 0)
> > +				return total_copied;
> 
> Any reason we return a potential short copy here, but fall into the
> manual copy if the reflink outright fails?
> 
> > +		}
> > +	}
> > +
> > +use_generic:
> > +	/* Use the regular copy to deal with leftover bytes. */
> > +	copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
> > +			dst_off, len, flags);
> > +	if (copy_ret < 0)
> > +		return copy_ret;
> 
> Perhaps this should also check/return total_copied in the event we've
> already done some work..?
> 
> Brian
> 
> > +	return total_copied + copy_ret;
> > +}
> > +
> >  STATIC int
> >  xfs_file_open(
> >  	struct inode	*inode,
> > @@ -1381,6 +1479,7 @@ const struct file_operations xfs_file_operations = {
> >  	.get_unmapped_area = thp_get_unmapped_area,
> >  	.fallocate	= xfs_file_fallocate,
> >  	.fadvise	= xfs_file_fadvise,
> > +	.copy_file_range = xfs_file_copy_range,
> >  	.remap_file_range = xfs_file_remap_range,
> >  };
> >  
> > 
> 
