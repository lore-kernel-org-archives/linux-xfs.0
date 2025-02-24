Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA865227
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433549; cv=none; b=YiXSyBmF5Sluyl9q+61bdAwy2DO0UkwsLeDeSn0ysRyBAX1Y1gU6TcnaQ6Mdwmaw4U7nQdPldE5MVrjth1NFhwsOFucIqPv7z+6VM/uNlKVwhzMpGuqiD+1CrpBpWvCC2T28+HLvEYTFqEVAMV+UXNXDD0/dN2pIqDql9qlAxTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433549; c=relaxed/simple;
	bh=B8Um3eMk3hvqma38jKFiyIbEi663Dt3UgWX5h5sXLl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFIMn3VrWTu/swbTK8q0NVw4+QNhmoBuwwlxQFPHN4tyh2K0TVbtbWq2EUjdP53E1vzzqJGuXnrFcQNWGPflX7tMshhNzeWhbZjoBJctL9oyNKhuKX83SuHHuot04+0ZKu8ToJKfshEvJ8LmwIJYdutJgWb5IRtMMshNkRQI6jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XZDplTQP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XZDplTQP"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22185cddbffso99691595ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 13:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740433546; x=1741038346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=baQcd4BlBbeci4pq+lkQS7gSttZ++rUKJi5374wmvuA=;
        b=XZDplTQPnT2QE+FR9MkNOp94a+o/ES4Ftkv3D99+hGCxy9U9g5/Ilt6ay0cHDhy9FX
         0m8cGAwuyTrwC3nEffFU7eijYtsAvsAql6LnIrmsao+iOfbmyx51POIBF4howRhzRMmb
         I0QkrjL7KMy74GCknt62ju5VLWfA908YhZxP3J3dvMVlAgmOeMqMwWjNo8Vl0vZ8Plh8
         EbSwK60l4YkLB9q2Bm2UsFSAs9Nq8cCQbYPUXmE6Uf7INaTG7mf9cb4L8eeWO3M/HFKL
         lvfJdJnpy9v5nBmUXFg8XlT2fob7WkHwx1OuO9bGkdoPB7+1ypSksihpX7ivHZbGpYk4
         ycKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740433546; x=1741038346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baQcd4BlBbeci4pq+lkQS7gSttZ++rUKJi5374wmvuA=;
        b=Jd/Oy1VyhXGhqMGy6cw1eQ8HVQw+vffkkSXRIhnmoFe0BSkvnBeAxgewfSgay8CMyj
         lVAmvcsTRyCWpzgkVYxUCCeg6QXW3YnYf+A9+A4coMLn/tLn5S4kBYl27JGV+/jfRz38
         bYJ8gHXLpHm7mqmxMSmQDmgYISAKB7YfLmrLz2JnIxfuVqjqfgKPf+V8eTZnmyJpFNKU
         cqv8b6qs16FZU1WEfxgxA9j3TFQaiezdp15ImNnL6OANdyNvDJFdLUZceP+h4xpy4EAU
         MhbyiwjHYEfyzhOQFUSQTRn36dWVYy7bFrPMi45loP3OgqL77QEDcbqTpxYl0X4IIWyw
         MqSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVzFZ0Bl8JEkzpKH/Gy26nj1Q/5aqidXOx2fgPBl/iulFwBT/SsG5tXNQZPSEEpOpZhumUbg21Z2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNuVhWzXhw+QUi//RDn7MTfl3fqRvIDee0CbCiB4tgBthxhWTs
	0DlP3M2KIEWHr15jeGGQOdkIaxdhnyI4I1t2qFKTJ/fbeXLxuICbHFvePNwb0JQ=
X-Gm-Gg: ASbGncuaQUaUQyahKLE0ciWR5v2i1de+yoVCs6kkMsU2U/DnmGFFGAItzqQnC5GnOfD
	VB9SIale7vhqINMgBjhpB+SXVBrHDP7IzDlYUliJqlkwaT2nkaqCpeSBRQarr7e1vY8nqQZ1ZVm
	ByWv5C1ojziwHHjjVmgzC4IeHRJocfZximf7P4+dccN5/fDEL3lOMAHwY26Ee8dol6hCOh/PElv
	T/u1KbeMdxM1cwzCfFJYO/J+JuvlVdVi0EKJXWiBnDGRCmV1C4xwljneAS22Zgm9EmFhl1SLFjz
	W+mtKyqQnaAKev36cTh1/mxjYpiPR1ejZPEIs7ONwNiL6Q0nQ8SxTkxRY42p4ZButpx4Ti3D92P
	t2A==
X-Google-Smtp-Source: AGHT+IF1kivAJK+5XJv15nd3N2xNPfYMjBaPhJULgUhbrdplw1aav3juq/XyTUOTjPQZBXSn8PmxHg==
X-Received: by 2002:a05:6a00:3d0f:b0:732:61d2:8187 with SMTP id d2e1a72fcca58-7341411d7c9mr30371600b3a.11.1740433546051;
        Mon, 24 Feb 2025 13:45:46 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aeda8384d1esm114878a12.38.2025.02.24.13.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 13:45:45 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tmgGk-00000005Vo4-2uVO;
	Tue, 25 Feb 2025 08:45:42 +1100
Date: Tue, 25 Feb 2025 08:45:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 3/8][next] xfs: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <Z7zohueO2E3ZSpfj@dread.disaster.area>
References: <cover.1739957534.git.gustavoars@kernel.org>
 <e1b8405de7073547ed6252a314fb467680b4c7e8.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1b8405de7073547ed6252a314fb467680b4c7e8.1739957534.git.gustavoars@kernel.org>

On Mon, Feb 24, 2025 at 08:27:44PM +1030, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Change the type of the middle struct members currently causing trouble
> from `struct bio` to `struct bio_hdr`.

What's this bio_hdr thing? You haven't sent the patch to the XFS
list, so we cannot review this for correctness. Please cc the
-entire- patch set to -all- recipients so we can see the whole
change in it's full context.

> We also use `container_of()` whenever we need to retrieve a pointer to
> the flexible structure `struct bio`, through which we can access the
> flexible-array member in it, if necessary.
> 
> With these changes fix 27 of the following warnings:
> 
> fs/xfs/xfs_log_priv.h:208:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/xfs/xfs_log.c      | 15 +++++++++------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f8851ff835de..7e8b71f64a46 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1245,7 +1245,7 @@ xlog_ioend_work(
>  	}
>  
>  	xlog_state_done_syncing(iclog);
> -	bio_uninit(&iclog->ic_bio);
> +	bio_uninit(container_of(&iclog->ic_bio, struct bio, __hdr));

This is a pretty nasty conversion. The code is obviously correct
right now - the bio uses an external bvec table, so has no
associated allocated bvec space and so the bio isn't flexibly
sized.

Making the code more complex for humans to understand and get
right because "the compiler is dumb" is a bad tradeoff.

I also think this is a really nasty way of fixing the problem;
casting the fixed size structure to a flex sized structure that can
overlap other parent structure fields really isn't a good solution.
IMO, it is a recipe for unexpected memory corruption when the bio
isn't set up properly by the caller or there are bugs in the way the
bio is iterated/processed....

>  	return;
>  shutdown:
>  	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f3d78869e5e5..32abc48aef24 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -205,7 +205,7 @@ typedef struct xlog_in_core {
>  #endif
>  	struct semaphore	ic_sema;
>  	struct work_struct	ic_end_io_work;
> -	struct bio		ic_bio;
> +	struct bio_hdr		ic_bio;
>  	struct bio_vec          ic_bvec[];

But then there is the bigger question: ic_bvec is a *fixed size*
that is allocated at mount time. The fact it is defined as a
flexible array is the problem here, not the embedding of a struct
bio. i.e. we've used a flex array to optimise away an extra
allocation in a non-performance sensitive path.

Hence if we had done it this way:

	struct bvec		*ic_bvecs;
	struct bio		ic_bio;		// must be last
};

and use another allocation for ic_bvecs in xlog_alloc_log() (similar
to how we do the separate allocation of the *ic_data buffer that is
mapped into ic_bio at IO time), then none of the code that accesses
ic_bio for IO purposes needs to change and the compiler warnings go
away. That's a much cleaner solution that requires no extra
cognitive load on developers to maintain in correct working order.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
