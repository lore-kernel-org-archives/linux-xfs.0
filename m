Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4741D0BA3
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119824; cv=none; b=jecZK1jMP3Zu8dZB8eXp28YNwGMvum2jEfrEH2DXcoY6Xnw+JNutCnRE0ruTVNlz13C9B8AthMMzrv+BXHkH9s3yoh+Gmm9si2Zf/kKIeg++qGwUSV8kzZtCXWAhwD2aijWqzpv5S3ipVEtu1BE3H5qmcDxTNN3/eTe6K++5YZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119824; c=relaxed/simple;
	bh=eVo74uH1a3S1xTDyHAwg/cqDzhhkxhUoHUiV5/lJywg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtAzN7r4iOS5TpLQ0cKPE+Vq+Zc+AW+hjvhJRDSVFOkvfqjb8J/J7DezYd7AUkOQLah6P0ZQfutFT+OBbqjmk9Z3ZGl6Xb/pe6Yyrg2u5z3ButHPdR3Ne/jxlLnCfHxzy5nlSi+AIHk0ho4KCo3oiuQRuCuAiBcRkraZCYPLTKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQVxIWK8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQVxIWK8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730119821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=locDhZ8enW58ZhgvKUzesyAlGj6c2tT4bEjg1OEiR/E=;
	b=WQVxIWK8m2jC630owteMYGhEDiySLh5a/Amn2g4lwqV65Ve5VimZyBc6BPHOFGpTtqmGiB
	1HikGRnS7QXrwUSoNCATCH9rk2H2IUe/IP4lhu/jf5AIZt7QxExbiGkbj2B5eu6bh1XaWY
	RyyZzfa61IA93ZAlFVRwC2xQRCIG+ws=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-YKqwGf2nPGeYWciKCMJlMQ-1; Mon, 28 Oct 2024 08:50:20 -0400
X-MC-Unique: YKqwGf2nPGeYWciKCMJlMQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71a122bf521so3953613b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 05:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730119819; x=1730724619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=locDhZ8enW58ZhgvKUzesyAlGj6c2tT4bEjg1OEiR/E=;
        b=a7N6I/qt1sdwNxFrn0uBpUkCnZKmF9PAF9KjMafFXcxOuWTQqKzRsHY9hwfB6+PNT0
         nuD7rz9/6OkkoAyd3PppPsp6TzamJZ1Vy7m93QRtwTJ8cRBifydVtj+aGDpsF3shdmIo
         g7iCY9nvTaKJWlrqblJSPupMgEUBZeabFBmaiqEwHEwNCehfjtSXW2XnQbgiRWOI75Sz
         V8a5JXY4fl3ePJWcvaftLkdvq2nmebMNyB9FkmcynNQ01RlaiY3tlj/byXWuJQestXxm
         VoTRCwzMafjfPArAAZI/Gw9RQu5yCg+4co4jEsrpqw2zGWVDdqGtFBjkgaV1XPNnPqy6
         rZew==
X-Forwarded-Encrypted: i=1; AJvYcCWML6tvWXBUIneTLdngiVmx9mTBY2UR+XO0+WImi018xRzIgS4mmcp6FIHKOXhD7m8N0XVid7004iU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCY+NfR1HQd5zFIgpIkIuc5tlKmepGVaG5Fw9x1Zd5GnaardPR
	kqxq50fJHKNjjmpNMupB530xp/WLZ3VsAZhvr7xm6gMbi/MZHaZIIcBhvKuSCWPBuYMcPoGKDtw
	vnacz9dT6zLgofZoGaqiFHs1pAQd3SfW00fe3qXGM7/Y0Y4qplVLlOG1vK+W1sdJY+85x
X-Received: by 2002:a05:6a00:1398:b0:71e:59d2:9c99 with SMTP id d2e1a72fcca58-72062f8376emr13432542b3a.4.1730119818929;
        Mon, 28 Oct 2024 05:50:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeDRueDu/QalrBy6yjA8xJl0WqO1On2tyepjdx21DYmt0yg/dQGMT4XuWo9uJuaZFlKRKqAQ==
X-Received: by 2002:a05:6a00:1398:b0:71e:59d2:9c99 with SMTP id d2e1a72fcca58-72062f8376emr13432514b3a.4.1730119818590;
        Mon, 28 Oct 2024 05:50:18 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057935769sm5640003b3a.77.2024.10.28.05.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 05:50:18 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:50:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: notrun if kernel xfs not supports ascii-ci feature
Message-ID: <20241028125015.nzly4g4kxmyjtefv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241026201234.77387-1-zlang@kernel.org>
 <Zx9PGD6m8ySNaXSR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx9PGD6m8ySNaXSR@infradead.org>

On Mon, Oct 28, 2024 at 01:45:12AM -0700, Christoph Hellwig wrote:
> > +	_try_scratch_mount >/dev/null 2>&1 \
> > +		|| _notrun "XFS doesn't support ascii-ci feature"
> 
> I would have normally expected the || to be placed on the previous
> line.

Sure, I'll merge this patch as this:

_try_scratch_mount >/dev/null 2>&1 || \
	_notrun "XFS doesn't support ascii-ci feature"

Thanks for your reviewing.

> 
> Nitpicking aside:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 

