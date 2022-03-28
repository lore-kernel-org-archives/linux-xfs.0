Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F948C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 23:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiC1XqR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiC1XqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 19:46:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE37213926D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 16:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44D55B812A5
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 23:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC04DC340ED;
        Mon, 28 Mar 2022 23:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648511071;
        bh=xVXQSyzwsGJ35vScYHJoZ7TqcxM4Zd+yaLJ3XDdxkfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IeDJtMtciYygTmwR1LwDfgLGz/b023eH6AR33MLxNcQLPAuxHCctYMNKqqagAPt9i
         IibhJO8SGLj/SLvzRT7voI/UzXg67nze44VvHZoOzHdJ8tYRFR9y5a7Hg21nFz34Mo
         8y4oGms8k/o31zCo7dyKoLWoQagw4UOlZkhVOl/kVLzTGLq/TCq8PLBwPvNlTcxJJG
         wKF+nHj++o9tf3e3x0ktxMGmLR52SNTHHY/nRuQdM2mZaCX7Nu+92hro9CNpUtP66E
         jE8YPvZDIwAJYBcCdQOawWPXe1kE8buMLCYdy7xWKfK9pXlO2/DRc5ih1AyjIr+Bvm
         mlayd/qC2vewQ==
Date:   Mon, 28 Mar 2022 16:44:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_quota: separate quota info acquisition into
 get_quota()
Message-ID: <20220328234431.GC27690@magnolia>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-2-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-2-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 12:24:59AM +0200, Andrey Albershteyn wrote:
> Both report_mount() and dump_file() have identical code to get quota
> information. This could be used for further separation of the
> functions.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  quota/report.c | 49 +++++++++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 2eb5b5a9..97a89a92 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -59,16 +59,15 @@ report_help(void)
>  "\n"));
>  }
>  
> -static int 
> -dump_file(
> -	FILE		*fp,
> +static int
> +get_quota(
> +	fs_disk_quota_t *d,

At first I confused this for a quotatools patch, but then I realized
that xfsprogs /and/ quotatools both define this structure.

Anyway... please use the non-typedef version of this, in keeping with
the current style:

static int
get_dquot(
	struct fs_disk_quota	*d,
	uint			id,
	...

Also I think this ought to be called get_dquot in keeping with (AFAICT)
the naming conventions: "dquot" for specific quota records vs. "quota"
to refer to the overall feature.

>  	uint		id,
>  	uint		*oid,
>  	uint		type,
>  	char		*dev,
>  	int		flags)
>  {
> -	fs_disk_quota_t	d;
>  	int		cmd;
>  
>  	if (flags & GETNEXTQUOTA_FLAG)
> @@ -77,7 +76,7 @@ dump_file(
>  		cmd = XFS_GETQUOTA;
>  
>  	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
> -	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
> +	if (xfsquotactl(cmd, dev, type, id, (void *)d) < 0) {
>  		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
>  		    cmd == XFS_GETQUOTA)
>  			perror("XFS_GETQUOTA");
> @@ -85,12 +84,29 @@ dump_file(
>  	}
>  
>  	if (oid) {
> -		*oid = d.d_id;
> +		*oid = d->d_id;
>  		/* Did kernelspace wrap? */
>  		if (*oid < id)
>  			return 0;
>  	}
>  
> +	return 1;
> +}
> +
> +static int
> +dump_file(
> +	FILE		*fp,
> +	uint		id,
> +	uint		*oid,
> +	uint		type,
> +	char		*dev,
> +	int		flags)
> +{
> +	fs_disk_quota_t	d;
> +
> +	if	(!get_quota(&d, id, oid, type, dev, flags))

Please don't insert a whole tab after 'if'.

--D

> +		return 0;
> +
>  	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
>  	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
>  	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
> @@ -329,31 +345,12 @@ report_mount(
>  {
>  	fs_disk_quota_t	d;
>  	time64_t	timer;
> -	char		*dev = mount->fs_name;
>  	char		c[8], h[8], s[8];
>  	uint		qflags;
>  	int		count;
> -	int		cmd;
>  
> -	if (flags & GETNEXTQUOTA_FLAG)
> -		cmd = XFS_GETNEXTQUOTA;
> -	else
> -		cmd = XFS_GETQUOTA;
> -
> -	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA*/
> -	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
> -		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
> -		    cmd == XFS_GETQUOTA)
> -			perror("XFS_GETQUOTA");
> +	if	(!get_quota(&d, id, oid, type, mount->fs_name, flags))
>  		return 0;
> -	}
> -
> -	if (oid) {
> -		*oid = d.d_id;
> -		/* Did kernelspace wrap? */
> -		if (* oid < id)
> -			return 0;
> -	}
>  
>  	if (flags & TERSE_FLAG) {
>  		count = 0;
> -- 
> 2.27.0
> 
