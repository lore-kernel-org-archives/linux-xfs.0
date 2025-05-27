Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F7E1C3BFC
	for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748380347; cv=none; b=VVXQadN+ML8KLseBxip4nEli/BgfoRlUm1unUYoh4qg7GDdLvtJlZ4SOC58OBbSX8pmhtcNsLS4MZiiCwKXvJAfVFQzcUU9L17PbRHiIQLqKZ/TYGIF6+Rb+LfildRoxOXNR4KOeI7nLfIv54/lcd9jdcip8TfKC3oh9j0+hdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748380347; c=relaxed/simple;
	bh=DQ7gvIg477mXkbwD+tqhbnf21WuB0ClZJXQEpiX+dCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebne5+tXCKiTnZRg5ZOh2Km/38jCwO0mimHUmMvljddGcrjyn+Lohapfk9cyOxCKsgAqIK61iETtOt/ZR8iVY8pJwjun8LcUoZVHcA7Sv/RuyCZIrYYif7ZHYUTVt8HCd683N786AuRSkuzls0OD4fjSg0DVnzmsVY7rcePhLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Sa1/xR6g; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Sa1/xR6g"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-231e98e46c0so31933285ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 14:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1748380345; x=1748985145; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqliXQh59DYt1kumcR2EztTwEVCDnwBbbaZcfU/tuM4=;
        b=Sa1/xR6gHko5zgyhIu5i6eiULqSTRMOyDU8xc8OUXRdHCcTM03heekBqJZFmkFWvYT
         UX59zj+ftWpE66bntAYtl+Ax6+GLkYBWlQb/lkBR1t09niGebSsotQ1adDNtOKqmFmLJ
         RWpCIQGNcY6CxahzlF3I5tTBWUw/pu3OgNZlIMtIsZzR8y3Fas3JeM0ek7e2beK2RLyU
         SidLpEOSK6DKfolP8iZrPCMnqA9eW05Hd8gBCjPYtwAQfqgBCgQMPBzil81HX8jxbGWB
         xSwLsk87TbIyBhqBZr/QffQa9s6tZ4xVyO4BsIsINE++Vv79gUqueu7WGNgnfRq9yCcZ
         v8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748380345; x=1748985145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqliXQh59DYt1kumcR2EztTwEVCDnwBbbaZcfU/tuM4=;
        b=e6rCyeIO7cKND2AhB6ZoLsmAcjD9Fl2ggrMu8iUllFcHL9m0AdSEjP/+MnvEKSNExZ
         3SxCAYs0ioNG5O0Hy3N/PQfCrOsafdj8zqucoHzrXLiWemUrvGbGu99ssQ1IrcDwT/h8
         eUg+skAu4H5+8Sw9RuGmlmw2auNkO+zlhVh8UNSXtDQw94nnBy/Clj7AtxDQxHH8Kji7
         /R+KTddf5rq5zOqVIryum0L5b4zankxKIiQPf/Nj2oGI9pvBZFcaEfkoI7MjDzmmDYYJ
         Vy3jU6FHiGtDLnZAoGMVaElKHTJcLQs/sB7knQVQEUCMBEi2LAoMqQWW7YvGR4+DiClj
         FIxg==
X-Forwarded-Encrypted: i=1; AJvYcCVRZ8O54pYdr/WBd5jbNOtwAv6ohmQ7vRXPmcauwdgWZfvGojRTdiST1Rk958D8JSpInHRprp9o118=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ZVr+63jtejCLbeDEPd+BrW0d5t5Mh++PA/YRVxyN//yrvqK4
	aZ2+0o0++LkW1Xs1i3Qc+8DdQCFDmCchRj4R4xG/EI8E/WjNVv5SSZvpB7sh7/6+i+I=
X-Gm-Gg: ASbGncub3X/scqY8UHxXFy2DY2gX8ZvdNgAgoiqhzTZcBX15oFUCWUPTjDFbEuV5Zzu
	Q7QYlRitSlylyTzFCa0b15rpQX83F9uoWbDsqWa/dNlt/tVYquyM3gHOI8gSspp5YWTbMU89RMB
	1O4zhX6mlSBvafyPYzzj0+A7J+Q32goMXmZnDM2jHpgBlYRAcAnpNDnCod3528fS1mCQ+0CbE6W
	xL3acFQred3dix0ZBsMfIB+JabJ/6zGbw5oK5CDRDNh5aIMFK0f6XBcii6B+Pd3YbEh+p+KCxhg
	z+30Nqga3Vb9z7A5npTCcBXSuS+aHK9kQof0VZrBzv8EFMC8h5gVstM9NXWUxdICDrwcjbrr/yl
	8wio/ouwQTTfQQygN7YLujYjdx/4=
X-Google-Smtp-Source: AGHT+IGy9c1SIpR62DuX3RY6owTyXe677BgnxKCJ9+xqz0YJshlg1pIkj1ulbuns/NCIo5SMedW9fA==
X-Received: by 2002:a17:903:198c:b0:21a:8300:b9d5 with SMTP id d9443c01a7336-23414f6185cmr201233445ad.23.1748380345232;
        Tue, 27 May 2025 14:12:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-234cc2363b1sm236395ad.174.2025.05.27.14.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 14:12:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uK1aw-00000008wla-0J4N;
	Wed, 28 May 2025 07:12:22 +1000
Date: Wed, 28 May 2025 07:12:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: don't lose folio dropbehind state for overwrites
Message-ID: <aDYqtuXdLvcSl78t@dread.disaster.area>
References: <a61432ad-fa05-4547-ab82-8d2f74d84038@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a61432ad-fa05-4547-ab82-8d2f74d84038@kernel.dk>

On Tue, May 27, 2025 at 09:43:42AM -0600, Jens Axboe wrote:
> DONTCACHE I/O must have the completion punted to a workqueue, just like
> what is done for unwritten extents, as the completion needs task context
> to perform the invalidation of the folio(s). However, if writeback is
> started off filemap_fdatawrite_range() off generic_sync() and it's an
> overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
> don't look at the folio being added and no further state is passed down
> to help it know that this is a dropbehind/DONTCACHE write.
> 
> Check if the folio being added is marked as dropbehind, and set
> IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
> the decision making of completion context in xfs_submit_ioend().
> Additionally include this ioend flag in the NOMERGE flags, to avoid
> mixing it with unrelated IO.
> 
> This fixes extra page cache being instantiated when the write performed
> is an overwrite, rather than newly instantiated blocks.
> 
> Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> Found this one while testing the unrelated issue of invalidation being a
> bit broken before 6.15 release. We need this to ensure that overwrites
> also prune correctly, just like unwritten extents currently do.

I wondered about the stack traces showing DONTCACHE writeback
completion being handled from irq context[*] when I read the -fsdevel
thread about broken DONTCACHE functionality yesterday.

[*] second trace in the failure reported in this comment:

https://lore.kernel.org/linux-fsdevel/432302ad-aa95-44f4-8728-77e61cc1f20c@kernel.dk/

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 233abf598f65..3729391a18f3 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1691,6 +1691,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
>  		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
>  	if (wpc->iomap.flags & IOMAP_F_SHARED)
>  		ioend_flags |= IOMAP_IOEND_SHARED;
> +	if (folio_test_dropbehind(folio))
> +		ioend_flags |= IOMAP_IOEND_DONTCACHE;
>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>  
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 26a04a783489..1b7a006402ea 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -436,6 +436,9 @@ xfs_map_blocks(
>  	return 0;
>  }
>  
> +#define IOEND_WQ_FLAGS	(IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED | \
> +			 IOMAP_IOEND_DONTCACHE)
> +
>  static int
>  xfs_submit_ioend(
>  	struct iomap_writepage_ctx *wpc,
> @@ -460,8 +463,7 @@ xfs_submit_ioend(
>  	memalloc_nofs_restore(nofs_flag);
>  
>  	/* send ioends that might require a transaction to the completion wq */
> -	if (xfs_ioend_is_append(ioend) ||
> -	    (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED)))
> +	if (xfs_ioend_is_append(ioend) || ioend->io_flags & IOEND_WQ_FLAGS)
>  		ioend->io_bio.bi_end_io = xfs_end_bio;
>  
>  	if (status)

IMO, this would be cleaner as a helper so that individual cases can
be commented correctly, as page cache invalidation does not actually
require a transaction...

Something like:

static bool
xfs_ioend_needs_wq_completion(
	struct xfs_ioend	*ioend)
{
	/* Changing inode size requires a transaction. */
	if (xfs_ioend_is_append(ioend))
		return true;

	/* Extent manipulation requires a transaction. */
	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
		return true;

	/* Page cache invalidation cannot be done in irq context. */
	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
		return true;

	return false;
}

Otherwise seems fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
