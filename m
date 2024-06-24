Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962119D062;
	Mon, 24 Jun 2024 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719245180; cv=none; b=UvtuKBHTxR64G4VUj2ryRtE/BKAw9RWav5wRd1b05mz1f0HQUF0gA/AVAg0GG92fv8wCtleoolsmawY4AGgP8mOpQP40c24x+RPgWqf5KdjNF5HdxCk4uGPddSPlhTfHa8a/HONQX9NybFX+iVZ7TF4ZMsW0h5vAZ4Y/nj6ZLJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719245180; c=relaxed/simple;
	bh=mFHnk4g1MbD5a3PfmJFoozdGS8dj3tLPxwtdLjwpSlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnzhV7PudcJvIBdNevPXq4epqt+nitQSU8+ibHnCmjYWO4C48YuMXq52qfdr2qqkEw8maPtVL3rhROSeFMvUgrpOQ4RfV64xDsUDLtyON2rjMvebhfhArlhvAQa1qQRQTS0cq3JWM4wD77JxAseknydtqf4vR2GEipJLGh+vMpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddKxYVzE; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddKxYVzE"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f47f07acd3so36741845ad.0;
        Mon, 24 Jun 2024 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719245178; x=1719849978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdwjoxQKHusWugnAHNqs8eZLGRo8UFQhILVITUkD3go=;
        b=ddKxYVzE7tqjzsmsfyGczxOT+xye2p8WV80uEt2s8XfW8dNbEj41H7tUuxL3Ok3OqE
         ypxLC9Y6s/qppFFPtfpr9tUkuTslMBPpvyq8gHNWj+f0zOx0SFfQzl/9Ro2gmvcFpYq0
         axZ23JdLf4SVSibWXRzRERi41DR5XgOi/p6KFzI0xWkJoO/u+oaCduqyKLkk9JAFRTjN
         zyUEyGGO6nILMRSGTbrUBzUvC2/2UBkZ6yf1dXzBRERWagFE+GnHn9bwMxLHORqyYFMc
         3/riJq+ifQHeEXSkYUHmDpasqYPT/K7FfUCu4tP2au20ELFkptOxSraa2KgkiMzRqESh
         EePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719245178; x=1719849978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdwjoxQKHusWugnAHNqs8eZLGRo8UFQhILVITUkD3go=;
        b=gvUlQCqAAmy9uLF9TOY5APntwNUNHsCWAi/y3x3hl/C7s+4B4Mg52X/s+af2ambToW
         C+QuxaLsMhU0NqXstwtgP5AyddzpIXG5Jz8NWLqegjsXHDrelsnYQjKOCwtXcdEBCnCS
         BJEJIk41Nf4u2aobAgCFoCmsNy8oZSCcl5+DFBjjp2W3kwI7t9JxV5ybDzj5RIUPBl12
         QDslarXw6pulgUl+EdHjKJZTAE+1kWaJrf/iEBaa1QJlur0c1Mg4xlLb7McdeRA1HVoD
         kVWAEEYOX6kTUp0IG6AtzpUqncg2/knKTfpwevLuprPt9zg4lN+wwnRaE/I/xPGHb4kd
         wDHA==
X-Forwarded-Encrypted: i=1; AJvYcCVcc+Z1spfP1wlR7nhshlqjyJYSjjyYGlNFBDaiiW6btD0Z6wqGSfqnS9N5+E1s54Sy/Oh45if79hpFptNFcWICbzO3u4XYxYdiDBmadr8SpQBpDW6iegzT1pwO5v3V1B5eHDMPqVGd
X-Gm-Message-State: AOJu0Yy1iIqCdhPaMkrYhY2C0bRhsKK/R3mK4UeAaUq+HluuqHEWZRGI
	mk3VUFOIFdXKlgRhUJT9fWT6WQMdpeC3KLagPZWqNyCNZaS32c67
X-Google-Smtp-Source: AGHT+IEdPEpvCrATpvF4p5kJao7Bx5GEjdyMHGnsAXo2lRhBTKt0+vtJ/83zCAsLsx6uW1a86WVlWw==
X-Received: by 2002:a17:902:d48f:b0:1fa:a68:47a8 with SMTP id d9443c01a7336-1fa1d51e2d5mr68154395ad.28.1719245177610;
        Mon, 24 Jun 2024 09:06:17 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5d29sm64404615ad.154.2024.06.24.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 09:06:17 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: djwong@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	chandan.babu@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and release it early
Date: Tue, 25 Jun 2024 00:06:14 +0800
Message-ID: <20240624160614.1984901-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20240624152529.GD3058325@frogsfrogsfrogs>
References: <20240624152529.GD3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 24 Jun 2024 08:25:29 -0700, djwong@kernel.org wrote:
> On Sun, Jun 23, 2024 at 08:31:19PM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > In the current implementation, in most cases, the memory of xfs_log_vec
> > and xfs_log_iovec is allocated together. Therefore the life cycle of
> > xfs_log_iovec has to remain the same as xfs_log_vec.
> > 
> > But this is not necessary. When the content in xfs_log_iovec is written
> > to iclog by xlog_write(), it no longer needs to exist in the memory. But
> > xfs_log_vec is still useful, because after we flush the iclog into the
> > disk log space, we need to find the corresponding xfs_log_item through
> > the xfs_log_vec->lv_item field and add it to AIL.
> > 
> > This patch separates the memory allocation of xfs_log_iovec from
> > xfs_log_vec, and releases the memory of xfs_log_iovec in advance after
> > the content in xfs_log_iovec is written to iclog.
> 
> Why would anyone care?  This makes lifecycle reasoning more complicated
> but no justification is provided.

xfs_log_iovec is where all log data is saved. Compared to xfs_log_vec itself,
xfs_log_iovec occupies a larger memory space.

When their memory spaces are allocated together, the memory occupied by
xfs_log_iovec can only be released after iclog is written to the disk log
space. But when xfs_log_iovec is written to iclog, its existence becomes
meaningless, because a copy of its content is already saved in iclog at this
time.

And if they are separated, we can release its memory when the data in
xfs_log_iovec is written to iclog. The interval between these two time points
is not too small.

Since xfs_log_iovec is the area that currently uses the most memory in
xfs_log_vec, this means that we have released quite a lot of memory. Freeing
memory that occupies a larger size earlier means smaller memory usage.

Jinliang Zheng

> 
> --D
> 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> >  fs/xfs/xfs_log.c     |  2 ++
> >  fs/xfs/xfs_log.h     |  8 ++++++--
> >  fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++----------
> >  3 files changed, 24 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 416c15494983..f7af9550c17b 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2526,6 +2526,8 @@ xlog_write(
> >  			xlog_write_full(lv, ticket, iclog, &log_offset,
> >  					 &len, &record_cnt, &data_cnt);
> >  		}
> > +		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
> > +			kvfree(lv->lv_iovecp);
> >  	}
> >  	ASSERT(len == 0);
> >  
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index d69acf881153..f052c7fdb3e9 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -6,6 +6,8 @@
> >  #ifndef	__XFS_LOG_H__
> >  #define __XFS_LOG_H__
> >  
> > +#define XFS_LOG_VEC_DYNAMIC	(1 << 0)
> > +
> >  struct xfs_cil_ctx;
> >  
> >  struct xfs_log_vec {
> > @@ -17,7 +19,8 @@ struct xfs_log_vec {
> >  	char			*lv_buf;	/* formatted buffer */
> >  	int			lv_bytes;	/* accounted space in buffer */
> >  	int			lv_buf_len;	/* aligned size of buffer */
> > -	int			lv_size;	/* size of allocated lv */
> > +	int			lv_size;	/* size of allocated iovec + buffer */
> > +	int			lv_flags;	/* lv flags */
> >  };
> >  
> >  #define XFS_LOG_VEC_ORDERED	(-1)
> > @@ -40,6 +43,7 @@ static inline void
> >  xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
> >  		int data_len)
> >  {
> > +	struct xfs_log_iovec	*lvec = lv->lv_iovecp;
> >  	struct xlog_op_header	*oph = vec->i_addr;
> >  	int			len;
> >  
> > @@ -69,7 +73,7 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
> >  	vec->i_len = len;
> >  
> >  	/* Catch buffer overruns */
> > -	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
> > +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lvec + lv->lv_size);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index f51cbc6405c1..3be9f86ce655 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -219,8 +219,7 @@ static inline int
> >  xlog_cil_iovec_space(
> >  	uint	niovecs)
> >  {
> > -	return round_up((sizeof(struct xfs_log_vec) +
> > -					niovecs * sizeof(struct xfs_log_iovec)),
> > +	return round_up(niovecs * sizeof(struct xfs_log_iovec),
> >  			sizeof(uint64_t));
> >  }
> >  
> > @@ -279,6 +278,7 @@ xlog_cil_alloc_shadow_bufs(
> >  
> >  	list_for_each_entry(lip, &tp->t_items, li_trans) {
> >  		struct xfs_log_vec *lv;
> > +		struct xfs_log_iovec *lvec;
> >  		int	niovecs = 0;
> >  		int	nbytes = 0;
> >  		int	buf_size;
> > @@ -339,18 +339,23 @@ xlog_cil_alloc_shadow_bufs(
> >  			 * the buffer, only the log vector header and the iovec
> >  			 * storage.
> >  			 */
> > -			kvfree(lip->li_lv_shadow);
> > -			lv = xlog_kvmalloc(buf_size);
> > -
> > -			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> > +			if (lip->li_lv_shadow) {
> > +				kvfree(lip->li_lv_shadow->lv_iovecp);
> > +				kvfree(lip->li_lv_shadow);
> > +			}
> > +			lv = xlog_kvmalloc(sizeof(struct xfs_log_vec));
> > +			memset(lv, 0, sizeof(struct xfs_log_vec));
> > +			lvec = xlog_kvmalloc(buf_size);
> > +			memset(lvec, 0, xlog_cil_iovec_space(niovecs));
> >  
> > +			lv->lv_flags |= XFS_LOG_VEC_DYNAMIC;
> >  			INIT_LIST_HEAD(&lv->lv_list);
> >  			lv->lv_item = lip;
> >  			lv->lv_size = buf_size;
> >  			if (ordered)
> >  				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
> >  			else
> > -				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
> > +				lv->lv_iovecp = lvec;
> >  			lip->li_lv_shadow = lv;
> >  		} else {
> >  			/* same or smaller, optimise common overwrite case */
> > @@ -366,9 +371,9 @@ xlog_cil_alloc_shadow_bufs(
> >  		lv->lv_niovecs = niovecs;
> >  
> >  		/* The allocated data region lies beyond the iovec region */
> > -		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
> > +		lv->lv_buf = (char *)lv->lv_iovecp +
> > +				xlog_cil_iovec_space(niovecs);
> >  	}
> > -
> >  }
> >  
> >  /*
> > @@ -502,7 +507,7 @@ xlog_cil_insert_format_items(
> >  			/* reset the lv buffer information for new formatting */
> >  			lv->lv_buf_len = 0;
> >  			lv->lv_bytes = 0;
> > -			lv->lv_buf = (char *)lv +
> > +			lv->lv_buf = (char *)lv->lv_iovecp +
> >  					xlog_cil_iovec_space(lv->lv_niovecs);
> >  		} else {
> >  			/* switch to shadow buffer! */
> > @@ -1544,6 +1549,7 @@ xlog_cil_process_intents(
> >  		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
> >  		trace_xfs_cil_whiteout_mark(ilip);
> >  		len += ilip->li_lv->lv_bytes;
> > +		kvfree(ilip->li_lv->lv_iovecp);
> >  		kvfree(ilip->li_lv);
> >  		ilip->li_lv = NULL;
> >  
> > -- 
> > 2.39.3
> > 
> > 
