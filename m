Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375DA524C
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 07:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738825419; cv=none; b=be+N9b113ZNtYb01u7zowN6FuhmDlXFuaTaEPDEOtSwipxS6u90kaL7M/SLapnPGJQ6IfYL7sYEtP1wftYnLM0y6/spQphbIl9RcxXHc1Y+qcfMVtBfSiDm8C3eBc0zffe/SVwVin4CIKNyUs9zqL++sV1h4WVvwPaHxeCY9Hh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738825419; c=relaxed/simple;
	bh=MAFCAya9BQkJMUURO+rRoCDwCJNoQaOdeo0REAIb7GU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RvxV/BDXgN4+YgVJumSAnYQ7Et7gTkKlR2rgzh6ubWJTv9nWkxSKaPCzuN6VhMNAZYuzd+u6uk7oq7cK8oaZMKY0VllCjziDsCAxryCGizYaGZQLDLVUjVcnCEMZI+c//5ALH4nkIkoN3lN9ut26atJdxZIX12ImOL8voJjzUZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=i7MQOhUb; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="i7MQOhUb"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f2f386cbeso9942975ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2025 23:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738825417; x=1739430217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nQlE4RUuOJEH8ZS5oPRIjTRf8PeVD9Uib5yhX/tij5I=;
        b=i7MQOhUb4LVoFwnX/gN0pnwRLkv4+cSJVLkgfHwhvvA30xW3Gg6GdMlyBUdlaeTriL
         ovot06cXq0BjFt653DYHulV/KF6bCxG5le4tn0eaUO2/AHmtsIJVuRJw99GVC/UFXD/q
         bhXZZvWJdCCOErf06Y0Q4itY12LyaTmwo5eNu4uhJdkUV8GkzmBmbTjenbq3nZCjSNz1
         b/5JTYMfgxBPCudS8G3s9Y8yzF2cKFOOUdNQs6xDF/HGS4IGJtY5PVAoQm/E/IkNnRxB
         6jUruIQWmyFToUcGYI/NZG7jFSJZR6l57bHFeF+W9CeGW4De12Qe0OiP1DJFDCeiGPqM
         LS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738825417; x=1739430217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQlE4RUuOJEH8ZS5oPRIjTRf8PeVD9Uib5yhX/tij5I=;
        b=VUcRnk8L4dkPbzXlgPh3a91JGyvXEKFQvMUlp8DbvSSONl0JFNwYsCshsDNGwzvhw7
         xB6rrn6HAuKRyJAIBMToVwuteiPpVCHW106bD8p166jNQFCP33qiQn8XLe0G2gi+n7X+
         Z+YL2Z84+O2COXYn3fD8rdbiNzVZgd7uQZGl5ERblvyPAj6iV/XXOShgwjV631Gmf/Vb
         U7Ni32SuXu59a8NzR7jSJtRTMpRqiTEWbRyDhGYzsLdlWHFmYMgLpzmi+QOxNE4xkHZJ
         l13ln77lWHm9WAhdyZdMRbcpJf1nIBW+szKPgRhrZCagwhFs6KTm3pK1qKNOS3XqrpKc
         wIXw==
X-Forwarded-Encrypted: i=1; AJvYcCUkcpLgZL+TNKitysJiZUIrB7wHXqbGy9dXVBuD1s7edhvfDfGdozPSlIlH0Sb1S5XUwuLKOo7CPdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS3XkeS34VLmpG9VAhEAhWg852kye6wozAre3E/fQFdMTHEHQg
	0JX+71ppV9AZk3nE5dm/TlcO1ssgc1IKFnkir9qtsTQBBZL4g5R5wRfTg8qsn1U=
X-Gm-Gg: ASbGncsu42UG6vMyZMlA2kFLlfFoE3EbbekbXCTBiQtsYuA3ueVRioFd7eu7IAlQMJi
	umnJX8aBb6WD7427GMUGkhAwLzoGdFnkpc1GJQF9fhePaNUr8a+xRpeIlbZcHM5lOsYEkkQLW44
	hPo5BLd5E4QYgUgUCQ2j1cuQ1gop38jGBGDlwSflSZzAFUu0y7iajmiOelcTQxzgxLDYI0hS0UN
	1PlnST8Q5Toqr2aT50eR5a+fHDq2OZOegRVv11wGhp+PEc7LHVdK2+HhtTI5nR7Vs4n4pu3r6C4
	vyVLvdsZB710rJy4KHsQdeHIx9A95anq6yPBvT0ze1Fzv9R6t7YCvlnuaoTcomvf7SM=
X-Google-Smtp-Source: AGHT+IERqwAuIz2LbI4H2cXRffhRbWK8NogNWLUOiKPiVGnftwbq0dCKec86Botpymx0udw3Vfvqsw==
X-Received: by 2002:a17:903:8c5:b0:215:e98c:c5bc with SMTP id d9443c01a7336-21f17ed4f20mr111807405ad.48.1738825417482;
        Wed, 05 Feb 2025 23:03:37 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3650f087sm5407235ad.6.2025.02.05.23.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:03:36 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfvvB-0000000FGd0-44r2;
	Thu, 06 Feb 2025 18:03:33 +1100
Date: Thu, 6 Feb 2025 18:03:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fix swapon for recently unshared blocks v2
Message-ID: <Z6RexZIJFCQmbvn7@dread.disaster.area>
References: <20250206061507.2320090-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206061507.2320090-1-hch@lst.de>

On Thu, Feb 06, 2025 at 07:14:59AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> the first patch fixes the recently added generic/370, and the
> second one does a bit of naming cleanup in the area.
> 
> Changes since v1:
>  - expand the comment based on text from Dave Chinner
>  - add a Fixes tag

With the added comment:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
