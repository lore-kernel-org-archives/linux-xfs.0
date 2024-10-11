Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F9C1CDA19
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728632696; cv=none; b=GW91xOASndiCGuMOLXCs7NYnCXn6oapcwWSfihPoX1+jPfWabaN0aj150Grjj4dN/nhtaH9GVG8WOh0kKiwp/k9VT4aMgGF5iVEQZTzVHUMDy2d4UX+thuBS7xIa3/5hwKyKROFyUKDIWEyQ60csjqNqY0pJpfTZ9bUMkr6JylM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728632696; c=relaxed/simple;
	bh=WoDgltAzSTOU+FpjCQ3cdnWLBuyoa+JYorj6KnpdPiE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IrZB4Uado87p+DkYpSs+8KN+bnsQqTzdrMEd/w1fYsyY8mGOkUup9CQ7dMgCoIM7FSX9pNPkECzvUsTy0YDixab7wB64Rrrnn1z0J+7sNhuLDrsiiwekUk16KUWfCmf4S5yth7fMqE7T5CoGtIcdcfsptdc4g5lr7F/6naciHaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XS7T/G6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XS7T/G6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E252C4CEC3;
	Fri, 11 Oct 2024 07:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728632696;
	bh=WoDgltAzSTOU+FpjCQ3cdnWLBuyoa+JYorj6KnpdPiE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=XS7T/G6W+XVo+AW5weWc1ze+r28piO2CnSiBP73fYajHIb4cl517grTSYFFObZpnS
	 tswIhFzTYyEJz9dOqWi1E2ySwrY+tYwpksv5xbc8bXUYq6c4VP6VrUm/cd4SDplJce
	 +HBZ4r4OwKwVNxN3/LqTGpWEhuVxnD/eAMJ+PSX1YyqG4dYjhm96H+rA8u7gR0dUSr
	 KAOftNi6VBY1AkacVY/rNjFXJNDvZ9bA3BoD+OgE5b14lM3Nm3CgjD9kvYIkPgJQT7
	 OJmGGKqtER3QWUrszaYzSuevEDN3aVEjj2Zg5t/26ZxUlaI+n/62TSrm8hcWpWg/sH
	 9/exSITbePtAQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, 
 Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com
In-Reply-To: <20240930104217.2184941-1-leo.lilong@huawei.com>
References: <20240930104217.2184941-1-leo.lilong@huawei.com>
Subject: Re: [next] xfs: remove the redundant xfs_alloc_log_agf
Message-Id: <172863269409.1112815.4154437152344391162.b4-ty@kernel.org>
Date: Fri, 11 Oct 2024 09:44:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 30 Sep 2024 18:42:17 +0800, Long Li wrote:
> There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
> The AGF does not change between the two calls. Although this does not pose
> any practical problems, it seems like a small mistake. Therefore, fix it
> by removing the first xfs_alloc_log_agf invocation.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove the redundant xfs_alloc_log_agf
      (no commit info)

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

