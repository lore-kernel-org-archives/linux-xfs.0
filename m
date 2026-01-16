Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5737221DAD
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575139; cv=none; b=dJN3JOWz9L9CjzrXAbqfTswBsy69ysrdCBI/gjov3a88BNdcXjrYfhVAwnhuScjhoIcCHP4SZj+y8oAS+F08g6vj7LvWDihAIM/SgQYpf/beJYq4K0Pmy6kwH1pcaqtTjX62KCSTVFfyeGyJQ5dW9ntq+w30aYBUk+TR9wyv6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575139; c=relaxed/simple;
	bh=7cGeMk8GyRdqCvDdT0G0vEEeDlTTsLl/4l41tbPOOLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLGIzcCUEellzr1gqStfyUFEggPeofixx037lqQMKIwpmLulpE3VeKiwRWdBb13CrCIjFL5QBkQa6I/dY6LEcJog/5yLeBTR6SccLd+PaCg7kmGetuBqZztqI62hwdF4PCsEZJwoBK/drSV+7ybmLTFXlUyqv2npxyc8L5ZT5uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+EOQSjF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mschl6yR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+EOQSjF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mschl6yR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768575136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0h8VbcliXJU5w8d5JITrLYVgYncPw3n5MJT/9tJnIiY=;
	b=E+EOQSjF41qCY6L3vwz84/bmoZ1FTsNoJR7s14s6DLIhWMr8s/3SIJrjAhWKPl+c+9cZbe
	hOxZjXY5PvcZlHvlGoDh7XD+kwika0W54w9c4n0t7l9n3WcKJ9ksCJxudMS2NBE7Uytv6n
	hay7WevjVD6PMpWtWrx4lNY7Tsor4Vs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-SnJx6JZQNyiSSyq9vw_2fA-1; Fri, 16 Jan 2026 09:52:15 -0500
X-MC-Unique: SnJx6JZQNyiSSyq9vw_2fA-1
X-Mimecast-MFC-AGG-ID: SnJx6JZQNyiSSyq9vw_2fA_1768575134
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430fcf10287so1816425f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 06:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768575134; x=1769179934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0h8VbcliXJU5w8d5JITrLYVgYncPw3n5MJT/9tJnIiY=;
        b=mschl6yRVQS+DtwWHfp3xugp7a/voGhBSSAXCed+4WaF33U8gYDW8SDwbylxMEAX+E
         F5Ilyt9dmahvWxjOGgx5nG3XiIJrQeZIAW0yMYdfbNs5+wnOITtBHiXNbHNGy3y3UoRV
         xmddYIp8A7Fi0MCiDLdP9pCU4WIKSlg1GZsv8JK7ZrzG//wWfdp2x9E2IFGNAurUQdG3
         q30iTML/7CNXZ1ihkPWfipKDFf9u+9mJDR0r6uz5v+A93tbPYnAeGk2a2vM+M0C50jgX
         koGSvCKaQBWI1RAethdlEG4cICqeKsTc4p70MnJfAYwfl8UbNq3onDo1Z7X2iynw9XGp
         ALQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768575134; x=1769179934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0h8VbcliXJU5w8d5JITrLYVgYncPw3n5MJT/9tJnIiY=;
        b=nul73xHrHTq7keOvYasEV30GFz6WhRjcjTYBTIMNymn6hykGZWEb/BaP0Dn9z8jCoY
         UCgktdAP5Z2r5yi1hSF6CBJIZUTQaHjUzqOyBiD7fPzeD3L/vADDFuAMiuP8ja08Y7ML
         Zs3gvs7JQfxT+2EIvBQyBY9/JNcrseGYWCmGTSGoi1ydL8XJzCUHGbl23FRBIesl6SuU
         9z0vfFLJXRbslLZmOw10BRFvRmwd3BWRmuZLkTaUdEkRCwsxInqEaPeWhaUpjs23iMB9
         3YcUOIPYQv1vOG0+DvCZRhxFTi3UCZK2/a1mC+pLx7b5CkDmkjxUk/7vGKvW1pW0yTyZ
         Oeww==
X-Forwarded-Encrypted: i=1; AJvYcCVCaoN//lh/99O9isRp7XRY7H/4B5cn7vgpGBiWhIylm+9+WwdcJ75RsV4PekZtQfLO7ObpH9NWRgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRlP9LU1cDTyg2VDSiBDWME4ix4+rN9I4Sv9v9FnoexSkPsC7f
	e+huvgf6wszpPVeAlj89wO/iREJwhuKzVOWhErV+NhQIQWouiEcFvJo+cUwBQaM3SNzN0lAyUYi
	RGe/XVowjI/Oep6NH08MX3oS/zm6HgrDff5p/nRHWEJKpGtA9/RrEN4dSPtXc
X-Gm-Gg: AY/fxX4r8TjzYCMWfNgNV4xXKVUc9+l5CafBe0rTRT0Bbh5Ge537ocxkW4F9dRj/uQM
	XBhFOqBRht7mqAQHM8r4DsLtX2KW8IFfylFltC+jiwGceZMkGkj/EiWVgopBufcI0QQ4dF8v7gy
	HNKliefp+xlEaQO1STiEyEMeHbWQ7Bq4yFNy35PwcC9BfWzj9FZq3HA712ON2b4asqW6e1rCb0h
	BJa595ajWNL2D8+cQ45/IrVWxADEZsRtb9Id0r3uNZFArmO1+Mwz36f1cfuMxg1QzFxt3SIsqz4
	ttG0CDAqFcyFOYSpditlSFOwz2SW3dv5fyENdOVz150tLB53iM5iF6U6+8ojceZw1Hcsducp9IM
	=
X-Received: by 2002:a05:6000:40e0:b0:431:701:4a1a with SMTP id ffacd0b85a97d-435699997a3mr4331552f8f.26.1768575134303;
        Fri, 16 Jan 2026 06:52:14 -0800 (PST)
X-Received: by 2002:a05:6000:40e0:b0:431:701:4a1a with SMTP id ffacd0b85a97d-435699997a3mr4331513f8f.26.1768575133696;
        Fri, 16 Jan 2026 06:52:13 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996d02dsm5633075f8f.23.2026.01.16.06.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 06:52:13 -0800 (PST)
Date: Fri, 16 Jan 2026 15:52:12 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 16/22] xfs: add fs-verity support
Message-ID: <5s37vliyxikgz22dakooeml37yo2jnhqqinnnag5czbtz46io5@h6jikziw3qxr>
References: <cover.1768229271.patch-series@thinky>
 <p4vwqbgks2zr5i4f4d2t2i3gs2l4tnsmi2eijay5jba5y4kx6e@g3k4uk4ia4es>
 <20260112230548.GR15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112230548.GR15551@frogsfrogsfrogs>

> > +	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
> > +	error = xfs_fsverity_read(inode, buf, desc_size, desc_pos);
> > +	if (error)
> > +		return error;
> > +
> > +	return desc_size;
> > +}
> 
> You might want to wrap the integrity checks through XFS_IS_CORRUPT so
> that we get some logging on corrupt fsverity data.  Also, if descriptor
> corruption doesn't prevent iget from completing, then we ought to define
> a new health state for the xfs_inode so that it can report those kinds
> of failures via bulkstat.

yeah, iget will complete as it doesn't trigger fsverity to read
descriptor. I will add a new health state. Thanks!

-- 
- Andrey

