Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030EF28E7;
	Wed, 26 Jun 2024 05:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719378440; cv=none; b=Pt0ZYmH+aLeyR2Ulzt2VnJC4Vy1CjWglcr7JvEINBPYumJmQBIf1fIagjJ0me283mzErMsvzt6PoN6cxtbJgBdLcTXN90IHCUpzJO36dlR7580Ma6ZTsacGPbpirOhAsWaUtK2h3ZkE4k0PEnXgPSSU+8dWLicn3+zgMQcA+Kh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719378440; c=relaxed/simple;
	bh=yNSF7dMHw70nchoGScXJKl5A+rJnoqJjPWleT+gFbWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqZId4QGEYipcZcmXLLMDZcLlH0/+EIeYzedS+yhp1Enq5x1ihhhsQqamJbXc66vE//6pPtMd2MunapW3C23vXfXfNkhflIReu8mtyD/frHQtE9gUF9tUzjE5yJdKZ+jd315Eo4pxSB+Hw8fQFu8iarz68SljEv+lvK7BbQFTiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PvpYFcDY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvpYFcDY"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f9b52ef481so51286605ad.1;
        Tue, 25 Jun 2024 22:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719378438; x=1719983238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2gTDiOVkD5QASIl+OkG6+1XhEwWWwFrDP5G6UmkUPc=;
        b=PvpYFcDYrt2GXb/09J2Z6y8jlBE88bi4+uB/qLZ4ixp+mKdd0UO2R1Rs69Hd8OB3cq
         sOg3rP88GmkLwJLRpJ/VjyiRpjBf2xYYH3VOAFxQBWQW9aOxL6aHEoiEWIkCvilKk/sa
         qJ7H8HRoGrKpBPGm+RqoVzGG0jwT6yU8ctnayH5jbthpaEEPXhYFuFh/qJ+G/0pY6j4a
         SMG2CGMtlXXyAly0/5bzQYuRmsJ9chEFsdBl3oxYYXJmnKlQ6ve2OYGCaB45N9AHqUul
         ziFGbXJWFDUaGoSsrOahlyz6UrvpYQ4rjfPlC3la27WaD3kLqjqSGMDjJvV5ED0t9/JQ
         SCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719378438; x=1719983238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2gTDiOVkD5QASIl+OkG6+1XhEwWWwFrDP5G6UmkUPc=;
        b=H6NPxAjtl+MC8O0rgWl5RLHT6eP5vxo92WBjyMqWCSxB2P8UDcpdJB/gAMk8Q9xzxp
         ZDeKZZ50dO+bqUzGd5Zydfs6EwhkHyJSoZnkwm+ylyZvlfZDTDYGm6+XlmqpuzFtJwrr
         hD8USihLFXSE+wRRcDEGuPVTu2MMcqrW9wuPU8j/UHfTd1kHWsPWfA4Ul6lbVZl0Wm0V
         17DkfDzGiofQgfES5Jd1BJIQ3bpoRHbuXCd/ZkM2Xb3yUfHhi7liYHbSCGbmHOMjPCB6
         mqM/HXyuHkNE0Rv326RktRfdcWs86FvZSjC8r+36mxoWn95CJUIbwZKtNbFJV8NAMYOI
         +09Q==
X-Forwarded-Encrypted: i=1; AJvYcCUeGPGH+6Ecml6HVAQ72W8ZgQYlgghy5NBNknNEfK8xrEdVTkmC4Wsa7fEIiyehV0Yvvre7NkjgCK/alWo5cPTiSnKGw8EDqUAmupxi5KS/VaXx6PCWRlJ8AJL4ev47BiqWsuuB8PZb
X-Gm-Message-State: AOJu0YwX5MpAdpi0wFxlmqdIdelCczy1qEvy9j4JbMU3VkF98Np2cOcR
	QBIhSKM2zEXAUB5U1ryPSkaMhe8Rk5i7NuPNLIjbU0zvF/Atr7My
X-Google-Smtp-Source: AGHT+IFTITSBnLp37a1zKaOM7iuWXbD3QmfxqYU7B4lsHRUzsRel9G6KTm0gA6YcFuSdROOcTXy7ig==
X-Received: by 2002:a17:902:e5c1:b0:1f6:a606:539e with SMTP id d9443c01a7336-1fa23f3600amr103829625ad.61.1719378438127;
        Tue, 25 Jun 2024 22:07:18 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f2a06sm90305755ad.31.2024.06.25.22.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 22:07:17 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: hch@infradead.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and release it early
Date: Wed, 26 Jun 2024 13:07:15 +0800
Message-ID: <20240626050715.25210-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <Znqq7GUFnwFj-SFI@infradead.org>
References: <Znqq7GUFnwFj-SFI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Jun 2024 04:33:00 -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2526,6 +2526,8 @@ xlog_write(
> >  			xlog_write_full(lv, ticket, iclog, &log_offset,
> >  					 &len, &record_cnt, &data_cnt);
> >  		}
> > +		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
> > +			kvfree(lv->lv_iovecp);
> 
> This should porbably be a function paramter to xlog_write, with
> xlog_cil_write_chain asking for the iovecs to be freed because they
> are dynamically allocated, and the other two not becaue the iovecs
> are on-stack.  With that we don't need to grow a new field in
> struct xfs_log_vec.

xlog_write() will write all xfs_log_iovec on the lv chain linked list to iclog.
We seem to have no way to distinguish whether the xfs_log_iovec on the lv_chain
list is on the stack by adding new parameters to xlog_write().

> 
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
> 
> This area can use quite a bit of a redo.  The xfs_log_vec is tiny,
> so it doesn't really need a vmalloc fallback but can simply use
> kmalloc.
> 
> But more importantly there is no need to really it, you just
> need to allocate it.  So this should probably become:
> 
> 	lv = lip->li_lv_shadow;
> 	if (!lv) {
> 		/* kmalloc and initialize, set lv_size to zero */
> 	}
> 
> 	if (buf_size > lv->lv_size) {
> 		/* grow case that rallocates ->lv_iovecp */
> 	} else {
> 		/* same or smaller, optimise common overwrite case */
> 		..
> 	}

If we take the memory allocation of xfs_log_vec out of the if branch below, we
have to face the corner case of buf_size = 0.

But the release and reallocation of xfs_log_vec in this patch is indeed
redundant. I've optimized it in [PATCH v2] and [PATCH v3].

Link to [PATCH v3]:
- https://lore.kernel.org/linux-xfs/20240626044909.15060-1-alexjlzheng@tencent.com/T/#t

Thank you for your suggestion. :)
Jinliang Zheng
