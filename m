Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139EE4E66A3;
	Wed, 16 Sep 2026 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560414; cv=none; b=tfloCzeroWCBtDwLBRZbwTydvIfiMo9jppOHxPRvFF1jX2fidokvCUd/DbQ500r4sYnD4wEjyRVb+Ss6RbVZ5+qFujA+fHq6A1+cVwNTTUVo2SpYJSrkHy3OOco4ik4tc9rrptYqhPX6GeyPATV/53VvC5Uj6d4EpbZeld4TKe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560414; c=relaxed/simple;
	bh=B/kcsNPAuR5SSilIx+u1oYV9N/yASshRXmU/9Bfo7os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sea96HQAwMLdScy3Trlu3ACukrOFYqEn3HFKa8OoNCoLQ01GAJ0OJMdUI1qSe0tYNrV3LDKXGJWYhE9sMVC+Sz6SIDHLsbL2eAn9ggq5ByQ0Cw8ew3Z2vezHrPJNDfw5omk3OJOj9B38NilEYwbDZtWPQ0z3Rl0JdYLcwiFOy0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwlEOu1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwlEOu1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573EA1F000FF;
	Wed, 16 Sep 2026 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560400;
	bh=avQSMGxf3urZsOOPDNQr8o0Hm6tBgiCGfW1YYsQSua4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=PwlEOu1wWedzexF7N+o8y40z0tz+nfZnwllnan6qDqZQNfWcTbbthsfHuNzdjzYU7
	 yd9R5oO7dHPsuPvgZU7FsnPCCTBkwbp169R7olmBRbDaICp04p6ZLAV9dpS5uOkBfr
	 2T1dhsPOeodjyaQKjbhXke75mihRij3xa1O/tEfet5ywaB93oB6kLEkgOcmKXKuYJf
	 aowaQHAdUIcmoGtNA7xK8733K8fBa2LuK5HOF9PUZxmFgUAjX1qXuH6kd9dXSayRTu
	 bANhKc1PBPr/ftDdlNdcHwbyPCp4SbxAtoDc22VlDMeBEeZU3EWpwsjIPnpRX4d5RZ
	 Dp58DN08NULZA==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 13
Message-Id: <178956039904.10466.12265208795098637359.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:39 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 09 Sep 2026 22:59:53 -0700, Darrick J. Wong wrote:
> Here's a thirteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: guard against igrab failure in xrep_findparent_from_dcache
      commit: 5b644229bd677d52c4efa5973c1fab842c57f896
[2/6] xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
      commit: afbccf99f7f82117cba9ad4b0b006692030f49e8
[3/6] xfs: fix attr fork block count checks in xrep_inode_blockcounts
      commit: bb991b7f79dd34cc5f24db0f736bf75630c970e7
[4/6] xfs: release orphanage dir inode if chown fails
      commit: 1c32cdc986467eaffeedb6c5334852809555b82d
[5/6] xfs: release AGFL after walking it during rmapbt repair
      commit: 8b4ad2814274d43ed8bdfcf857efb8c79815d9c6
[6/6] xfs: use correct jiffies comparison function in xchk_maybe_relax
      commit: 984aab2d905a8557fafb27cd9e8713d6d12b3437

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

