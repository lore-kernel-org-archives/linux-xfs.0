Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603BE22171A
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 12:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609472; cv=none; b=EgP+lzd0okY6xu7qX3JpYRrZFLDyRZ+xU4q/aBLebYqIbKnRWhQcgKXccfhW5XucbSCIWQVLSz7IvbOUBhhXJXnlwDudQp1cQH5BiDJspQK5bvVDw2c39JCwJmmnBRuq7GDKVHCuZWxC/4Vd3mv9wqeWgVuF3XZU2aeiBfD9Opk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609472; c=relaxed/simple;
	bh=jbF+un70Xkt5SPzJBNL5nux8GjqZ6W5e1OmvimXg3gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkPJaJAeo09hni0xPIhT+VbNbzSlNkxPaJpKsjbAax673X3i23I1aYAiUY1y0Ak/UVDp8Q59yrAEw7/zDuVTMU3qoSwyqkuMkdNZDNrk/4Gcra8zeqz5v28hBN3YOkzKfwxYXgLU1PCS+pW6is9FDGKNpffFKrgI/EVaUduxRNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ccWxkonR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ccWxkonR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741609470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XgI9q1ST8/HWLPe5DWyUlqWpV13ydnBAaevSAufyWok=;
	b=ccWxkonRNEVssAB/DI9WXujXXE41tkS8x8+mtO8mYsYoAzSFEN81sPSVVnd4sUL1EKRRUy
	rbjqBLKelOPy/Z2HoLtM98+flFBY2RUz2GnyYQFkt67m2FOaO1WVcqgxzRXvCUB8ICw8Vn
	L/YjyeGF+l0nbR3ElKH/ymP+95k8+P4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-9tm0_K9dOHm0gkN4ajXH4w-1; Mon, 10 Mar 2025 08:24:28 -0400
X-MC-Unique: 9tm0_K9dOHm0gkN4ajXH4w-1
X-Mimecast-MFC-AGG-ID: 9tm0_K9dOHm0gkN4ajXH4w_1741609468
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4394c489babso19480185e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 05:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741609468; x=1742214268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgI9q1ST8/HWLPe5DWyUlqWpV13ydnBAaevSAufyWok=;
        b=n8YcaoZM1ys94DS1uqhvVhTxWJ3GHDO/8rD4TF+BOyf37/r3HneeW+tIsgqsjv8K/0
         j44QE1EjQo/JVEuxg8nhStVhUM5IPbiK5uo4TKfnWNWW+yc5GvIKsU5acaz9rmAJabvv
         MTLK9a2DOZRl6cnMvlg9eI8yA9x/WlVKOLjbhAMGQMTlRwLqJr77WVciNCfyj/2tUger
         smlt7o7DE3lgD3DKQdl72HG4z7YqmoS7NrynseQaKIZ2Swe+5gra0hb0ruh217ZRr/gO
         iSTSUkKzQNIVrMr9i87o7OySBMjga7+gNPQRh/74SDKqiNVXPO61/pWHw496DrgaMou5
         TgdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMk4vZ7+tNDj+y+U/Iwa/3ylxwb8Z/VU1sO2y93QUZKqG7U9lgWivBkBZR3mjDeIJZfFk+Yj1k9ig=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIt/w/lV9fpNCunMtMaAQGLVFsJ6xuP8yRNXa1O69vpzmDnz7V
	rfWYbq9qAc27iIH37MSNiW4B+1tg6L9dMpblTlPW0zp+MeBaS6yXgA2JDpT6Co3mymcJA8Qm6u0
	nwTnLtIlDNkWk+Le4U0tsbTXwd1iWuN3kac4ErQ1JnmhY/VIMSYE6ikgJ
X-Gm-Gg: ASbGncurpdcZrH9il7WQ5XVsX/RIPqNrIk3GuWHA7LTkypAO8xZaNTFWekkNHl+Szrq
	ArKKvyUm0fmSzn7S+mmqcTZSPZ/H/K6TsSJK7pXqA2w1ihUP4x28jYB270lhZVLkKM6VgmrJrga
	hXp2qGOQ1o9Vr+wHQ7t6xg3tlJf2Qza6wFHrLhjlsYX+Mo0g1v5ECpee8qOs6mTctANKfpCxh1+
	BTIE+ZDutvUAoh6LRHxa57KXfgEpMGAfcpBo0jpM9ey5SbIl2ULVARqwJ5kJrgbeBCXyhfFLN/+
	q/6qebcDOtT2+x+WiW85dOqGfGkotH/XEhg=
X-Received: by 2002:a05:600c:45d1:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-43c686f96a0mr88045785e9.30.1741609467760;
        Mon, 10 Mar 2025 05:24:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrWbxBT2S80+P/eqF5tNHn9Beq7qhyOyq/pGXW8Mmq6Lff595X0PbVKVfWTmgoZsHN9M/Tcg==
X-Received: by 2002:a05:600c:45d1:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-43c686f96a0mr88045515e9.30.1741609467415;
        Mon, 10 Mar 2025 05:24:27 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ceeb34904sm61424925e9.30.2025.03.10.05.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 05:24:27 -0700 (PDT)
Date: Mon, 10 Mar 2025 13:24:26 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Kjetil Torgrim Homme <kjetilho@ifi.uio.no>, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_{admin,repair},man5: tell the user to mount with
 nouuid for snapshots
Message-ID: <w7ift5gmxeihp2u3chbi25to7mfnurvhizgo36aitpzwx2mf5w@jg55nn5sti2w>
References: <20250307175501.GS2803749@frogsfrogsfrogs>
 <f296547d-7a7c-4df5-89e2-9e3cdab546f5@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f296547d-7a7c-4df5-89e2-9e3cdab546f5@oracle.com>

On 2025-03-07 20:37:48, John Garry wrote:
> On 07/03/2025 17:55, Darrick J. Wong wrote:
> > +"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
> > +"filesystem, you may need to give mount the nouuid option.If you are unable\n"
> 
> mega nitpick: it looks like a space was missing before 'If'

will fix it when applying

> 
> > +"to mount the filesystem, then use the -L option to destroy the log and\n"
> 

-- 
- Andrey

