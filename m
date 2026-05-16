Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95BB3E1D06
	for <linux-xfs@vger.kernel.org>; Sat, 16 May 2026 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778936159; cv=none; b=LrYYVqf3NUygTU30bjw7flc9qqmkOcytWmZmx2DD58asTycHXpaUChqFaM6ddkKDlD8A+Z4QwDAYa9TbA5sor+kZ3zHaMfYdRjApD8s1pr8k329mv5eX27zPPlzzEUSJRFErgdw2EIDGkgE4KMZlUch9pEwEWhGRf3k95BjStNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778936159; c=relaxed/simple;
	bh=A3rsjx/e0sH3ypncb6HhNgZk+XoZszLMybuCHv+/y6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxS75A3zs21K5dO/m+1OTnNtMYiuIQjuibaOLsISs8/xidrZ6sFrTY7DsP8GJaLOwnrTACWRcaVSJtqO5YwEsGeHdabqkHGw+CE+Fd0W8ZKc+ePH2vKRhF5LhK0UNEnQsRtXNqEiFxKglXITtTCyLGAv2BLfdHFG/YqjEQYJ+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELw9kUcC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lGWMhFM0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELw9kUcC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lGWMhFM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778936156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FRcShxdd6chEWa8benJBO4QTzrRSYh+rVhYzFlnbZ1U=;
	b=ELw9kUcCHA1OiltOxj5inJQ8ykdTokmMeJTMnT5r/WU4WvpQBJKAwqoX6HisqniKK2TqCr
	ruEE9Wxvy8yA0j4wNnlQ3bBTvKByQRWgSltLSMSPyCHXKzBfAgBBOWdK0Kly1K20NFSVuG
	f93d+z1/a3z/8qDHRJZCHOT/qZmWprY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-e4ELYp6AP4WH9zS_2LTh6w-1; Sat, 16 May 2026 08:55:54 -0400
X-MC-Unique: e4ELYp6AP4WH9zS_2LTh6w-1
X-Mimecast-MFC-AGG-ID: e4ELYp6AP4WH9zS_2LTh6w_1778936154
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fd9c22b8fso8042525e9.3
        for <linux-xfs@vger.kernel.org>; Sat, 16 May 2026 05:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778936154; x=1779540954; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRcShxdd6chEWa8benJBO4QTzrRSYh+rVhYzFlnbZ1U=;
        b=lGWMhFM0mGAamZBWsIWMmW2aXTiztmu8fn3dHQBvwLgFjayTVdkC3AzivLtIA1Eq7w
         TcyP8GtcmDpPfhc5QJHn79dnzGjx4MYbqI8YZ9RugmYyYc/WjCLwJV2/5zoDx9pHD4ao
         85xwGYNWGODGOEuOvgROFaqQ0W5BYw+2wUSMa/UGKkvu7+4iWNWkU5F2bJLtZqYBr0gZ
         ia8i0fKP8Piw0uu9MdblHKuwiSCGlfYvHTErwewTI3dhyOFt5Owcn/hf8mmbAuLD3nQd
         oc0Xhjz7XzkgOJEh5Hklc/BMuFr5myPcdpUL9xlHojHVjaS3kAui35KoKhKdpRsaiREI
         WBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778936154; x=1779540954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRcShxdd6chEWa8benJBO4QTzrRSYh+rVhYzFlnbZ1U=;
        b=HVGBUkLNcQM+CuILYv2W+DtzhXT+TwBqKsdJr2vLH+P5t4CmVmqZyxDHJZ6gBLVK/g
         mqNyi+xzHnkr2U/dUqAvdL1XGiRg4o2OR/j4xMePEwfzzllylKCglfjSid94avuv9VCy
         e1KiYvBtpkM5Ks9yznYkeCttqC2t8IZy2ASfyTosLhMchMakim4cCg+9hJIQQnvxTTee
         lris83QWXgsLlFged6yrLftRuX+o608SJXIPnmFJwIGWxR6XkFe78D3PQFofMznQoEer
         P6p3pjce/4upeyPyui73WKdYnkbj9OlzVTVB1dA8NofTNoX9JLE/T7PYjzZj8rfH3rPh
         hLlw==
X-Forwarded-Encrypted: i=1; AFNElJ9uktGYMkVEHr7u9yLO5xf3HpO+HMpXAJdGb02GTaeQRrQxIiYVO5duMGb75yDLsa70OnAvxelm0Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxqqd9L/BzZOA72BFwJa95f2csdeoKujp4xEYXUYCXCb/itgk3
	ajCq6Fd6kMdBod35I2aCze1etjWLBn4+McfIo6JOyVCRhasmDqTyzEAyGf4W4Tr/aryszwWaiFj
	kYxyTHRuCGn09IIpO42ddC4xDaolBWDKIMaKESbD1IAxrb/obEkLnAe1RhX0O
X-Gm-Gg: Acq92OEpfW7JQArwoBxsV2PKa0vOT194QV/gg94qmUxGCdrSFh5KxlIxz1GdixbvaIo
	QSFB17jAIqUvkaPs/DY3bjqFhQcetsmTl7s8g8dL4jhkDsj28t7VH+gYWdU7MnhMFjpJKzvOzTE
	uF9MUoc8DLM+5gSX1fsjfmyXzdgD3fs4C6DJSGGHG4BdibvSSypRItG8/w4gnxNLDkl+0NxTq9n
	WAWn8MffuEdKSCqKzqzVpAAAckLouVmHGwgWVTmqBycWq3dV2OpmfiQMEe0Yj+B25o2YcFRnKqe
	fXbCRHhI9uDMw5zVM01iSIuKMmgDpzucLJ4I1efWEo/OFT+bDh5Uh4xu7WpCvCjcZcu3dTBZ1To
	1MLYIW3u4+lVb/X6bKK405g==
X-Received: by 2002:a05:600c:8b01:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48ff3345725mr44917425e9.5.1778936153661;
        Sat, 16 May 2026 05:55:53 -0700 (PDT)
X-Received: by 2002:a05:600c:8b01:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48ff3345725mr44917135e9.5.1778936153236;
        Sat, 16 May 2026 05:55:53 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5e9d5d9sm147590775e9.15.2026.05.16.05.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 05:55:52 -0700 (PDT)
Date: Sat, 16 May 2026 14:55:52 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-ID: <gacy7yuzvgzucfj4arw5uplthkqog4k3r2gsgbsei46b6yc3jb@psayb6xo4ele>
References: <20260515133212.4039831-1-hch@lst.de>
 <20260515133212.4039831-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515133212.4039831-2-hch@lst.de>

On 2026-05-15 15:31:58, Christoph Hellwig wrote:
> When a buffer is freed either by LRU eviction or because it is unset,
> the lockref is marked as dead instantly, which prevents the buffer from
> being used after finding it in the buffer hash in xfs_buf_lookup and
> xfs_buf_find_insert.  But the latter will then not add the new buffer to
> the hash because it already found an existing buffer.
> 
> Fix this using in two places:  Remove the buffer from the hash before
> marking the lockref dead so that that no buffer with a dead lockref can
> be found in the hash, but if we find one in xfs_buf_find_insert due to
> store reordering, handle this case correctly instead of returning an
> unhashed buffer.
> 
> Fixes: 67fe4303972e ("xfs: don't keep a reference for buffers on the LRU")
> Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reported-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for quick fix!

The issues is gone now, tested on v7.1-rc3 and v7.1-rc3 with
fsverity.

Tested-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

