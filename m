Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700966;
	b=Ze/7IGWxBfZWzSQvgxwlAUD2Af+qFDU0QE7duQm659rz9q9KlW9ZnpdK3n9PFSBAlzzd
	 fIow1VWxHorIseCNtMpP9KzOUF4bCZSd+gZtA8NBeolVgh3AjCJ6LSuV72XGMbTtisfUU
	 61QebCVTPK8ehRL8QFmMr7EfOa/LJUbpXbI0ua20JfrNyrQsTB/YlIR+HvKjC206jQqDN
	 CCunZAXqRjPxguIP+DzlYb2lZUaOf5ScjHQNTjMvl1bJQXgU1YFLRvTsAIQddb8E6m4y7
	 zJ21ufay6iOvmz9e+hHkDYx3s2QyE6XBmHCR8N/XCqMeX6mx/YJJdvPA2AVYRws2QcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700966;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=LAzOYd2w4RecwKcyWfuM201vpXmpfSgixMqme7/wjRo=;
	b=JQuKr+lXKKXadHiVeK0JzMabPsnyo7ZTwXAGdwGrz6RGw5B9j1UV95ANbO0sw4SCa39t
	 xvCJFTSHQRuXyilcvkBcvKbFEh00NL7cTTiGDqh7B8EK0rC1qFRmo4+mvnAMZOqYn/3HB
	 i4fMp8fnTVjoFPoaPaMOmMm0FR/jF/qgqRLhGEobFo7YTplXn3EmpzQBQIFGZyRkO0XcD
	 olXWauQjoHzxneVenxwqQ3dGWt1T4UP4zvb6rLYqWSER+W1/Ng73UmcxAX/AHi+49PE1U
	 DcOYgAiotyNuG9LJknSndP0hObRWF6flgfFkQ9jRJwFwiOQPBEoAonWndlNVikMrWMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RMf/Wuzr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10FB606A32A;
	Thu, 26 Nov 2026 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMf/Wuzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531A21F000D4;
	Thu, 26 Nov 2026 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700965;
	bh=LAzOYd2w4RecwKcyWfuM201vpXmpfSgixMqme7/wjRo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RMf/Wuzr0LpxJylCKptS6fo4MN17yuzEbBN+Kb2+7kQqewAzLCKeQ+9rS9pk76GkH
	 ceZ7qPYI7X+C7Zr9vtCRScdsTu//BhEITKPZCnB46ZI0GX4fwplsGQYWXeUpjmzdr7
	 CuIM5RE2ic+/Nh547IAXDrk/GJSR8CvhMwBexIdDc1ugNRPX6s+J+nCIIrmvQkdOr9
	 OqITacRRdZwdc1HWwt1gorPGykvrkNn+cD60NFna+2YO8oR4UZNkDevu5sdknUGYL/
	 TJ5WR0oL8XfMAYdJBJA4AhXg8mMu03hNV3kx9dVRf46nFkfVLW0xFInMhOtY1Txl3Q
	 Wmo30dpzYxxRg==
From: Carlos Maiolino <cem@kernel.org>
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, 
 Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <179559978502.2875040.12926533524466805036@gmail.com>
References: <179559978502.2875040.12926533524466805036@gmail.com>
Subject: Re: [PATCH v2] xfs: reject a hole in a remote xattr value
Message-Id: <179570096395.157938.10147028865872982891.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:23 +0100
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

On Wed, 25 Nov 2026 23:59:28 +0900, Kyuwon Cho wrote:
> xfs_attr_rmtval_get() maps the blocks of a remote xattr value from the
> on-disk value length and only asserts that a mapping is not a hole. The
> leaf verifier caps the length at XFS_XATTR_SIZE_MAX but does not check
> it against the blocks the value owns, so a larger length makes the read
> reach a hole. Without CONFIG_XFS_DEBUG the hole becomes a disk address
> past the end of the device:
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: reject a hole in a remote xattr value
      commit: a1c699766280d148ce594df157ce83ec05f5858d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

