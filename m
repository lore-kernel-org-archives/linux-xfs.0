Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB72C04EBF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B112089F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbfIWMsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbfIWMsj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 08:48:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D188218C891B;
        Mon, 23 Sep 2019 12:48:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CDDA5D9CA;
        Mon, 23 Sep 2019 12:48:38 +0000 (UTC)
Date:   Mon, 23 Sep 2019 08:48:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix userdata allocation detection regression
Message-ID: <20190923124836.GC6924@bfoster>
References: <20190920021943.26930-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920021943.26930-1-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Mon, 23 Sep 2019 12:48:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 07:19:43PM -0700, Christoph Hellwig wrote:
> The XFS_ALLOC_USERDATA was not directly used, but indirectly in the
> xfs_alloc_is_userdata function that check for any bit that is not
> XFS_ALLOC_NOBUSY being set.  But XFS_ALLOC_NOBUSY is equivalent to
> a user data allocation, so rename that flag and check for that instead
> to reduce the confusion.
> 
> Fixes: 1baa2800e62d ("xfs: remove the unused XFS_ALLOC_USERDATA flag")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.h | 7 ++++---
>  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 58fa85cec325..24710746cecb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -83,18 +83,19 @@ typedef struct xfs_alloc_arg {
>   */
>  #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
>  #define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
> -#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
> +#define XFS_ALLOC_USERDATA		(1 << 2)/* allocation is for user data*/
>  
>  static inline bool
>  xfs_alloc_is_userdata(int datatype)
>  {
> -	return (datatype & ~XFS_ALLOC_NOBUSY) != 0;
> +	return (datatype & XFS_ALLOC_USERDATA);
>  }
>  

Prior to this change (and commit 1baa2800e62d), something like an xattr
remote value block would not be considered user data. As of this change,
that is no longer the case. That seems reasonable on first thought (it
is user data after all), but I'm not so sure it's appropriate once you
look through some of the ways xfs_alloc_is_userdata() is used.

Brian

>  static inline bool
>  xfs_alloc_allow_busy_reuse(int datatype)
>  {
> -	return (datatype & XFS_ALLOC_NOBUSY) == 0;
> +	/* Busy extents not allowed for user data */
> +	return (datatype & XFS_ALLOC_USERDATA) == 0;
>  }
>  
>  /* freespace limit calculations */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 054b4ce30033..a2d8c4e4cad5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4041,7 +4041,7 @@ xfs_bmapi_allocate(
>  	 * the busy list.
>  	 */
>  	if (!(bma->flags & XFS_BMAPI_METADATA)) {
> -		bma->datatype = XFS_ALLOC_NOBUSY;
> +		bma->datatype = XFS_ALLOC_USERDATA;
>  		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
>  			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
>  		if (bma->flags & XFS_BMAPI_ZERO)
> -- 
> 2.20.1
> 
