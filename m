Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC3A13E3F5
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732181746; cv=none; b=WxoHrE7vUqpsM0JmXWxZTBYVcmHBN+usVnP0CixrGn1r3pBk2mtBbaP2jao5ch5I5B0SquVLz2KwLgv76Otdmd/EcjbcDKMj4O8xcGiKwamsOMnIaaJHLVgx42n5tH2VRoTnouEAIvSWqI8wEnLLr3FNAnJSiDc5pLFelnh7NwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732181746; c=relaxed/simple;
	bh=g30hGWyzlT85JGfMkm1BuayUpjVwmv2oeZJYNX53f4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaWeo7HU803kOK7rVzYePH3E1a714hLn4t8pNLO1wBEFUtNbnJ1j/FPBBaxvbdzlWmlqfm7zaWeGrGS+5XsqlYDkv6HOL2PZSukL32SDkL1vMQGAAZ/jfTb3erqVuBP2ZXwHKG2zHni5few0sTJuMkTSS12gRJF30Qny88K24wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWwzknyG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWwzknyG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732181743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=twr1Vd5/IUIFed39IpMewT+Cuxz63lwavhCPiJw0HLc=;
	b=hWwzknyGxN1BxhXsnGTdnv7NEBFXnaLUuwYDWCqDqZ3vNn/QZaOFwggIEmH6fgNZrbNCxp
	37ge4kgjW4CJb7+NiUI7v+3ekD/DVLeQRx6rGB05ufrENPPGFfdGpJnJkvyrljR95UtJOK
	bBZlKcGff8naiX4gOs/9FODJgoadEs0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-X-pGs528N5CId4lb82Q15g-1; Thu, 21 Nov 2024 04:35:42 -0500
X-MC-Unique: X-pGs528N5CId4lb82Q15g-1
X-Mimecast-MFC-AGG-ID: X-pGs528N5CId4lb82Q15g
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71e578061ffso950062b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 01:35:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732181741; x=1732786541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twr1Vd5/IUIFed39IpMewT+Cuxz63lwavhCPiJw0HLc=;
        b=w+hRO3a4H/nlR53HZXPeHoufOTmnpsR0DdWYsV9z62VNYZmkstA2xyBjTHTHw85VPa
         nUByHV2E1j2UBWlNPXM6XdSfAb3AxN135Le7YYtwhufasFJXVdlGMxI8uB0XlDWkLmNM
         Wh5mq89BOOgPNlw7pz6Islf7bEuEMRswIXHX63R37f5thXSMrshOZ+yLXzlz0T63+6zN
         BV9cqEawgwK3wkiHdx2kHdPUExaC6r94G4E3Bu+gG07VTjigSSMrqwvSXeZQ9xGgkI1K
         /OJcDsHsHDQm33R6KK0af6vVeujG3tABopltujf7F5nnWez8T+HYfAS30Vn+f69niK2H
         2q9A==
X-Forwarded-Encrypted: i=1; AJvYcCV89PugyHuuyUjxcFxQUWzEIJjvSkrj/8ydR3cFzFw0JeeJnNIH8lbiEHNpF/pwAvuvbqcPKiO+4+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMIR2QCu8xqaSDCadF+K7B4blc3AtogZu/MwFNjGY+TTcTFj0v
	8D9CIFfEhBYLYJODmekoU3FFA456ISADEdbzlSMtjOyhHTnB35h23FdulsHuVaESzcU4CYJgvqd
	yCRLR9P98FvO0biSbfNg888MV4A8tB0TCy2/0x3YP1uOhvzqlR1hFgvBCfw==
X-Received: by 2002:a17:90b:4a07:b0:2ea:bea2:dffd with SMTP id 98e67ed59e1d1-2eaca73fb17mr6622843a91.21.1732181740871;
        Thu, 21 Nov 2024 01:35:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoY5xAsZDzAV5P5YLI5BNR5T1h00E5v62wsCcyiyBS4MsykjurHPBo2AgszxNPeoTj0sCUgA==
X-Received: by 2002:a17:90b:4a07:b0:2ea:bea2:dffd with SMTP id 98e67ed59e1d1-2eaca73fb17mr6622832a91.21.1732181740540;
        Thu, 21 Nov 2024 01:35:40 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-212878a7c51sm9487255ad.74.2024.11.21.01.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 01:35:40 -0800 (PST)
Date: Thu, 21 Nov 2024 17:35:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/157: do not drop necessary mkfs options
Message-ID: <20241121093537.ae74gwbzl53yvsn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241116190800.1870975-1-zlang@kernel.org>
 <20241116190800.1870975-3-zlang@kernel.org>
 <20241118222614.GK9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118222614.GK9425@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 02:26:14PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 17, 2024 at 03:08:00AM +0800, Zorro Lang wrote:
> > To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
> > does:
> > 
> >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > 
> > but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
> > fails with incompatible $MKFS_OPTIONS options, likes this:
> > 
> >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > 
> > but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
> > that, we give the "-L oldlabel" to _scratch_mkfs_sized through
> > function parameters, not through global MKFS_OPTIONS.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  tests/xfs/157 | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/tests/xfs/157 b/tests/xfs/157
> > index 9b5badbae..f8f102d78 100755
> > --- a/tests/xfs/157
> > +++ b/tests/xfs/157
> > @@ -66,8 +66,7 @@ scenario() {
> >  }
> >  
> >  check_label() {
> > -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> > -		>> $seqres.full
> > +	_scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1
> 
> Don't quote the "-L" and "oldlabel" within the same string unless you
> want them passed as a single string to _scratch_mkfs.  Right now that
> works because although you have _scratch_mkfs_sized using "$@"

I use "$@" just for _scratch_mkfs_sized can give an empty argument to
_try_scratch_mkfs_sized to be its second argument.

how about:
_scratch_mkfs_sized "$fs_size" "" -L oldlabel

> (doublequote-dollarsign-atsign-doublequote) to pass its arguments intact
> to _scratch_mkfs, it turns out that _scratch_mkfs just brazely passes $*
> (with no quoting) to the actual MKFS_PROG which results in any space in
> any single argument being treated as an argument separator and the
> string is broken into multiple arguments.
> 
> This is why you *can't* do _scratch_mkfs -L "moo cow".
> 
> This is also part of why everyone hates bash.

Hmm... do you need to change the $* of _scratch_mkfs to $@ too?

> 
> --D
> 
> >  	_scratch_xfs_db -c label
> >  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> >  	_scratch_xfs_db -c label
> > -- 
> > 2.45.2
> > 
> > 
> 

