Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E3EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 23:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244413AbiECXEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 19:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244277AbiECXEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451B18B3C
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 16:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36236173B
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 23:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255E4C385A4;
        Tue,  3 May 2022 23:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651618847;
        bh=yoCAsI84jewMp4oT8BoE5MbHdC4Z6Tos9PSrv5aPzPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gba4ECWA3tk/42Uujb9ZrXAh25wXpkTtBVs5bk3ZfVSPbfbQQPUz4oBgACXovcnIp
         GDM1i4iYntvo9CSLU5qzgGyRwBWE5N736BvnaV+FbMbEb8+17LinEckSkjln37kd6I
         hPPNgwvFoS1Ea/gDXODrvT/abZsqiX2l/+nSwDlN1WhHqf4WGPh841aWPAH5ywOaNY
         8PZ/exLjhE0oouTo9+TSj3Q49CFEj85psrSh7qVId3Xnc/t0yQBBKRCH9ocWfks4YL
         kdYJxf+OQsD584ehL0dpheD6JZV+igDSfBK2XA+6F1XSs/pAaL7smfBO2AaBdzWm4I
         FHHNiPzAFJa7A==
Date:   Tue, 3 May 2022 16:00:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged
 calls in report/dump
Message-ID: <20220503230046.GJ8265@magnolia>
References: <20220502150207.117112-1-aalbersh@redhat.com>
 <20220502150207.117112-5-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502150207.117112-5-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 05:02:10PM +0200, Andrey Albershteyn wrote:
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

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  quota/report.c | 148 ++++++++++++++++---------------------------------
>  1 file changed, 49 insertions(+), 99 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 8ca154f0..2b9577a5 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -63,7 +63,6 @@ static int
>  get_dquot(
>  	struct fs_disk_quota *d,
>  	uint		id,
> -	uint		*oid,
>  	uint		type,
>  	char		*dev,
>  	int		flags)
> @@ -83,12 +82,9 @@ get_dquot(
>  		return 0;
>  	}
>  
> -	if (oid) {
> -		*oid = d->d_id;
> -		/* Did kernelspace wrap? */
> -		if (*oid < id)
> -			return 0;
> -	}
> +	/* Did kernelspace wrap? */
> +	if (d->d_id < id)
> +		return 0;
>  
>  	return 1;
>  }
> @@ -135,7 +131,7 @@ dump_limits_any_type(
>  {
>  	fs_path_t	*mount;
>  	struct fs_disk_quota d;
> -	uint		id = 0, oid;
> +	uint		id = lower, flags = 0;
>  
>  	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
>  		exitcode = 1;
> @@ -144,26 +140,16 @@ dump_limits_any_type(
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
> +	while (get_dquot(&d, id, type, mount->fs_name,
> +				flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		dump_file(fp, &d, mount->fs_name);
> +		id = d.d_id + 1;
> +		flags |= GETNEXTQUOTA_FLAG;
>  	}
>  
> -	/* Use GETNEXTQUOTA if it's available */
> -	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> -		dump_file(fp, &d, mount->fs_name);
> -		id = oid + 1;
> -		while (get_dquot(&d, id, &oid, type, mount->fs_name,
> -					GETNEXTQUOTA_FLAG)) {
> -			dump_file(fp, &d, mount->fs_name);
> -			id = oid + 1;
> -		}
> +	if (flags & GETNEXTQUOTA_FLAG)
>  		return;
> -	}
>  
>  	/* Otherwise fall back to iterating over each uid/gid/prjid */
>  	switch (type) {
> @@ -171,7 +157,7 @@ dump_limits_any_type(
>  			struct group *g;
>  			setgrent();
>  			while ((g = getgrent()) != NULL) {
> -				get_dquot(&d, g->gr_gid, NULL, type,
> +				get_dquot(&d, g->gr_gid, type,
>  						mount->fs_name, 0);
>  				dump_file(fp, &d, mount->fs_name);
>  			}
> @@ -182,7 +168,7 @@ dump_limits_any_type(
>  			struct fs_project *p;
>  			setprent();
>  			while ((p = getprent()) != NULL) {
> -				get_dquot(&d, p->pr_prid, NULL, type,
> +				get_dquot(&d, p->pr_prid, type,
>  						mount->fs_name, 0);
>  				dump_file(fp, &d, mount->fs_name);
>  			}
> @@ -193,7 +179,7 @@ dump_limits_any_type(
>  			struct passwd *u;
>  			setpwent();
>  			while ((u = getpwent()) != NULL) {
> -				get_dquot(&d, u->pw_uid, NULL, type,
> +				get_dquot(&d, u->pw_uid, type,
>  						mount->fs_name, 0);
>  				dump_file(fp, &d, mount->fs_name);
>  			}
> @@ -472,34 +458,22 @@ report_user_mount(
>  {
>  	struct passwd	*u;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower;
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
> -		id = oid + 1;
> +	while (get_dquot(&d, id, XFS_USER_QUOTA, mount->fs_name,
> +				flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
> +		id = d.d_id + 1;
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
> -			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
> +			if (get_dquot(&d, u->pw_uid, XFS_USER_QUOTA,
>  						mount->fs_name, flags)) {
>  				report_mount(fp, &d, u->pw_name, form,
>  						XFS_USER_QUOTA, mount, flags);
> @@ -524,34 +498,22 @@ report_group_mount(
>  {
>  	struct group	*g;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower;
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
> -		id = oid + 1;
> +	while (get_dquot(&d, id, XFS_GROUP_QUOTA, mount->fs_name,
> +				flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
> +		id = d.d_id + 1;
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
> -			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
> +			if (get_dquot(&d, g->gr_gid, XFS_GROUP_QUOTA,
>  						mount->fs_name, flags)) {
>  				report_mount(fp, &d, g->gr_name, form,
>  						XFS_GROUP_QUOTA, mount, flags);
> @@ -575,38 +537,26 @@ report_project_mount(
>  {
>  	fs_project_t	*p;
>  	struct fs_disk_quota	d;
> -	uint		id = 0, oid;
> +	uint		id = lower;
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
> -		id = oid + 1;
> +	while (get_dquot(&d, id, XFS_PROJ_QUOTA, mount->fs_name,
> +				flags | GETNEXTQUOTA_FLAG) &&
> +			!(upper && (d.d_id > upper))) {
> +		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
> +		id = d.d_id + 1;
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
>  			 * isn't defined
>  			 */
> -			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
> -						mount->fs_name, flags)) {
> +			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount->fs_name,
> +						flags)) {
>  				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
>  						mount, flags);
>  				flags |= NO_HEADER_FLAG;
> @@ -615,7 +565,7 @@ report_project_mount(
>  
>  		setprent();
>  		while ((p = getprent()) != NULL) {
> -			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
> +			if (get_dquot(&d, p->pr_prid, XFS_PROJ_QUOTA,
>  						mount->fs_name, flags)) {
>  				report_mount(fp, &d, p->pr_name, form,
>  						XFS_PROJ_QUOTA, mount, flags);
> -- 
> 2.27.0
> 
