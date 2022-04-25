Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE40C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbiDYQZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiDYQZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:25:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CCF7487B
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0383EB81903
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51DFC385A4;
        Mon, 25 Apr 2022 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650903760;
        bh=9rhGcoYUxFJ84RQHidntZAvEXBfU4u/lVIl0Q/l2AgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecBB0hKNBSGmJKtJAbVLx6frpiz50TW8Rcjs3ny8ObyJv2mSImXnrkMBh5CFpTPHh
         RU5lv3TSNZIqixCgUxejbRQMxwrPNtitlvWi/xEg3OMKFFgnDoJRgOjLmbNlthF7RO
         6tOM1uT2zzGkVtY82YfOFupznfV+TIOn/3uy+ZSqR5mG0vlEtVrwXnEqNEgOeJH1Cg
         NhvGz/IWW3G04boaQsbtIRxwi+7FQEwx2xdpLmdJ3xotqqRxr4wGEW2RGc9Id64uD4
         0FRYHT3oNtQHrkzjH/UZJ4PCvycOXmKjcEC+5eYcuk2yKsdvDNLD8XJPA9pzpCaFv/
         HPyYPJDSMttcg==
Date:   Mon, 25 Apr 2022 09:22:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/5] xfs_quota: separate quota info acquisition into
 get_dquot()
Message-ID: <20220425162240.GG17025@magnolia>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-2-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-2-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:04PM +0200, Andrey Albershteyn wrote:
> Both report_mount() and dump_file() have identical code to get quota
> information. This could be used for further separation of the
> functions.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  quota/report.c | 49 +++++++++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 2eb5b5a9..cccc654e 100644
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
> +get_dquot(
> +	struct fs_disk_quota *d,
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

struct fs_disk_quota	d;

With that nit fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
> +	if (!get_dquot(&d, id, oid, type, dev, flags))
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
> +	if (!get_dquot(&d, id, oid, type, mount->fs_name, flags))
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
