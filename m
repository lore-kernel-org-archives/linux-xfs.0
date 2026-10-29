Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290240;
	b=ygD4e1OifaM+8HCEfqwqLQ3OvfxC1pa8l8j0a2Xrb5iQiK0I30cEsX1ahwRH/4gTN0mQ
	 +1MBTVLyvjUPMQg2Vn38Ky0pfntlt++g2YUZmyubAbCWEk6XnpGekEVTyTjY4wrWK/kx6
	 pYy6OY5B1dSiNNUo7TXcOZcA5udO1GOLWH0/YJ2091Q62zKY8o9dO78ZyXK+tSYDHQ411
	 gtjp6mPjTfeAhKoFzhcvcjZiMK/TjnEJH5GYMvw87aBGYgQL+YdU8V/WThr/gn4AWEWzM
	 MVmtuaF/GIZVo2I3W+Pxuiglw57Z0irrB3lLpvywTOMOJtYsEvvkljDSsQJJ+ogtJWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7Ar2Zw6guuhzDCnE4ms/+0FLvakfxeitqZpLw1OfyRg=;
	b=N4ft8aHKK3xIWuU3PisohtQXOfhVWvwE4QJzBSwKT8FUUUPuGSqbFjm1lfBDhPgIkF+a
	 kPnzp9K8quUAPDIDbDNQykaOKl/PjtLRqgNITwHTl/E8K8HxVHuBaLoubAXgEWNh8GPz3
	 I3vTR+yVRlTkSMoxp2rAUxZ0LtZjLgZxPN9tvgFK32c+qtKBqDlG4Bd7M+9F4nRUhd3rs
	 8TREOrEedF2Fz4KHZCS3zcxfDbNoAP915C/hfNQAHiY8rISSPHMZ243GK7kDzFHxstzqp
	 6USVE1Mu9C0wvu8qe5npz6k3MrNdkRf/p0WMrY/ZQTf4JAF+uCg6f8dlmKfnilt0L4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddBfETWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE1606A327
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddBfETWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE211F01816;
	Thu, 29 Oct 2026 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290239;
	bh=7Ar2Zw6guuhzDCnE4ms/+0FLvakfxeitqZpLw1OfyRg=;
	h=From:To:Cc:Subject:Date;
	b=ddBfETWunUSbNvwJVRZ5TMYpNzPqHmbcXdF5ODHHL116Dusuu6UAzoDEea7k4c6yB
	 U8Ox/lMh/yxIs9G8Z+G1b5P/xi54qqijYv31LyAdkvqR8LmK7iFvSIozj3G8ftZDe1
	 N/6zAGPPA5gkI2nU/HC2eoNg6Xi4hAtMKCFO2BOrGvmckh101BAVo6MSzj4YFgp0PV
	 zOajZxnMnRybc4vBR8/aS0WbXVUAO3JEjVbwTua889K3fjPD07oCre4YMVMYB7/Wr3
	 IETzAVkcqVabRVAcEvUvazhl+wjxSEYSa44dDs2uHrCTVghuffOlBJMteQE3oyppg/
	 D2hzD7cxVha5w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de
Subject: [PATCH 0/2] xfsprogs: warning fix and add stack usage to gitignore
Date: Thu, 29 Oct 2026 17:10:21 +0100
Message-ID: <20261029161027.1213438-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi folks,

One last fix for a warning to make it compile under gcc16 and all these
new warnings enabled. And a gitignore update with stack usage files.

Andrey Albershteyn (2):
  xfs: fix two warnings in xfs_alloc.c
  xfsprogs: add gcc generated stack usage files to gitignore

 .gitignore                     | 1 +
 libxfs/stubs/xfs_extent_busy.h | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.54.0

