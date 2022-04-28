Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC64C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiD1Mq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344020AbiD1Mqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:46:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 286EBBE0C
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651149820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z5o9kbVhRSXBv8EFq0rMV66jM6t6vAEtw7pKJaiBSqY=;
        b=FqGJ4cIiZdff089+0YBv2Z3TGYJw0s40hIRwvH9zYN/5WaHnSRtJuLA/LFIuDNM4XumQQj
        YZqSqRNDZaSHi+0hmQgI3xdBDkm1BPsFNtnCryxfMSwxzchQB/zDNSvBDK0tLFLAoa7ny2
        YraHaW/gx1wUS3wqJhTTKodPaPI+KPc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-rW9x2PhXPKCOGloIBbKDwA-1; Thu, 28 Apr 2022 08:43:39 -0400
X-MC-Unique: rW9x2PhXPKCOGloIBbKDwA-1
Received: by mail-wm1-f71.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso1500485wmq.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z5o9kbVhRSXBv8EFq0rMV66jM6t6vAEtw7pKJaiBSqY=;
        b=ZGfLWvIpIi1EcRWLM7uKeiaT4MoeUM/XGP2y9M6XAKrlBSyXqRbI6T+xbhmxOQeJin
         0Kn4ulxoA07qHaSHn4K62GlozQIRblQz/SwsFuTYy6ciSQFMfKClvIVf4Z0hNb4DEL5v
         +uFDIMXxHLTTs9n4TK/TSA9IsDTQoz+SLxgSwFoh4PgD8z9djrcOuby/7W/TGlrNQ9PF
         G3DqozM6roJYIt4CpoLlDjEP2SyPVAmLSQwKpep/tNAxqKXUDSDnmNEWuHARiBE8iezC
         LOzfCiuiaunoP6aPd1cRhtTWPKoLHtYNgWbUdVIPvklld43PUs3rKS1ESn0W+7cGvS6X
         Q8jQ==
X-Gm-Message-State: AOAM5324xCNqKpsi58mvVrmVl/sR4RJzGactOS6ERQzKQNkT903RPH/9
        Rmk2S1CHQZ//nzJcm3kNMXecSjU57jcqpLnBDZztZlkGAHsqB8zyzo6QneuwXf/YMTU/V2Fcdah
        aRLbkEYXvzaKagOqz8dc=
X-Received: by 2002:a5d:40cf:0:b0:20a:e0cf:2a47 with SMTP id b15-20020a5d40cf000000b0020ae0cf2a47mr12735288wrq.575.1651149817611;
        Thu, 28 Apr 2022 05:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznFYJKVtyg8aUrt3w4hAzk4/6jR4EMPpSAduNdO9oXnQqs7qc4vVt5ROTTZEF8GW3KIIv74g==
X-Received: by 2002:a5d:40cf:0:b0:20a:e0cf:2a47 with SMTP id b15-20020a5d40cf000000b0020ae0cf2a47mr12735277wrq.575.1651149817430;
        Thu, 28 Apr 2022 05:43:37 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j29-20020a05600c1c1d00b0039419ad13a4sm297642wms.2.2022.04.28.05.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 05:43:36 -0700 (PDT)
Date:   Thu, 28 Apr 2022 14:43:35 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] xfs_quota: separate get_dquot() and dump_file()
Message-ID: <YmqL94LMw1MnKWS2@aalbersh.remote.csb>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-3-aalbersh@redhat.com>
 <20220425162836.GH17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425162836.GH17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 09:28:36AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 20, 2022 at 04:45:05PM +0200, Andrey Albershteyn wrote:
> > Separate quota info acquisition from outputting it to file. This
> > allows upper functions to filter obtained info (e.g. within specific
> > ID range).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  quota/report.c | 86 ++++++++++++++++++++++++++------------------------
> >  1 file changed, 45 insertions(+), 41 deletions(-)
> > 
> > diff --git a/quota/report.c b/quota/report.c
> > index cccc654e..d5c6f84f 100644
> > --- a/quota/report.c
> > +++ b/quota/report.c
> > @@ -96,39 +96,31 @@ get_dquot(
> >  static int
> >  dump_file(
> 
> I kinda wonder if this ought to be named 'dump_dquot' since it's not
> really dumping a file or even the dquots of a specifc file.  OTOH, the
> rest of the utility seems to have similar naming conventions for "report
> something to a FILE* stream" so

yeah, I also think that names are not very descriptive, but I didn't
want to change too many things. There's also space to merge report*
functions :)

> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> >  	FILE		*fp,
> > -	uint		id,
> > -	uint		*oid,
> > -	uint		type,
> > -	char		*dev,
> > -	int		flags)
> > +	struct fs_disk_quota *d,
> > +	char		*dev)
> >  {
> > -	fs_disk_quota_t	d;
> > -
> > -	if (!get_dquot(&d, id, oid, type, dev, flags))
> > -		return 0;
> > -
> > -	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
> > -	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
> > -	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
> > +	if (!d->d_blk_softlimit && !d->d_blk_hardlimit &&
> > +	    !d->d_ino_softlimit && !d->d_ino_hardlimit &&
> > +	    !d->d_rtb_softlimit && !d->d_rtb_hardlimit)
> >  		return 1;
> >  	fprintf(fp, "fs = %s\n", dev);
> >  	/* this branch is for backward compatibility reasons */
> > -	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
> > +	if (d->d_rtb_softlimit || d->d_rtb_hardlimit)
> >  		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n",
> > -			d.d_id,
> > -			(unsigned long long)d.d_blk_softlimit,
> > -			(unsigned long long)d.d_blk_hardlimit,
> > -			(unsigned long long)d.d_ino_softlimit,
> > -			(unsigned long long)d.d_ino_hardlimit,
> > -			(unsigned long long)d.d_rtb_softlimit,
> > -			(unsigned long long)d.d_rtb_hardlimit);
> > +			d->d_id,
> > +			(unsigned long long)d->d_blk_softlimit,
> > +			(unsigned long long)d->d_blk_hardlimit,
> > +			(unsigned long long)d->d_ino_softlimit,
> > +			(unsigned long long)d->d_ino_hardlimit,
> > +			(unsigned long long)d->d_rtb_softlimit,
> > +			(unsigned long long)d->d_rtb_hardlimit);
> >  	else
> >  		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n",
> > -			d.d_id,
> > -			(unsigned long long)d.d_blk_softlimit,
> > -			(unsigned long long)d.d_blk_hardlimit,
> > -			(unsigned long long)d.d_ino_softlimit,
> > -			(unsigned long long)d.d_ino_hardlimit);
> > +			d->d_id,
> > +			(unsigned long long)d->d_blk_softlimit,
> > +			(unsigned long long)d->d_blk_hardlimit,
> > +			(unsigned long long)d->d_ino_softlimit,
> > +			(unsigned long long)d->d_ino_hardlimit);
> >  
> >  	return 1;
> >  }
> > @@ -142,6 +134,7 @@ dump_limits_any_type(
> >  	uint		upper)
> >  {
> >  	fs_path_t	*mount;
> > +	struct fs_disk_quota d;
> >  	uint		id = 0, oid;
> >  
> >  	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
> > @@ -153,46 +146,57 @@ dump_limits_any_type(
> >  
> >  	/* Range was specified; query everything in it */
> >  	if (upper) {
> > -		for (id = lower; id <= upper; id++)
> > -			dump_file(fp, id, NULL, type, mount->fs_name, 0);
> > +		for (id = lower; id <= upper; id++) {
> > +			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
> > +			dump_file(fp, &d, mount->fs_name);
> > +		}
> >  		return;
> >  	}
> >  
> >  	/* Use GETNEXTQUOTA if it's available */
> > -	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> > +	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
> > +		dump_file(fp, &d, mount->fs_name);
> >  		id = oid + 1;
> > -		while (dump_file(fp, id, &oid, type, mount->fs_name,
> > -				 GETNEXTQUOTA_FLAG))
> > +		while (get_dquot(&d, id, &oid, type, mount->fs_name,
> > +					GETNEXTQUOTA_FLAG)) {
> > +			dump_file(fp, &d, mount->fs_name);
> >  			id = oid + 1;
> > +		}
> >  		return;
> > -        }
> > +	}
> >  
> >  	/* Otherwise fall back to iterating over each uid/gid/prjid */
> >  	switch (type) {
> >  	case XFS_GROUP_QUOTA: {
> >  			struct group *g;
> >  			setgrent();
> > -			while ((g = getgrent()) != NULL)
> > -				dump_file(fp, g->gr_gid, NULL, type,
> > -					  mount->fs_name, 0);
> > +			while ((g = getgrent()) != NULL) {
> > +				get_dquot(&d, g->gr_gid, NULL, type,
> > +						mount->fs_name, 0);
> > +				dump_file(fp, &d, mount->fs_name);
> > +			}
> >  			endgrent();
> >  			break;
> >  		}
> >  	case XFS_PROJ_QUOTA: {
> >  			struct fs_project *p;
> >  			setprent();
> > -			while ((p = getprent()) != NULL)
> > -				dump_file(fp, p->pr_prid, NULL, type,
> > -					  mount->fs_name, 0);
> > +			while ((p = getprent()) != NULL) {
> > +				get_dquot(&d, p->pr_prid, NULL, type,
> > +						mount->fs_name, 0);
> > +				dump_file(fp, &d, mount->fs_name);
> > +			}
> >  			endprent();
> >  			break;
> >  		}
> >  	case XFS_USER_QUOTA: {
> >  			struct passwd *u;
> >  			setpwent();
> > -			while ((u = getpwent()) != NULL)
> > -				dump_file(fp, u->pw_uid, NULL, type,
> > -					  mount->fs_name, 0);
> > +			while ((u = getpwent()) != NULL) {
> > +				get_dquot(&d, u->pw_uid, NULL, type,
> > +						mount->fs_name, 0);
> > +				dump_file(fp, &d, mount->fs_name);
> > +			}
> >  			endpwent();
> >  			break;
> >  		}
> > -- 
> > 2.27.0
> > 
> 

-- 
- Andrey

