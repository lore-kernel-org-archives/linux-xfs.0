Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AA5C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DEE613F0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFCE50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:57:26 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:46203 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhFCE50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 00:57:26 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4BA3480B2BA;
        Thu,  3 Jun 2021 14:55:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofOF-008MUn-NN; Thu, 03 Jun 2021 14:55:31 +1000
Date:   Thu, 3 Jun 2021 14:55:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename struct xfs_eofblocks to xfs_icwalk
Message-ID: <20210603045531.GS664593@dread.disaster.area>
References: <162268997425.2724263.18220495607834735216.stgit@locust>
 <162268998538.2724263.16964371295618826505.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268998538.2724263.16964371295618826505.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=BbKm2MxNj_b0kDq-ctIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:13:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfs_eofblocks structure is no longer well-named -- nowadays it
> provides optional filtering criteria to any walk of the incore inode
> cache.  Only one of the cache walk goals has anything to do with
> clearing of speculative post-EOF preallocations, so change the name to
> be more appropriate.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c   |    6 +-
>  fs/xfs/xfs_icache.c |  154 ++++++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_icache.h |   14 ++---
>  fs/xfs/xfs_ioctl.c  |   30 +++++-----
>  fs/xfs/xfs_trace.h  |   36 ++++++------
>  5 files changed, 120 insertions(+), 120 deletions(-)
.....
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1fe4c1fc0aea..a0fcadb1a04f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1875,7 +1875,7 @@ xfs_ioc_setlabel(
>  static inline int
>  xfs_fs_eofblocks_from_user(
>  	struct xfs_fs_eofblocks		*src,
> -	struct xfs_eofblocks		*dst)
> +	struct xfs_icwalk		*dst)
>  {
>  	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
>  		return -EINVAL;
> @@ -1887,21 +1887,21 @@ xfs_fs_eofblocks_from_user(
>  	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
>  		return -EINVAL;
>  
> -	dst->eof_flags = src->eof_flags;
> -	dst->eof_prid = src->eof_prid;
> -	dst->eof_min_file_size = src->eof_min_file_size;
> +	dst->icw_flags = src->eof_flags;
> +	dst->icw_prid = src->eof_prid;
> +	dst->icw_min_file_size = src->eof_min_file_size;

Ah, ok, that's why the flags were encoded to have the same values as
the user API - it's just a straight value copy of the field.

Hmmmm. What happens in future if we've added new internal flags and
then add a new API flag and they overlap in value? That seems like
a bit of landmine?

Otherwise the change looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
