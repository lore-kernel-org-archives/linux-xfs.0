Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516372C3268
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 10:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768300078; cv=none; b=ZWJPXMuIdo54hWEe7DfOHCdtWa4poppJDuZHb1/tUdv1yhOXFDF7eVSyEi/UXvLQ7xdYH+0ATZot1sVjOoMYXzRYAnBM0jTZ38a7T/gwQLkH8f6JW2wzS0okZDxebIlSG6ScA+/F+ABRS3TOyXib0acz/BntGfhFreWMURSrbog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768300078; c=relaxed/simple;
	bh=Y1EG2gg9trMLtTzJzcQqnxtPYB99MBscnRy8ZXGd7Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOsyWNazfFuiVqlFIx7dldB62X/FIA87zISBVJoO9BEfOJPT5eoXbLztw64jK773VCfInooIRobEKKEApcEx8SR8WVPMvrrMOWmeaBVrEvGX2TBZeELB7QjG5vVWmA5MLxyRFRE60wnJDu3HUBYV435Bh8sGmX82QPgJmhdRmkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwoVN2Yj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pJQcF+MU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwoVN2Yj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pJQcF+MU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768300075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0z1MicA7DsF+xKcCgaImlqMyjxE6Xv47VRmj/QLAAM=;
	b=PwoVN2YjhhSvL3zLGkVIHJHBdAStHVRys1gQYhPibs82fZn2JNjgY55kqyhHrkLgCsWlRc
	x9p7pgkjWOD+Z7AoBapTaU3GTMMWHrgF/lT3/NllUbIXIv3Ik+66tz8oGRmZ9etZ2FbJXM
	t/dFB/gadc2aqN4vMPKU2zEzSDKUkbI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-s5rDfPkhMsKA80UcdqxXAg-1; Tue, 13 Jan 2026 05:27:54 -0500
X-MC-Unique: s5rDfPkhMsKA80UcdqxXAg-1
X-Mimecast-MFC-AGG-ID: s5rDfPkhMsKA80UcdqxXAg_1768300072
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so51343005e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 02:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768300072; x=1768904872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E0z1MicA7DsF+xKcCgaImlqMyjxE6Xv47VRmj/QLAAM=;
        b=pJQcF+MU67bLK+KX4sIjHk+TafqlmuQf3TrfHXOfZVFiQ3QkUOadfCsbX/kZaJh2Dd
         V5grPgHtOzmyZBCRE9Koqcq6zkCRkwl9jlDlDlTDyo+h03AzXB+B3WZ2fVM+LGYJeKPJ
         yhUaAWQCdVZ7DzlqMZC7GWz1nBD1F1OzZVZ8bDJMTdOO/WvgSyJSbkpjYO6oBwAJjl2f
         RIBbHO6YEwBRHrJV2Wn3RsZYBzGfTpAG4Y7xvByUx5vVLvQuzyd0tERYON1Rt3kpc2Fs
         FIQZ6M/6N8UsG6tqEG/8Z+HccD/rNzv6w6oE7uMS4UrRWODH+bNE/f2g5fb3MJS0flmM
         Xyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768300072; x=1768904872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E0z1MicA7DsF+xKcCgaImlqMyjxE6Xv47VRmj/QLAAM=;
        b=MxkJLWH2c8//1NIZJif2M8oDxqX7GFganfL1y7TQCOK7oLME2nXYUyVdbbnDEAoB1L
         IvdzBhE86Ue2is6Q06WuvlSpoDMOy+d+Vc//YI7+/GBXqM6EXlLhuTuJqp4hgzKx702A
         9xbazLwMLinXpyFnugrjTnnGAvsfvLqwiOr+7c9y2gRE2hWNw1wGGPai6n1F/U8gJ6MC
         f1VHAkRKEVYBL0FTm6zqQfmpKBSNN04THuDkaQodLBd32qXACNdeGi62/RLz0q1HBgnc
         LPVKAyybOK2T9fshGWB9EsfPY43/C8Ek/xbEg0q9AudBBDpBzHnDpMDbfKrj06O0Hm4g
         D1aw==
X-Forwarded-Encrypted: i=1; AJvYcCVnUQt1z3NHy5jvkdlwt4APDYrHOHQmmY7gGrahF7lZQjoDuCI2kJq9S9VzF9BongLXVfF2ezb5QCc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0/hCOT11A6JD/Gz29JgB5WhJn+oI8fWd3C81F2InkDxa7zLvV
	OtOmW24abja4QPqV0PIDpoAgky6nOAL7SfQx63fwSDPUsCah0Kgbc8pDDbyyiVpy7nx1Vud6qPf
	rNkGN3b0Gq3Ptb4exk35530Upan0nRUIqqAwFfV04gbj56G3jBaJw7YFqNtog
X-Gm-Gg: AY/fxX7wR9c+KwFOcbSLg4JX/XlWLayApl/EKqk9xy7RBVJLwP4k5MQsV+aecJpDo3B
	xETOli94IxWCoLU4nthNPoscBFvExscKtahO2XJIN+Ga2SYtVUMJiTDbV2BrDFr5pJ+q3DN/Jsy
	WS9f3B/mJLqj76XWC6S3g6VG7Cjp290vN1OdvcwjnTJqEhZHDvI0NiaMFySEjcuujh0bXOzMi6z
	aNm6DtdeR/CkH+0S4skM3vmTsLNgmhsFqTqBuFzVDT0lqXTXE4TgfAZ+diEwANXpMLTIENeQaIH
	eow3aO3IHlBK7UQUVe/8qsAdmZ9ByLvs2xAbuFiCZP4MPhvSdHVpiF2ZXs7i9II48egb6qLvW3M
	=
X-Received: by 2002:a05:600c:4685:b0:477:7975:30ea with SMTP id 5b1f17b1804b1-47d84b41bcbmr245060485e9.29.1768300071691;
        Tue, 13 Jan 2026 02:27:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR2ffY/nFR+GP3KY/RVv+hIA96YMk+myFc+0psgr29NAZFkwA7UJxzHTC3X0Uic0XrdUJ4pw==
X-Received: by 2002:a05:600c:4685:b0:477:7975:30ea with SMTP id 5b1f17b1804b1-47d84b41bcbmr245060245e9.29.1768300071196;
        Tue, 13 Jan 2026 02:27:51 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f620ac8sm389705405e9.0.2026.01.13.02.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 02:27:50 -0800 (PST)
Date: Tue, 13 Jan 2026 11:27:49 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 1/22] fsverity: report validation errors back to the
 filesystem
Message-ID: <7nix5lf63rm6hrkpr3y37culoiiz53rerj5lcur5bez6gbstc7@xgu6qwkx4qa6>
References: <cover.1768229271.patch-series@thinky>
 <dx6z2f5lrnevosqoqr4a2aa5bmxldmishn6ln22hvdkuxxmjqa@rddd4kri6bce>
 <20260113012911.GU15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113012911.GU15551@frogsfrogsfrogs>

On 2026-01-12 17:29:11, Darrick J. Wong wrote:
> > To: "Darrick J. Wong" <aalbersh@redhat.com>
> 
> Say    ^^^^^^^ what?

oh damn, sorry, that's my broken script

> 
> On Mon, Jan 12, 2026 at 03:49:50PM +0100, Darrick J. Wong wrote:
> > Provide a new function call so that validation errors can be reported
> > back to the filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/verity/verify.c              |  4 ++++
> >  include/linux/fsverity.h        | 14 ++++++++++++++
> >  include/trace/events/fsverity.h | 19 +++++++++++++++++++
> >  3 files changed, 37 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> > index 47a66f088f..ef411cf5d8 100644
> > --- a/fs/verity/verify.c
> > +++ b/fs/verity/verify.c
> > @@ -271,6 +271,10 @@
> >  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
> >  		params->hash_alg->name, hsize,
> >  		level == 0 ? dblock->real_hash : real_hash);
> > +	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
> > +	if (inode->i_sb->s_vop->file_corrupt)
> > +		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
> > +						 params->block_size);
> 
> If fserror_report[1] gets merged before this series, I think we should
> add a new FSERR_ type and call fserror_report instead.
> 
> https://lore.kernel.org/linux-fsdevel/176826402610.3490369.4378391061533403171.stgit@frogsfrogsfrogs/T/#u

I see, will health monitoring also use these events? I mean if XFS's
fsverity need to report corrupting error then

-- 
- Andrey

