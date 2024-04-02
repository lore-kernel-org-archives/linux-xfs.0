Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E924559151
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712052574; cv=none; b=kWjHqfwkrEB9j3WO5rkd/I7mUq+qAZ2J1Ub4oYBXg22n74xRV/4lmaYelg0TnlnxIx1pk/Pt9DVc0I8DCBYniJ3pBMVHe/LueKsN3VMNikQYWbw/Ph6HMBQ4a0crFSG3Pqaf7nIMk6sI3GCyN+p14DWflBWyoYwdAYPSxOkqqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712052574; c=relaxed/simple;
	bh=OU9f/oHdpSv5so4XxuOO4NXfr+ACnzAx5W/5jBZ/xW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSYqejXg3NyIJAXjLMLTtcrzcCMkBhlEt5m8d8FdwpwOLof7r3IxMdusIA8KincN6Z+3eQfLr0Z3KgvEvemYaAM5bgFkGZhywe2vOYp0fu4rM64t905FKk2KSyKfvxvpBOKl/3BV4hORR/Lbfsz1wranHM/gLtaKHiDelYaPuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uj1t0NZV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uj1t0NZV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712052571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2bp0ENkGdxs60VdgrG/Ao+HASiC17rsYdOAl+5ioPU=;
	b=Uj1t0NZVCzyOACj12i04yK0VfEfK8bVY2DbYTWDClepOy5YaoQ0aXMN9ixxZjn1tOMVT0B
	6Sf6E/Tr5KLnM+sCI+gF5rnyPkPU+By3orv8lm70Vl8vm4VOJJhpO22YoVxZifwwKquCx6
	tTwXaJKzd5WlwWcdWByOefyQSwOgb2k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-kMI6pPpWOoCAHCA6MqMyBg-1; Tue, 02 Apr 2024 06:09:30 -0400
X-MC-Unique: kMI6pPpWOoCAHCA6MqMyBg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5684bf1440dso2394607a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 03:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712052569; x=1712657369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2bp0ENkGdxs60VdgrG/Ao+HASiC17rsYdOAl+5ioPU=;
        b=rNGUJbFRr5hcUudXPSMTcUkXlKtHdQg/N7Rke+BkSOO45G67jr6OypSRfbwn5AnfZ6
         to2HcOGWN97N7klAQn4c2T4oxoTTVsZCvsEhQeeuEX572DBSgIs7kk20djeZsbbpEITd
         4aSGIArUs/V3KXW/ClPmlbAzAbh2s/FRQxrFXALyvRX/sk24msEDVeZkoa8zAwGEuTj6
         zPvk6mETBVyN5VGy49fwgTlT2KKVkUZiq7XlYPaEvcWzjNaPxsrJQGHkSg9EU+mEUd5f
         dGSP2enO4l35kXAkeNO+kfEGXwUlyTrjs6hlXhQVkbATAYLu2qa1KB9tL/WRGXA/Kx73
         RFWw==
X-Forwarded-Encrypted: i=1; AJvYcCXPy7xl5nj20UXMgzBPppSuE0MN8ORsK2mhQGnF/iQffOepB0e1DKdwhtKPCcneH2nszGTWh7ZcIhtH2+Pn5FnzekQDsyfb70cM
X-Gm-Message-State: AOJu0YyK4lAiRkpYtgzG1UKpmrLqkom4+iY1fKBCo3c4gF6h5I1Xu/A6
	eRk2wUFnU9jWzW/4EJKrCPgnLu5avy8gQNWXr2GfAP2JIHdPV/lI3tnCQl0RMqs57g06La64dWt
	uEs9+PM5AE2MODfh61vCAglvoCixzQrNXxfZWJwX6hqG0upGUvHAMBzXI
X-Received: by 2002:a50:d7d9:0:b0:568:180a:284b with SMTP id m25-20020a50d7d9000000b00568180a284bmr6072563edj.37.1712052569094;
        Tue, 02 Apr 2024 03:09:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2u/iYin6OUN30jHEOhcY414TrEvqk+AMnddAkYTd2kcCDkV6Z9aKRNEYtCWRv/9yomjo8ZQ==
X-Received: by 2002:a50:d7d9:0:b0:568:180a:284b with SMTP id m25-20020a50d7d9000000b00568180a284bmr6072551edj.37.1712052568633;
        Tue, 02 Apr 2024 03:09:28 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n3-20020a50cc43000000b0056bb1b017besm6549855edi.23.2024.04.02.03.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 03:09:28 -0700 (PDT)
Date: Tue, 2 Apr 2024 12:09:27 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 02/29] xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
Message-ID: <33acelck44533qoui3avtjbehb54rvf2j2opmxhpflf4g3kr22@wkipgjny64yn>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868593.1988170.18437361749358268580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868593.1988170.18437361749358268580.stgit@frogsfrogsfrogs>

On 2024-03-29 17:36:35, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Turn this into a properly typechecked function, and actually use the
> correct blocksize for extended attributes.  The function cannot be
> static inline because xfsprogs userspace uses it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |   19 ++++++++++++++++---
>  fs/xfs/libxfs/xfs_da_format.h   |    4 +---
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

