Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBA48097D
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560413; cv=none; b=AiE9gIZu/hGkBqlDY00/dfaE9Y3cCVUtZGUbn5bsxMTvBnDBLrZ2RToM/MvCmkaPPZoAD+XRHVGVjR6pd065t3bGPf7AHhyhxKfM8cDpmVUyw/JnvrNVr5odO32cHXw5FNOwAmhgIkQsG2AQMcT8YaGbgG7Wd4BRjjcyMGBkgJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560413; c=relaxed/simple;
	bh=NP+HshwcaO1HffgrWP6/BkUK+FtP4AWfdTtl3e3Nut4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mbaTE7tRtnpYADfPmMLd5AY4YWFAx/bYO2ksQKy10il0AdZOQ5iWfiu1ddXmCk0nG/sxZY1v1p7svtOrQBlLQTke6GY5jSwg4DBBNu0c9f7ROi8UDZy3muyB3VGanVou7n5wf/RniKJ16ZWnj14/9uvn74KL5CRFGVWZNWA277I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lz5xfG/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lz5xfG/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6961F00899;
	Wed, 16 Sep 2026 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560403;
	bh=YhNARcR0D3t96wV9pcNdlKDdUQTLT4GjAgrZPvBIp2I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Lz5xfG/JUEDJm3G9+ObKM6YvavrHMXqCqUmVXp6jtoHMCvOsDJoc10lTJHIVPAR4q
	 yaMlZPNU9XnOSFhCvmOCtfcjMM/HPDRuF4rFsCEk9PzPLwgpLy2cVs3ugpOQA9LN6k
	 eXLlGibGUJFgUuAICZDAoXktR1dcVmUV0GF7TArvGAMkTeTdKw2EjErqil+z2CEI/z
	 HbfaqfYM9PqlWkYqk9wc7toCgaahv78PIWrkobirUysmvx4num6srcalCvuimygAD6
	 Le6/Mri0adwtWmlQRErdelEpbzx3bekzssSoohAv1wm2Mn2OQDFJFMTEQuq7RQ4b2v
	 JF8hqqUH5Gz5Q==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, hans.holmberg@wdc.com, dlemoal@kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260914113538.2448661-1-hch@lst.de>
References: <20260914113538.2448661-1-hch@lst.de>
Subject: Re: [PATCH] xfs: don't try to get a reference to a NULL oz in
 xfs_get_cached_zone
Message-Id: <178956040206.10466.10912584948881173844.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 14 Sep 2026 13:35:38 +0200, Christoph Hellwig wrote:
> oz can be NULL when we resample it after taking i_flags_lock, so account
> for that.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: don't try to get a reference to a NULL oz in xfs_get_cached_zone
      commit: 14e379600d3e57ab0872b049c28cfe5ef519d439

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

