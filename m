Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6844538398
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 10:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710931056; cv=none; b=QW0kZGFQVgRuhimsDnTZa+93JNP1Cb9TKeAAUJ/V981tmPe88W2zxZVO58ggvMs0qz3nW/3opcE8/GE9HL2etJ8Zn5eNVkwZsU+3h7YsmMQohgEhxYZGjQMlgcRR6C0gwLRCvd7H86JCm482tRRdcCQBC360cKUF+kDeYkn2F/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710931056; c=relaxed/simple;
	bh=9UYs4ZwejA0f5HPmQh6g5I9ponZ+C0/FZF4IS9lsAzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8yqk3zuoy50ryEJAep1sFfZZ0c0FL/LLybYf/ua6/PF4uOFcvdO6C0Y9oBpr0xfHmkkJeLXzVxfAz3njZGg1EQF3Qu65GUy6YxLnrDDGUHqspewBKfbWGId2fKIy2KmVjaGAZSF7FPhqwKvl8GC8ifTPyu9pWeN+qHWjj5bH28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irOxKMZv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irOxKMZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710931053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ADJP39t1GFmXzKGwztEyWbu3Yu1GQbVpqFj8SngTSA0=;
	b=irOxKMZvknRAEvnJ6eqlPEvWWot60ztPvaVBRFJejWzIczMGPSqvFoo5Vs4RZzMcDYckbN
	lc2EC15eZf0+4rWwIocp59QB+HsOaIQ/qHvlQREwkl9NUmLZTG4EkSlsA1r0108gA2LniI
	H1/3Uk54zxIG5FX8mc3CJiVb/FGLHr4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-Z2kXbRGdMJWdq8BDRikFiw-1; Wed, 20 Mar 2024 06:37:31 -0400
X-MC-Unique: Z2kXbRGdMJWdq8BDRikFiw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4698fc37dfso303280366b.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 03:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710931050; x=1711535850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADJP39t1GFmXzKGwztEyWbu3Yu1GQbVpqFj8SngTSA0=;
        b=GFVgoVcIT5mLL9F+5zrLTv4h7uFaSkxhXMsoFY62/tYcoyFTn2CSzJb1hGmRvx3O/D
         N7Y4yyqjUE5GPuZJR5opBPyJlonueGV3dvI1IXu5bffSdnipBFL0eP6RlXDZ++jGICmN
         fLjXjbv2LfiCfENgv12Oo8v6FpTHier/8C+0d7DSHknZppFZv6LpvX1nBNj2oI6BpSK9
         FhipFBlPwcrcVFBY12V12J+yoTwbOrjQtgxqaE9Y3d5A0GMtxAPGuGwIIK1sMh9nPAs1
         c0hMSbf40q1kGKt1P6owx0Ia8AXL8P78lf4/Q/3Q5lu4ngwqgaFEGTL0UgBqz1yGDUqD
         XK5A==
X-Forwarded-Encrypted: i=1; AJvYcCX5fD/LwEzTkxLGYr0iC2AAMTtufPW/7SF7d6YilKYcAPUQymEQGYN9cGcAGVjmNnJ/Q7enRURYgJowWeqJg4EUSnTvUAKg+uN5
X-Gm-Message-State: AOJu0Yz9Sz01PZX6gvSEkt8i9Z+5lCLF9RBMQ7lfWz39n7VEaCnRbvp4
	/R0E/6QZYw8U8fjA+c6WepC17fVtXfi/KvfoP5zaBMIdwuolSu2PdOZSMNHmNwotpKFR225WYml
	FF2HzN+9XT1jJzGukhRu9+Fcn/1hDZoJMalX5Fj+c1d/9+8oRubcZjAEs
X-Received: by 2002:a17:907:6d0d:b0:a46:a927:115e with SMTP id sa13-20020a1709076d0d00b00a46a927115emr10378526ejc.39.1710931050413;
        Wed, 20 Mar 2024 03:37:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIJTAG9ko72Loy57po7F4TUY1dy0JWk8zC92Uf2ucyNg7WDekar5E7XdbMe/WRMTnJxVjXFg==
X-Received: by 2002:a17:907:6d0d:b0:a46:a927:115e with SMTP id sa13-20020a1709076d0d00b00a46a927115emr10378499ejc.39.1710931049760;
        Wed, 20 Mar 2024 03:37:29 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id wr6-20020a170907700600b00a4623030893sm7019903ejb.126.2024.03.20.03.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 03:37:29 -0700 (PDT)
Date: Wed, 20 Mar 2024 11:37:28 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/29] fsverity: add per-sb workqueue for post read
 processing
Message-ID: <ktc3ofsctond43xfc3lerr4evy3a3hsclyxm24cmhf7fsxxfsw@gjqnq57cbeoy>
References: <171035223299.2613863.12196197862413309469.stgit@frogsfrogsfrogs>
 <171035223488.2613863.7583467519759571221.stgit@frogsfrogsfrogs>
 <20240319233010.GV1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319233010.GV1927156@frogsfrogsfrogs>

On 2024-03-19 16:30:10, Darrick J. Wong wrote:
> On Wed, Mar 13, 2024 at 10:54:39AM -0700, Darrick J. Wong wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > For XFS, fsverity's global workqueue is not really suitable due to:
> > 
> > 1. High priority workqueues are used within XFS to ensure that data
> >    IO completion cannot stall processing of journal IO completions.
> >    Hence using a WQ_HIGHPRI workqueue directly in the user data IO
> >    path is a potential filesystem livelock/deadlock vector.
> > 
> > 2. The fsverity workqueue is global - it creates a cross-filesystem
> >    contention point.
> > 
> > This patch adds per-filesystem, per-cpu workqueue for fsverity
> > work. This allows iomap to add verification work in the read path on
> > BIO completion.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/super.c               |    7 +++++++
> >  include/linux/fs.h       |    2 ++
> >  include/linux/fsverity.h |   22 ++++++++++++++++++++++
> >  3 files changed, 31 insertions(+)
> > 
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index d35e85295489..338d86864200 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -642,6 +642,13 @@ void generic_shutdown_super(struct super_block *sb)
> >  			sb->s_dio_done_wq = NULL;
> >  		}
> >  
> > +#ifdef CONFIG_FS_VERITY
> > +		if (sb->s_read_done_wq) {
> > +			destroy_workqueue(sb->s_read_done_wq);
> > +			sb->s_read_done_wq = NULL;
> > +		}
> > +#endif
> > +
> >  		if (sop->put_super)
> >  			sop->put_super(sb);
> >  
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index ed5966a70495..9db24a825d94 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1221,6 +1221,8 @@ struct super_block {
> >  #endif
> >  #ifdef CONFIG_FS_VERITY
> >  	const struct fsverity_operations *s_vop;
> > +	/* Completion queue for post read verification */
> > +	struct workqueue_struct *s_read_done_wq;
> >  #endif
> >  #if IS_ENABLED(CONFIG_UNICODE)
> >  	struct unicode_map *s_encoding;
> > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > index 0973b521ac5a..45b7c613148a 100644
> > --- a/include/linux/fsverity.h
> > +++ b/include/linux/fsverity.h
> > @@ -241,6 +241,22 @@ void fsverity_enqueue_verify_work(struct work_struct *work);
> >  void fsverity_invalidate_block(struct inode *inode,
> >  		struct fsverity_blockbuf *block);
> >  
> > +static inline int fsverity_set_ops(struct super_block *sb,
> > +				   const struct fsverity_operations *ops)
> > +{
> > +	sb->s_vop = ops;
> > +
> > +	/* Create per-sb workqueue for post read bio verification */
> > +	struct workqueue_struct *wq = alloc_workqueue(
> > +		"pread/%s", (WQ_FREEZABLE | WQ_MEM_RECLAIM), 0, sb->s_id);
> 
> Looking at this more closely, why is it that the fsverity_read_queue
> is unbound and tagged WQ_HIGHPRI, whereas this one is instead FREEZEABLE
> and MEM_RECLAIM and bound?
> 
> If it's really feasible to use /one/ workqueue for all the read
> post-processing then this ought to be a fs/super.c helper ala
> sb_init_dio_done_wq.  That said, from Eric's comments on the v5 thread
> about fsverity and fscrypt locking horns over workqueue stalls I'm not
> convinced that's true.

There's good explanation by Dave why WQ_HIGHPRI is not a good fit
for XFS (potential livelock/deadlock):

https://lore.kernel.org/linux-xfs/20221214054357.GI3600936@dread.disaster.area/

Based on his feedback I changed it to per-filesystem.

-- 
- Andrey

