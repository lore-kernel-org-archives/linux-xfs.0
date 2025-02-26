Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9104B20CCEB
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591010; cv=none; b=hVFSyUZ4PHWQpfvyeOG+qWq1NE/LHdYy50zCXip2amRzqDCmgnLZMZTFC26PhhVy54DSGfmrNJwOW6JVOVJkYzYDxBpu81DMluiQgKW2/x9V/n/asxb/trDz6QO/yJHGRTJiLJ1v6QIxmpQoTX+5WXllx3cX2f/b/onS4lEpZ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591010; c=relaxed/simple;
	bh=K3UGITGRipM7p76j5dqZhf82Lz+6ZzCI3IDP+V/gDS4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=px4BF7qJ3t3hLq56UL3Kg6AcWVG1JI1oTLEfVZMOKL+ITowY8NDW2+HgBst4l+DzBk8UEEeNNN6iIJlXvyIk/JKuPR1Ds6loBkpcOt0Mlz2O4FEPCOdaFe3lR4cLawM3I3gc/8PpZq9siForhqVmfGB/OYV0udt5wWWSI0TQaAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cQCZq8Eh; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cQCZq8Eh"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d2b3811513so3885095ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 09:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740591007; x=1741195807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lVANN8GELxA2LEZTYYuOIhpjLMR/AaCWMuZrSOMGLrc=;
        b=cQCZq8Eh8wytrbvhFMn53yUpCmDdNAz97WmlsGHXIDVQqNdkqrMn3JX04fuUueXB4a
         3y4jcBPn5tnIaiIey1EbnmsmB5ZaNQBcvbvDmnL7KOdF9MeugHdfxJWngr18TLcxKvE6
         ebJZ9M2l288fYcmTdU9fGhm+P6wYJ/N0j7Ppi6r5Wqpx4LLFXf9iBmV2v7x66RqKv+4k
         Kt75CCw7oQZ+i7O6DRtxF+jBOevryDFMvPEXGjlANyee6s2FUDaxU2f2mTqNIS8ON+Go
         w7Rr/4g9EOfy6vA0u45w2DISLtGLRZep3ToyYRY/v6wAarRH8wkGFeqB2xsLJIIM7r7/
         96eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740591007; x=1741195807;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVANN8GELxA2LEZTYYuOIhpjLMR/AaCWMuZrSOMGLrc=;
        b=wMjgadGWuUpVYL4PZ0rlLE4+c542oyB+fDZPRIC4DMW6IoMeGSKL1j/gXb8lrthFaL
         6RqodGIlR3dHgHCtIfky5IzskoVvOEYR4PJ5Tdg5xO5n6zz7E2aDwpf6d0DeJ+UW+7po
         v+9olFBA1nt63ZwRZKc7h1QShCMtkGl+DdEAH/J4vf/hE+klNRSOWpZG3GmPtHgv/kPG
         FpSzJGCgrtdIjLwBMAK2Xx/B3ulPvlS9H6L/2jHwmtrYpxSgiHfeLlWe11Gt3FzH521X
         fTI6nhho1h8KqqF3vWgM19UavcbN6Ps7uyPmEepBfQVm6oVvwAovYf7d5jNutRwSO2DQ
         4ymQ==
X-Gm-Message-State: AOJu0Ywx5S9AHI5XS628mr3FKF2hH6xKcqzJzwpWR0KARYPNMK7pnkNR
	5AAhyLBsao/ujsoM6ncBOs18FOLKuxUEg4Yt5kKpV3P50xfvuySpW7c5QOCxtdmABJ6xYpKw1sd
	C
X-Gm-Gg: ASbGncuR+cmi+/EibT/IgRW3yCtPIPXSUNEl5aQ6DVuIahDfGUApXaSBodSAmYNwbOT
	XzVkayKw85WbdFy3gPnFBR9Q6lnvLtOMAwYNE8gxNmo5XoGevqveGzars+2fx/YwPgqN5mvri1j
	wGo7nPDrLv6vBJk0vu1goAAaJ+aZkVXcmIf6SNq3SD20NVeqy+lO+Emxj0gKtw3+fatj5eYOtOT
	CJY6sx8cesVlmqmEGp5RDdiAeohAWV2VL+sSbvALQeTnwo7FaukNszjgI4++nlkRXvTiHx3F6Nl
	NkGZ5+0YfuOPfK9G2bpzIA==
X-Google-Smtp-Source: AGHT+IE08XKenNtq+bMrYzA9dT3+ZDEykgqaeLAjmo+xmDFjtzY5WSOX0WPToZEER5xGTORC4ixEjA==
X-Received: by 2002:a05:6e02:2188:b0:3d1:9bca:cf28 with SMTP id e9e14a558f8ab-3d3dd2e9deemr2357195ab.8.1740591007529;
        Wed, 26 Feb 2025 09:30:07 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d361653616sm8894395ab.25.2025.02.26.09.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 09:30:06 -0800 (PST)
Message-ID: <ba718fc2-08ba-4d7e-98f9-47f3f52c13a8@kernel.dk>
Date: Wed, 26 Feb 2025 10:30:05 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/2] Add XFS support for RWF_DONTCACHE
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <20250204184047.356762-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250204184047.356762-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 11:39 AM, Jens Axboe wrote:
> Hi,
> 
> Now that the main bits are in mainline, here are the XFS patches for
> adding RWF_DONTCACHE support. It's pretty trivial - patch 1 adds the
> basic iomap flag and check, and patch 2 flags FOP_DONTCACHE support
> in the file_operations struct. Could be folded into a single patch
> at this point, I'll leave that up to you guys what you prefer.
> 
> Patches are aginst 6.14-rc1.
> 
> Since v1:
> - Remove stale commit message paragraph
> - Add comments for iomap flag from Darrick

Is this slated for 6.15? I don't see it in the tree yet, but I also
don't see a lot of other things in there. Would be a shame to miss the
next release on this front.

-- 
Jens Axboe
