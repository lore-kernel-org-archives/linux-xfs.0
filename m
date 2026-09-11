Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216053F8251
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111737; cv=none; b=sxQXL5eNoFOZfYTwqKOZel5Agw8hqLb5VKEMvtQsH9uDq7Hz7n90WZMDqRHSDMTImZI/ebtjOJynQGBS95M+3i8UzlAYXJVLokadbJa85kULpMLGEwiIdLH/PNUwA23DSQK5qMfZaIVjR5WrY+dOI43y4f5E2zC3vzzEdf48cXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111737; c=relaxed/simple;
	bh=iheL+8mdGIjoL8bM7+xSJb28+yrAQl56cPBE/ftBS2I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tWSIwI20vetO5Q7/jmYDWyXqWwK61+NQ2yomSHNqO7vy1xZdu7t3Npuq8F2CBzi/i2yOZGLZ4Ua7DupQONx1Z0Bb5bKOaVwxlXiLO/a3DxHaLb3UK0PwfrByzgSLM4khPOfGX9OfRgr9ZazrPBXxzcfk+Tv/9QuuR5f8v2k6y1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE+xN2LE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE+xN2LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0511D1F000FF;
	Fri, 11 Sep 2026 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111735;
	bh=OTL749lxnyK3Zdosid3cfCEzRNDyXP3iaoCIZppZpyw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jE+xN2LEQGP/jJShxRI4b8o+y1YfpnJM5u5P/qmfutWh90OI5BB7Wlu/SLbw3bJJd
	 JVhRoR0/zu68Tkqdn94QH4rjaKQYQTgQxsyC2z9jLaILYtsWy+EK8mMTkWXOv3RuoM
	 3+opZhxNqutFdHtdI1N5VLMkJs584qx1jw/XAXfFyBhFlmjCyauB9KLAdkP4s5qwn0
	 L5sU7363soIEtCxbcfDnodVpTOY/T9ZQnbFZ3HgS9Nsgotfvib2I7iwfCw4Q7ogVxH
	 Ztm3IH2t24WP4oTNaCIPOz80E/W1XWmRyGa9ljeoYufjGhEAMQZlzb8KNOJqM01qNP
	 i04gZI1eBpHdQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: anuj20.g@samsung.com, linux-xfs@vger.kernel.org
In-Reply-To: <20260907072739.719289-1-hch@lst.de>
References: <20260907072739.719289-1-hch@lst.de>
Subject: Re: [PATCH] xfs: set IOMAP_F_INTEGRITY for zoned writes on
 integrity devices
Message-Id: <178911173472.25121.4349366611867700541.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:28:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 07 Sep 2026 10:27:39 +0300, Christoph Hellwig wrote:
> xfs_iomap_set_anon_write does not set IOMAP_F_INTEGRITY based on
> bdev_has_integrity_csum(), so file system PI generation is silently
> skipped for zoned writes on integrity-enabled devices, and left to
> the block layer PI generation.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices
      commit: 50ba24ccb9a94f61c707209442ca23d98c815052

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

