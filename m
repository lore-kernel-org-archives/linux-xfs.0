Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9443612F387
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284551; cv=none; b=LNaDtJXjOzl/52KKsLdBmgMoVhMy4+xbItyNqtpfIyEhniTK/7rYWxmfg/lBoBgcldUrQTUXcu2ObxR8smIg4k1TfPj8sZ44KBJX/JCy2xp4SBCr0CN5I5M9BGI8JfxnXXKNAeqb0FqAiQlx6WyRg9oGFeMOd1+NaGksV8vd2d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284551; c=relaxed/simple;
	bh=J7ffBiB/yGPLsp5tv7edXEoQu/xuuKBAkYdaZUzjf98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfZhgZBVFKNb1jGiQOKUAAiHBLD3jIBFgOBb8edUOQ4kEupOF2P5iaJYV0IiB3do/XMJYOwjaWVpqv01y4P3SLtkDynWfcrJST3jGDgNWVZa/Xw/i0cOJycOznkL7aelThJRa86E6CJ8SHYcRySwPHTGpXa431CYHu9OGcSMUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFTaG1JQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFTaG1JQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713284548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwTDtC9/TRfe7tQAN6HPcrYNVq0Uk2KbGM+60flxlb0=;
	b=AFTaG1JQoL7cDJktg/v5S42oZUuMFGDKkSUTF7MgDnOzkF5lbW9CZThAEmNkoK4+ys2AQg
	AB6Xc2jsYNfdNzwiploD0No55H2/z5GnjQ7Vasr6+ssekS4ECIZz1PaQeTiaWMrpyNNIx2
	vmQNC56NwsnFuzKBVETmvaCMCkm9tZ8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-Q4m1kZA-P4ytMao_eRiNmw-1; Tue, 16 Apr 2024 12:22:26 -0400
X-MC-Unique: Q4m1kZA-P4ytMao_eRiNmw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a51b00fc137so361417266b.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 09:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713284545; x=1713889345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwTDtC9/TRfe7tQAN6HPcrYNVq0Uk2KbGM+60flxlb0=;
        b=ef3pBuzyhXknxMOD5sO6M8ePx4X/SCNhrCvIFDw1GYS2aAU/ijKxfg0OPsN4U4v7Ev
         WZYE4viNt4JoGkUwvcKtpmNfwZBxB/4F+E960EduQbrxsLxmPw2Fi1s5ouDXZ/vj+6sy
         bhbhYeU5HJlqfYdMAQWc/WoGsm+UtlMID9AZbar9z2SJzHhLe1c10J519VKKoe+mOsHz
         QR2K3KmmWdfS+ABr2J5T944T358HTyGDKCav6bCGLYk/xQmbQS6sAhWWmC78Qmc9x+sA
         OGgcE54kRa/shuDXin4018JJaCLS88LvYf7+s9XnNrdYHQWCulRaXDzOLJOSJ8mbej9k
         tyBw==
X-Forwarded-Encrypted: i=1; AJvYcCVM+nW1R49zHb5Y8zEgsHSfLsUm80qBk/8vGKJIgPUsmX/k/i55wfvKBdNrSdYPTgake4uUgOnSI2Awk1Qq8ydq2o/h8+gPl83y
X-Gm-Message-State: AOJu0YyaRx5k7NGsmMwYuu+DGEEUP3BOyRhFdU6lJEVuShHQWvuwe8uO
	FgFvWw+C75z9YKJdR6YdQMK5uYRRDNvhAvEVaizRU1Smh+xsJdTcTLSqimRFVkM0JEu8W/ttWq9
	ZSt96N/wVQf6zKMDzsKQuyInit8jhOCO8N0T5Qy7GUhJkeRSJ3CKwODdz
X-Received: by 2002:a17:906:ee87:b0:a52:3d27:2040 with SMTP id wt7-20020a170906ee8700b00a523d272040mr11331973ejb.38.1713284545115;
        Tue, 16 Apr 2024 09:22:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLuTEyUm48meyORD+vl40+lvlfijA9eKbfcldj1VtIA2QArVu2oas9o92jj6kja7HvCbCsdQ==
X-Received: by 2002:a17:906:ee87:b0:a52:3d27:2040 with SMTP id wt7-20020a170906ee8700b00a523d272040mr11331950ejb.38.1713284544545;
        Tue, 16 Apr 2024 09:22:24 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id pk2-20020a170906d7a200b00a4ea067f6f8sm7033418ejb.161.2024.04.16.09.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 09:22:24 -0700 (PDT)
Date: Tue, 16 Apr 2024 18:22:23 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: init count to stop loop from execution
Message-ID: <afebt6wfxpuzheu7cilv27nanlwvztmaqeqmc7dp3umlihyyz7@57jzqgcdkqw2>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-4-aalbersh@redhat.com>
 <20240416161530.GL11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416161530.GL11948@frogsfrogsfrogs>

On 2024-04-16 09:15:30, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 02:34:25PM +0200, Andrey Albershteyn wrote:
> > jdm_parentpaths() doesn't initialize count. If count happens to be
> > non-zero, following loop can result in access overflow.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  io/parent.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/io/parent.c b/io/parent.c
> > index 8f63607ffec2..5750d98a3b75 100644
> > --- a/io/parent.c
> > +++ b/io/parent.c
> > @@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
> 
> check_parents is an artifact of the old sgi parent pointers code and
> (apparently) its need to check parent pointer correctness via xfs_io
> commands.  The Linux parent pointers patchset fixed all those
> referential integrity problems (thanks, Allison!) and will blow this
> away, so I think we should ignore this report:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/io/parent.c?h=pptrs&id=c0854b85c1e8c90ea3eea930a20d1323e61ddb40

I see, thanks, will drop this one

> 
> --D
> 
> >  	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
> >  {
> >  	int error, i;
> > -	__u32 count;
> > +	__u32 count = 0;
> >  	parent_t *entryp;
> >  
> >  	do {
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

