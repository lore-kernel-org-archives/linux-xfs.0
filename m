Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DC438FEF9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309840; cv=none; b=PyLD+6UBVPw1CbHq30PlE1G3BErgFvWjt5QS5Kjsvbe57m0uhmmsVIREUVfVbErBWqj9iS6fPwcNHrh30FVUNTmUmXTR3wJjf1UQEUQLfqDc33xaKEwt2oLFbXLeZ6WMtN3AaE/K26kfNo+rU8GcinxDLpBxlbNNbDebDIG47xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309840; c=relaxed/simple;
	bh=aH4INW3hjFlqqdO+79hmF4T5sCd7QvOoMP9ln11c3mU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f3JSCAJ0HyQO4mQWHmXjXQHVEdrqqR6RLvLdiC2DuctLvOaQJZR/wm3WAdpmgOpIy3gbt2SP++IDGm5GW+74NM7kkhIVzpyVUtjJ4MReBVtmuWglLnBachdRMX36BDYo0/PikdSednRww5RGOwbUrz3qJ5W5CvRCVbBN8PKWSjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASqUpwsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASqUpwsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86774C16AAE;
	Tue, 13 Jan 2026 13:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309840;
	bh=aH4INW3hjFlqqdO+79hmF4T5sCd7QvOoMP9ln11c3mU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ASqUpwsTSUT7+Cq0M3OYLzk3ij6rxV99nUo5KDsFqoB9ax/vtQERrHkreZwEfZkAf
	 GKMDvdrAgTGHJjR5Nom0W74uu4GVWmz+qm+L/j15qIxOzJ+kz8URhw/kC6AxPjogX7
	 N8c4L8TP2MkryK/M2uvBNrgw16dyAXC9lWDtjdE0u9Zmwl5fLS288CPZI/CE/Q+4EV
	 n5YqBGlE1t+9IokmNocdg6BIo7WZvtYCxi9pirpKEyyNk0+zq0Y6PzsgszISTtsFsm
	 Pk5gvrctE6xYYqGty+gZQDA7yALpWyDk0blPqAOX7vJGTGh8BY66OKg3RngHj18/Q3
	 Q3M5PmWdUx+Rg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260109151827.2376883-1-hch@lst.de>
References: <20260109151827.2376883-1-hch@lst.de>
Subject: Re: [PATCH] xfs: improve the assert at the top of xfs_log_cover
Message-Id: <176830983926.127908.15132527353240791123.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 09 Jan 2026 16:18:21 +0100, Christoph Hellwig wrote:
> Move each condition into a separate assert so that we can see which
> on triggered.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: improve the assert at the top of xfs_log_cover
      commit: df7ec7226fbe14d8654193933da81b2470cc5814

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

