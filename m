Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AE41448D4
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712602854; cv=none; b=r2s1NdzXuNcVAGAqKPsKQXnsVMyzUPcAqQMS7ASlXej0G5WVkcjWko/WAB5TE7ILZDUYuKjLCROr0rnQyf2SJOuUNs7Ub6LMzSKWQquqeUVFAtBGgaZlB3FuHgaBdoi2/F39GELin65BgxFTN0nd5+zL3xZbDJkVl+/3qyXEHEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712602854; c=relaxed/simple;
	bh=K+7q1REcORZIGhh0XnxohXvlSCUt1Sm5g7l9UwSiUkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X94Pbmuabv0H6TskimpRKRS+q3pBZFX5I2nZqWbjk2C/ViM1UL0EhQKdfuFV7XIGubHCTe8BgSuZFJ7zSVM6/JRNnDkiF52iSsejWRvdq698MB+zKdMPemYKuRLcuTZpvSu/DqL8pDAKMX4KxUEHS+rBU4N8RwGiyaAms1cTOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JAso9vbe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JAso9vbe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712602852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=88+D8iz1phlu4lJsOrmc5P0Y3kTg5b4oDnCnIoO1Zvg=;
	b=JAso9vbeW5/ZO69z76h6xHHiL449thzB5tAc3FL5tioYjX882c70WkXGBJsJKDiHx9HeHk
	r0YeRn1BsOEAmPyrrLFNqac9hOPei7urCzU4zdS8KUvhyzuVlQm4azRGP8PG6iDdExEkD8
	QVQMfzzI3gD8e7Xc9dTkHe8AWP04LBg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-KBGtqik4OFWHa5Q3uetaPw-1; Mon, 08 Apr 2024 15:00:50 -0400
X-MC-Unique: KBGtqik4OFWHa5Q3uetaPw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5c5c8ef7d0dso3906647a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 08 Apr 2024 12:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712602849; x=1713207649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88+D8iz1phlu4lJsOrmc5P0Y3kTg5b4oDnCnIoO1Zvg=;
        b=of6MnT7blfSW5YceRwWwl3ZRLEHHKgbE122l5P5ivxe9VEiNLWWZYW5tzUDTod4gai
         BkW5o77Lrc21Y3zKyvnIR0iVm0qLA8nEHDEAaCJdOiMb9EaRi7ajjyhcB24aGiQ4VRFR
         jpmWklA4wS5mHQRlbQ2j6bNkFf4v8qnB4qZEtqneUKcItAR7HHbFAZ7po3S26wrOOdkG
         uXf6i3Lj8ChrOOCIYyX0KJIkZ/Nggn94E/hOToDuyPQdI8UzgUOVe4ISeSuBlZhSN9Gp
         bENMCRiefUI1B2k7bJqDOw6kLxjeKsnJq26I9RijiFFa9ucegycAXDtSETSppEF4H9uP
         APpg==
X-Forwarded-Encrypted: i=1; AJvYcCW9b2p8xful+bnxGQHZg5tiIHxDv/ftKyYyBpMtvNMfld4ftA9IJNpoYunCDpcpRSNIy3xJjB8kENCUGFWHEvDTr+HxuPHdTl6/
X-Gm-Message-State: AOJu0YxNRSCra0ue7nkpHfXmBPDkBqfAaBeXpzioYc1Pld0Q9nmLfrUE
	omYyO86/uPNNwE/aTRA7rQLv6ZptltFplZE4pWmwG66wDiZ4VbZTQLats5ubXIKV2NcqNfia0sk
	8dKQNs+jaoqY8bZLuAIC6Xzx58dPP0/IdhAJfeGhqg2aqrxcUaWf2rqy2eg==
X-Received: by 2002:a05:6a20:9c8b:b0:1a7:760f:feec with SMTP id mj11-20020a056a209c8b00b001a7760ffeecmr2919460pzb.20.1712602848823;
        Mon, 08 Apr 2024 12:00:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5eZNvcTRkAd6yJWfNbNuUTgxlUrWgvWXCU3PsR47PtVtR8dRe/LqVTa3PsraTaI9ft/qq+A==
X-Received: by 2002:a05:6a20:9c8b:b0:1a7:760f:feec with SMTP id mj11-20020a056a209c8b00b001a7760ffeecmr2919433pzb.20.1712602848323;
        Mon, 08 Apr 2024 12:00:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s42-20020a056a0017aa00b006ed59179b14sm1329322pfg.83.2024.04.08.12.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 12:00:47 -0700 (PDT)
Date: Tue, 9 Apr 2024 03:00:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240408145939.GA26949@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145939.GA26949@lst.de>

On Mon, Apr 08, 2024 at 04:59:39PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 08, 2024 at 10:55:54PM +0800, Zorro Lang wrote:
> > > this series ensures tests pass on kernels without v5 support.  As a side
> > > effect it also removes support for historic kernels and xfsprogs without
> > > any v5 support, and without mkfs input validation.
> > 
> > Thanks for doing this! I'm wondering if fstests should do this "removing"
> > earlier than xfs? Hope to hear more opinions from xfs list and other fstests
> > users (especially from some LTS distro) :)
> 
> What is being removed is support for kernels and xfsprogs that do not
> support v5 file systems at all, not testing on v4 file system for the
> test device and the large majority of tests using the scratch device
> without specifying an explicit version.

Sure, I think most of systems testing doesn't need this, except some old
LTS distros.

> 
> The exception from the above are two sub-cases for v4 that are removed in
> the this series - if we really care about them I could move them into
> separate tests, but I doubt it's worth it.

Let me check and test this patchset more, before acking it. And give some
time to get more review. Thanks for this patchset!

Thanks,
Zorro

> 

