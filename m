Return-Path: <SRS0=Ptmy=CP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422E4C433E2
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 22:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0230F214DB
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 22:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIFWAQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Sep 2020 18:00:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54269 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbgIFWAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Sep 2020 18:00:16 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 911713A8223;
        Mon,  7 Sep 2020 08:00:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kF2hn-0006qa-Vs; Mon, 07 Sep 2020 08:00:11 +1000
Date:   Mon, 7 Sep 2020 08:00:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200906220011.GN12131@dread.disaster.area>
References: <20200903161724.85328-1-cmaiolino@redhat.com>
 <20200903161859.85511-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903161859.85511-1-cmaiolino@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=aB0TQsvS-76-Kf6od54A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 06:18:59PM +0200, Carlos Maiolino wrote:
> xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> instead of playing with more #includes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V2:
> 	 - keep macro comments above inline functions
> 	V3:
> 	- Add extra spacing in xfs_attr_sf_totsize()
> 	- Fix open curling braces on inline functions
> 	- use void * casting on xfs_attr_sf_nextentry()
> 	V4:
> 	- Fix open curling braces
> 	- remove unneeded parenthesis
> 
>  fs/xfs/libxfs/xfs_attr.c      | 15 ++++++++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 30 +++++++++++++++++++-----------
>  fs/xfs/xfs_attr_list.c        |  4 ++--
>  4 files changed, 42 insertions(+), 25 deletions(-)

Couple of minor nits below.

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e055c079f397..16ef80943b8ef 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -428,7 +428,7 @@ xfs_attr_set(
>  		 */
>  		if (XFS_IFORK_Q(dp) == 0) {
>  			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> -				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
> +				xfs_attr_sf_entsize_byname(args->namelen,
>  						args->valuelen);
>  
>  			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> @@ -523,6 +523,15 @@ xfs_attr_set(
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
>  
> +/* total space in use */

Comment is redundant.

> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
> +{
> +	struct xfs_attr_shortform *sf =
> +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +
> +	return be16_to_cpu(sf->hdr.totsize);
> +}

If you have to break the declaration line like that, you
may as well just do:

+	struct xfs_attr_shortform *sf;
+
+	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	return be16_to_cpu(sf->hdr.totsize);


Otherwise the patch looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
