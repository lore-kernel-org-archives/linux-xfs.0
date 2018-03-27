Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbeC0WQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:16:14 -0400
Date: Tue, 27 Mar 2018 15:14:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs_scrub: initialize movon in
Message-ID: <20180327221437.GD4818@magnolia>
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <6fe699ea-cb0d-f7c6-4736-54138db30cef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe699ea-cb0d-f7c6-4736-54138db30cef@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 05:11:49PM -0500, Eric Sandeen wrote:
> Given the logic in xfs_scrub_connections, it's possible to
> fail all 3 tests and wind up checking an uninitialized moveon
> variable at the end.  Start out with "true" to avoid this and
> move on even if all the conditions in the function are false.
> 
> Fixes-coverity-id: 1433617
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Subject line needs typo fix, but otherwise:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 8e0a1be..5f2a1a7 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -244,7 +244,7 @@ xfs_scrub_connections(
>  {
>  	bool			*pmoveon = arg;
>  	char			descr[DESCR_BUFSZ];
> -	bool			moveon;
> +	bool			moveon = true;
>  	xfs_agnumber_t		agno;
>  	xfs_agino_t		agino;
>  	int			fd = -1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
