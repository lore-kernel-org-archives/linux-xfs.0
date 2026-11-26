Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700956;
	b=SSUkCNE8jLRRCQO46Lwcs0u75mRcA9yr3kAeSjLKUTSeFwE6UsEPM164BdSRfTEDBqQY
	 o9XFqDqPugSo8jni//xpQgs00KoCJIqkf1ZwEEow8dpO3QWnYLZTfi/2Vw7ABpuEAfMbn
	 N6Jha8/zbSu5KyavlGqJCphKUqMSqvWzlVF1BWW6zcs/UOpUvez+HF+tXAgMTmXxD+stc
	 IMVWF4cZWy/fgvnYOL7Lov18nNuUTy5qHiZeb0fDfHsaBOj3t09igPuGGFHAjc33IRgkW
	 PQsLk1dIW4T0AlDTfr7dtDXNFoW/yQ1xYeOCp88fwwQ0W7che4CjiRoHpkDF160YIrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700956;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=eaZlJQH1zN9bCB3H5z9xJS4+XnoNgM90cssYz6mZpWA=;
	b=b3tosJUT8UABCXU+3t3I4Hcz1N5Ne3V3+iSo0l7IfGXDgW5x82vT67xSnBNX7f1NoO3+
	 4ZskruPbN61LgfY5ha2zhG7XEWO1QiefIzdE7pvtTp7TjPfQ+eBEeYaH55d0eCUUvmXFJ
	 lbEjpZuatH3gE78hcWIdPEHMbfbackCIABOiza7xGyY1KSiMkY01QjibPOW3+eFniQqrA
	 TQ5tx+mLMhpWjsgiw836DFWMuzdo8Z6QDYWGxfhnlxPbX6DLmg7Ysiy6BWPwmjCAji+wL
	 Czy5EFQYfnPJxtjVbTIgB5cM/O76BglqT2xh3w5E2GHALTqVbjbSBr7ZWb6gR2ivC6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UNFu5E3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7312606A327;
	Thu, 26 Nov 2026 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UNFu5E3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3481F000D2;
	Thu, 26 Nov 2026 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700955;
	bh=eaZlJQH1zN9bCB3H5z9xJS4+XnoNgM90cssYz6mZpWA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UNFu5E3vVHE3NlAlUtntG7AYBuWIC9GD42PsM7eLXjmrRiKIE6hWU59C2/pDGZBOh
	 nqGgn47v2OYMVFmS1zMHDaNb8fac+IOMhnCG0CAx0D1xKw/kKceu+sD3L1GY7PeHqo
	 ysQiU9+yfjLMUHLTfRdBn3+iDl41OabP0ejeCtlQlEGpn8bTCyYHMVOWE2J19Uc675
	 ZxJ+McKIpyQNy6Yb/QNBdBU54c0ON4rJqoZMOVR56gbKSRKu8kB7O1GgK4tQF1VS9K
	 o8rog4lEW2VNYZmhefodEgLYyv6/3zQpDW6hWaCrJxx0lVGo2Jn3gRieG6LOP+Xht0
	 6aZQVZl0Ogqzg==
From: Carlos Maiolino <cem@kernel.org>
To: Ian Rogers <irogers@google.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>
In-Reply-To: <20261119170449.1513687-1-irogers@google.com>
References: <20261119170449.1513687-1-irogers@google.com>
Subject: Re: [PATCH] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()
Message-Id: <179570095414.157938.8265917270360236898.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:14 +0100
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

On Thu, 19 Nov 2026 09:04:49 -0800, Ian Rogers wrote:
> When xfs_getfsmap_rtdev_rtbitmap() was converted to iterate over realtime
> groups with xfs_rtgroup_next_range(), 'error' was left uninitialized. If a
> continuation or range-bounded FS_IOC_GETFSMAP query has start_rgno >
> end_rgno (for example when keys[0].fmr_physical + keys[0].fmr_length lies
> in a higher realtime group than keys[1].fmr_physical while both remain
> below eofs), the while loop executes zero iterations and returns the
> uninitialized stack variable 'error' directly to userspace as the ioctl()
> return value.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()
      commit: c43e28d4f2d2000777478a5b87946bba65c3dfdd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

