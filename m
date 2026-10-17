Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE53B14D0;
	Sat, 17 Oct 2026 03:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206050; cv=none; b=f43a06BiiduLfdSI/HssmVKd4b8wcIpRx2D/BGLanPCe0jIVz2iDthsaLtv5gKuBXGyQsf2oi9Ni9iPZolEIAT7Udquqn8Urk2ec8KCjMXKrnqiEb1HyHRD2096SZfUytpQZDF/pVx1rQka+v59WOAHUBOr0zrvHU50IfK6mCM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206050; c=relaxed/simple;
	bh=2gxHHx/MDpv739q1wc6vpt/O6GBL+ypee6x8PgLWFMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoWd8Kkc+J1/EuQ/thK8PkZTlk2oqLXPzr6D3ITXb1zjz535d9rNOmWKkvaS4lXvE5t3i9sAMZH7+O8YeAH7/5Q/9gxz65tMicgsRGGjSwvWm8JP+iFMDEBjbsdtv86nl7dPSViSkrYEGwdqQZnc03fFO8N6quMG6Bfbo2j+EHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBsyLPen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBsyLPen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A131F000C6;
	Sat, 17 Oct 2026 03:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206044;
	bh=GU0RetsOiXTV2gvfwha3kOBm0rNfA9ThtN5R3CT/tys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBsyLPengUupRYgwT9cVxhJWBJNIg39ImWN5xHVR74DVC+WhkhXoBn9cYuoNVrDgb
	 OiP7gGqteT/Lif6h1FfEGLcUMZd/Mcy/lmbqkLzfAdVQD2lpSs/pDmMOh3IXd9EMun
	 rwqkVAGUcc3LtRDpiAzhoSNNzZ/h4kxMu85S95IyLHi+Mh27FQfEjJcFfzaFqk6l10
	 xpPJO2l5RCECLYnKWsw1jN5mnHKzGqa1bzSQiCTeV5sZZ3vtEtXRxbngb4sZBizv/A
	 VqqdqGN031hoG9E9K0FpcoLJCjzQ8f0X7iGDu81IpLpLb+R9s5cC8lSUKkmf5dY8TT
	 iQrhMvRM76R1A==
From: Sasha Levin <sashal@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: Re: [PATCH RESEND 5.15 v2 0/9] Backport of XFS umount hang fixes
Date: Fri, 16 Oct 2026 23:00:20 -0400
Message-ID: <2026-10-16-1-daily-reply-0015-xfs-umount-hang-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

Queued the series for 5.15, thanks.

-- 
Thanks,
Sasha
