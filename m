Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992332;
	b=gEgs8UjfvH1XBtByoZX34RgfUtrtSCYA4QENgfbpyDAl5g8CRFqLs/5oH0q68VmwmSz9
	 pVl61jW7yE/kCQwukYyiLfN0bXEgEX0bicp3SCqpuro+kzcjLPZ64yua0TM7Rlhahn+Vm
	 zCIZkpVjiELFD5Vk2wxT2mO0imYOoH0hJrtu3ddZhR5W3KIq5BqU7DUbdFPJL75XahooN
	 iIXyuNTJ0jXUzDQzDGFKy1BE7asqM65Lu4QmiAHXx2eAFAqIxS2ODk4pd3Kqb3xCSArXg
	 8osy/NjLOzz0KRbc60PwfoLUH6phnG5x6httGN6Hfpp871sx3zQo3ovy7mjlsuh+hFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992332;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=q1aGfoJv3nh3OfplTk5orJYqusAX6yvWzsWz5R+QOto=;
	b=kAiM1g6QVh8Nj7WiGmmGR4ESzlcv4aPXXlNFU1y85czGbl6eB9pJxwAps+G6ZQoYVxOs
	 /07xM1YOE6M2/DMebtsvRLqX6ePJ3PGKJBddoEIVCGtr8F6GyF6dmfS0WoxXaMkcOf6D8
	 cCOc3GOXl5vl7F0dbTU1YTjHro8PdCOe9AhH5+DY6XR0nTdZGFmgkovgbYYOs/R1hpIia
	 Dz50pzumuedGiTmjPaCbuwKvM0oBayFqXnYvbxwhpLFhFk/UtBdLxnAj+6VeumBtvNXDh
	 A5TFUVOhLd4kGVrpM0zRrD+SyYKBeQ2K0yqkYhRlg4q/myNN1z1XFE1k4cDL2WtjsZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZ6WrCSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEFA606A32A;
	Wed, 18 Nov 2026 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZ6WrCSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F521F000C4;
	Wed, 18 Nov 2026 08:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992332;
	bh=q1aGfoJv3nh3OfplTk5orJYqusAX6yvWzsWz5R+QOto=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hZ6WrCSGLlvu6OXCuxXfzK2izbneYynpE2aRyJI47beK8Q4XxHkIcMMhC7gT3ZQW/
	 m4P/7jf2KyBoxPA6UnY2I06sMN0lnboN+dYdPlhSsTXSQxFDyFRGW8JiiXYKATLfeG
	 Wc2pMoX4TpNTgR+ceU0hdaBZNPiNg0Z008zpsjqsOalxJRAo4iIblnEsnZYWrvDIyv
	 ZIJ7wFhYGFFHTbuzm9/mFcgpC0lLIngGv9AYuV94oHhcLps+/Gv5n0nk+semK6n1k5
	 2UpzVUYK0E+iBonZmFUTE9nPUX877w7hlQtAYotwGdig4mi7NkFBpucD6QnzE2MF7S
	 C9L1piVF2TYiA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261109-xfs-swapext-break-layout-v1-1-7f6f137d18bb@samsung.com>
References: <20261109-xfs-swapext-break-layout-v1-1-7f6f137d18bb@samsung.com>
Subject: Re: [PATCH] xfs: break layouts before swapping extents
Message-Id: <179499233058.5574.6177455515756441128.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:50 +0100
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

On Mon, 09 Nov 2026 17:26:56 +0900, Daejun Park wrote:
> XFS_IOC_SWAPEXT does not break pNFS layouts. A client can keep writing
> to blocks that the swap moved to the temporary file. xfs_fsr frees
> those blocks when it closes that file. The writes then land in whatever
> reuses them.
> 
> Lock with xfs_ilock2_io_mmap(), as the exchange-range ioctls do.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: break layouts before swapping extents
      commit: 0d8026c7ac0c79a8ebe2942a3c3114c06aced734

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

