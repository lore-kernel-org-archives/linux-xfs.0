Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB620C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiDYQgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbiDYQgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE4ADE92F
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AF9B81900
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F79C385A4;
        Mon, 25 Apr 2022 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650904381;
        bh=UduHHqltdH4a6ZNt6d7drSmaWecG6fq7ByH+J50h9dA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVAMtj/qRH5JVq8vp5RvjLRyMDuWvLOg6p7A2lEvl5UpHvY9sgHTarv3cFSjaCgQI
         g+gcD9kt80RdGZL2H0PtAYhP7Zd/yIvLaQ9CeuO1oHMfBaXU0SrGDWYBqjM38liAUY
         8X1VgpjcGB0YtHifS61DaFdMQ/ZpF/b9Fh2fMKI/u7pSwtmXvmracRcEGXe2fEtYm/
         RIw1rl7+Boob3Dg0TnddXA7r2Qo6QtwpcyKEquHzgMOj4/p0NFJCrStdqmJFdjbADB
         PLZy870oUUqIjVGgIWOub9plR4ghbc8rgjBXvp11rdApGoE61FcwbGfKZf+sRETD/W
         FxDR0j119gzYA==
Date:   Mon, 25 Apr 2022 09:33:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged
 calls in report/dump
Message-ID: <20220425163300.GJ17025@magnolia>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-5-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-5-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:07PM +0200, Andrey Albershteyn wrote:
> The implementation based on XFS_GETQUOTA call for each ID in range,
> specified with -L/-U, is quite slow for wider ranges.
> 
> If kernel supports XFS_GETNEXTQUOTA, report_*_mount/dump_any_file
> will use that to obtain quota list for the mount. XFS_GETNEXTQUOTA
> returns quota of the requested ID and next ID with non-empty quota.
> 
> Otherwise, XFS_GETQUOTA will be used for each user/group/project ID
> known from password/group/project database.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  quota/report.c | 116 +++++++++++++++----------------------------------
>  1 file changed, 35 insertions(+), 81 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 8ca154f0..65d931f3 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -135,7 +135,7 @@ dump_limits_any_type(
>  {
>  	fs_path_t	*mount;
>  	struct fs_disk_quota d;
> -	uint		id = 0, oid;
> +	uint		id = lower, oid, flags = 0;
>  
>  	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
>  		exitcode = 1;
> @@ -144,27 +144,17 @@ dump_limits_any_type(
>  		return;
>  	}
>  
> -	/* Range was specified; query everything in it */
> -	if (upper) {
> -		for (id = lower; id <= upper; id++) {
> -			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
> -			dump_file(fp, &d, mount->fs_name);
> -		}
> -		return;
> -	}
> -
> -	/* Use GETNEXTQUOTA if it's available */
> -	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> +	while (get_dquot(&d, id, &oid, type,
> +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
>  		dump_file(fp, &d, mount->fs_name);
>  		id = oid + 1;

Just out of curiosity, could this be "id = d.d_id + 1", and then you
don't have to pass around &oid at all?

--D

> -		while (get_dquot(&d, id, &oid, type, mount->fs_name,
> -					GETNEXTQUOTA_FLAG)) {
> -			dump_file(fp, &d, mount->fs_name);
> -			id = oid + 1;
> -		}
> -		return;
> +		flags |= GETNEXTQUOTA_FLAG;
>  	}
>  
> +	if (flags & GETNEXTQUOTA_FLAG)
> +		return;
> +
>  	/* Otherwise fall back to iterating over each uid/gid/prjid */
>  	switch (type) {
>  	case XFS_GROUP_QUOTA: {
> @@ -472,31 +462,19 @@ report_user_mount(
>  {
>  	struct passwd	*u;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower, oid;
>  
> -	if (upper) {	/* identifier range specified */
> -		for (id = lower; id <= upper; id++) {
> -			if (get_dquot(&d, id, NULL, XFS_USER_QUOTA,
> -						mount->fs_name, flags)) {
> -				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> -						mount, flags);
> -				flags |= NO_HEADER_FLAG;
> -			}
> -		}
> -	} else if (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
> -				flags|GETNEXTQUOTA_FLAG)) {
> -		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
> -			flags|GETNEXTQUOTA_FLAG);
> +	while (get_dquot(&d, id, &oid, XFS_USER_QUOTA,
> +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
> -				flags)) {
> -			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> -				mount, flags);
> -			id = oid + 1;
> -		}
> -	} else {
> +	}
> +
> +	/* No GETNEXTQUOTA support, iterate over all from password file */
> +	if (!(flags & GETNEXTQUOTA_FLAG)) {
>  		setpwent();
>  		while ((u = getpwent()) != NULL) {
>  			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
> @@ -524,31 +502,19 @@ report_group_mount(
>  {
>  	struct group	*g;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower, oid;
>  
> -	if (upper) {	/* identifier range specified */
> -		for (id = lower; id <= upper; id++) {
> -			if (get_dquot(&d, id, NULL, XFS_GROUP_QUOTA,
> -						mount->fs_name, flags)) {
> -				report_mount(fp, &d, NULL, form,
> -						XFS_GROUP_QUOTA, mount, flags);
> -				flags |= NO_HEADER_FLAG;
> -			}
> -		}
> -	} else if (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> -				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> -		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> -				flags|GETNEXTQUOTA_FLAG);
> +	while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (oid > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> -					mount->fs_name, flags)) {
> -			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> -					flags);
> -			id = oid + 1;
> -		}
> -	} else {
> +	}
> +
> +	/* No GETNEXTQUOTA support, iterate over all from password file */
> +	if (!(flags & GETNEXTQUOTA_FLAG)) {
>  		setgrent();
>  		while ((g = getgrent()) != NULL) {
>  			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
> @@ -575,31 +541,19 @@ report_project_mount(
>  {
>  	fs_project_t	*p;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower, oid;
>  
> -	if (upper) {	/* identifier range specified */
> -		for (id = lower; id <= upper; id++) {
> -			if (get_dquot(&d, id, NULL, XFS_PROJ_QUOTA,
> -						mount->fs_name, flags)) {
> -				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
> -						mount, flags);
> -				flags |= NO_HEADER_FLAG;
> -			}
> -		}
> -	} else if (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> -				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> -		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> -				flags|GETNEXTQUOTA_FLAG);
> +	while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> -					mount->fs_name, flags)) {
> -			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> -					flags);
> -			id = oid + 1;
> -		}
> -	} else {
> +	}
> +
> +	/* No GETNEXTQUOTA support, iterate over all */
> +	if (!(flags & GETNEXTQUOTA_FLAG)) {
>  		if (!getprprid(0)) {
>  			/*
>  			 * Print default project quota, even if projid 0
> -- 
> 2.27.0
> 
