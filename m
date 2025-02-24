Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD7186E40
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431036; cv=none; b=nT7bLu72f5kA6Gz021n0HfCLJa9JgURyyD+6GEsMwWhHa8Ct77WJf48U7pS9bv7op+54vhMOjz6l1xrvVt8JrV97hSy7XEl2Iz3m0Gf9brZJfTJLdIgYEyqBePZPv30lBfknRN5QZOpVbLMdS3EVYUZDp026qu/KeSgd5l2DvNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431036; c=relaxed/simple;
	bh=gGuy4qTYiCjJwricMlnYfbjxl6LLbfE7sAm2AOIO11k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKRE9Ma+TuHSh+xZ6QheHgE9r/OUFLNK++i2+LlhxllkcS74mWsWBcJmfpwN51pNFI4fBO0xmccaKjjoiSWb+wlQluVmBuzKvhvy0Dxkewbdx2bwlWeiQEnT9RJXAeI0OmcOL9moLN3wCEziGBwdofXouFO6s4/knlwTpxDV4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3H+k0EyY; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3H+k0EyY"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-220ca204d04so79184775ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 13:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740431034; x=1741035834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/jive8ubizwrqfSP6PFykHj+E6EHW/olQWkmUkQbXU=;
        b=3H+k0EyYiKK4eBDIvHYOrD0NCcLw/kd0Ndk5oqw8wkldsbVFN38AZqZCdcFtOwXo1f
         Yo+wcQSqavmZlzGQGA39ZxapafjauS0Ebg8Sd3vsJ5PLF0suYkjQRdzqvhP5ppbq2oTi
         PtVxT9mj56EzRqLp51zhkO3rZnB450f+PrEOxdsxRPcj76Fp2+7e9vhFFPpYScGsWpxP
         9Rg67BlRG1OIvBghZHCgVPjj2ZzuxAvHtiCgDqqZdrJqI8p3GC/B5zlzbbBUPf9DD6wU
         uPQ7troVNPZM9wzbGCbkCCekzppsnA9UJA0t1eXKJvSP3cgs/9FlyT3i2sERRiZD3MOp
         mbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740431034; x=1741035834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/jive8ubizwrqfSP6PFykHj+E6EHW/olQWkmUkQbXU=;
        b=QhXk97agwyHFNctAWFphMPrQE8MS77pZuIo25y2PpQixbHihSjZ52kA43/w32yuB8a
         HovFxbicZvflKXXnP8fk2wDk+Cq9Ud2fnwVekaHinfCrFk3KfWybvjCqzk/nfEJIlqIb
         Y2EsEo/O5FiVj6xCXhgWQ0+f6pi0stRcNod9kRNUhofQd1fonPIQKawJ4VcC18v4+Nrd
         P1JC/PRPifYkUDdMHYQEvZo7eDcBrhgSzJRfc/Ffnh4B/iBBpDFPsWdIyNV3vQyNvz1P
         UzbKD5SDYkFiO6n2X+DrFiPGHv3LUd/tZGvi656QRAIsIl1Ra/s8MIgyrBb7cN5gzRwq
         CUdg==
X-Forwarded-Encrypted: i=1; AJvYcCWXPbiU4bIMD8cIkGUtVA/vD+7M3AxdB8cP/U/Qh8+OmiKMdtug/wC/j7sQ2L6jFj1fNUvlhDOm2Lc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJfcWh4TehcIbpTuETUs+pVYSr/zdpuiJCGnzXi5zJKocttG0k
	7xsyjDADXwL0rs892NDqoZKnASDatPR+WjSP528xYPnGI/79oyRAU0hWDsZvM/0=
X-Gm-Gg: ASbGncv3G6QUSfxYQT88DX3wmc/L7kPqp1WRWJkAgNNDDKd55J3QJm4zBUG0m1zezCz
	pXKmrsyGx3Xf1NgQwtbp9KacLGx25srCXjcDqDyYIh/zTkseue8C8Ao2SAuK5cNiOO2RoITBNt7
	EgA4lyYwuXIMryRQVyIcwcFohO0MOqcX5tPJszL2MQ6pSxmpYP6iwuhN+/5J9SSxRIPVQnIgn2s
	ozbAbD/AUSOQPdU8hx/chbYTBALg9oZHTNoVQeCdlZRuPi55AsZ5uFV7CrgExZk4hwYAp0ktbi4
	MdKo4Yn+AafaRtqRic6gMLIVPLt/KwyJ0cO3Uh1z0Z4WIlJwWp2kPjJZPoiPVaPkz+MJZBb/7vg
	XzQ==
X-Google-Smtp-Source: AGHT+IGDfZAu9noHHanLfS2UfQWv+8cy247PmWEFZRYomlFQXiwVDW4y+8YDXd34Dox4qY9CFk3JiA==
X-Received: by 2002:a05:6a20:748a:b0:1ee:ab62:c26 with SMTP id adf61e73a8af0-1eef3d8d2a0mr28024351637.27.1740431032756;
        Mon, 24 Feb 2025 13:03:52 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a6f5c07sm90060b3a.38.2025.02.24.13.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 13:03:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tmfcD-00000005V6s-0zUy;
	Tue, 25 Feb 2025 08:03:49 +1100
Date: Tue, 25 Feb 2025 08:03:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: buffer cache simplifications v2
Message-ID: <Z7zetQgREN94ogEh@dread.disaster.area>
References: <20250224151144.342859-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224151144.342859-1-hch@lst.de>

On Mon, Feb 24, 2025 at 07:11:34AM -0800, Christoph Hellwig wrote:
> Hi all,
> 
> this series reduces some superlfous work done in the buffer cache.  Most
> notable an extra workqueue context switch for synchronous I/O, and
> tracking of in-flight I/O for buffers where that is not needed.

Series looks fine to me - a nice set of little improvements.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
