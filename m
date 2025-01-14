Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA22284A5D
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850644; cv=none; b=GMeMwIvdtp0VBpAfno01uJRnP+XdItwlWiakQ2CV0/XUwBszzIK0MAQjP51E6aq0Owmw68sNxvcSvrPd/mc/5rqGvxHKANgw+drGx2Di7wJ99qeG2gxuhM9pw58JAJL7gWO/bUoGtJMVFISeL91NV4t4XZxnvOl6bVeEFHA2Ewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850644; c=relaxed/simple;
	bh=VTxXwNA1Guv56GoaEe54BYwD/TVZcruRsZ8TKSAYRDE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZmPQHu7XNk8rNvv8S9gSMjV5zLJpIhloGiPMVMVMheY8WhFt7xVRZ51pK4vZ8bt+SAVsdmEcxsr5ytofBWqhUeiSvCqw9omSJ1R+jEpZeeesDsrXDDTDw8WL37tMDr3UZ1DBB0Fmy1yytnG8RC1jyRt+iCo3XtyVPO5O4x5XFjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAxgm1Vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAxgm1Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8432CC4CEDD;
	Tue, 14 Jan 2025 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850644;
	bh=VTxXwNA1Guv56GoaEe54BYwD/TVZcruRsZ8TKSAYRDE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JAxgm1VkdCoVuuSDEBQT6AY7jyMbFXSmJZjGxBwblZfZ453D4wgR84A+hJSrhERiO
	 4J4ootsHBjbTUXxPROMjHj73v2vzA1RZQi7TgVIq/CoBSXtUqzUgHEwMpAIUC9Dmyt
	 zmhQGpUyFBfQQE6kJQk8LSDnvtSyrlRmLuuV44/SAnyzRPNGbade9p8TvpAIPvC+oI
	 grd2FtIHDw9q8E0Z9e5Bbi5YYvix2xy+sLIkji7ou1cKG2DIDBEHpYZ8MGreyf6c08
	 n7/8lyTRuqf4f5YfbrWeCDT0cJqmuyT8bcIVMQYDjoDF7j532vhdGytoNGj6JgVmi2
	 69S5/6DRjxnbw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20250113043120.2054080-1-hch@lst.de>
References: <20250113043120.2054080-1-hch@lst.de>
Subject: Re: [PATCH] xfs: constify feature checks
Message-Id: <173685064317.121209.6115306129449122201.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:43 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Jan 2025 05:31:20 +0100, Christoph Hellwig wrote:
> They will eventually be needed to be const for zoned growfs, but even
> now having such simpler helpers as const as possible is a good thing.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: constify feature checks
      commit: 183d988ae9e7ada9d7d4333e2289256e74a5ab5b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

