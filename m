Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760E1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 08:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344617AbiD1IrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344610AbiD1Iqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 04:46:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B093AAB6E
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 01:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651135175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u4+0AWTujHiEZpN7SOhWuNzGMM3Dk31MoulP7a+eSlQ=;
        b=EOOkdSOJb6F0aRyQ4nigm3Gkd7j6xkRvN/gkKDhAAXrIW3RhqrKimwGE1wFDsU1WhqegE/
        abG1qnkn0CNCyqCm1QimAb0A9sdyr4DuOuM3D+/vtZ8S7LwRe99YslrHSjVtLgx2imjL7d
        EsoQjIPzbAlkMrvk7GCCrV+vtpkjH4w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-qC_YWxgkO2ashSRuASWg9Q-1; Thu, 28 Apr 2022 04:39:34 -0400
X-MC-Unique: qC_YWxgkO2ashSRuASWg9Q-1
Received: by mail-wm1-f69.google.com with SMTP id v191-20020a1cacc8000000b0038ce818d2efso1655593wme.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 01:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4+0AWTujHiEZpN7SOhWuNzGMM3Dk31MoulP7a+eSlQ=;
        b=GTCaMY+ZxywVvWijFZXWXRIjCPpiuEcX+oUg577pOzTLIcbyVO5HntMzihNY7aoebw
         a1Ahj80EECiDEfush5TM1MIpbwinEK5GMN1quI+FdlUQJMqNzQ8ZKz6XEm7j/u4ui3cs
         AAandsXoOUCas+u11UL+jy7SHdLPoMyyF7uRkLCfDLsiGVy+nUTIH8XEfmMTpeOHOrWG
         QZphUf8xErykIpk6h9efAQRTLszpFNL8pNEXbpvEiOVTav32J01UbCcD7I2gqK9tWChu
         z/JUXeSEP2c3wVy/mgG2gbhOhCSTMbMk0UOZ706f/CBGKR9btkdgSK40IlOpm+Y3uq+q
         ToQg==
X-Gm-Message-State: AOAM531NYUPErXpNciVyoomLUTgH8rCfZdoEfVbJ4v7ePSdFE9S1UJkQ
        W8Kg8HQnqduWrDC1pir9u9qaQhzCEaSYOy6HQxT+XkBm4pBW8MG4kXb6Q5E/RrZZxEw/b9lRHYy
        fj7OXlVEOZ6r/OKn71MM=
X-Received: by 2002:a5d:61cc:0:b0:20a:d154:9806 with SMTP id q12-20020a5d61cc000000b0020ad1549806mr20434867wrv.439.1651135172715;
        Thu, 28 Apr 2022 01:39:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPFvqWpotZy8pv02IMwh4Za7nIztf0VSgyZCBbyivvTvXqyfp3qWBtZmqT4KQo5lO1UyLF7Q==
X-Received: by 2002:a5d:61cc:0:b0:20a:d154:9806 with SMTP id q12-20020a5d61cc000000b0020ad1549806mr20434850wrv.439.1651135172428;
        Thu, 28 Apr 2022 01:39:32 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g13-20020a5d64ed000000b0020a9e488976sm17035291wri.25.2022.04.28.01.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:39:31 -0700 (PDT)
Date:   Thu, 28 Apr 2022 10:39:30 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged
 calls in report/dump
Message-ID: <YmpSwlJZ2Zb/dFKc@aalbersh.remote.csb>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-5-aalbersh@redhat.com>
 <20220425163300.GJ17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425163300.GJ17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 09:33:00AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 20, 2022 at 04:45:07PM +0200, Andrey Albershteyn wrote:
> > The implementation based on XFS_GETQUOTA call for each ID in range,
> > specified with -L/-U, is quite slow for wider ranges.
> > 
> > If kernel supports XFS_GETNEXTQUOTA, report_*_mount/dump_any_file
> > will use that to obtain quota list for the mount. XFS_GETNEXTQUOTA
> > returns quota of the requested ID and next ID with non-empty quota.
> > 
> > Otherwise, XFS_GETQUOTA will be used for each user/group/project ID
> > known from password/group/project database.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  quota/report.c | 116 +++++++++++++++----------------------------------
> >  1 file changed, 35 insertions(+), 81 deletions(-)
> > 
> > diff --git a/quota/report.c b/quota/report.c
> > index 8ca154f0..65d931f3 100644
> > --- a/quota/report.c
> > +++ b/quota/report.c
> > @@ -135,7 +135,7 @@ dump_limits_any_type(
> >  {
> >  	fs_path_t	*mount;
> >  	struct fs_disk_quota d;
> > -	uint		id = 0, oid;
> > +	uint		id = lower, oid, flags = 0;
> >  
> >  	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
> >  		exitcode = 1;
> > @@ -144,27 +144,17 @@ dump_limits_any_type(
> >  		return;
> >  	}
> >  
> > -	/* Range was specified; query everything in it */
> > -	if (upper) {
> > -		for (id = lower; id <= upper; id++) {
> > -			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
> > -			dump_file(fp, &d, mount->fs_name);
> > -		}
> > -		return;
> > -	}
> > -
> > -	/* Use GETNEXTQUOTA if it's available */
> > -	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> > +	while (get_dquot(&d, id, &oid, type,
> > +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> > +			!(upper && (d.d_id > upper))) {
> >  		dump_file(fp, &d, mount->fs_name);
> >  		id = oid + 1;
> 
> Just out of curiosity, could this be "id = d.d_id + 1", and then you
> don't have to pass around &oid at all?

yeah I think it can be removed (haven't noticed that it's not needed
anymore), I will resend it together with fix to another your comment

> 
> --D
> 
> > -		while (get_dquot(&d, id, &oid, type, mount->fs_name,
> > -					GETNEXTQUOTA_FLAG)) {
> > -			dump_file(fp, &d, mount->fs_name);
> > -			id = oid + 1;
> > -		}
> > -		return;
> > +		flags |= GETNEXTQUOTA_FLAG;
> >  	}
> >  
> > +	if (flags & GETNEXTQUOTA_FLAG)
> > +		return;
> > +
> >  	/* Otherwise fall back to iterating over each uid/gid/prjid */
> >  	switch (type) {
> >  	case XFS_GROUP_QUOTA: {
> > @@ -472,31 +462,19 @@ report_user_mount(
> >  {
> >  	struct passwd	*u;
> >  	struct fs_disk_quota	d;
> > -	uint		id = 0, oid;
> > +	uint		id = lower, oid;
> >  
> > -	if (upper) {	/* identifier range specified */
> > -		for (id = lower; id <= upper; id++) {
> > -			if (get_dquot(&d, id, NULL, XFS_USER_QUOTA,
> > -						mount->fs_name, flags)) {
> > -				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> > -						mount, flags);
> > -				flags |= NO_HEADER_FLAG;
> > -			}
> > -		}
> > -	} else if (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
> > -				flags|GETNEXTQUOTA_FLAG)) {
> > -		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
> > -			flags|GETNEXTQUOTA_FLAG);
> > +	while (get_dquot(&d, id, &oid, XFS_USER_QUOTA,
> > +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> > +			!(upper && (d.d_id > upper))) {
> > +		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
> >  		id = oid + 1;
> >  		flags |= GETNEXTQUOTA_FLAG;
> >  		flags |= NO_HEADER_FLAG;
> > -		while (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
> > -				flags)) {
> > -			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
> > -				mount, flags);
> > -			id = oid + 1;
> > -		}
> > -	} else {
> > +	}
> > +
> > +	/* No GETNEXTQUOTA support, iterate over all from password file */
> > +	if (!(flags & GETNEXTQUOTA_FLAG)) {
> >  		setpwent();
> >  		while ((u = getpwent()) != NULL) {
> >  			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
> > @@ -524,31 +502,19 @@ report_group_mount(
> >  {
> >  	struct group	*g;
> >  	struct fs_disk_quota	d;
> > -	uint		id = 0, oid;
> > +	uint		id = lower, oid;
> >  
> > -	if (upper) {	/* identifier range specified */
> > -		for (id = lower; id <= upper; id++) {
> > -			if (get_dquot(&d, id, NULL, XFS_GROUP_QUOTA,
> > -						mount->fs_name, flags)) {
> > -				report_mount(fp, &d, NULL, form,
> > -						XFS_GROUP_QUOTA, mount, flags);
> > -				flags |= NO_HEADER_FLAG;
> > -			}
> > -		}
> > -	} else if (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> > -				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> > -		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> > -				flags|GETNEXTQUOTA_FLAG);
> > +	while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> > +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> > +			!(upper && (oid > upper))) {
> > +		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
> >  		id = oid + 1;
> >  		flags |= GETNEXTQUOTA_FLAG;
> >  		flags |= NO_HEADER_FLAG;
> > -		while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
> > -					mount->fs_name, flags)) {
> > -			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
> > -					flags);
> > -			id = oid + 1;
> > -		}
> > -	} else {
> > +	}
> > +
> > +	/* No GETNEXTQUOTA support, iterate over all from password file */
> > +	if (!(flags & GETNEXTQUOTA_FLAG)) {
> >  		setgrent();
> >  		while ((g = getgrent()) != NULL) {
> >  			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
> > @@ -575,31 +541,19 @@ report_project_mount(
> >  {
> >  	fs_project_t	*p;
> >  	struct fs_disk_quota	d;
> > -	uint		id = 0, oid;
> > +	uint		id = lower, oid;
> >  
> > -	if (upper) {	/* identifier range specified */
> > -		for (id = lower; id <= upper; id++) {
> > -			if (get_dquot(&d, id, NULL, XFS_PROJ_QUOTA,
> > -						mount->fs_name, flags)) {
> > -				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
> > -						mount, flags);
> > -				flags |= NO_HEADER_FLAG;
> > -			}
> > -		}
> > -	} else if (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> > -				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
> > -		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> > -				flags|GETNEXTQUOTA_FLAG);
> > +	while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> > +				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
> > +			!(upper && (d.d_id > upper))) {
> > +		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
> >  		id = oid + 1;
> >  		flags |= GETNEXTQUOTA_FLAG;
> >  		flags |= NO_HEADER_FLAG;
> > -		while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
> > -					mount->fs_name, flags)) {
> > -			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
> > -					flags);
> > -			id = oid + 1;
> > -		}
> > -	} else {
> > +	}
> > +
> > +	/* No GETNEXTQUOTA support, iterate over all */
> > +	if (!(flags & GETNEXTQUOTA_FLAG)) {
> >  		if (!getprprid(0)) {
> >  			/*
> >  			 * Print default project quota, even if projid 0
> > -- 
> > 2.27.0
> > 
> 

-- 
- Andrey

