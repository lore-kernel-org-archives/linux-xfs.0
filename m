Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA455C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiDYQcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiDYQcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBDEA76C3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE611B818F9
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF1AC385A7;
        Mon, 25 Apr 2022 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650904146;
        bh=uJ0JNupqdAE71/6iF/12AKUe/8gAWyt74BRFCfaIeys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V9zNh7pa08VjM2AJtK2DMmvCTdy1BjK/FUaIaoJOO3/VaD+4SHhsbR9tw3JN62fM4
         uq88Kshh1ZKrzxj5Hz8Jk/WYMcIkOCZzfpsgAIkLULaQE+erArk9rvCILkDlaCONsh
         hQBtNrslBkpAZQjt0WTcBUMzSqzEsNC69qjwq1le13kINZswBrGOaxDjbqPJ61B24X
         xABYdIsHisiAYlpafwtAmC8Mo8UnBLRfwwIUjEJ0YnvmrSGArYzvPh8QnjtcdSw18w
         BWrbkS8zHYTk99Kmdr83nYQNT02oFapnQtxaoOpJxpt1J+G7ExeWxgwJUMYFjG8q2p
         ZGkzbjrq2kRSw==
Date:   Mon, 25 Apr 2022 09:29:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] xfs_quota: separate get_dquot() and report_mount()
Message-ID: <20220425162905.GI17025@magnolia>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-4-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-4-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:06PM +0200, Andrey Albershteyn wrote:
> Separate quota info acquisition from outputting. This allows upper
> functions to filter obtained info (e.g. within specific ID range).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  quota/report.c | 178 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 103 insertions(+), 75 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index d5c6f84f..8ca154f0 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -339,30 +339,25 @@ report_header(
>  static int
>  report_mount(
>  	FILE		*fp,
> -	uint32_t	id,
> +	struct fs_disk_quota *d,
>  	char		*name,
> -	uint32_t	*oid,
>  	uint		form,
>  	uint		type,
>  	fs_path_t	*mount,
>  	uint		flags)
>  {
> -	fs_disk_quota_t	d;
>  	time64_t	timer;
>  	char		c[8], h[8], s[8];
>  	uint		qflags;
>  	int		count;
>  
> -	if (!get_dquot(&d, id, oid, type, mount->fs_name, flags))
> -		return 0;
> -
>  	if (flags & TERSE_FLAG) {
>  		count = 0;
> -		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
> +		if ((form & XFS_BLOCK_QUOTA) && d->d_bcount)
>  			count++;
> -		if ((form & XFS_INODE_QUOTA) && d.d_icount)
> +		if ((form & XFS_INODE_QUOTA) && d->d_icount)
>  			count++;
> -		if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
> +		if ((form & XFS_RTBLOCK_QUOTA) && d->d_rtbcount)
>  			count++;
>  		if (!count)
>  			return 0;
> @@ -372,19 +367,19 @@ report_mount(
>  		report_header(fp, form, type, mount, flags);
>  
>  	if (flags & NO_LOOKUP_FLAG) {
> -		fprintf(fp, "#%-10u", d.d_id);
> +		fprintf(fp, "#%-10u", d->d_id);
>  	} else {
>  		if (name == NULL) {
>  			if (type == XFS_USER_QUOTA) {
> -				struct passwd	*u = getpwuid(d.d_id);
> +				struct passwd	*u = getpwuid(d->d_id);
>  				if (u)
>  					name = u->pw_name;
>  			} else if (type == XFS_GROUP_QUOTA) {
> -				struct group	*g = getgrgid(d.d_id);
> +				struct group	*g = getgrgid(d->d_id);
>  				if (g)
>  					name = g->gr_name;
>  			} else if (type == XFS_PROJ_QUOTA) {
> -				fs_project_t	*p = getprprid(d.d_id);
> +				fs_project_t	*p = getprprid(d->d_id);
>  				if (p)
>  					name = p->pr_name;
>  			}
> @@ -393,73 +388,73 @@ report_mount(
>  		if (name != NULL)
>  			fprintf(fp, "%-10s", name);
>  		else
> -			fprintf(fp, "#%-9u", d.d_id);
> +			fprintf(fp, "#%-9u", d->d_id);
>  	}
>  
>  	if (form & XFS_BLOCK_QUOTA) {
> -		timer = decode_timer(&d, d.d_btimer, d.d_btimer_hi);
> +		timer = decode_timer(d, d->d_btimer, d->d_btimer_hi);
>  		qflags = (flags & HUMAN_FLAG);
> -		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
> +		if (d->d_blk_hardlimit && d->d_bcount > d->d_blk_hardlimit)
>  			qflags |= LIMIT_FLAG;
> -		if (d.d_blk_softlimit && d.d_bcount > d.d_blk_softlimit)
> +		if (d->d_blk_softlimit && d->d_bcount > d->d_blk_softlimit)
>  			qflags |= QUOTA_FLAG;
>  		if (flags & HUMAN_FLAG)
>  			fprintf(fp, " %6s %6s %6s  %02d %8s",
> -				bbs_to_string(d.d_bcount, c, sizeof(c)),
> -				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
> -				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
> -				d.d_bwarns,
> +				bbs_to_string(d->d_bcount, c, sizeof(c)),
> +				bbs_to_string(d->d_blk_softlimit, s, sizeof(s)),
> +				bbs_to_string(d->d_blk_hardlimit, h, sizeof(h)),
> +				d->d_bwarns,
>  				time_to_string(timer, qflags));
>  		else
>  			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
> -				(unsigned long long)d.d_bcount >> 1,
> -				(unsigned long long)d.d_blk_softlimit >> 1,
> -				(unsigned long long)d.d_blk_hardlimit >> 1,
> -				d.d_bwarns,
> +				(unsigned long long)d->d_bcount >> 1,
> +				(unsigned long long)d->d_blk_softlimit >> 1,
> +				(unsigned long long)d->d_blk_hardlimit >> 1,
> +				d->d_bwarns,
>  				time_to_string(timer, qflags));
>  	}
>  	if (form & XFS_INODE_QUOTA) {
> -		timer = decode_timer(&d, d.d_itimer, d.d_itimer_hi);
> +		timer = decode_timer(d, d->d_itimer, d->d_itimer_hi);
>  		qflags = (flags & HUMAN_FLAG);
> -		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
> +		if (d->d_ino_hardlimit && d->d_icount > d->d_ino_hardlimit)
>  			qflags |= LIMIT_FLAG;
> -		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
> +		if (d->d_ino_softlimit && d->d_icount > d->d_ino_softlimit)
>  			qflags |= QUOTA_FLAG;
>  		if (flags & HUMAN_FLAG)
>  			fprintf(fp, " %6s %6s %6s  %02d %8s",
> -				num_to_string(d.d_icount, c, sizeof(c)),
> -				num_to_string(d.d_ino_softlimit, s, sizeof(s)),
> -				num_to_string(d.d_ino_hardlimit, h, sizeof(h)),
> -				d.d_iwarns,
> +				num_to_string(d->d_icount, c, sizeof(c)),
> +				num_to_string(d->d_ino_softlimit, s, sizeof(s)),
> +				num_to_string(d->d_ino_hardlimit, h, sizeof(h)),
> +				d->d_iwarns,
>  				time_to_string(timer, qflags));
>  		else
>  			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
> -				(unsigned long long)d.d_icount,
> -				(unsigned long long)d.d_ino_softlimit,
> -				(unsigned long long)d.d_ino_hardlimit,
> -				d.d_iwarns,
> +				(unsigned long long)d->d_icount,
> +				(unsigned long long)d->d_ino_softlimit,
> +				(unsigned long long)d->d_ino_hardlimit,
> +				d->d_iwarns,
>  				time_to_string(timer, qflags));
>  	}
>  	if (form & XFS_RTBLOCK_QUOTA) {
> -		timer = decode_timer(&d, d.d_rtbtimer, d.d_rtbtimer_hi);
> +		timer = decode_timer(d, d->d_rtbtimer, d->d_rtbtimer_hi);
>  		qflags = (flags & HUMAN_FLAG);
> -		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
> +		if (d->d_rtb_hardlimit && d->d_rtbcount > d->d_rtb_hardlimit)
>  			qflags |= LIMIT_FLAG;
> -		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
> +		if (d->d_rtb_softlimit && d->d_rtbcount > d->d_rtb_softlimit)
>  			qflags |= QUOTA_FLAG;
>  		if (flags & HUMAN_FLAG)
>  			fprintf(fp, " %6s %6s %6s  %02d %8s",
> -				bbs_to_string(d.d_rtbcount, c, sizeof(c)),
> -				bbs_to_string(d.d_rtb_softlimit, s, sizeof(s)),
> -				bbs_to_string(d.d_rtb_hardlimit, h, sizeof(h)),
> -				d.d_rtbwarns,
> +				bbs_to_string(d->d_rtbcount, c, sizeof(c)),
> +				bbs_to_string(d->d_rtb_softlimit, s, sizeof(s)),
> +				bbs_to_string(d->d_rtb_hardlimit, h, sizeof(h)),
> +				d->d_rtbwarns,
>  				time_to_string(timer, qflags));
>  		else
>  			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
> -				(unsigned long long)d.d_rtbcount >> 1,
> -				(unsigned long long)d.d_rtb_softlimit >> 1,
> -				(unsigned long long)d.d_rtb_hardlimit >> 1,
> -				d.d_rtbwarns,
> +				(unsigned long long)d->d_rtbcount >> 1,
> +				(unsigned long long)d->d_rtb_softlimit >> 1,
> +				(unsigned long long)d->d_rtb_hardlimit >> 1,
> +				d->d_rtbwarns,
>  				time_to_string(timer, qflags));
>  	}
>  	fputc('\n', fp);
> @@ -476,30 +471,40 @@ report_user_mount(
>  	uint		flags)
>  {
>  	struct passwd	*u;
> +	struct fs_disk_quota	d;
>  	uint		id = 0, oid;
>  
>  	if (upper) {	/* identifier range specified */
>  		for (id = lower; id <= upper; id++) {
> -			if (report_mount(fp, id, NULL, NULL,
> -					form, XFS_USER_QUOTA, mount, flags))
> +			if (get_dquot(&d, id, NULL, XFS_USER_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> +						mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
> -	} else if (report_mount(fp, id, NULL, &oid, form,
> -				XFS_USER_QUOTA, mount,
> +	} else if (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
>  				flags|GETNEXTQUOTA_FLAG)) {
> +		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
> +			flags|GETNEXTQUOTA_FLAG);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
> -				    mount, flags)) {
> +		while (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
> +				flags)) {
> +			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> +				mount, flags);
>  			id = oid + 1;
>  		}
>  	} else {
>  		setpwent();
>  		while ((u = getpwent()) != NULL) {
> -			if (report_mount(fp, u->pw_uid, u->pw_name, NULL,
> -					form, XFS_USER_QUOTA, mount, flags))
> +			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, u->pw_name, form,
> +						XFS_USER_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
>  		endpwent();
>  	}
> @@ -518,30 +523,40 @@ report_group_mount(
>  	uint		flags)
>  {
>  	struct group	*g;
> +	struct fs_disk_quota	d;
>  	uint		id = 0, oid;
>  
>  	if (upper) {	/* identifier range specified */
>  		for (id = lower; id <= upper; id++) {
> -			if (report_mount(fp, id, NULL, NULL,
> -					form, XFS_GROUP_QUOTA, mount, flags))
> +			if (get_dquot(&d, id, NULL, XFS_GROUP_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, NULL, form,
> +						XFS_GROUP_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
> -	} else if (report_mount(fp, id, NULL, &oid, form,
> -				XFS_GROUP_QUOTA, mount,
> -				flags|GETNEXTQUOTA_FLAG)) {
> +	} else if (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> +				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> +		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> +				flags|GETNEXTQUOTA_FLAG);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
> -				    mount, flags)) {
> +		while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> +					mount->fs_name, flags)) {
> +			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> +					flags);
>  			id = oid + 1;
>  		}
>  	} else {
>  		setgrent();
>  		while ((g = getgrent()) != NULL) {
> -			if (report_mount(fp, g->gr_gid, g->gr_name, NULL,
> -					form, XFS_GROUP_QUOTA, mount, flags))
> +			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, g->gr_name, form,
> +						XFS_GROUP_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
>  	}
>  	if (flags & NO_HEADER_FLAG)
> @@ -559,22 +574,29 @@ report_project_mount(
>  	uint		flags)
>  {
>  	fs_project_t	*p;
> +	struct fs_disk_quota	d;
>  	uint		id = 0, oid;
>  
>  	if (upper) {	/* identifier range specified */
>  		for (id = lower; id <= upper; id++) {
> -			if (report_mount(fp, id, NULL, NULL,
> -					form, XFS_PROJ_QUOTA, mount, flags))
> +			if (get_dquot(&d, id, NULL, XFS_PROJ_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
> +						mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
> -	} else if (report_mount(fp, id, NULL, &oid, form,
> -				XFS_PROJ_QUOTA, mount,
> -				flags|GETNEXTQUOTA_FLAG)) {
> +	} else if (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> +				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> +		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> +				flags|GETNEXTQUOTA_FLAG);
>  		id = oid + 1;
>  		flags |= GETNEXTQUOTA_FLAG;
>  		flags |= NO_HEADER_FLAG;
> -		while (report_mount(fp, id, NULL, &oid, form, XFS_PROJ_QUOTA,
> -				    mount, flags)) {
> +		while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> +					mount->fs_name, flags)) {
> +			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> +					flags);
>  			id = oid + 1;
>  		}
>  	} else {
> @@ -583,16 +605,22 @@ report_project_mount(
>  			 * Print default project quota, even if projid 0
>  			 * isn't defined
>  			 */
> -			if (report_mount(fp, 0, NULL, NULL,
> -					form, XFS_PROJ_QUOTA, mount, flags))
> +			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
> +						mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
>  
>  		setprent();
>  		while ((p = getprent()) != NULL) {
> -			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
> -					form, XFS_PROJ_QUOTA, mount, flags))
> +			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
> +						mount->fs_name, flags)) {
> +				report_mount(fp, &d, p->pr_name, form,
> +						XFS_PROJ_QUOTA, mount, flags);
>  				flags |= NO_HEADER_FLAG;
> +			}
>  		}
>  		endprent();
>  	}
> -- 
> 2.27.0
> 
