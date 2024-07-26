Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976D917C7DA
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014249; cv=none; b=o8xWrr6PJlq6Wi+wfbXiQBxW//NMpRGngGBHfM0i7L0pM4nXw/Hk59YF/nGrUsuyC0/8B2lZ2ALa+Kqco3v6tVXWSdKnKzFd8XRkVM/1etb2sazLY9iuytk58TIHAKqJbfUd10cVO2ItJM6JNzEZmmSfJ2L30gTF6Kxf8xLH/YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014249; c=relaxed/simple;
	bh=GEwKHBVtx1N26/ujHSceefTYpD0QGzCg6xKzapPXe84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJOXPrvt56LfM0H7T1sTnxyn4nmbi0zUiJYz0Y6m4TW1UI2dKJWdEr/vMD6ETziKDKXRvU5fooxj4hk1YO3kPTTHtYIcZz4ZxSTm/cJjde3dX89QxB2clMid/oAohM5oy3zsKCaZxhqE3iSwGxzz84beLr2t+LqZtU+Wos+t3gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yb5Ci+ow; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yb5Ci+ow"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722014246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw3IWU7w6zZsJSaAnBwaTqswOfBwnb8wRbLaVBbbqJ4=;
	b=Yb5Ci+owua6euZ25R7eV5IhB9sVduUvS3fqYvHkom9zpq1iCN00pDFn3L2af94p042wQyp
	HcvpT7YdQZYi6gbP3WE4rDg4pi/bV+3bz4RHYZMOmkrY6sB8x8kNFJii1ECn9tjr+5NtGL
	mkQV1F5Giwihz4SGwgacCgELCqp5WOs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-syZ3z_N3P2qIYRxb6l5nug-1; Fri, 26 Jul 2024 13:17:24 -0400
X-MC-Unique: syZ3z_N3P2qIYRxb6l5nug-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fd6d695662so8953355ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 10:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014243; x=1722619043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw3IWU7w6zZsJSaAnBwaTqswOfBwnb8wRbLaVBbbqJ4=;
        b=jI0KiBC+tA14H9neam7vpTwBzzrpNEY8evxSg4wKQ9gWysieJjgkErq3niZq/wisys
         qkyhyrEGnFa15w23yYBwzJce0po8xu0aDT8qCa+6J2QvJQILQpDidlfKoZO1Vo3zrCvX
         hUbcwb6EdhvLZL1k7e5VvDWzwXXfwDMnkGOpsoY3hSP/D5TvHcz0xCecGbNcsVpjA17w
         e3HkcrEEcTeZyW9AyOAfILGVSlQ6PgwqlWNoC5GQTVeyvpbZ4QAtWna9NUY/zCFZP52Z
         i44Y37nPtnwqcfMGxAA2qkjvMSGR/na8Eg8I3WaRJamWPmJ4hx9CtBUX/EGKGjrR2aVs
         a1XA==
X-Forwarded-Encrypted: i=1; AJvYcCWuMB+tWiFPKXMgDWFA3YIQj3BQkQ+SIa1mgbN+2KFJxtMB8SB7wo2BvkIkT38lZ8yEGziOSNwQfLK9CbJcu+L+UGgO5qNwEeoM
X-Gm-Message-State: AOJu0YzPNnF322VRKzyaAi01wV1R+4yQy6lRF0w9zgFSlQdJjcr06+Vp
	vAMb1CXia6YL7gy5Cli9PBnMdwHmyvHhK2Rr2YJWvm7yW08xQGPuMw2PVqaKvtRUOqKlnZE4zjP
	AASjZ9BxKBVkzt4+z6c0tukSfUEEO9rumxzH3lzSb/+wj9osV6H4+U3jxUg==
X-Received: by 2002:a17:902:fd08:b0:1fd:6d6d:68e7 with SMTP id d9443c01a7336-1ff048b07b9mr3275335ad.43.1722014242117;
        Fri, 26 Jul 2024 10:17:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHV8kswWkxc0kwXS2BsEOM7JImFw8sfMaRuWDfDSbqVn5HjOy4+vI6im3jP6KzTizpAG6n23g==
X-Received: by 2002:a17:902:fd08:b0:1fd:6d6d:68e7 with SMTP id d9443c01a7336-1ff048b07b9mr3275145ad.43.1722014241786;
        Fri, 26 Jul 2024 10:17:21 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7d22742sm35370225ad.107.2024.07.26.10.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 10:17:21 -0700 (PDT)
Date: Sat, 27 Jul 2024 01:17:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/754: fix _fixed_by tags
Message-ID: <20240726171718.46mida3edxf5dm55@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240726165107.GR103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726165107.GR103020@frogsfrogsfrogs>

On Fri, Jul 26, 2024 at 09:51:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test requires an xfs_repair patch, so note that in the test.  Also
> update the kernel git hash since we now have one.
> 
> Reported-by: maxj.fnst@fujitsu.com
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/754 |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/754 b/tests/generic/754
> index f73d1ed611..7afda609f5 100755
> --- a/tests/generic/754
> +++ b/tests/generic/754
> @@ -13,9 +13,12 @@ _begin_fstest auto
>  
>  _require_scratch
>  
> -test $FSTYP = "xfs" && \
> -	_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> +if [ $FSTYP = "xfs" ]; then
> +	_fixed_by_git_commit kernel 38de567906d95 \
>  			"xfs: allow symlinks with short remote targets"
> +	_fixed_by_git_commit xfsprogs XXXXXXXXXXXXX \
> +			"xfs_repair: small remote symlinks are ok"

Thanks for this update.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +fi
>  
>  _scratch_mkfs >> $seqres.full
>  _scratch_mount >> $seqres.full
> 

