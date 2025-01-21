Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDD6148832
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737431560; cv=none; b=RQ37cr5qFHsvNk7vwN5C0v/mG7S0xZ5mTxWtg854SgWDT+wPPuESCaS9Qn+VAVCNheUmSmRJwmlpg3NHs1K+gwFLyJu/3j1SQhKr+PiZrQtTtXfvxDLC10wa5Z+28grxrI2YRuD2Ybmw60fJOqmQ6gFz5CbXxdZYR/+unuYCv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737431560; c=relaxed/simple;
	bh=Op3refNe3zmAJxsEfIZXs3EvpBXAc1nxtoOag1mVq70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU2iioStJanwQpeNL1oxzwlPDOIreZa5V7LDtfVup5n8ZCjyhFE5sbIFzKpaus3VU901YCiAqCULqBGwVDAcXVrpt0JPBMHo7Z3JKuemti82+EO8k9BSHz/2qmF/DIb3gDasm8O0vWX6jrnMSyQIIx3goApy7UG+PxHbxBiDuYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LzqUQjAq; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LzqUQjAq"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ef6c56032eso6527018a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737431558; x=1738036358; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Bkm76FL6Qr2OJ5O9V4YsHFL2MtzHY+iPQD24o8/L8Q=;
        b=LzqUQjAqQK/JBHv2bSPJNRUxjZzL6R81HHKuFsXQAVJEQeG9FRjFYLz0Acsk3olmRi
         EJtBALpIn0SBjWmvarxJMF3XPyIIwnhd1clppbA3RUfdRL9GMkbfRG+kr8TF7EsY56JO
         VQjWjCILsQNvBr/Leqjh5AbH9fdTvUWKtSEnXKyjmOfF/+nYtd4z+RLj51ePs32IUNhM
         XIizF+Ztx+znWl436SSFnHpLT6iiIeM9dCJA1Q4IgpSLQuHO8f9ufO+XxLf+wS7MaljZ
         oDvF/BETjn5tn/MHp7v8nnubG2NkRHhE2Bt7JAmo3OUaLuZjsfR3WEy8DkQ79PD6t72h
         spHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737431558; x=1738036358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Bkm76FL6Qr2OJ5O9V4YsHFL2MtzHY+iPQD24o8/L8Q=;
        b=kiLDPhgHRQSjKed3b1EhcbN4jI0Jc9uug9A53oHDL9OHnD27VoX4i2N9Mfn1bSKLZN
         Vqokp2fm+KzhGIWPT/U4hOKKxsKh9+auPbv7l3OOG5J6oyciPawaKtmf/hf6WpuuWLh9
         r5cWoXDYa4nPxxgzauex7422eeDXow7jFaFHcgnPT2ZjrL1hgohQfB6G4vqtU8H8cv+i
         bysH8wqZTpmyOpJab5cWNLve18HHtsMDILumqnQ0qI3iYHZPXqCw2vQMkDBUvTRGeQy1
         4FiXaJVZDDgkmAT47EbLTxgFq0lfTQ4LT5xc5tRYuhoIyTqqfswkS9NDIw3rS3S8zm6L
         chtw==
X-Forwarded-Encrypted: i=1; AJvYcCVsMGnyEMib5YaYOh5TUPGinWhXRep3HHKew8qScp56phCqtXARWuKOlm4p+tSbcDFiObONJ60RbY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlBYV1LmmF5H9Z1jGt8Nqzi1W+kwnXk+FnG9ljUz50BXvlt1Sj
	PcXGYbkF5sLsjkbnb/Ex6xU/plORZHhwQ1Ed6+TouejkcEUxbCW0pbRi+Ub99q4=
X-Gm-Gg: ASbGncsn1+qa8Cwc2n//uv3muSih+HWL3Bmtb6BMC6/3MnuTiag+A0oJh2qs0+yAaN8
	n9Cf5Vy6dVx0h5PzML8zs/CL6602KDNjiMuYy+ILL3wW0OAzAUSaF34C2cii96B6dW4ib17V1Wm
	05GQzjCunzeemCLCwXuWrwSK06jiZaPKX/LapL5jamHxN/4Cl+uOUZT9GbnLAu4+4HwBN7ZNT8h
	roOMJmPdg8r8jrCWSBgiTDw7zwPdIyQ/zKOIl7FLAwjXxlzJrGWx+hxkzLCHiPu+6AoVZZ7q7U1
	EROGwZAiasCGicD/quZFlQgnN8sCtE9jxBA=
X-Google-Smtp-Source: AGHT+IFkq/B7XsSyAhp00U5Q84kequdJDfLGc8tWgUI1LhBoCrG4adcypDPWql0vCF1BcAHyLYCiaw==
X-Received: by 2002:a17:90b:5249:b0:2ee:af31:a7b3 with SMTP id 98e67ed59e1d1-2f782c4feebmr25088692a91.7.1737431558511;
        Mon, 20 Jan 2025 19:52:38 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c14ffaasm11656481a91.4.2025.01.20.19.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:52:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta5Jb-00000008Vr9-17np;
	Tue, 21 Jan 2025 14:52:35 +1100
Date: Tue, 21 Jan 2025 14:52:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/23] unmount: resume logging of stdout and stderr for
 filtering
Message-ID: <Z48aA5-wMRNrXKER@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974213.1927324.1385565534988725161.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974213.1927324.1385565534988725161.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:27:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a number of places where a test program calls a variant of
> _unmount but then pipes the output through a _filter script or
> something.  The new _unmount helper redirects stdout and stderr to
> seqres.full, which means that those error messages (some of which are
> encoded in the golden outputs) are suppressed.  This leads to test
> regressions in generic/050 and other places, so let's resume logging.

Huh. g/050 hasn't been failing in my test runs. Bizarre.

Anyway, change looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
