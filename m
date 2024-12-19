Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6EE19F424;
	Thu, 19 Dec 2024 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630716; cv=none; b=eFFwIN/F/Uf5B1icoaiZKP8zstlVjsP9GPZaw162zxlp10TvFZLd+mVLBSNTUUlOo121/7F2Xqfh29Zqh9gFixtywcP2c5SvyosA8NiYRnvjhTbFYRYXSwRFxt7Wg4SoLC/C1UL7c6YmnUBDz9IVTKtsJhwuclQt2dM6gZRw8Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630716; c=relaxed/simple;
	bh=GUr+ymCn330apw2SkTF8SoeKI7LFiOvVDZCr3JHYJd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoAL3+0RcBedYECOvgthNUEV43zpmfFDz5/YAyPt8bAlwTulD1U4gxds1OpAeuEl0se1UJQjMexbS7K4QaLBdprRu2Qs4eRBGIN3nOFBeikpPANqaqGZUywJ82+27+AKTLdqWt21gJeCd+QTWHVBjWccIEvThRco4CaKYYxjvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYqCDQUO; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYqCDQUO"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-728eccf836bso995621b3a.1;
        Thu, 19 Dec 2024 09:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734630713; x=1735235513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lwm/HUN1v4wImD5MxbQe1ldqiX4FDVc796CzwXcqztA=;
        b=IYqCDQUOvoV3m9Hul8rVQ5ulIfhlzRq3xB4yFqWOaHkUzJywz8Xf1lMAr6yPiwfXgF
         4zLOzAlpY7xLCgjR9PUQPgoDn4xOy5ZOlyzD9/IuXtn4SqJQ9Jl7zjUI7trwNbAhzKFE
         jJL4+9J8rA5gr8MnalWkW7Jw/0x+n6Ekmi3pKUNVY0ouLprZ3rcYwJNZ1O8Dp4aUVsZe
         bLo3xu2jEcIRkK6xCX2lbuSeuW7hMXA2xhwOBRddXyAkDTXB5hQHuLq9kpEO/08CRGwn
         QHsXK+NpiRshDdbj+USxV7uN7+7bDEtCuW6tj0xZOZFpbzPHn9KAnSsq66LSjX5+bkfF
         GY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734630713; x=1735235513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lwm/HUN1v4wImD5MxbQe1ldqiX4FDVc796CzwXcqztA=;
        b=Kv5AnLzv+yzBJOaBBRwuypshcfrScUiuJk/FWzdOQxcYzRI9vgym6LODXCErmoD14r
         cKQk0GQ87HVIjbX6M73zISfPdmz0njYdcjDM1Z1jggc2OaSaEnVsii4R9G83Gdp2oB+Z
         ZD5pfPexI4KWYnHeCJAzIeOtpKaY8lpQhz+/5yVStk6D7q2CCjE08RfjX9u4QB4JVWaw
         Nji2bipy30UZU56tFaD0PctAqsDN4TOHk6K8xdT6SxsXd1+qaQ8MRV5Vp30c3/offngV
         lR4VQI6InBatJj1XlXlk22fHS+nqJKWyxjIqD9tDA4LddnGejg4e5g+yL4QX8A+CdHJi
         h7cA==
X-Forwarded-Encrypted: i=1; AJvYcCV/7so9/t8oV6bZErUbOEYdkAYFJ/JPNWilMtZ3YBeYjF/fGEXjtnNUwawao1qheXUIwQUox9Bya9Ti@vger.kernel.org, AJvYcCXV1rdNxK25qSJkwSP7e/vkAH9+b/lFlI2nwmcH9TdwiOg66045yxxXTlsm7qd9lZQA6phImI8wFFNrYKU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5/DYuhfpoX+2g4P/tFUmpnB1pcgG3nP+2RcdOXJJjYwYa3C54
	new6IMfiTjxLBn0tNFey6W8CHTvKcQM53iBe6l0d3E1ue+OoH5GT
X-Gm-Gg: ASbGnct7n0smaFSbJnyjVuAckiKsP+kxdVtxqqytcdkMDQeZU5HO/u+p+q6q/0BCkJ0
	1IAnlWjs5gOeEG6crBt44jjF4dSshS2H1BGi3XGZ124Q4hTaf7QYRjJjZ+M2WufcqA4GM71ilrc
	5SQ9rQSlSbw/y9arQrzWCb0TZNM6qumVFeK7of5B4RO0QYMBrjZmLNnfCCtkkjZexbbvnOUILGs
	D6LKC6+oAAiLADiAO8PgDw7/XtAaZaf6Pg7WNlsuvW7XURxf+MBBFyPNNJRadUTqDHdfqdP
X-Google-Smtp-Source: AGHT+IHKXWDq5eCRkjP4KVZCsCB6iyzXU0D4TMT0MsYY25ziGyVrxVcm8p4Qh4gx4ONXvQ3b8qr9lA==
X-Received: by 2002:aa7:888d:0:b0:725:e37d:cd36 with SMTP id d2e1a72fcca58-72aa8ca8776mr6581461b3a.2.1734630713411;
        Thu, 19 Dec 2024 09:51:53 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c244sm1586105b3a.195.2024.12.19.09.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 09:51:52 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: djwong@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	chandan.babu@oracle.com,
	flyingpeng@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Date: Fri, 20 Dec 2024 01:51:49 +0800
Message-ID: <20241219175149.93086-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20241219173615.GL6174@frogsfrogsfrogs>
References: <20241219173615.GL6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 19 Dec 2024 09:36:15 -0800, Darrick J. Wong wrote:
> On Fri, Dec 20, 2024 at 01:16:29AM +0800, Jinliang Zheng wrote:
> > xfs_buf uses a semaphore for mutual exclusion, and its count value
> > is initialized to 1, which is equivalent to a mutex.
> > 
> > However, mutex->owner can provide more information when analyzing
> > vmcore, making it easier for us to identify which task currently
> > holds the lock.
> 
> Does XFS pass buffers between tasks?  xfs_btree_split has that whole
> blob of ugly code where it can pass a locked inode and transaction to a
> workqueue function to avoid overrunning the kernel stack.

When xfs_buf_lock() causes a hung task, we need to know which task
currently holds the lock.

However, sometimes the command 'search -t <address of xfs_buf>' may
not be effective, such as when the stack frame of xfs_buf_lock()
has been popped.

Replacing the semaphore with a mutex for xfs_buf has no negative
functional impact, but in certain situations, it indeed facilitates
our debugging.

Thank you,
Jinliang Zheng

> 
> --D
> 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> >  fs/xfs/xfs_buf.c   |  9 +++++----
> >  fs/xfs/xfs_buf.h   |  4 ++--
> >  fs/xfs/xfs_trace.h | 25 +++++--------------------
> >  3 files changed, 12 insertions(+), 26 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index aa4dbda7b536..7c59d7905ea1 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -243,7 +243,8 @@ _xfs_buf_alloc(
> >  	INIT_LIST_HEAD(&bp->b_lru);
> >  	INIT_LIST_HEAD(&bp->b_list);
> >  	INIT_LIST_HEAD(&bp->b_li_list);
> > -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> > +	mutex_init(&bp->b_mutex);
> > +	mutex_lock(&bp->b_mutex); /* held, no waiters */
> >  	spin_lock_init(&bp->b_lock);
> >  	bp->b_target = target;
> >  	bp->b_mount = target->bt_mount;
> > @@ -1168,7 +1169,7 @@ xfs_buf_trylock(
> >  {
> >  	int			locked;
> >  
> > -	locked = down_trylock(&bp->b_sema) == 0;
> > +	locked = mutex_trylock(&bp->b_mutex);
> >  	if (locked)
> >  		trace_xfs_buf_trylock(bp, _RET_IP_);
> >  	else
> > @@ -1193,7 +1194,7 @@ xfs_buf_lock(
> >  
> >  	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
> >  		xfs_log_force(bp->b_mount, 0);
> > -	down(&bp->b_sema);
> > +	mutex_lock(&bp->b_mutex);
> >  
> >  	trace_xfs_buf_lock_done(bp, _RET_IP_);
> >  }
> > @@ -1204,7 +1205,7 @@ xfs_buf_unlock(
> >  {
> >  	ASSERT(xfs_buf_islocked(bp));
> >  
> > -	up(&bp->b_sema);
> > +	mutex_unlock(&bp->b_mutex);
> >  	trace_xfs_buf_unlock(bp, _RET_IP_);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index b1580644501f..2c48e388d451 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -171,7 +171,7 @@ struct xfs_buf {
> >  	atomic_t		b_hold;		/* reference count */
> >  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
> >  	xfs_buf_flags_t		b_flags;	/* status flags */
> > -	struct semaphore	b_sema;		/* semaphore for lockables */
> > +	struct mutex		b_mutex;	/* mutex for lockables */
> >  
> >  	/*
> >  	 * concurrent access to b_lru and b_lru_flags are protected by
> > @@ -304,7 +304,7 @@ extern int xfs_buf_trylock(struct xfs_buf *);
> >  extern void xfs_buf_lock(struct xfs_buf *);
> >  extern void xfs_buf_unlock(struct xfs_buf *);
> >  #define xfs_buf_islocked(bp) \
> > -	((bp)->b_sema.count <= 0)
> > +	mutex_is_locked(&(bp)->b_mutex)
> >  
> >  static inline void xfs_buf_relse(struct xfs_buf *bp)
> >  {
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 180ce697305a..ba6c003b82af 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -443,7 +443,6 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
> >  		__field(int, nblks)
> >  		__field(int, hold)
> >  		__field(int, pincount)
> > -		__field(unsigned, lockval)
> >  		__field(unsigned, flags)
> >  		__field(unsigned long, caller_ip)
> >  		__field(const void *, buf_ops)
> > @@ -454,19 +453,17 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
> >  		__entry->nblks = bp->b_length;
> >  		__entry->hold = atomic_read(&bp->b_hold);
> >  		__entry->pincount = atomic_read(&bp->b_pin_count);
> > -		__entry->lockval = bp->b_sema.count;
> >  		__entry->flags = bp->b_flags;
> >  		__entry->caller_ip = caller_ip;
> >  		__entry->buf_ops = bp->b_ops;
> >  	),
> >  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> > -		  "lock %d flags %s bufops %pS caller %pS",
> > +		  "flags %s bufops %pS caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  (unsigned long long)__entry->bno,
> >  		  __entry->nblks,
> >  		  __entry->hold,
> >  		  __entry->pincount,
> > -		  __entry->lockval,
> >  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
> >  		  __entry->buf_ops,
> >  		  (void *)__entry->caller_ip)
> > @@ -514,7 +511,6 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
> >  		__field(unsigned int, length)
> >  		__field(int, hold)
> >  		__field(int, pincount)
> > -		__field(unsigned, lockval)
> >  		__field(unsigned, flags)
> >  		__field(unsigned long, caller_ip)
> >  	),
> > @@ -525,17 +521,15 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
> >  		__entry->flags = flags;
> >  		__entry->hold = atomic_read(&bp->b_hold);
> >  		__entry->pincount = atomic_read(&bp->b_pin_count);
> > -		__entry->lockval = bp->b_sema.count;
> >  		__entry->caller_ip = caller_ip;
> >  	),
> >  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> > -		  "lock %d flags %s caller %pS",
> > +		  "flags %s caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  (unsigned long long)__entry->bno,
> >  		  __entry->length,
> >  		  __entry->hold,
> >  		  __entry->pincount,
> > -		  __entry->lockval,
> >  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
> >  		  (void *)__entry->caller_ip)
> >  )
> > @@ -558,7 +552,6 @@ TRACE_EVENT(xfs_buf_ioerror,
> >  		__field(unsigned, flags)
> >  		__field(int, hold)
> >  		__field(int, pincount)
> > -		__field(unsigned, lockval)
> >  		__field(int, error)
> >  		__field(xfs_failaddr_t, caller_ip)
> >  	),
> > @@ -568,19 +561,17 @@ TRACE_EVENT(xfs_buf_ioerror,
> >  		__entry->length = bp->b_length;
> >  		__entry->hold = atomic_read(&bp->b_hold);
> >  		__entry->pincount = atomic_read(&bp->b_pin_count);
> > -		__entry->lockval = bp->b_sema.count;
> >  		__entry->error = error;
> >  		__entry->flags = bp->b_flags;
> >  		__entry->caller_ip = caller_ip;
> >  	),
> >  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> > -		  "lock %d error %d flags %s caller %pS",
> > +		  "error %d flags %s caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  (unsigned long long)__entry->bno,
> >  		  __entry->length,
> >  		  __entry->hold,
> >  		  __entry->pincount,
> > -		  __entry->lockval,
> >  		  __entry->error,
> >  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
> >  		  (void *)__entry->caller_ip)
> > @@ -595,7 +586,6 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
> >  		__field(unsigned int, buf_len)
> >  		__field(int, buf_hold)
> >  		__field(int, buf_pincount)
> > -		__field(int, buf_lockval)
> >  		__field(unsigned, buf_flags)
> >  		__field(unsigned, bli_recur)
> >  		__field(int, bli_refcount)
> > @@ -612,18 +602,16 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
> >  		__entry->buf_flags = bip->bli_buf->b_flags;
> >  		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
> >  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
> > -		__entry->buf_lockval = bip->bli_buf->b_sema.count;
> >  		__entry->li_flags = bip->bli_item.li_flags;
> >  	),
> >  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> > -		  "lock %d flags %s recur %d refcount %d bliflags %s "
> > +		  "flags %s recur %d refcount %d bliflags %s "
> >  		  "liflags %s",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  (unsigned long long)__entry->buf_bno,
> >  		  __entry->buf_len,
> >  		  __entry->buf_hold,
> >  		  __entry->buf_pincount,
> > -		  __entry->buf_lockval,
> >  		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
> >  		  __entry->bli_recur,
> >  		  __entry->bli_refcount,
> > @@ -4802,7 +4790,6 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
> >  		__field(int, nblks)
> >  		__field(int, hold)
> >  		__field(int, pincount)
> > -		__field(unsigned int, lockval)
> >  		__field(unsigned int, flags)
> >  	),
> >  	TP_fast_assign(
> > @@ -4811,16 +4798,14 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
> >  		__entry->nblks = bp->b_length;
> >  		__entry->hold = atomic_read(&bp->b_hold);
> >  		__entry->pincount = atomic_read(&bp->b_pin_count);
> > -		__entry->lockval = bp->b_sema.count;
> >  		__entry->flags = bp->b_flags;
> >  	),
> > -	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d lock %d flags %s",
> > +	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d flags %s",
> >  		  __entry->xfino,
> >  		  (unsigned long long)__entry->bno,
> >  		  __entry->nblks,
> >  		  __entry->hold,
> >  		  __entry->pincount,
> > -		  __entry->lockval,
> >  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS))
> >  )
> >  
> > -- 
> > 2.41.1
> > 
> > 
