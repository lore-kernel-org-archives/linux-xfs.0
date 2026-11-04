Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801509;
	b=T6rjiWe22M58iy7knjSAQIlVdPWSAXjhHGrVsn0BcjtbGLFFav+NYbkcQIcExR/BHV0z
	 9XkInFL9Q/RfP/MG/dq4ord/is0xdjuNWX6ogazt82iEdXyonNqGmfwGXtZ+EOg0hYAd8
	 VS8I8oR0lct5x9C6Ft62Sxl1VKGIp64UNrG03Cija4SRwMZxgtLRToCCKqYB6J0MFjl3D
	 zvMKvBYTmMZJkJanuSxqFp4k402Nh4FPojRtzt5bqpcFkdfbCIlAd0f1PtMGyIFkCd6EY
	 ilvcsvZ4FpuQ1g/9+e0ljFCwfhjkRmHg3FjJ1K5dtvntCEOlgmCIkuGoQpEwlkaox0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801509;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=xUf29/ZuQXA5n7Aj13d43eFSCViWwTTjNal4MWf5b0Y=;
	b=qxZl1efT5FazJ8qEMPHut9Q3G4lDhlHDMqEXey5JgjrJslBeUpzYAyivKtADZGfqXSDk
	 /PU6G17wVHf1yP1L3hYNYTJ6UEvC9XkpDDraK/4WH+sto/e7SJCWRjBSZDUGazC9qOAf+
	 h2R4kClOUcoD8DaU30cqKk2VxDwGQNw7MH7hJB9kRfeY/7AXRQW4HFg9Qtj5XJqm6GnOi
	 UaRKy9r5P51C4xavFvr0fR0jrsYtoEWT3gXVl+kET0Y5UdJLIfCnfmIvmkvuU3BOz48it
	 uJRN8ixFQhlGWx1JO5NaO9gxbwsPQ1ZmPjIYuufZyW4HmBXf+Yo7LWzpfhrOY7BL+Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fmxj6Bqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7D0606A328;
	Wed,  4 Nov 2026 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fmxj6Bqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9311F000C1;
	Wed,  4 Nov 2026 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801508;
	bh=xUf29/ZuQXA5n7Aj13d43eFSCViWwTTjNal4MWf5b0Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Fmxj6BqsRvL3xVhjV325BY2v5VCsFoAbTjF7g2+5MSxeRZz8CiJUCvFEX1D7AMRCJ
	 JCrNBo89gzk0L6pgYLhM/4ZQTAcWzl3ooL5vlxRUkHW3Xm0pBzd2IzV80EPTM6T3pH
	 tLaWP1oq2mKnqC+j7yqCLtrN4/WswBAI6ecSTDDmsotKCSNzbHCht44+HWVRqOFrIs
	 8rjCBD8ZxKidG15rhdbM8qW6FyjQuvXPNMrNNuswbGJuMQ4Lx6irZYa7OL66LM7qsP
	 6vXxJKRYQ2zZPI7iFhMV9ceIDkhaGeGG7x2HJLtl/vlDLVYs4NH/SCZUkKEkLknzhw
	 eeYOBVn+aaxXQ==
From: Carlos Maiolino <cem@kernel.org>
To: Reid Downing <skibletz@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Darrick J . Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>, 
 Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
In-Reply-To: <20261027161748.2760321-1-skibletz@gmail.com>
References: <20261027161748.2760321-1-skibletz@gmail.com>
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
Message-Id: <179380150683.5728.1818667649783476739.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 15:11:46 +0100
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

On Tue, 27 Oct 2026 12:17:48 -0400, Reid Downing wrote:
> bs_blocks and bs_xflags were both read from bstat32->bs_size.
> Read each one from its own field instead.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
      commit: b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

