Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6DB15B108
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 09:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715334098; cv=none; b=PgeRHyPpbQF0oenEJMafZwZevac9bzZu82szhdWBUm99YgQhdbfM5TsIqIaSgHOm0/ISRcq24UKBCkyvmXNdVSzTRZqw6UB6FmfGZd0N2OwHsAcFls3H09oYoOvHozqbN6F/l9IAqG2Ro+sX45bIfGd82435frdeMYbTfGNPf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715334098; c=relaxed/simple;
	bh=tRlMSSKU4GxmnZd/YKlt+r95N348jaoshfQhAu1KN58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jldKS4HCfYXweso0YLm+D6NZ3s45ZBAfI6lj5HRI+/JLNhZeLkJJqUQtJ8eIPQIVd12TFEir2MYS+H9YHaeREJif6LQMrvr018uoR9tsW35Ol6nSUUQHcX6UklVkWsL1++LGC3bZGD2wUDno8e20Jg4I3BQDIsdXHHjSS/TJ3b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ie1d+OVD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ie1d+OVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715334095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK7pemXvh2SgDXvj1ra5jlmBVQFQWAYmH8jPesF9cTQ=;
	b=Ie1d+OVDE7vnsHUjmlgNVO3UuEQRZj4GNx4tGf7lk7CPXWoyQVDFMCucCsumU4A+FvBjGp
	cM3Cm9M8fpxfZsjJslNvDDsWjIPlC9VpWqS/N6c6ZOzPqGBXo9q7SAshpvJy03u72s7CZC
	+8IugRtFCSlLmj+5lVU4OMrRnZRZgqo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-1x5L07r4OHG2-GNC4wcoyQ-1; Fri, 10 May 2024 05:41:33 -0400
X-MC-Unique: 1x5L07r4OHG2-GNC4wcoyQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-57352b195afso449114a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 02:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715334092; x=1715938892;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YK7pemXvh2SgDXvj1ra5jlmBVQFQWAYmH8jPesF9cTQ=;
        b=jcOSjAtl33EuJRKD9VvhJZG6nalGTkpi9ZJTn42zT8GxyJ1vzCneNq5mmwOzOOX7dY
         YKDULw3QSr10M8czEI6dx+Pshux5gzCoiRiYApccBLD6LXD3dc/OuEvGajq/DXvAYla2
         DrwDf+8RllfD0m8J3qAiLxALvt3VKmVz72FzOI3gZPIDdvBycsAqkhDOgrk+6mBGNJWD
         2nYC6+F+9dTQ+xTeRUIRQGPQcLwYT1WkEAEHxAuke9oXqsvcX+6MS12DmV1eysb4ZBfs
         FM67RUKVRkmRr2FyI9KIVW7jjRY8iaDf/J9DPEY6S8qrR4mRM4U6crLyp5HIW3fb3NQe
         o4ww==
X-Forwarded-Encrypted: i=1; AJvYcCWeqBNQz6KMXZw20oj+EorOCbrB57C6P77rfeYPfqMCygstjQ1gjGRtZeULZgU8Kr7eTDvaHGBhAozGIpaYzD345xOA3Ij3xhrF
X-Gm-Message-State: AOJu0YxEwZPBaQfNwBS47IGED5vhoDYKJCNPnPbemA0EsPYn+SIU5V95
	A/Un6csWRxXCmjEz+X/okMvXVdPM+wvjNj6DnKwAAK86+SaLCUGRBB9/gWxV4mfpHDe9H2oB3yY
	mswhoxdGw89Qs5+SDFueQNnClAHUXDCGsVNzHUOeisNVUQCSG4vrjkcAY6jpRjOUD
X-Received: by 2002:a50:a6c9:0:b0:571:fc02:1ce with SMTP id 4fb4d7f45d1cf-5734d6b1f3cmr1288423a12.38.1715334092114;
        Fri, 10 May 2024 02:41:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0sHv5UQeY7+bSzkltxWgzYBH0chfAY+6K5ySAmWBqaNS2UYew0pvc19ajE0cEZ8F2fcH/oQ==
X-Received: by 2002:a50:a6c9:0:b0:571:fc02:1ce with SMTP id 4fb4d7f45d1cf-5734d6b1f3cmr1288398a12.38.1715334091490;
        Fri, 10 May 2024 02:41:31 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733bea6704sm1634749a12.3.2024.05.10.02.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:41:31 -0700 (PDT)
Date: Fri, 10 May 2024 11:41:30 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: allow renames of project-less inodes
Message-ID: <qshbjpdltobq5j2fqba3ahyws2lwpfyxbojvhxgrsxtmzppz5j@ac24yd6o7saq>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-4-aalbersh@redhat.com>
 <20240509232805.GS360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509232805.GS360919@frogsfrogsfrogs>

On 2024-05-09 16:28:05, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 05:14:58PM +0200, Andrey Albershteyn wrote:
> > Identical problem as worked around in commit e23d7e82b707 ("xfs:
> > allow cross-linking special files without project quota") exists
> > with renames. Renaming special file without project ID is not
> > possible inside PROJINHERIT directory.
> > 
> > Special files inodes can not have project ID set from userspace and
> > are skipped during initial project setup. Those inodes are left
> > project-less in the project directory. New inodes created after
> > project initialization do have an ID. Creating hard links or
> > renaming those project-less inodes then fails on different ID check.
> > 
> > Add workaround to allow renames of special files without project ID.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 58fb7a5062e1..508113515eec 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3275,8 +3275,19 @@ xfs_rename(
> >  	 */
> >  	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> >  		     target_dp->i_projid != src_ip->i_projid)) {
> > -		error = -EXDEV;
> > -		goto out_trans_cancel;
> > +		/*
> > +		 * Project quota setup skips special files which can
> > +		 * leave inodes in a PROJINHERIT directory without a
> > +		 * project ID set. We need to allow renames to be made
> > +		 * to these "project-less" inodes because userspace
> > +		 * expects them to succeed after project ID setup,
> > +		 * but everything else should be rejected.
> > +		 */
> > +		if (!special_file(VFS_I(src_ip)->i_mode) ||
> > +		    src_ip->i_projid != 0) {
> > +			error = -EXDEV;
> > +			goto out_trans_cancel;
> > +		}
> >  	}
> 
> Should this be a shared helper called by xfs_rename and xfs_link?

yeah, it can be

> 
> --D
> 
> >  
> >  	/* RENAME_EXCHANGE is unique from here on. */
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

