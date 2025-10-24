Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905DD20D51C
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 06:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761288594; cv=none; b=PnPQRMW6zmZSA0wxF3TSh9yiWES6CnYYNeq9XNZAQhYlmDAyThTYc/lbPEtGAssHjvtq5KQh1zTcTnqaQ8fUJDiJ5MaS0BNfQZLy7JNWCEHvJze8+4cRiyVoZeHiMCxsU28taJep2L3aVl4DIeURwi5aFC6tduHyHWkqOJ+fU7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761288594; c=relaxed/simple;
	bh=9vBPEojZFqE9ty/6D3pThFauraHYwTpalTAAyZmWy+Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=VnDtbQ0uAoiH4FagFktdLKrcQ4yhfDRUkEwPrnZ4HmAIw8IQZAfBlKEOxter2HZipbGxrsOza/E0axdpNE5iLuagCTFlqFRLmYCeib1ug0Z+RxpEhujl5rporCLU0r6RXwEApdnI3eSum77Kzbric8RbO9+mWWP0nHsehBsHkmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aocwFo2i; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aocwFo2i"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so1395072b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 23:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761288592; x=1761893392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=km/6k02PixTAqdwRObjjj37gw0zTjmxCVFm4PbnN0vM=;
        b=aocwFo2iwyQXzunpY3YY/LglR7A2L0TtoJ5iM61FQIOag2L6AdCQc0vK79Rc9lqR4c
         rc9TdIJoaE8Vb9eRz7VVuDlOx8h+WUus/hn7Q0iIKZzhdeiFdeg3p/AQRH18J7O+7HrU
         IrhYkve2wN6hzVC010WA3LshH62aimVsHhK/e1Wt/y//BlR6v9yEmbK9AV0UuuFlSrCN
         1KAFXQ+IRhdodxZZ4uyGiMeaK7Kr9mYwU5iYEgIlb5tmFC1RjBSZbWvbFi8sSuvfPuzP
         +kqGwVHOWHK1pmLFivSqy0fRx7lOFkqAucRfh5RPMsDQ+SS4QWv7AsFedDdXMrOBaTqv
         eMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761288592; x=1761893392;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=km/6k02PixTAqdwRObjjj37gw0zTjmxCVFm4PbnN0vM=;
        b=Px4ozsQqUxlMINwvXR03IZnC4eCYbCS/Sc6XYA0SyipwiHP8RTnYNIYN+npKaFkOcL
         j75j30oVfJnm+CXRF2pEdN9XE65PB1u9awjYijIKzkiZBaIE91n6LXGYHVfKjT0q+y9M
         E8NoMJVzXWyQdgD4OfZMpZg6UHMI8LgNEvy5vS/elAUMfHjm1DRX9/YlQc++9mWilmqE
         YF2rPl4JHECtV4I9499X1iBC1KpSwVPsLfu0VgtBDVRSxHWoBd51UB5ts2WaAopunvU1
         RVzs1ZLa36HiAOqUSiBMe7zIyOpiijMV7Q0ZDHoRmsVmbYdMLytYahn2nI/50YP9rqF8
         r+7Q==
X-Gm-Message-State: AOJu0YwBpYgzrBabKHhjzaXPyHiM6ybTk0JNodul5wiDs62/lIodjYrT
	LWFxb47NdMal/0MCAOosHTyILY+WJYvvHI4Lo5ZdpYbE4nJpuveLCuw2ET03nA==
X-Gm-Gg: ASbGncsNpiCf8qgmEhVXGiiO7c+uy6vjpSpg+krvu+HoGIRYhGs7xsy4Orsyd9wK8/A
	nJPn7GdgSTMbpPVaD4MD1fxJm7mVOSg8AQYsyUuyHp32FIDEtCN2D/DmbBkh6OXDYEoeJiH9rKF
	tPkKLc3LWe3YEAsvQ0oURcsCuMX88StWp5AHSJhzyUv/5wOGZmsSI8BkdO7xfKoLm3mGkD76oc2
	G9i9kktmJ0jHuja0Zad4DlpcoZpCmcO+Hp+LekqDWjwkZxBk6xaEW8mgz6phsJ/QNqvJOAAPgiU
	zMHCupag1+1eWv7NoKTlND3fTyzraSpdFYIRoZjSyLpI8gQRZ0Y8FoRLmsZQYDqscOwL3faCVd9
	ehbaUbay3Yn64iYGkvfqxWaumLbrwrdhZWDkrhXpLMc71Iyy0PUEAx21iNT7+n0A6AZFXmFasKm
	anusRBZc6yzF+zR6wxMIrnsfc93nK+4ydbR7i9jZ8gP/Vi8BKUgcTg
X-Google-Smtp-Source: AGHT+IHBw2wC0BoP2X02OWCazdHGMebKdJsDNmkJBbtCK1oS/G49+mr3awzE1GU+XQHCYvJEsXB+uA==
X-Received: by 2002:a05:6a00:4fce:b0:7a2:7d3b:4356 with SMTP id d2e1a72fcca58-7a27d3b4449mr4993313b3a.32.1761288591770;
        Thu, 23 Oct 2025 23:49:51 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274bb3789sm4779374b3a.60.2025.10.23.23.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 23:49:51 -0700 (PDT)
Message-ID: <47bc0211bd8cc5474fbb3edb5446e0e306ccb026.camel@gmail.com>
Subject: Re: [PATCH] xfs: use kmalloc_array() instead of kmalloc() for map
 allocation
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kriish Sharma <kriish.sharma2006@gmail.com>, Carlos Maiolino
	 <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com
Date: Fri, 24 Oct 2025 12:19:46 +0530
In-Reply-To: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>
References: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2025-10-18 at 19:45 +0000, Kriish Sharma wrote:
> Using kmalloc_array() better reflects the intent to allocate an array of
> map entries, and improves consistency with similar allocations across the
> kernel.
> 
> No functional change intended.
> 
> Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
> ---
>  fs/xfs/xfs_qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 23ba84ec919a..34ec61e455ff 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1218,7 +1218,7 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
>  
> -	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),
>  			GFP_KERNEL | __GFP_NOFAIL);
I think kmalloc_array is more useful when the size of memory to be allocated is dynamic with
kmalloc_array doing some additional checks on the size that is being passed. In this case, both
XFS_QUITER_MAP_SIZE  and sizeof(*map) are constant i.e, we are allocating constant size memory, so
maybe this isn't quite necessary?

Definition of kmalloc_array()

static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
{
	if (size != 0 && n > SIZE_MAX / size)
		return NULL;
	return kmalloc(n * size, flags);
}


--NR
>  
>  	lblkno = 0;

