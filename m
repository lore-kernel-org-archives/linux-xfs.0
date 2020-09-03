Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D2CC433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1791B20722
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vlD/IbwY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgICOc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgICOcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:32:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FDEC061246
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 07:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nOIxIELpGs9rWI7HOEBMWoMGoYsFEyGx2eCKWJvP12o=; b=vlD/IbwYmE+1YkIam0a2jpt9uA
        OR99bwobo71a7zl6fah9jEbbv8XYho3bqPVEEWmnCKOaSrDEc2zJ86KpTxUNrZPYxNLv8tnZSI8IX
        ED3/YFrXKc/1G1g5OvhTXYIm+c/Zu2+I1EnDpRf3Yg50HKpKJcn4yWh3boFWq4zv3dWulPMq550RM
        7IQkA3QpCBN59JE3IISDLB4OdLFbov7n6JcRF3/InOnv1FeK9NztzMtt296JVF5abPTzu3IqjGxCx
        OIPZCozWc/1b4718kbbA/dkAMotL1RRUqQR05UQ9yClkvtD+e6VArQ+C52mym9vK3b0etnRBwj9P1
        7E/5YAZA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDqHV-0005DK-Il; Thu, 03 Sep 2020 14:32:05 +0000
Date:   Thu, 3 Sep 2020 15:32:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200903143205.GA19892@infradead.org>
References: <20200903142839.72710-1-cmaiolino@redhat.com>
 <20200903142839.72710-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903142839.72710-4-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 04:28:38PM +0200, Carlos Maiolino wrote:
> nameval is a variable-size array, so, define it as it, and remove all
> the -1 magic number subtractions
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 
> 	V2:
> 	 - Drop wrong change to XFS_ATTR_SF_ENTSIZE_MAX
> 	V3:
> 	- Use XFS_ATTR_SF_ENTSIZE_BYNAME in xfs_attr_shortform_allfit()
> 	- Remove int casting and fix spacing on
> 	  XFS_ATTR_SF_ENTSIZE_BYNAME
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 10 ++++------
>  fs/xfs/libxfs/xfs_attr_sf.h   |  4 ++--
>  fs/xfs/libxfs/xfs_da_format.h |  2 +-
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d920183b08a99..fb05c77fc8c9f 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -992,9 +992,9 @@ xfs_attr_shortform_allfit(
>  			return 0;
>  		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
>  			return 0;
> -		bytes += sizeof(struct xfs_attr_sf_entry) - 1
> -				+ name_loc->namelen
> -				+ be16_to_cpu(name_loc->valuelen);
> +		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(
> +					name_loc->namelen,
> +					be16_to_cpu(name_loc->valuelen));

This can be:

		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(name_loc->namelen,
					be16_to_cpu(name_loc->valuelen));

and would be way more readable that way.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
