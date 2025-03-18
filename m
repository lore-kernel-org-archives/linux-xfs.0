Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6895D126BFA
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259539; cv=none; b=FPeX6HX2A5OTxCrT0ZJfRyYNXqd6jhHXgpZ146qafhhsaF+WFf7w08U3BSPTuq04nVnknDE8Hf1Eq8wDJkC2+xCVtgaPsdWeNgBNzH6zLT5XWYcDuh14yi0HWDgBFvmbKHhcr3zoaOmWOGwwPOCTOfF4/1A/u1QubcoBXbqfUTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259539; c=relaxed/simple;
	bh=5ZrR8FmwZFt9pMQl0RkxP1iXlpBNwx4xHhFgiYjCL/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGAd28jqaLqZV+l+Vao90pDb+anJoN8Ge4N+OTmWa9X1ckGdmcYzMCk99fv0vlvL9z95xUz6aGl4JNS08K/YFvbAG81yfwoDkeIoOK6G5bc0yIpsi6SFbEgfb6CDzWI5Jqtdt2ibDa3IMG4p5330apdk8Wnau9cSuPGbQQLKGjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=vTnCkht/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="vTnCkht/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2243803b776so54702975ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742259536; x=1742864336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=161MF4t546GPzVjY149056vVTO1SXIOW5yB7kEPgjX0=;
        b=vTnCkht/fr6CK9ulnVZUUxbpvSeC6S0Fu4B34j5+K3pI2KtOq6GzPoqjqB881//+i9
         DlKwOXyWum6LehN7ehNf1ErL/NLwPefCd7ERX4jVzJ90ChsWijDCl65G27V7+WZF51Yu
         NGox7LcOagZ0GTgLxVK12A5qpDvMekZ/Oe2yVTqOqLTvnX4vryx80qViWPfkK1La4e4z
         cwFofRL18Q+6E1eNw1LSJKSz7T62WcWa8+PzRXRkBAqHbvp9xbpeXNLm6hlsAqJX/mnm
         SdUDFc5zT/F6R+/NYj/unGwMmpNoxWCm7wpExZLl75HU2sf+lgop18/EXruh2u9yUZma
         4xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742259536; x=1742864336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=161MF4t546GPzVjY149056vVTO1SXIOW5yB7kEPgjX0=;
        b=NIfWXt7u/MPo+mCL8ZoL2lfl4tCfo/KhuuU1FtjnqJlXFAmN3+rIH3d4r7kYjy1sdz
         lyrGvbJNWKsty4Ebfrvez70ZbiukO9oGjf5CaEp/KcSoOci9rJspyx7YnKEIcquc1Tou
         kLecegh0n9EPfXSJzqOM3tKjbAorVI2CYu6P5o8yDXK+SxDIaSDOzb9g+VSi21ZRr6pY
         8zWakiFOQ6DJ5Ubwsohk0OxIzbsIGc71nmC7ru8klGhsBhEHf9Zbx+N05Rzsbdvea72L
         WuJkiO7RkxgErMSkAqxHT5x/1FyRs/gizNGI8z0JH4DNxKTmNkLEpdpk4wmIQ26s3QTI
         XC9Q==
X-Gm-Message-State: AOJu0Yy/wPUOqCUmApEr2rSzsuA0MhAmIiciBE/Q4kQrdk4fAsTpB/kU
	P15W2UUe2OyH+a3k7Wq2cjwwLsSRt/hEqWaCl5r1hhHHV31YnjGdmfI+jWjj1OiEZ6MSfzQZ+/P
	T
X-Gm-Gg: ASbGnct8iXoYZWeXV8Fb4kLvdssrwpWC1S2verfEvbsZhdRb0fgUfG1jXQoGpR06Af3
	r+QleT7FkNfTRjuHT78p2OzzNtCtzQKYmFxZdxj0JnJ3WmXVaov9n5OHzSP3FMs7h6MfCv250sw
	+P6vgOqFXw/G9n81EIzE1COq9G+UVUDHKfpuuK41kkS/2L4BTHGn5zCHzqO34vOxT9jVAnoAPcv
	b8uRBBWA2IU0EIxCmPSHzlSTsNmZUDgOlCsHCdkMkCPtmmQxBVYRw8wXLdjPiA9VLYSXXQekcHP
	CskXIWmdfeWVMWvFR/H55qdMNsdDlHdczMLc6nqiyjjk0ZbBvUHEvK2vbDJo2zcgiSciTAkw3KB
	DQWtyBhYVXw/Oq/N6M14k
X-Google-Smtp-Source: AGHT+IERR4mfcN1UyRIEMWh/yNyR6pN7eu0wrAPDMWpldRBepR8Zgm/FfsX/spSRvUuW6mpKeBSJPA==
X-Received: by 2002:a17:903:1c5:b0:224:1074:63a0 with SMTP id d9443c01a7336-2262c5ec907mr17449285ad.34.1742259536499;
        Mon, 17 Mar 2025 17:58:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-36-239.pa.vic.optusnet.com.au. [49.186.36.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2262d1641b3sm4475075ad.15.2025.03.17.17.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 17:58:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tuLID-0000000EVKu-1A31;
	Tue, 18 Mar 2025 11:58:53 +1100
Date: Tue, 18 Mar 2025 11:58:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
Subject: Re: [report] Unixbench shell1 performance regression
Message-ID: <Z9jFTdELyfwsfeKz@dread.disaster.area>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
 <Z9iJgWf_RL0vlolN@dread.disaster.area>
 <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>

On Tue, Mar 18, 2025 at 08:29:46AM +0800, Gao Xiang wrote:
> On 2025/3/18 04:43, Dave Chinner wrote:
> > On Mon, Mar 17, 2025 at 08:25:16AM +0800, Gao Xiang wrote:
> > > If they think the results are not good, they might ask us to move away
> > > of XFS filesystem.  It's not what I could do anything, you know.
> > 
> > If they think there is a filesystem better suited to their
> > requirements than XFS, then they are free to make that decision
> > themselves. We can point out that their selection metrics are
> > irrelevant to their actual workload, but in my experience this just
> > makes the people running the selection trial more convinced they are
> > right and they still make a poor decision....
> 
> The problem is not simple like this, what we'd like is to provide
> a unique cloud image for users to use.  It's impossible for us to
> provide two images for two filesystems.  But Unixbench is still
> important for many users, so either we still to XFS or switch back
> to EXT4.

Well, that means your company has the motivation to try to improve
the XFS code, doesn't it? If they won't put up the resources to
address issues that affect their customers, then why should anyone
else do that work for them for free?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
