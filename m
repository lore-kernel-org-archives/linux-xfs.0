Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0080E4C6C
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243842; cv=none; b=CfnJD4nO/AnDu7iy3gBexhn5NUg1J00jrzscDsUAharjm8AFIRX99O+VPFHRWsRsn2rIuD/WzRHKK9gtoOw4QoLhWW77tLzJ9ffGMLl5a/0+HCB91pWWgzPtIRqMRvejDFrP3ngkwr/KtyBuZRcYlJLDCyogIhn3Lap/Y9TX3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243842; c=relaxed/simple;
	bh=obfCg/DgR0twdjpyH6iwkLrskRU10klLpyXaKIdHrzQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CHBDIpMwXuYkpdmrscMCIFtl1F70hQN7r20vi9F7VxGcRHLZ7qc7kKVTtYp1tL0BzltDMWa1SoB0wqctoZ5f72gMACFlCDfR4xjwTR8ejBckxv9E/dhMFEpeZV3s1CjwWAH3DW9a71CQU6icTR5Yt9nB1LDmXBMyh+fyUQ3rJ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knbvFiJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knbvFiJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5568C4CEE9;
	Wed, 14 May 2025 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243841;
	bh=obfCg/DgR0twdjpyH6iwkLrskRU10klLpyXaKIdHrzQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=knbvFiJmH+Y45N1quXuycj+LbGUMd40ljbjQfhC+8bXrDE1ILQ+hf7VhME2ojDpe/
	 Ww+nvUg7O979eW2oFcBtBEDwdvaUn5kru6GB4QoLHJ0xHpPD9gB5tto5ThpgZQ0jNS
	 twrIjBflMv8ulB84iz7P+9Py1vdsxm54sTxWyXAj/xhyBlo8Mdxj/vKb7eyQ1dwCmU
	 izIrRnuR6HegV0gSPO6Qkc8lu4ZuNGw3j5m28D0HKffr+ucRjE4LQCuHKk5/oJVgoY
	 bJ893wap+EGAktYsGlxLz/a+wjz0VutP0GLRO2TTtk8m3wVD4ApEivLDRgKFe+U/gQ
	 PkHlBurPjQ9Nw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, cem@kernel.org
Cc: hch@lst.de, djwong@kernel.org, david@fromorbit.com
In-Reply-To: <20250512114304.658473-1-cem@kernel.org>
References: <20250512114304.658473-1-cem@kernel.org>
Subject: Re: [PATCH V2 0/2] Fix a couple comments
Message-Id: <174724384028.752716.11040176344951622906.b4-ty@kernel.org>
Date: Wed, 14 May 2025 19:30:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 12 May 2025 13:42:54 +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Fix a couple comments in the AIL code
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Carlos Maiolino (2):
>   xfs: Fix a comment on xfs_ail_delete
>   xfs: Fix comment on xfs_trans_ail_update_bulk()
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: Fix a comment on xfs_ail_delete
      commit: fa8deae92f473a2ebc0e1c7cfa316f5c083e1880
[2/2] xfs: Fix comment on xfs_trans_ail_update_bulk()
      commit: 08c73a4b2e3cd2ff9db0ecb3c5c0dd7e23edc770

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

