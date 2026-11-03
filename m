Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700150;
	b=3xiusK9l/RxKIavq+0dRzL08YSPz0WD0PxKpFEUKft3lbiUUQNCBUQe2de4ir7FWB3he
	 dWK8Hld/vEiNyPXa8chf9lNZoSQGdpzh5l3VQPeOPSD4VF60Ow4hUrFlRSJeXzOdHi/Ww
	 aKwyDxzGAt/CskfRFsjjlZIIb/30gOfzDEbZewOLgcrYpIFBfRXzPyfsmbA6fZ9+ppI+H
	 9MyO0N/t+2ieChkj9mPQ/e4tR0z79fj/Jd73Hh+et7GPUdFQPsn2jB91wgoTUfbcpcypW
	 2xNO+bd0bqccm0bbpbMKa0nlO1czmml0IiXAWxmNm5Cx/UTfi+Cje+ZeBfnWgstkCMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700150;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=o+8T0G5ZOxJZV8Yo9+JBL5DJiAA28BfdsiwcGf+SkEk=;
	b=S7LFSEbPgU2sjgezH20ek4/fOnLyq1uKNLZEAKSVVxDqwAnY/MOXJ1a2xtQPfmlr6M0Z
	 zD7NX19eD8YCNad5ScNMAIh75BzKLEga0qtCt0xD049s6z4f9N0nYiDdqgSGTKoa1gise
	 /7f4RrLbqfJSnfs/ybExnL8BdSVi0K6D5vOFLpMiU/KKRUbH5syDOhRJa0e0qCPiMvvpP
	 OdrK6zeDeRT6WzG/OA0TU5eVlHfp6u7um3KbVEw3Z2WYsXNwhZL7Ny744YqpbbZMTs1Vs
	 9NyudfSY7I6mKhC1JhnWa+1E/l2s3P9wURjVi6hFC969eBc5ZAxWgv7LRP4utiD+kEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HH7nSOOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D63606C50A;
	Tue,  3 Nov 2026 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HH7nSOOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE71F00919;
	Tue,  3 Nov 2026 10:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700149;
	bh=o+8T0G5ZOxJZV8Yo9+JBL5DJiAA28BfdsiwcGf+SkEk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HH7nSOOmOCcohM+PaZzVCT8/CuegeTE5V9mCZAlJwTEXSeZvdjPhKI2l3AigZZAGV
	 tQDYpqyuf5GfAhRhb/0A9Ndy3dylbRWpK6E2E4qr0yKEZlgT8SJwFpVYInprjCj4f/
	 gMM4bzrRCQbvvImz2sIyiZMs2xCAfPYpbSBUu7Y7luqGalO/3oVqBCq8AXpUqoOJWH
	 dkiUItTtzIUjzxyuWXHBpQeOYCIw2gjh8o9ovlG8aGA+ylO3nSkdfj2ekgBAgGBCL0
	 lWdQNCsrsbed0RmHWaRvu8VSbsAPqOS2qq/hJGoa357xTS8ke8MV+0B3c3lTN/79eU
	 3WxKtAWSt1MTg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, 
 Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wilfred Mallawa <wilfred.mallawa@wdc.com>
In-Reply-To: <20261026053454.987673-2-wilfred.opensource@gmail.com>
References: <20261026053454.987673-2-wilfred.opensource@gmail.com>
Subject: Re: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Message-Id: <179370014876.413123.17763541198759995883.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:28 +0100
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

On Mon, 26 Oct 2026 15:34:55 +1000, Wilfred Mallawa wrote:
> The goto for failing to setup /error/metadata jumps to the wrong place
> in xfs_mount_sysfs_init(). Fix it.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix unwind handling during xfs_mount_sysfs_init()
      commit: 7e31d6dd3419e27ca74b2f9844d5a014f05e814d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

