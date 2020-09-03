Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E726C433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AA920665
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A3qBUrOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgICOdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbgICOdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:33:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1798FC061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 07:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4/PABegALubSt68K12MOPpWSBb3eNzxihpRrzMuG1WI=; b=A3qBUrOkHCF4sMgWHxCouHxWE9
        VollsKy2E2wkmQG8/Z37NQwXRhvwEHiL9Y1g6xgU1U+TN3uMxfoSkAWH855Z2eM+96AXxHn6muJbs
        II/ncCsBg9iFA5WNUTZAamg6cBS7tRD0bijtLR8BoWrog+qwBeldyIjyltCa+B0U1beGO6E4auz2t
        3V5BDIVjjTrtOUGee3V6KeAe9T8zUvywIKiYke/Jh+gwR8dWq/x/+Wg6UGUJhrdUOQPKS6zmZpcwK
        SOEO6IDVaiJeazMFj7WLc2YC1t4Mgd5WGea0cEyXAlB8bl3ERvqcJfWiTfXK6VeYBF3qheErYggwP
        pBeWmzWw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDqIX-0005Ge-Md; Thu, 03 Sep 2020 14:33:09 +0000
Date:   Thu, 3 Sep 2020 15:33:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903143309.GB19892@infradead.org>
References: <20200903142839.72710-1-cmaiolino@redhat.com>
 <20200903142839.72710-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903142839.72710-5-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 04:28:39PM +0200, Carlos Maiolino wrote:
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
> 
>  fs/xfs/libxfs/xfs_attr.c      | 14 +++++++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 30 +++++++++++++++++++-----------
>  fs/xfs/xfs_attr_list.c        |  4 ++--
>  4 files changed, 41 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e055c079f397..982014499f1ff 100644
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
> @@ -523,6 +523,14 @@ xfs_attr_set(
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
>  
> +/* total space in use */
> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> +	struct xfs_attr_shortform *sf =
> +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +
> +	return be16_to_cpu(sf->hdr.totsize);

The { should go on a line by its own.

> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
> +{
> +	return (void *)(sfep) + xfs_attr_sf_entsize(sfep);

No need for the braces around sfep.
