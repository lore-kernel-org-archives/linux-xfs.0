Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008B82890
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735477107; cv=none; b=e58wGfXUIemRfv5LwRPrEdr9Ez1cjPOr2qIyEDSAuX+8Q1xE56iCGft/IozbH3EPjk9XKQz6sCGXDMnJlmFfWwa1AKRYrMhfMSWMySRrgRKPcDiB0WY6Eg2RR0NslG+U954KZJBRIpc1KyFaU+1I7ltDhUZo+puDLQ+4tOyJoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735477107; c=relaxed/simple;
	bh=BVhGcUy8I0KEawvhuHph0uJJC6E4ApAHbKJ/MnIf6+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=se7Ck2r7If8kTcLx5v8k9ZTik0U6B9B8ViKSTuLpuFxNGB1i5DDeT7dIXEox2dACZmixxYfwcCCtXZPwwiLgwLuI5OFgQWCvPxaGYFxhmLYsd+ylnIyEX+xmHpsMGFiuejFboOY81V0pHRJ+skR4G7IdX5y8DH+IdEPHh2fVkas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAZVaYXV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAZVaYXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735477104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l14OkEJSbB2lQ6HRsz+CfVgzE+8xh7m2DNAoRxRsLF8=;
	b=cAZVaYXVI7GDw9P6mbnnwtZUJSJbvtvcRsxNFvulFNSoX2+TnRwtr3JeLT4Q1Xhx3hzcU8
	2Z4gl+InIIsno8f0JcTOWLRQDOG57kyz2OwMNxlYZwo8mhcRTp73ET00MDidKc8fsOisrt
	i9XsTJXeRAg+pOF5JMyyNjeFhzC7pYU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-h0HF5J8QPUWgpj5W0CqDng-1; Sun, 29 Dec 2024 07:58:23 -0500
X-MC-Unique: h0HF5J8QPUWgpj5W0CqDng-1
X-Mimecast-MFC-AGG-ID: h0HF5J8QPUWgpj5W0CqDng
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa66f6ce6bfso623367066b.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 04:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735477102; x=1736081902;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l14OkEJSbB2lQ6HRsz+CfVgzE+8xh7m2DNAoRxRsLF8=;
        b=B5xr8Tbfh3qA4LHKQbsu6MHjzF3JIG6v3xeraoN8kTcSLEVFCmdAxasJb6r+Y19L4Z
         ica2jnL5KTgiPPzYcp0twPXpE5DnTl1s4b8vj5uiyg6htEQg3G3ORbIAJw10IGkA9gcO
         LthTQidfG72CYtV91OuWwrWQmRYRbDZynjxzwQv8opEjXxb6VdTX3LmFJ/I+y4heFaGA
         Sw9GKj+oBrZ8G20jRltdk4EaDECRQp7sDCudcIajxbv3pWNrDJArxAK2Dv0VX5K3r6ff
         ENwxrgj07wD1yqbOzNjdTMrkyMby6cPPgU6hD613FvTHxsqkbMHmCj8ECbUJegM/pkZm
         D8Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXDTRp8MajBXZDmB+eDWpgtSjw/8QPYgCvCZW5ZqmIfWiHUccWwfMboKY/5Au6ir578lt0+DMQ+eiw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn4WGPJWCNxhp1z9rtsnj517c97xB9nJCCz33IiMtjLJ2cx3X2
	882xdX08OVM82EdgvfLO81OsoPRDG2NBYPEUXsqmZ6sldHa9yDcL6lk0ITMUHW6Ed8JU5oco8Mc
	RvI8jGzWy9WxuByU8hbAtGrUFzChI1jqETMhrYzGUeRGi29kZQhOrL5up
X-Gm-Gg: ASbGncu03/AnJ0HJ/hA5hK7Ss4KLiOB8YwusZo2tGRkktb0b2N6Zl1WpwRskMEZWLOi
	pI9ZVMIydPpyEheCOL8vviW3FMrovqbB7C66hv9sezbFPUJdYV10U70GoQyQs81yp68RLPtxSTJ
	tIJjJhf9O7cx0V07KnVJ7xCBBSbCuaG5pGybmrWFEU6QH5UbvucNqBkxgqdeZ8TyzdPyNASYwGT
	eBSldq/MGz1B4AG+DlnsKkgDYyPstiwcekit5pu9mbjevy4ps9eWdzSGjhDkYn6FsZlJohkIJFQ
X-Received: by 2002:a17:907:2d8b:b0:aa6:6e41:ea53 with SMTP id a640c23a62f3a-aac271316a3mr3275092766b.7.1735477101887;
        Sun, 29 Dec 2024 04:58:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5WcMKb9KoHZScLGl440Om+DdLYKGQDDOkHuv9hHp+lBTr72kpE0uwz6aQinwzNqD+D8dqMg==
X-Received: by 2002:a17:907:2d8b:b0:aa6:6e41:ea53 with SMTP id a640c23a62f3a-aac271316a3mr3275089966b.7.1735477101454;
        Sun, 29 Dec 2024 04:58:21 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe415dsm1365204966b.123.2024.12.29.04.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 04:58:20 -0800 (PST)
Date: Sun, 29 Dec 2024 13:58:19 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Victor Skvortsov <victor.skvortsov@amd.com>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Xinhui Pan <Xinhui.Pan@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Carlos Maiolino <cem@kernel.org>, Chandan Babu R <chandanbabu@kernel.org>, 
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 2/3] xfs/libxfs: replace kmalloc() and memcpy() with
 kmemdup()
Message-ID: <cdnpycsyf37gbcp6yxx36pxgilothhdpajmtwle5pphjxshn6o@j5enpjtww3xx>
References: <20241217225811.2437150-2-mtodorovac69@gmail.com>
 <20241217225811.2437150-4-mtodorovac69@gmail.com>
 <20241219003521.GD6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241219003521.GD6174@frogsfrogsfrogs>

On 2024-12-18 16:35:21, Darrick J. Wong wrote:
> On Tue, Dec 17, 2024 at 11:58:12PM +0100, Mirsad Todorovac wrote:
> > The source static analysis tool gave the following advice:
> > 
> > ./fs/xfs/libxfs/xfs_dir2.c:382:15-22: WARNING opportunity for kmemdup
> > 
> >  → 382         args->value = kmalloc(len,
> >    383                          GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
> >    384         if (!args->value)
> >    385                 return -ENOMEM;
> >    386
> >  → 387         memcpy(args->value, name, len);
> >    388         args->valuelen = len;
> >    389         return -EEXIST;
> > 
> > Replacing kmalloc() + memcpy() with kmemdump() doesn't change semantics.
> > Original code works without fault, so this is not a bug fix but proposed improvement.
> 
> I guess this is all right, but seeing as this code is shared with
> userspace ("libxfs"), making this change will just add to the wrappers
> that we have to have:
> 
> void *kmemdup_noprof(const void *src, size_t len, gfp_t gfp)
> {
> 	void *p;
> 
> 	p = kmalloc_node_track_caller_noprof(len, gfp, NUMA_NO_NODE, _RET_IP_);
> 	if (p)
> 		memcpy(p, src, len);
> 	return p;
> }
> 
> Is this sufficiently better?  That's a question for the kernel
> maintainer (cem) and the userspace maintainer (andrey, now cc'd).
> 
> --D

There's still possibility to set wrong length in args->valuelen,
which I suppose what this change tries to prevent.

But otherwise wrapper looks good to me

> 
> > Link: https://lwn.net/Articles/198928/
> > Fixes: 94a69db2367ef ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> > Fixes: 384f3ced07efd ("[XFS] Return case-insensitive match for dentry cache")
> > Fixes: 2451337dd0439 ("xfs: global error sign conversion")
> > Cc: Carlos Maiolino <cem@kernel.org>
> > Cc: "Darrick J. Wong" <djwong@kernel.org>
> > Cc: Chandan Babu R <chandanbabu@kernel.org>
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: linux-xfs@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
> > ---
> >  v1:
> > 	initial version.
> > 
> >  fs/xfs/libxfs/xfs_dir2.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > index 202468223bf9..24251e42bdeb 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.c
> > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > @@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
> >  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
> >  		return -EEXIST;
> >  
> > -	args->value = kmalloc(len,
> > +	args->value = kmemdup(name, len,
> >  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
> >  	if (!args->value)
> >  		return -ENOMEM;
> >  
> > -	memcpy(args->value, name, len);
> >  	args->valuelen = len;
> >  	return -EEXIST;
> >  }
> > -- 
> > 2.43.0
> > 
> > 
> 

-- 
- Andrey

