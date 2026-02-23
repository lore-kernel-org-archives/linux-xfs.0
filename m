Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E833CE86
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771870767; cv=none; b=dOm34rp/Z0zaVfV90gMI0MLd331pombGXDplaU/aUQVeXS22QvkFEvpMUBEwP5WY/6afJz3KSAT10UUXTg+5uZ6LvINFmIxTr6JwclSW+jyh9v1XOmC4f8WSScsfabdRmsXzlsiVZMtdx8HmiBlEvKQrlOk7tECxFi8De03ql8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771870767; c=relaxed/simple;
	bh=tYg6lKXCrXqkSRjroh8xnR35YcUacejrcTuL0nB1Jg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyOXd1sxAFmquiqHibuIiNkbKetxsyzYQuUi2FnsN5a22jZQQhHhvEE3O0x9+5xYmn3XTw7UwBpHT0fT15pvetzgdRrdGRO5L3txhr7QIa0e++e5T6CkpcQLhOMu7XARoyBFGncMqikT2t6DOWRNg9eVJpi9ULIfNbOU1raCJS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aB+cCavL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CMELSw5N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aB+cCavL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CMELSw5N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771870763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5ifqmgc0Bd/dYXqGP8nteQfhBSpKJvq3ZUBjnYwveQk=;
	b=aB+cCavLs+zm+jpCb/2mr4KCcVI/Ye/8MYApgLMtX5j7MYq1uXd+NlqcWmpRPy1Bne+oJK
	HJ7m+/COGrks5e/ZXSRHHju9+yTkdGv4eL9Q4j6k4qSsw1kqKrJDDvORih7AmSTBGd9Zrh
	BqLhXxpQEayspziUcGESAyr1LNHaKtQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-Yo-q6gt2OOiTmxO1jzRMVw-1; Mon, 23 Feb 2026 13:19:21 -0500
X-MC-Unique: Yo-q6gt2OOiTmxO1jzRMVw-1
X-Mimecast-MFC-AGG-ID: Yo-q6gt2OOiTmxO1jzRMVw_1771870760
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435991d4a3aso3245271f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 10:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771870760; x=1772475560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ifqmgc0Bd/dYXqGP8nteQfhBSpKJvq3ZUBjnYwveQk=;
        b=CMELSw5NQJZgvFoLaBpbPb1/kcl8z9hiFK1axxzRKIYj/cKHBd8TcFAQRBDQlAV89K
         /TbZcIVev1E0JhbF5gforNUnGeN42pKxtXql1aOy1A4Src5po27AMxtjZmUExep7IFk+
         ewvc/ruAWYsgl+QYimErrT7Nlp0m8V9ieOsZzA40G1e1RvmVrNFvHDH5AvjxkZsKbbPQ
         7o6GG8G2qnRs/cdwCmrVg0AnOCXY4sc1gFVLIO6vRMZ+8qGZQE469byx6HdLIPIIUEpc
         Afjld7IfKjFwzF7g3BYhgtVp0U8tLHgQ9Macj6YxYIyN9ZLIWL/Oj/vQX2qIZOWeC+al
         QkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771870760; x=1772475560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ifqmgc0Bd/dYXqGP8nteQfhBSpKJvq3ZUBjnYwveQk=;
        b=vpLKg6pg1c6H6Xkc8uQ0fnVUI/vEI6kL7DxL5pVIhb+47RLYPY3tsmMZ0GEi2AIgEX
         19FCWrcF7BkCFFvjmZeOlx0tDcviq1Pss6yn49j4hZNbXUUqIjbqFBKMUYYdA7hRsZ/9
         j6gjq1CPsC8c8jomvo1CUG57uXJHjkFaMPcUdLZA46hdMrpyFku/jUrbSrroKRplmRW4
         bQiqE5pzyPHklPYR6gLf0Otk9yybyL2uO+VqZ28mzwJPq4xVMFKNej+R5yk1M9KBuDeK
         +ouIk2RiaHDScyNf07ivx5F+ISer8jgSUnwP2vMm5qEWpOEzZ8JViRMdnjPcAlpKkrjp
         UNqw==
X-Forwarded-Encrypted: i=1; AJvYcCVawgddYlaSRtBM7JFmvVIofBPNkBlMONJBxMtJFYKVdna6CPwiEQ2PcThLGaxOgs5gIFzwSY9lLwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJAb4b4pqnVukUQtyulvRxlXDISrEwLUQxodsXdRgLwv6q2H/g
	K6Y5bgHH5M4QqZM6U9lFJSjnsC1wrAz3sPhzomfQJChwrUhDcxhIvtVfRJkwRPFn5kGmL4F+t3S
	4oRlrq3egqLaAWFeMdDEdnmZ7BuqAjnLrGtUKprK+AZv6a34R/EhKdvQDtbNA
X-Gm-Gg: ATEYQzyyY6hUeKzm4eoKtYQAT/60YofLTrr34wkQ0bG77sn/jrNIoDAfdhDpGCG+SJy
	EWgDnoxI18IuKDoLMwqd6MEVZsXbFZuUWUYBO68Z39wgAM7JKPXoSFkQZJp8z5l83FJo1F+FiEE
	iK1Z/M5LzEmHODJLV6YxOd39czoaModtnT7+TI284fZgk0b4ESUu+/Rc/NjjJN524zp0HTw4Ezm
	H93uOm6gvNtxhlftpRPX0dmEzm4bY+R3Ay3B+qQSIMvUKUFa3pWGxGzG/5lam7gWN6BSXRUGDe0
	1Lwifaapqmhh7MeKoPiS4Jr9Z2tGprnWZdGSjGBpC/HJWxaYFmu5bsoIk9hQgyUhD8Gc+6lGiq4
	Z8ZhdKF7comw=
X-Received: by 2002:a05:6000:2301:b0:435:a501:359 with SMTP id ffacd0b85a97d-4396f18a666mr17997606f8f.41.1771870760132;
        Mon, 23 Feb 2026 10:19:20 -0800 (PST)
X-Received: by 2002:a05:6000:2301:b0:435:a501:359 with SMTP id ffacd0b85a97d-4396f18a666mr17997554f8f.41.1771870759664;
        Mon, 23 Feb 2026 10:19:19 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970c08b9csm23518931f8f.16.2026.02.23.10.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 10:19:19 -0800 (PST)
Date: Mon, 23 Feb 2026 19:19:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 33/35] xfs: introduce health state for corrupted
 fsverity metadata
Message-ID: <zv5rshpef3fti4ldwhfcaekmjjzcwtxr3fgtabwyufkhcn4gvw@uk4ojtvmxquc>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-34-aalbersh@kernel.org>
 <20260219173427.GL6490@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219173427.GL6490@frogsfrogsfrogs>

On 2026-02-19 09:34:27, Darrick J. Wong wrote:
> On Wed, Feb 18, 2026 at 12:19:33AM +0100, Andrey Albershteyn wrote:
> > Report corrupted fsverity descriptor through health system.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> Looks good to me, though I'll have to revisit this with a sharper eye
> for what happens if/when you rebase to use fserror_*.
> 
> IIRC inconsistencies between the merkle tree and the file data are
> reported as -EIO, right?

iomap reports -EIO on the file data read, and fsverity_verify_bio()
will report block size failure with fserror_report_data_lost().

> And at that point we have the file range
> information, so we could actually use fserror_report_data_lost.
> 
> I forget, what do we do for inconsistencies between an internal node of
> the merkle tree and the next level down?  That sounds like something
> that should set XFS_SICK_INO_FSVERITY, right?

It's done by fsverity itself in verify_data_block() and will be
reported with fserror_report_data_lost().

> For this bit involving just the fsverity descriptor,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks!

> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_fs.h     |  1 +
> >  fs/xfs/libxfs/xfs_health.h |  4 +++-
> >  fs/xfs/xfs_fsverity.c      | 13 ++++++++++---
> >  fs/xfs/xfs_health.c        |  1 +
> >  4 files changed, 15 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 36a87276f0b7..d8be7fe93382 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -423,6 +423,7 @@ struct xfs_bulkstat {
> >  #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
> >  #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
> >  #define XFS_BS_SICK_DATA	(1 << 9)  /* file data */
> > +#define XFS_BS_SICK_FSVERITY	(1 << 10) /* fsverity metadata */
> >  
> >  /*
> >   * Project quota id helpers (previously projid was 16bit only
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > index fa91916ad072..c534aacf3199 100644
> > --- a/fs/xfs/libxfs/xfs_health.h
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -105,6 +105,7 @@ struct xfs_rtgroup;
> >  #define XFS_SICK_INO_FORGET	(1 << 12)
> >  #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
> >  #define XFS_SICK_INO_DATA	(1 << 14)  /* file data */
> > +#define XFS_SICK_INO_FSVERITY	(1 << 15)  /* fsverity metadata */
> >  
> >  /* Primary evidence of health problems in a given group. */
> >  #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
> > @@ -142,7 +143,8 @@ struct xfs_rtgroup;
> >  				 XFS_SICK_INO_SYMLINK | \
> >  				 XFS_SICK_INO_PARENT | \
> >  				 XFS_SICK_INO_DIRTREE | \
> > -				 XFS_SICK_INO_DATA)
> > +				 XFS_SICK_INO_DATA | \
> > +				 XFS_SICK_INO_FSVERITY)
> >  
> >  #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
> >  				 XFS_SICK_INO_BMBTA_ZAPPED | \
> > diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> > index 5a2874236c3c..d89512d59328 100644
> > --- a/fs/xfs/xfs_fsverity.c
> > +++ b/fs/xfs/xfs_fsverity.c
> > @@ -197,16 +197,23 @@ xfs_fsverity_get_descriptor(
> >  		return error;
> >  
> >  	desc_size = be32_to_cpu(d_desc_size);
> > -	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
> > +	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE)) {
> > +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
> >  		return -ERANGE;
> > -	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
> > +	}
> > +
> > +	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos)) {
> > +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
> >  		return -ERANGE;
> > +	}
> >  
> >  	if (!buf_size)
> >  		return desc_size;
> >  
> > -	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
> > +	if (XFS_IS_CORRUPT(mp, desc_size > buf_size)) {
> > +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
> >  		return -ERANGE;
> > +	}
> >  
> >  	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
> >  	error = xfs_fsverity_read(inode, buf, desc_size, desc_pos);
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index b851651c02b2..e52ee02f7d7c 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -488,6 +488,7 @@ static const struct ioctl_sick_map ino_map[] = {
> >  	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
> >  	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
> >  	{ XFS_SICK_INO_DATA,	XFS_BS_SICK_DATA },
> > +	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
> >  };
> >  
> >  /* Fill out bulkstat health info. */
> > -- 
> > 2.51.2
> > 
> > 
> 

-- 
- Andrey

