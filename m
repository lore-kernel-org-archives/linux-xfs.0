Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AE32E718F
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039457; cv=none; b=kRNNRNFRBWMQuqQ++O2HD1FaGBg8TG00WvhqGSMWpTBqMRRRAi9hC2asb8aq8EOnOLrAozg+eGSKKUoHz7uyBIeVbaOtUxZuqNu3OEUt+3/Lq9vpySh4xCbynoQmOkCdCWT+WMGA9dRlYuTSGq8Zp/QkUIYu3T6wfmJm8EmoiwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039457; c=relaxed/simple;
	bh=i08MQH2Mhl7s3JtSsZbubbUEjxCW2BAmsMK6yHwBikI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UZxnoWV1YYUkub4+2+rbOJ7cko1H7h7KZlz/YJqweszzITVdqLO+Y3imeDi+g7enGMTwN4hfOFGdbD2nPvGCPMJI+ye5CjX0tGyfpr0ucj2lC7Hg+wL1UpBla1cHpJEjeKL9uyOfzXg+zSkChZKzvLp2rQRZyT7C83250EADRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D97kop8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D97kop8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23CFC4CEF5;
	Tue, 21 Oct 2025 09:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039456;
	bh=i08MQH2Mhl7s3JtSsZbubbUEjxCW2BAmsMK6yHwBikI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=D97kop8HmS39lNcb3yUpEP5630ImkzUs+H7jQcPcuGc7feXoq2VXE4DEdhK0dupOZ
	 c53qsu2d0+h7cb+tyjhROWoZhrP9YWuamN0Qj5SISxH6iIzUl+qxCVAN1hSkN6GiAT
	 LiT/FdUnvuWO+kARfxVZOEDWKEdhEej0wPXSI7r6LSB9CW3r5cYpkGKDFUDjNPx22E
	 qqqd8mBbhc9CY3FyNA/dKf1UtzcbKzDoTXL8/nOR5DiV+ZiAdTLEJLsafVz6LWvu+F
	 xFQwJfncrapmJa58v2Dxd9fqOTznLOXLKhwlUmA4IkM8sDo5cUQLiI4DxxPg9VhgFz
	 6oID7944lhDfw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
In-Reply-To: <20251015062930.60765-1-hch@lst.de>
References: <20251015062930.60765-1-hch@lst.de>
Subject: Re: [PATCH] xfs: avoid busy loops in GCD
Message-Id: <176103945549.16579.10233186565512132450.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 15 Oct 2025 15:29:30 +0900, Christoph Hellwig wrote:
> When GCD has no new work to handle, but read, write or reset commands
> are outstanding, it currently busy loops, which is a bit suboptimal,
> and can lead to softlockup warnings in case of stuck commands.
> 
> Change the code so that the task state is only set to running when work
> is performed, which looks a bit tricky due to the design of the
> reading/writing/resetting lists that contain both in-flight and finished
> commands.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: avoid busy loops in GCD
      commit: a8c861f401b4b2f8feda282abff929fa91c1f73a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

