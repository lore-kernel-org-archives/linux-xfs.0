Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E1531B137
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756474979; cv=none; b=Ont6bCDLnDKAcIUKY6ArxdleXV9lvUj4EDTprqWcG6mHggLW1eEFKt3JbcgGoIvT/kkS9crAueZelJZhvxBnwdm6qdmzqRKOtvjLtj01Lhf+FsvPsAM8B6Ths41e8DXGUaLIdX2K4ho1jJ2vn+5XAZepk6P1aO+kfG8yBpOYSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756474979; c=relaxed/simple;
	bh=0O0KEp6LUq0tLczixqImv1+NNldRbKSoplwU7+oN4lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVFzcSlYKF928h/jomh+UJ91A4UnKk0oB81QLpSduZ+qYLIFcodPA4gbhLeIzj6tIDspGYhVl5kXucE1knz2KYr/eI61EMLSUXA1+OmK1BsvxlNvHbTd8KXTD6nSMCbJQoKbASNOEcpGut73U5/wfFxGd5oizZt/0mLia4QVN50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=gfeb6AW0; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="gfeb6AW0"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-72019872530so18682537b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1756474976; x=1757079776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1ZiXJTOBuHCxbeXNBMGUUNCiAlSqlghqRoS7x15138=;
        b=gfeb6AW036UOIjjvJENhjdblhE0CyM05HuYyOjdvmjjI3ZwTMVWjihPMYr5EwAT71Z
         saLxQ7fPCpfjrY7P89DXzJkPLJGuILDA5rD5dQ59IR98URC4YnX1yLu1o6DW7ZfXfv4N
         nhpfxxdvhwO3N4GzGBYPwoiE+gwxWVE/BK00l63I9rTLGATabgduH3e2g2CJTJcd+BZY
         6/g+Ox9OmXqxW6+0fWqdc09ulXNjZoFGP96JtsIHjmM0uhvuB0+/pxvbBKXma50Hez1c
         +3E34tmUOiKQoJCpsFKldhFee9308KLFMoYylYeRuVv0Cz5Khmnupoc6T5tVGE8YwC6e
         f68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756474976; x=1757079776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1ZiXJTOBuHCxbeXNBMGUUNCiAlSqlghqRoS7x15138=;
        b=i1BomBAoFTX9EhbgUU3ON5y1dNaZXVu2OIoNHms9di0a0qckE6qlnXZsXowxS9kRAy
         WII1cnOHkMnRQnQVtPXF439PF7qAXgP0M/LzDEsma+QQAvULDTCZ9TOfsQDZ1ms3sODh
         ElNCOvcyb2KPbejUn8yfBGc4GQ2t8nVIbJakxjiuMyiAQ/MymSpujENxguvMCHj+AC+G
         KjFfVrZ0rc8YslkHwS4sBIcyYi8Fk1roMZ/r9PkYUm0ttuWuKCN3sbdcwj5KkZdDfRwt
         AqjCL60F+Qb8oRe42aV0GBgrviffmIW14fudyPBJ+O2UaktAr9/QCZOAX3me3FaSoRFH
         J0Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXExLCXhFFgd7sShSN6esQ2Gk4/nRWdUdcdjbSk/wbYhESXsbDak9/S/Fc62F6uU1aaqO6BuqnSnFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3M6ZfAwnMrY6EFZ4+5NKnQNOpkjDJYGyqCdWoZO0eoi6psPvQ
	3L6z+hWjG23y6/PksaN9vScM+eqzzhGWLhTC1zYqFYO7JKxl27Ng0sgcW1JNPgiG57ZhB82UVcw
	Ag8Ic
X-Gm-Gg: ASbGncuyARZ3WW28viufjhaLA0yMjwQitGADe2xEIAUnNAPWyVXZRDqJ/vbWmmzaF1o
	J+gVJ/U9N7qzTdRC8t5ML43c+AaCLyjmyuUhQhB6yueGrg8mcsx+xbbUY0glMr0g9Z88Q1oRMeL
	WTohYtOyvBcCxDrUgwDaoyrAtKmNsOYvIWDDB6T+CwwShfN1Znh7tysXISUIrEdsRsH2ssxfLfG
	mG5/Nh8U3tKQnbOnWDpuwgFuXSAHFPDFKWfC3uQ3nILlXlYLl0mKulnJN9U/TPA8tOAXsr0nwSL
	qf5G88riFdHEj44CyCGVj5D8d+a9Ts23CMF9flxJtUN3CGY5phXaWNzE2oEu5fiDnW7JE5iAWrH
	BfX3mtRio+ZzQdX4TOy2+DrgrIWLAPoZVL51fQLrZF1/Qb62/nS3RD8GotSU=
X-Google-Smtp-Source: AGHT+IE+0aV7Dv2MSdHR6RCJccYKyOmtC1rNyOnGAOEj3zcV8iBnEfJHHdNigJI6ejsuus/zawV3rQ==
X-Received: by 2002:a05:690c:387:b0:71b:f56a:d123 with SMTP id 00721157ae682-71fdc2d0229mr238186837b3.6.1756474976424;
        Fri, 29 Aug 2025 06:42:56 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721c630ed7csm6982237b3.2.2025.08.29.06.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 06:42:55 -0700 (PDT)
Date: Fri, 29 Aug 2025 09:42:54 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, amir73il@gmail.com
Subject: Re: [PATCH v2 23/54] fs: use refcount_inc_not_zero in igrab
Message-ID: <20250829134254.GA2854962@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <d40a41e428c07f88ea011fbf191bd8efac94c523.1756222465.git.josef@toxicpanda.com>
 <20250828220806.GA2077538@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828220806.GA2077538@google.com>

On Thu, Aug 28, 2025 at 10:08:06PM +0000, Eric Biggers wrote:
> On Tue, Aug 26, 2025 at 11:39:23AM -0400, Josef Bacik wrote:
> > +static inline struct inode *inode_tryget(struct inode *inode)
> > +{
> > +	/*
> > +	 * We are using inode_tryget() because we're interested in getting a
> > +	 * live reference to the inode, which is ->i_count. Normally we would
> > +	 * grab i_obj_count first, as it is the higher priority reference.
> > +	 * However we're only interested in making sure we have a live inode,
> > +	 * and we know that if we get a reference for i_count then we can safely
> > +	 * acquire i_obj_count because we always drop i_obj_count after dropping
> > +	 * an i_count reference.
> > +	 *
> > +	 * This is meant to be used either in a place where we have an existing
> > +	 * i_obj_count reference on the inode, or under rcu_read_lock() so we
> > +	 * know we're safe in accessing this inode still.
> > +	 */
> > +	VFS_WARN_ON_ONCE(!iobj_count_read(inode) && !rcu_read_lock_held());
> > +
> > +	if (refcount_inc_not_zero(&inode->i_count)) {
> > +		iobj_get(inode);
> > +		return inode;
> > +	}
> > +
> > +	/*
> > +	 * If we failed to increment the reference count, then the
> > +	 * inode is being freed or has been freed.  We return NULL
> > +	 * in this case.
> > +	 */
> > +	return NULL;
> 
> Is there a reason to take one i_obj_count reference per i_count
> reference, instead of a single i_obj_count reference associated with
> i_count being nonzero?  With a single reference owned by i_count != 0,
> it wouldn't be necessary to touch i_obj_count when i_count is changed,
> except when i_count reaches zero.  That would be more efficient.
> 
> BTW, fscrypt_master_key::mk_active_refs and
> fscrypt_master_key::mk_struct_refs use that solution.  For
> mk_active_refs != 0, one reference in mk_struct_refs is held.
> 

That certainly could be done as well, hell I do that pattern for the writeback
lists and such. I'll discuss with Christian and see what he thinks. Thanks,

Josef
