Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316F64A5EC6
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966516; cv=none; b=YAbXhg0SoeHCJsdqLUvJGCKxDeqEEYkMmiALPq3903q3E2DArJW1N0PGdLOqDRUp/Ly3EL4BsYGGSwiO6wQ9Gyg1Y93F49+ulJB31UO7xqtzrkoO4e77sq43uc1h6deVivIqFt8pEVoDgVc7Xblwi/a36xGVl3eJwNzKh1G7Lp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966516; c=relaxed/simple;
	bh=SBip93dc5uniSljjjbi9GyHO+imcw87QZfgPD4dUNPY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oFoQBd47FR8NByiITD/OFodaNrCMtp2tnSv6oyhY9OCR9xE2WvUfoKjmflHlIeMuBcFWoAxaYBjgmlwVDVJegWn2L1I04wcPFjks74sFrRbV2nta7kZoKpvKRq1BTZrSZpQ9mzwZ+Jeq/yMC5zElGOyVbf/XSNSvBG8wdNDjQTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMsPuyQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMsPuyQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044E81F00893;
	Wed, 14 Oct 2026 08:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966514;
	bh=UDL3T/yEUuLmN2OydYl3l8OuQ9f1lJeWzmkA2GHTj+U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aMsPuyQzxwqOmX/mZifjv+ag0RWRhsqCPOW26tVS/YwommUPOQo28P7uVtkuQjOR/
	 32lovYQ+IJ9K5fF5ZGBjy/rprLLWlIheWIFWDSXAE3AgaG0ZjmZ+v2TwMkqedkRQls
	 3NtF7gkRzQ8HKx+ANLXITX3vAsQla/q4yfCQq1RYVg3titXQQFOM0xZyNrZ5Zg1mbr
	 9prrXFqWnWlNJN4k9tQQfemueEMiHc847BxbPPmeI3cGqzvFGFk6B83gyjg5afA+5D
	 XN6A5HU/wsirkJWIbfWce8Q6pSrCk3zxLJjIiEB3+XMJNFTHKd3MQ9xDi2e4X/9xRP
	 wIOPfFm0ecL5w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20261013115755.1473496-1-hch@lst.de>
References: <20261013115755.1473496-1-hch@lst.de>
Subject: Re: [PATCH] xfs: handle NULL open_zone for merged ioends in
 xfs_end_ioend_write_zoned
Message-Id: <179196651370.20513.13533675308050946895.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 13 Oct 2026 13:57:55 +0200, Christoph Hellwig wrote:
> The NULL checks on the merged ioends added in commit ae285611891f ("xfs:
> handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones") got
> lost when the code was moved to a new file.  Reinstate the check, and
> also update the comments to be a little more coherent.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: handle NULL open_zone for merged ioends in xfs_end_ioend_write_zoned
      commit: 90388d46b08ac8dd2c179f63f8739b4ac514d926

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

