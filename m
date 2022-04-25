Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624F5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbiDYQbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238874AbiDYQbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2B392335
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 540086145A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63A5C385A4;
        Mon, 25 Apr 2022 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650904116;
        bh=fdAbDPOrsW+o+ZExjf808RJ01ozQVMhzEcdHn9tvEws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L3pPjXwDyOW+M9TqVVjXUt2Vu/Ja8KWgFBnaqUSnK0RKZfNhF/pZQwhoIt6lCbg/3
         IYDCIajdU9aBuqlgmCM3wEacQ9NV8pDPUdd14w6B7Rt8sKRND0m2HXbBbThEmeK0AZ
         Wvt+kd2AeVSiUp8+urTzTGX8vqMmwVO1hwZTtz3fL2UX082Sel/pPxqlFztMco9JHG
         szhe7D+/wYQ+9yHjZ3h/rY6juq27jFY3zzSi3vW/jVn5mbfU4N7PIfNn4tK2YHf02t
         FXm7tvF8y4Qe2SjCBXeDJ2ej3VrGtiAdqA6HjOueWGsMvuMQPDhdIYfU6VZY9+Z2rO
         6dXmtmaLdx9KA==
Date:   Mon, 25 Apr 2022 09:28:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] xfs_quota: separate get_dquot() and dump_file()
Message-ID: <20220425162836.GH17025@magnolia>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-3-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-3-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:05PM +0200, Andrey Albershteyn wrote:
> Separate quota info acquisition from outputting it to file. This
> allows upper functions to filter obtained info (e.g. within specific
> ID range).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  quota/report.c | 86 ++++++++++++++++++++++++++------------------------
>  1 file changed, 45 insertions(+), 41 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index cccc654e..d5c6f84f 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -96,39 +96,31 @@ get_dquot(
>  static int
>  dump_file(

I kinda wonder if this ought to be named 'dump_dquot' since it's not
really dumping a file or even the dquots of a specifc file.  OTOH, the
rest of the utility seems to have similar naming conventions for "report
something to a FILE* stream" so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	FILE		*fp,
> -	uint		id,
> -	uint		*oid,
> -	uint		type,
> -	char		*dev,
> -	int		flags)
> +	struct fs_disk_quota *d,
> +	char		*dev)
>  {
> -	fs_disk_quota_t	d;
> -
> -	if (!get_dquot(&d, id, oid, type, dev, flags))
> -		return 0;
> -
> -	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
> -	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
> -	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
> +	if (!d->d_blk_softlimit && !d->d_blk_hardlimit &&
> +	    !d->d_ino_softlimit && !d->d_ino_hardlimit &&
> +	    !d->d_rtb_softlimit && !d->d_rtb_hardlimit)
>  		return 1;
>  	fprintf(fp, "fs = %s\n", dev);
>  	/* this branch is for backward compatibility reasons */
> -	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
> +	if (d->d_rtb_softlimit || d->d_rtb_hardlimit)
>  		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n",
> -			d.d_id,
> -			(unsigned long long)d.d_blk_softlimit,
> -			(unsigned long long)d.d_blk_hardlimit,
> -			(unsigned long long)d.d_ino_softlimit,
> -			(unsigned long long)d.d_ino_hardlimit,
> -			(unsigned long long)d.d_rtb_softlimit,
> -			(unsigned long long)d.d_rtb_hardlimit);
> +			d->d_id,
> +			(unsigned long long)d->d_blk_softlimit,
> +			(unsigned long long)d->d_blk_hardlimit,
> +			(unsigned long long)d->d_ino_softlimit,
> +			(unsigned long long)d->d_ino_hardlimit,
> +			(unsigned long long)d->d_rtb_softlimit,
> +			(unsigned long long)d->d_rtb_hardlimit);
>  	else
>  		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n",
> -			d.d_id,
> -			(unsigned long long)d.d_blk_softlimit,
> -			(unsigned long long)d.d_blk_hardlimit,
> -			(unsigned long long)d.d_ino_softlimit,
> -			(unsigned long long)d.d_ino_hardlimit);
> +			d->d_id,
> +			(unsigned long long)d->d_blk_softlimit,
> +			(unsigned long long)d->d_blk_hardlimit,
> +			(unsigned long long)d->d_ino_softlimit,
> +			(unsigned long long)d->d_ino_hardlimit);
>  
>  	return 1;
>  }
> @@ -142,6 +134,7 @@ dump_limits_any_type(
>  	uint		upper)
>  {
>  	fs_path_t	*mount;
> +	struct fs_disk_quota d;
>  	uint		id = 0, oid;
>  
>  	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
> @@ -153,46 +146,57 @@ dump_limits_any_type(
>  
>  	/* Range was specified; query everything in it */
>  	if (upper) {
> -		for (id = lower; id <= upper; id++)
> -			dump_file(fp, id, NULL, type, mount->fs_name, 0);
> +		for (id = lower; id <= upper; id++) {
> +			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
> +			dump_file(fp, &d, mount->fs_name);
> +		}
>  		return;
>  	}
>  
>  	/* Use GETNEXTQUOTA if it's available */
> -	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> +	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> +		dump_file(fp, &d, mount->fs_name);
>  		id = oid + 1;
> -		while (dump_file(fp, id, &oid, type, mount->fs_name,
> -				 GETNEXTQUOTA_FLAG))
> +		while (get_dquot(&d, id, &oid, type, mount->fs_name,
> +					GETNEXTQUOTA_FLAG)) {
> +			dump_file(fp, &d, mount->fs_name);
>  			id = oid + 1;
> +		}
>  		return;
> -        }
> +	}
>  
>  	/* Otherwise fall back to iterating over each uid/gid/prjid */
>  	switch (type) {
>  	case XFS_GROUP_QUOTA: {
>  			struct group *g;
>  			setgrent();
> -			while ((g = getgrent()) != NULL)
> -				dump_file(fp, g->gr_gid, NULL, type,
> -					  mount->fs_name, 0);
> +			while ((g = getgrent()) != NULL) {
> +				get_dquot(&d, g->gr_gid, NULL, type,
> +						mount->fs_name, 0);
> +				dump_file(fp, &d, mount->fs_name);
> +			}
>  			endgrent();
>  			break;
>  		}
>  	case XFS_PROJ_QUOTA: {
>  			struct fs_project *p;
>  			setprent();
> -			while ((p = getprent()) != NULL)
> -				dump_file(fp, p->pr_prid, NULL, type,
> -					  mount->fs_name, 0);
> +			while ((p = getprent()) != NULL) {
> +				get_dquot(&d, p->pr_prid, NULL, type,
> +						mount->fs_name, 0);
> +				dump_file(fp, &d, mount->fs_name);
> +			}
>  			endprent();
>  			break;
>  		}
>  	case XFS_USER_QUOTA: {
>  			struct passwd *u;
>  			setpwent();
> -			while ((u = getpwent()) != NULL)
> -				dump_file(fp, u->pw_uid, NULL, type,
> -					  mount->fs_name, 0);
> +			while ((u = getpwent()) != NULL) {
> +				get_dquot(&d, u->pw_uid, NULL, type,
> +						mount->fs_name, 0);
> +				dump_file(fp, &d, mount->fs_name);
> +			}
>  			endpwent();
>  			break;
>  		}
> -- 
> 2.27.0
> 
