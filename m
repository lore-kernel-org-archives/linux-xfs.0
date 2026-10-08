Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408573B995D
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466355; cv=none; b=a2HvbydnISJgOKQ/61xhFMtqONX0Jpyep+D+jsnj/DE78w7grTZSsZ+1/lUosrT8wRn+pDFOn+Xa9M3efla9sPXsnv05jkWv3mSM3hOiAO6bEMsZwJ/B7GJKeeJiww9yXdpWz/5413mtXX8J1OyvlsWQbE0LuNZwG2uZhKXLyrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466355; c=relaxed/simple;
	bh=SVvcOEQImRPtW3QGHKh9vBFOCVtxFRhBRWPUdGJWUTw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EJu4U/9m0j0HnQAp8SD0hpV5HOgSP9HtGyuLyUnqoQI5hfErjT3LS84dmdn7TEcUENzODI34RxEciDuoPWI+tEBDtrgzgZVLke0Fz1AxLafel3PrTn1h8MGcjDZGuwSrfIQEyyfgMz/PL/zzhsgHHvR9O4Rssy39PW9hd6DhOPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAzwHpCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAzwHpCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08B31F000FF;
	Thu,  8 Oct 2026 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466354;
	bh=lLngGVRPZAUsZJkxPQ5Tsku5aiRh4b4mhny/WFvY9MY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IAzwHpCaKvc8v1jhytzMYqcBIZWH79Qx/dRV3SpXdjMUTc/2jXkPTRJZqWfs9R5e1
	 CKHvGbj9gdVNABlSc9LO+OPHt+l72Lgd0NShMyHfGOh5/DCdHL6n+cc7/m3Sn6C9+t
	 ZfMdh44DS9pb6/twYqp2sUonwLZXkhOSU64c/au3FX4MMADnWp31Koz2HBDPLADA+V
	 F0JrTwMGVcNTEDZK68xwDkkY1i/vj8MBGgjTKpOQ19sk1/mva168xfYEtHL13zyOwo
	 lOBrbmN+iLZkqKrFl39SfXf8lUMhaaUDMpOZ3flv3zVqrfzZSFmyCIj2yYCzJuaeiI
	 VrzTyM94rfMcQ==
From: Carlos Maiolino <cem@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org, 
 sandeen@sandeen.net
In-Reply-To: <20260924151638.38535-1-cem@kernel.org>
References: <20260924151638.38535-1-cem@kernel.org>
Subject: Re: [PATCH v4 0/3] Enable xfs error reporting to print out error
 codes
Message-Id: <179146635257.378461.6592387078114127769.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 24 Sep 2026 17:16:27 +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This is the new version of the error code printing series.
> 
> The only modification here is on patch 2 which replaces the macros by
> an inline function suggested by hch.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: add xfs_error_report the ability to display an error code
      commit: b3837dc0c73143f86549c3808e0323a47fe739ad
[2/3] xfs: introduce xfs_trans_cancel_error()
      commit: f4922f6fb12b18ff1efe7cf5a46c187a07b7f9ea
[3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
      commit: 90c4dd2fa8fc3485551023e855c093bd9b675256

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

