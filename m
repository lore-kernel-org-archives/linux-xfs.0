Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700156;
	b=r6MArzjuy5NvjKzQWjKgyjRel3cS69mab3wu9KHcJqOWWQNvs4LxuRlOSdt3VLtjzFmc
	 pw1a+e4AC0FNTHK+Skk7bhClRPZTFRk8dYTc81F9m3JM1ymOYkVluV4fpoc9lbVG/oHm8
	 m4Ff7cpg98RYMhk0wYO5yWiPtA2NC0ZQ58myFutyjWdhqzK9fYXOauyF6DD4WoXneknf2
	 NPOk9RYLUkarVdGsN7dABzS5Xxfgn8QiWfzWbqcoy84y65PF+J9gZCKeANuDfUD38xx2s
	 A3DrYpqxpQIpgk2dxSgdij6Cah2G6XLAjSgtI4KGaZO+wkvlefPVPKx8UuzOdGypByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700156;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=oRS0byXxrxQ/FrUsf7DbZopH6usYQwj5ZwozRajoYWw=;
	b=FxBvT8Ovc4vTT9K2pAXoJyWQL2/G9ZzNva2XlAV0F1vnICukh8iSlyl+qGoij+vnx5Sm
	 d1+3CRDqfPsYJhuDUpJMGw6lT2Z6voP3QP6+C5Jrx5ZB//g0kNPIACWeqU3zc3zDPHE2u
	 asAMpmaQbHUM+RqSvMRJc67Z4itrpr/vh+P7lfMxNR0D4ZtMc/3XXggXG8kP8gUYp8gSG
	 EZqNzUUNB5bFZJbzGm9DT4APceMlurEQ4TTQD5/7vnS17tjfKVRmlaBK5Kh0BW9F79Eeh
	 zS8Fd8Jd5PCNG+wjLeVJi+b7OKCEWfYksLMF4ude4EjhVm2OnxDFkLPet3IUZn59/tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a54Md4AJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A52606D81A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a54Md4AJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD31F01806;
	Tue,  3 Nov 2026 10:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700155;
	bh=oRS0byXxrxQ/FrUsf7DbZopH6usYQwj5ZwozRajoYWw=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=a54Md4AJbsxgMRF5wkOXC5fsBxbbEOJdo3RH8zhL3XHWjBpejjZAySa66A6l7eeCb
	 8XPt0TNzU7CgdqleW+VqKOVz+hMYE1ES4KY75S0gpuQ88OpB06rY8evxwcpmMp7RqO
	 MLGQuxoGRfxG/hjJnJfMgJlSO5pN+AMPy/CS5e5DZzNqua4JzbL2YwmSZFK1quhsy1
	 zhlrpBePVmUZr13KpzFhu3M1e7gSVV9jRofnmldBwW29x6plPMnO7pQj2396meSIkp
	 LVGLsbVI4A+3szhFlY3VsX6BOt6KeCv9WNvmH1t4BQmzrpzV6kFCpivX/lhHRiGvzm
	 k5UnQ89xga2aw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>
In-Reply-To: <20261021210032.14001-1-ailiop@suse.com>
References: <20261021210032.14001-1-ailiop@suse.com>
Subject: Re: [PATCH] xfs: skip iunlock with empty iolock flags in
 xfs_file_dio_write_aligned
Message-Id: <179370015491.413123.2922473638051257538.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:34 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 21 Oct 2026 23:00:32 +0200, Anthony Iliopoulos wrote:
> When using RWF_NOWAIT, xfs_file_write_checks may fail to acquire an
> exclusive lock upgrade and return -EAGAIN for aligned DIO, setting
> iolock to 0.
> 
> In XFS_DEBUG kernels, passing no lock flags to xfs_iunlock triggers an
> assertion failure. Fix this by unlocking the iolock only when there are
> any flags set.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: skip iunlock with empty iolock flags in xfs_file_dio_write_aligned
      commit: 1e253beed5340fdf1aa43cc684e085a6d468f5f7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

