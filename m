Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5951132AADD
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435634; cv=none; b=eL5A5gfEiJch3T9wtD/Cqk9Ao1ZDKPgU7aW3XhFHPLlHFgMqF7HPPDThKCZovmdKvN02TnBL+JnsWht7VyET11OaClPJvs1J7lclK13edTEfZR1mCcIu3LFx9f5lznirMZkeH0xto+JcNSwbp1HmgGuEMlnA+ssUaaSDLNquYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435634; c=relaxed/simple;
	bh=s+HE41Hqexopb6otIZtNysHmZaBi33eDrT9biQ6Gv6g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oiw9oZcMaX29QeV3Kx2pfmGweVzPud0urGXsNs6EIrXvUoM2wXdIYfI0Jhe19wryX4gFPlSDOzYom4gya9h3qGvkJbEm0N/E/XWj4H0eJur/J4gRGEJ9y5Wd4bEM9pHgRoHRmD5p3Dd0FZEY/lU+DQzIV9AtfV+M+mYOEAEksgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IchTcykC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IchTcykC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55BCC16AAE;
	Thu,  6 Nov 2025 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762435631;
	bh=s+HE41Hqexopb6otIZtNysHmZaBi33eDrT9biQ6Gv6g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=IchTcykCSiCXDvGTraEQmHrevHP69sFnzAQndDhuIImepqYg5gWwEDUfBCGOpnIaW
	 6Q11nq1vDMGmZZ8P0dJB/+TWQGvlxFzzv1TUpkD70O2XQphmisso9IAlWFVIJn0xmg
	 is/mUP105Ood75ubHjMroRD2CIapw0b6UckEnLeJaH40ROIApsFLyqyf1tPYZZbk6n
	 a2dwlXKOUU7MDjvtwoG618TzbUWODylAq75n6vwY780vNuA2uG8WCgDo8ohTyHxLvx
	 XYLfTSAZuQgf4Du6w4XgEo7NpBDJJ067tAlNXtqoPg2h7pgZ3rmyJOMLNMP7XvNEZq
	 T9LTFeuftYpDQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
In-Reply-To: <20251104135053.2455097-1-hch@lst.de>
References: <20251104135053.2455097-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix a rtgroup leak when xfs_init_zone fails
Message-Id: <176243563064.345504.3036095110850646991.b4-ty@kernel.org>
Date: Thu, 06 Nov 2025 14:27:10 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 04 Nov 2025 08:50:53 -0500, Christoph Hellwig wrote:
> Drop the rtgrop reference when xfs_init_zone fails for a conventional
> device.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix a rtgroup leak when xfs_init_zone fails
      commit: f5714a3c1a5658251360603231efe1bee21f9c2c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

