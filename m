Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50277257AD4
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438307; cv=none; b=CbPnVUk/axDxTIvgWEdo/aoFBlh6u1QzSzU5fJTeLzqY/crh+sbIP1p1KDEcMm9slIEJfVMiOCJqQXEQi0lMiT4deg256vS+rLLsjjxVKHZrAKmyORYAviMm//CGFxXNiIhHazDtn+3VRTh5SiBEzELINKJ6gzedCPO/L6CYzyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438307; c=relaxed/simple;
	bh=sABJ0zDjI+HdAYjK6q+W6i4zhTPiFN5NjWMMBT+eTh4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mF7t6IB+0Q9Qx2PaH96/31yGdSTMuHawkqjjl5x4yALEVGV588Q8zzCsoK5vDkiMRMAbjXRFB+clpFrJfMwT9MjxXs3SZkCkIcGIA1QLnIWUsHSSZ3cYoe7GuxFad+M4cCBGjo4p/Lm/kt2XIeIrqh1mryCulBKvuj4O6gVsbZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ts2gYgC7; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ts2gYgC7"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d6e11cd7e2so1933545ab.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745438304; x=1746043104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9j5LjmU56b5qAgJCmFZDj31NsIm7pWmTfna1PU4IFm8=;
        b=Ts2gYgC7nfnC0WsxXQFgF6BZ9YN9hd1ccmdVEi6RTerUyu8PFoWyG7nhKy7a9AsYNp
         6bf1rHf8xvdODrEoF/3aJiUzgficfHfx9sUGCkOhXlPoFmRk2BFG1Er3fzERcJ2CuaAc
         hJePFjC9sqTqLcOU8xGH6ZZ6X0EPUXxIpn17FwPdolr/bqu+prehcfn5iEUquq0HW/Ou
         9pU3hcG1oX85Agg6VoU1+Xh3cAtjmRE0z2aK/+2Zu3Fp3sgbNh7rTSoCCmfpxuLvKwCf
         f4WcVmbeV8cgiImtCWFvQGn1pmAfKvOujlInYK5+Lf0XDA4AiW5JQ17UqJSFASXYUh2U
         g/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745438304; x=1746043104;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9j5LjmU56b5qAgJCmFZDj31NsIm7pWmTfna1PU4IFm8=;
        b=ar7p4w3IHm5DiNEsXhZCEXPxMfkC0MjsUs71SePSXmMnVk5sjdtA1vRAtAoFyH8eMa
         3YF4K4jbZIwxW4qtVqux2d78S5ta+gXVzqzUQJ7rluh1NbGCm8+qL/UprSgLW0nCCHWa
         YBMx9nWI6tRpLBwrHgmZ7iQmu0MB8BZfiMqd7jj3fv+WHpEVp+5HOT0O8lCVQeDapvxh
         cYJCwOWQOUlQWfbfZPoz8dei3nGy9EehaGIvFCJ5vRjzrVbVvDYapsGuPnSsJMvFlGK9
         W1ydFhtqadkkILvxpegZReHKbrPwLxEzqk5Nv1wizM7UZjJt+l4l9wv44x3x6tnFemBJ
         p89g==
X-Forwarded-Encrypted: i=1; AJvYcCWqRBb0mPVVMqTbzZVktW8bvJJT7+dsfOSEc4BNwv4PGQ4xiHLaiKadAic1azlA9WAdlL5SOYYEDGs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa+xHqSwxXt1pNLpTNFhw0Jv+zIawloNu+rQyR4htLXdddC1w/
	snv/dRlgqeQyv5v1WTUgROBAyoP+pm3dN4dIzXioU30dndS1WpYG5byqHzEGMCg=
X-Gm-Gg: ASbGncsi6uzK8/F4iAwQPut7sC9FWnNZCntsKd4jCt+wwM3BncFpa64cnumXLsfHHF0
	5F76hODU487pHa5Pw0shXJk6iywv01Ns2VeWt7NaeugC0aL7gSw2cSlEt6h+ca+WN00uOeDlcmK
	kj46WHiRr7ieG0d5BzKJPzSlMv0o1Rrke3EzK7VdvRmdVWgCHpcVeenpRbAyVX43XnU6ks+4SQ4
	N051gIXxW79/q1UUVa3JVe+IyP7ZUz2k7mmY188TijzOJWuimbk2hEgDBkEEyxSwcWdEeNPju1k
	aAsVWg7g5k3xKUn3/s/vDdSthXPELMw=
X-Google-Smtp-Source: AGHT+IEMJ0bRGRXiRlKdRhkAgWX19pwillKCdqIlVb4cy4gK+d8U2A8s+2kwKh/p2ao3kPhQzF0MkQ==
X-Received: by 2002:a05:6e02:b21:b0:3d3:d823:5402 with SMTP id e9e14a558f8ab-3d92ea8af22mr11668365ab.7.1745438304290;
        Wed, 23 Apr 2025 12:58:24 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a39335casm2960256173.84.2025.04.23.12.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 12:58:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, mcgrof@kernel.org, shinichiro.kawasaki@wdc.com, 
 hch@infradead.org, willy@infradead.org, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, shinichiro.kawasaki@wdc.com, 
 linux-block@vger.kernel.org, mcgrof@kernel.org
In-Reply-To: <174543795664.4139148.8846677768151191269.stgit@frogsfrogsfrogs>
References: <174543795664.4139148.8846677768151191269.stgit@frogsfrogsfrogs>
Subject: Re: (subset) [PATCHSET V4] block/xfs: bdev page cache bug fixes
 for 6.15
Message-Id: <174543830334.539678.13336981984894472656.b4-ty@kernel.dk>
Date: Wed, 23 Apr 2025 13:58:23 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 23 Apr 2025 12:53:36 -0700, Darrick J. Wong wrote:
> Here are a handful of bugfixes for 6.15.  The first patch fixes a race
> between set_blocksize and block device pagecache manipulation; the rest
> removes XFS' usage of set_blocksize since it's unnecessary.  I think this
> is ready for merging now.
> 
> v1: clean up into something reviewable
> v2: split block and xfs patches, add reviews
> v3: rebase to 6.15-rc3, no other dependencies
> v4: add more tags
> 
> [...]

Applied, thanks!

[1/3] block: fix race between set_blocksize and read paths
      commit: c0e473a0d226479e8e925d5ba93f751d8df628e9
[2/3] block: hoist block size validation code to a separate function
      commit: e03463d247ddac66e71143468373df3d74a3a6bd

Best regards,
-- 
Jens Axboe



