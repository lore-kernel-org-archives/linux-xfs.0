Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FE7C35DF8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 07:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90582176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 07:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgBYHVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 02:21:09 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55648 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgBYHVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 02:21:09 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5FED93A25C2;
        Tue, 25 Feb 2020 18:21:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6UWd-0007Ed-Ns; Tue, 25 Feb 2020 18:21:03 +1100
Date:   Tue, 25 Feb 2020 18:21:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
Message-ID: <20200225072103.GH10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-13-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=Q6CCZalBQtn9XRjt7cUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:04PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
> new transactions. We will use this later when we introduce delayed attributes

68-72 columns...

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 3de2eec..da40f85 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function
> + */
> +int
> +xfs_attr_rmtval_unmap(
> +	struct xfs_da_args	*args)
> +{
> +	int	error, done;

Best to initialise done to zero here.

> +
> +	/*
> +	 * Unmap value blocks for this attr.  This is similar to
> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +	 * for new transactions
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp,
> +		    args->rmtblkno, args->rmtblkcnt,
> +		    XFS_BMAPI_ATTRFORK, 1, &done);

Got 80 columns for code, please use them all :)

> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;

Hmmm, I guess I'm missing the context at this point: why not just pass the done
variable all the way back to the caller that will be looping on this function
call?

That turns this function into:

int
xfs_attr_rmtval_unmap(
	struct xfs_da_args      *args,
	bool			*done)
{
	return xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
				args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, done);
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
