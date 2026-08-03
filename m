Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AAB2D6E5A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 13:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763381; cv=none; b=cNDFq6uYi5qxT3lyIUf9Wwf9aRWikHhe9bYqSt+Ccodd/LnnyMrODpz8ZlpJ9gEMXE0LNJ+4xcdIgvLODymWbGKk0yBCVt3zrwhLUIjtg4u8oPkPRuIG2NeP6KCD94Cn8fleWZQVsIcdgndM5vclkOmAnE3Uwx5e1ZhkMH80arw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763381; c=relaxed/simple;
	bh=VmygTsmQmFAvlSGTtRq1iBkfeDz/gAS9RwbCOlVwzx8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kJjhFo5BRmh1f5NQigfLtQ8AMiO/IQ8LAfVpNjoWXln7B0cBl4MvCM4saO6VAwL1v0WxOTUv5s5UMxohhvSYYR77LMYPUvOt4yTXBkqA442ECEyx5em4R0tPRjEQNeGi+usXnhaR61jNVBeirm12mLmOOCoY2iaKgnH4PC5p3Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VA08G5I7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA08G5I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B011F00A3D;
	Mon,  3 Aug 2026 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763371;
	bh=xlSE3dBxCA+2dbuRpt6S/6OUJeeGPv58riuoWQFNj3g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VA08G5I7/EpbTejmNOdFvw8dRALqXyIvXycgBgQ1A12F17C3LHsVBnwLtTWdtAqKv
	 1OCme55jTDrRYAtlEHYk/G8K4xbXhhGis3QgNr7hgW9lBoGufd1pjbKGMMa2nimE3W
	 gmuzSxbYGNNWfXg6SjgboO8+IZod6M+1exsloyH11OcvIpt4tyz7EhN23OIAvWVzPQ
	 3H+deya+Dc5PaZSK504/Eig0Q+9GA3J/0dkqqwoVbAHIjEKoKUDSSu9YCpdrR9wKBz
	 OWc5/kLoiB/InATphm/dhRctIGL0GIqq8DQ/axxR4ovy9a20WnLoqfHjFph/mS/oZW
	 2pnf/V2wPT5cw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org
In-Reply-To: <20260722091801.503245-1-aalbersh@kernel.org>
References: <20260722091801.503245-1-aalbersh@kernel.org>
Subject: Re: [PATCH] xfs: fix inverted clearance of inode junk flags
Message-Id: <178576337047.315832.6359146679525353677.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 22 Jul 2026 11:17:59 +0200, Andrey Albershteyn wrote:
> sashiko.dev noticed that these checks clear all the valid flags instead
> of invalid. This probably was never hit as it only executed on invalid
> flag presence.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix inverted clearance of inode junk flags
      commit: fb082235c67551d526704e07a4efb82ac3a9ba48

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

