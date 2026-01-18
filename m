Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425652C3277
	for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 19:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768765413; cv=none; b=UCasmM7VPOKxxrQLFOWE5SZCVe2iU5eD7PjYbw1XTBTFY6AWLmXn3eOjbEQAiFf3LE4EsUoGwhbA4D/bdyddrkpAAVJUuqS7oVYp7vtG9PYyHSC8dCYTTMFodoPvwCIuhXEeIJTjlI/JhuZRQugnaOcJ32dYdo1RUOjOKdssbqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768765413; c=relaxed/simple;
	bh=ihCu/nCzNPdmHACgGF5iy8/LH2kLGnH2F2tu3J3iQ5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tL+zvtliK7x2MktpnhTyWaMxa8D2nvuRGJsXW0UMoyyIl5URt3s9ec5jRyda3VDsbF7P9Iq/tRO6NSkmmJgmdo1ewkhCbOH0LxBZjQoCOe1E7KhG/wWcHFyehC+8sV2fNU9X2+Ec2p/RkMKTKXkZbmNdbWKQ8QXTy555BHC0onQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdcKHsPC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rtD3W4ub; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdcKHsPC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rtD3W4ub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768765411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wx0WaUEMnldyhRZG5stWRx+iOw9veUh39W9sJgI7vC4=;
	b=BdcKHsPCrr1TMgXylCtszjO4UOKDrGwZ/PDabo3ZdBqUTft/8dZNS/Ef0B2ZBBnNAgjvWI
	jM3JmQDNXrwKR/NDykd9avajYMJKpXcK1DQOQH0oxaPVUsY7eQ37/5MthjcZzgM/H1LsXV
	lhL6XJrICvOij1OIInJxIqBE4N5jL58=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-q_ch2XwaNhOJuIZi49uY1A-1; Sun, 18 Jan 2026 14:43:29 -0500
X-MC-Unique: q_ch2XwaNhOJuIZi49uY1A-1
X-Mimecast-MFC-AGG-ID: q_ch2XwaNhOJuIZi49uY1A_1768765409
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a13cd9a784so27843405ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 11:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768765408; x=1769370208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wx0WaUEMnldyhRZG5stWRx+iOw9veUh39W9sJgI7vC4=;
        b=rtD3W4ubwaZJfJ8m/EmiWQEb2+oZRjCDUa8VzbAiq4r2KS2WZa9OaUr5DvaOKN1i3u
         kQRwXL1sFz6xWSSGsFGlryzZUWE06GrBrTCWWNOLtbE4kpOtdkrkL1OLh7X1R0ENRXJS
         3LSr6gMY51QQ5aUqO8ust8tHcWd83XbytpOyz19qCvyvO8yEm9IxD4Lh15EdRY3pCXsB
         I0TDiMZng7ubIsMyVf2+sR2JTzfZ+4fgZ9z9kjtlOyM1Qi91Aej9T82aE4i4I7o2giEp
         kqjCh6Udf4pwzF5iWq28k47ez1lrqyQ4cjPxglWsaAG8/ZJxg4ouYOazLH9ZApLhWzv2
         Nvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768765408; x=1769370208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wx0WaUEMnldyhRZG5stWRx+iOw9veUh39W9sJgI7vC4=;
        b=XbdgE50eyZ0lS3r83EePxa2pi3aNee7b9LAO3GzdMOwKUbnEgOC2NUyaPLoF4AjDrW
         jkAhv1wB0IMhMAHFSS9UC0OkS7oYAqxW8oEVUrotEtQpKQCy3VSld+APQCbRJhXimaQH
         j3wboUsTlQCbsdX+Cx9DxOcUIlA2PJC3yc95dtER6gWsH3ayGbzBhDhO1x7uSluMYF23
         MobXwglZBZpOdSWp1iq1wBRRG9Zne37bjOoEdzrc1k53bSwrsfxZ3hcWU+oSwn77VTGy
         Tn8/ByNF45bAzhPaBzqbIIZ6nL0CJJ4869etHtFeqbHGroWsvEmndSpqKWjH1KSRt9FL
         1A2A==
X-Gm-Message-State: AOJu0YyNbqo5UJeyYId3QrITBr/9hgoexGn1s+LjzphcB4WXUHYaaoCw
	suT0o+jfOHLRJKbhtqvdkY9raghFbucczji2HAl0Ko+MVdF9zgsbZ9/ttJBDzk31WjAyVSp9Tpo
	1mzrnkGRfmWlii9bmF9/Q5yu+CygbmgvqizLJEv72N4gY+FC10hjOqAXNqB1gkg==
X-Gm-Gg: AY/fxX5C0kYkkArsejG6W0y4p/ixvn0ybDN71QQIMnc9OMVTOZ06F07N1smrJCN4r4O
	PyBGt/fXdEe6TXrc0AszypOUzkFdMHQk3OtQX8Qzot5VaZdXP1wHCotyEL2OIOpuy8IKCzEZv+Q
	lcZxuDlZU8xHNZ8WWC7+1Pios1W6fRKCzCMnJPC3b25/32ezd4GErWqwZQb7/tBak0Es3D5Wrkp
	/A2rw669wArgh544gazqbjQXxg1BBo8XrUoBTe+JrFbKTXDAUmFiPy2trH07wLzskf8YB1k2DGt
	H9jBUY10159BwoqDF6kw0WuHlreV30LCHeR3uwB7BnuFZBLGKQe6v7ZQt8i3ONilcRJvmlb3DXs
	NCrZb9yraZ31GzKjHrUgwZXwymKJcqR/HH0NwcAAj8RGKXHZYNA==
X-Received: by 2002:a17:902:ce88:b0:299:fc47:d7e3 with SMTP id d9443c01a7336-2a7188fd7fdmr82941305ad.31.1768765408604;
        Sun, 18 Jan 2026 11:43:28 -0800 (PST)
X-Received: by 2002:a17:902:ce88:b0:299:fc47:d7e3 with SMTP id d9443c01a7336-2a7188fd7fdmr82941185ad.31.1768765408159;
        Sun, 18 Jan 2026 11:43:28 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190aa340sm72769685ad.3.2026.01.18.11.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 11:43:27 -0800 (PST)
Date: Mon, 19 Jan 2026 03:43:23 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH v6] xfs: test reproducible builds
Message-ID: <20260118194323.pyr426yu65v7dgpm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260108142222.37304-1-luca.dimaio1@gmail.com>
 <20260118175327.hdevfpau7uifdsb7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aW0x4lXOhO0g1_wm@f13>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW0x4lXOhO0g1_wm@f13>

On Sun, Jan 18, 2026 at 08:19:08PM +0100, Luca Di Maio wrote:
> On Mon, Jan 19, 2026 at 01:53:27AM +0800, Zorro Lang wrote:
> > On Thu, Jan 08, 2026 at 03:22:22PM +0100, Luca Di Maio wrote:
> > I think it's not good to be commit log, better to move this part ->
> > 
> > > 
> > > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > > ---
> > 
> >   -> here
> > 
> 
> Thanks Zorro, sent a v7 with the correction

I've merged v6 into "patches-in-queue" branch with a bit changes, will
merge into for-next branch after testing, feel free to check it:
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git?h=patches-in-queue

> 
> L.
> 

