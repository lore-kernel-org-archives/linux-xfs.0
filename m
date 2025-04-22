Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D9727D789;
	Tue, 22 Apr 2025 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330944; cv=none; b=HOOher0eGPMfG3ugis+qHvr9u5aq/zgWEXxkA1//TESdmsafdcvb9sC4/uVLUORUYlDeBL9gp0IssGdA8JxjkwRbUWR9qaNbRojIOBrHodzxCikeGTdSAlrcHqNKthvFIZjMzYp+6XCK0F1Uz0tT2QeahHwFwWiuN5KtzT/0zeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330944; c=relaxed/simple;
	bh=zA35fywSadrIG1v+r1dlhqX4ghhXhBKWTpaxZbfK/js=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=liQCSe3HYsa+hQvxtyb8X5tCGN3acaSNzBEteOPUqpt1JQG7Lye2BO6Yzsqk9TTeA2ZFLc8/NTQkpAWju6ytzEJdTLFMLItNnXluwbHDMAfkXs73jug51CvP/gk/1zi0Z6z7xzz+zW8b0/cZHgaWg0QBukBp0uO2//iRb8feXwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHitxyeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHitxyeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D36EC4CEE9;
	Tue, 22 Apr 2025 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745330943;
	bh=zA35fywSadrIG1v+r1dlhqX4ghhXhBKWTpaxZbfK/js=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VHitxyeKcqtAfa9MmSWy5XPsFvb3Sv18t4H+z48ejBHQ8B5TMCrLwccsQr4+JnUEb
	 2DeBWingYx96HzShBGh/DgxfHw+WF2eerPjvYCSE2dvFcOPokR3x4YBlT+h2/2i1ZS
	 FHeEOmlqFHFeJTJp0Xw7kkDyFN+aVLc80tcmj3pjuSrNmP1KaxNGHW4TCrp6GzV2mm
	 KXOD6F5IY5Roczcek66Vx34lk+rNjveKTXwL6ekocvGGM5tlY5tX1/602sMHEChlBg
	 FChu1bp251A1cee5Xx1j6nbjpbc2pCk+IsiwufVSLaIrQXYXSL278a7TxIedll8pW1
	 xlP/LzcpjRYOA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, cem@kernel.org
Cc: hch@lst.de, Hans.Holmberg@wdc.com, linux@roeck-us.net, 
 linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev
In-Reply-To: <20250422125501.1016384-1-cem@kernel.org>
References: <20250422125501.1016384-1-cem@kernel.org>
Subject: Re: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
Message-Id: <174533094182.1020409.10311218033139105345.b4-ty@kernel.org>
Date: Tue, 22 Apr 2025 16:09:01 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 22 Apr 2025 14:54:54 +0200, cem@kernel.org wrote:
> xfs_zoned_need_gc makes use of mult_frac() to calculate the threshold
> for triggering the zoned garbage collector, but, turns out mult_frac()
> doesn't properly work with 64-bit data types and this caused build
> failures on some 32-bit architectures.
> 
> Fix this by essentially open coding mult_frac() in a 64-bit friendly
> way.
> 
> [...]

Applied to for-next, thanks!

[1/1] XFS: fix zoned gc threshold math for 32-bit arches
      commit: bd7c19331913b955a7823e6315ca16bbcc65aeff

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

