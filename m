Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99623C4740A
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 00:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723EF21670
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 00:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfIJATi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 20:19:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39646 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390519AbfIJATh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Sep 2019 20:19:37 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 13DB343DA6B;
        Tue, 10 Sep 2019 10:19:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i7Tsb-0006Wa-Uv; Tue, 10 Sep 2019 10:19:33 +1000
Date:   Tue, 10 Sep 2019 10:19:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: separate internal metadata scrub functions
Message-ID: <20190910001933.GI16973@dread.disaster.area>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
 <156774082719.2643094.12163874100429393033.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774082719.2643094.12163874100429393033.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=He6T9x_Az7gqPd8ptjAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:33:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_scrub_metadata into two functions -- one to make a single
> call xfs_check_metadata, and the second retains the loop logic.  The
> name is a little easy to confuse with other functions, so rename it to
> reflect what it actually does: scrub all internal metadata of a given
> class (AG header, AG metadata, FS metadata).  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Minor nit:

> +/* Scrub non-inode metadata, saving corruption reports for later. */
> +static int
> +xfs_scrub_meta(
> +	struct scrub_ctx		*ctx,
> +	unsigned int			type,
> +	xfs_agnumber_t			agno,
> +	struct xfs_action_list		*alist)
> +{
> +	struct xfs_scrub_metadata	meta = {
> +		.sm_type		= type,
> +		.sm_agno		= agno,
> +	};

This should be called xfs_scrub_meta_type() because it only
scrubs the specific type passed into it....

>  /* Scrub metadata, saving corruption reports for later. */
>  static bool
> -xfs_scrub_metadata(
> +xfs_scrub_meta_type(
>  	struct scrub_ctx		*ctx,
>  	enum xfrog_scrub_type		scrub_type,
>  	xfs_agnumber_t			agno,
>  	struct xfs_action_list		*alist)
>  {
> -	struct xfs_scrub_metadata	meta = {0};
>  	const struct xfrog_scrub_descr	*sc;
> -	enum check_outcome		fix;
> -	int				type;
> +	unsigned int			type;
>  
>  	sc = xfrog_scrubbers;
>  	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
> +		int			ret;
> +

And this should be called xfs_scrub_all_metadata() because it
walks across all the metadata types in the filesystem and calls
xfs_scrub_meta_type() for each type to scrub them one by one....

Other than that, it looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
