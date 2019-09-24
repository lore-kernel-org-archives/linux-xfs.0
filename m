Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D407FC432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 09:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6EAB214D9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 09:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfIXJj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 05:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfIXJj2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 05:39:28 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6FCBC04B302;
        Tue, 24 Sep 2019 09:39:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D28D10013D9;
        Tue, 24 Sep 2019 09:39:27 +0000 (UTC)
Date:   Tue, 24 Sep 2019 05:39:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: revert 1baa2800e62d ("xfs: remove the unused
 XFS_ALLOC_USERDATA flag")
Message-ID: <20190924093925.GA13820@bfoster>
References: <20190923235224.GW2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923235224.GW2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 24 Sep 2019 09:39:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 04:52:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Revert this commit, as it caused periodic regressions in xfs/173 w/
> 1k blocks[1].
> 
> [1] https://lore.kernel.org/lkml/20190919014602.GN15734@shao2-debian/
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.h |    7 ++++---
>  fs/xfs/libxfs/xfs_bmap.c  |    8 ++++++--
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 58fa85cec325..d6ed5d2c07c2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -81,9 +81,10 @@ typedef struct xfs_alloc_arg {
>  /*
>   * Defines for datatype
>   */
> -#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
> -#define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
> -#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
> +#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
> +#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
> +#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
> +#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
>  
>  static inline bool
>  xfs_alloc_is_userdata(int datatype)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index eaf2d4250a26..4edc25a2ba80 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4042,8 +4042,12 @@ xfs_bmapi_allocate(
>  	 */
>  	if (!(bma->flags & XFS_BMAPI_METADATA)) {
>  		bma->datatype = XFS_ALLOC_NOBUSY;
> -		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
> -			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> +		if (whichfork == XFS_DATA_FORK) {
> +			if (bma->offset == 0)
> +				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> +			else
> +				bma->datatype |= XFS_ALLOC_USERDATA;
> +		}
>  		if (bma->flags & XFS_BMAPI_ZERO)
>  			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
>  	}
