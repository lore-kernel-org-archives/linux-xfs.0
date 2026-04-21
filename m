Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5119F382F04;
	Tue, 21 Apr 2026 21:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776807799; cv=none; b=nafus4bZkxSgYACsi3sn3slEl2ZRDBwuYeTx9DxI8kOdybyhvuZ5RRnLyip/pCJKCymrzKLDhYurbDNto5QS6P9gpYly3MoYpWn/hsE7rofOzylmaYfBTDoeGYoEcXfdSAW6Oh09jYvvsv6q/2t0rNoe5xrNLf5nT2Q8inPhpQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776807799; c=relaxed/simple;
	bh=pTUFlPVgh1+kKopP2/8EcrgMqvKTDIazFWCbVyb/saA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMSwqB7OvyyjTgMYq5J0I2vteWCMlYASq5AK4QjcghCzHLOtlyyUwZqeo8eE/I5vPGuVOcGp/E2axlnEgK3P2iJTu1Dlvm7HFkvi54Nr8Tf8o7KuoDWnxFI4jtQ6nnym4CsHPlFKmpCSf7IrO7J5QBMiRtd8Y4HT7cMWu4lfmr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZ1aTAqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZ1aTAqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C101C2BCB0;
	Tue, 21 Apr 2026 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776807799;
	bh=pTUFlPVgh1+kKopP2/8EcrgMqvKTDIazFWCbVyb/saA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZ1aTAqAp1DEuzXkk0YqoVGbSe2TJWO8OccQjAcTgtpULImuh5vd77WIS8fsUBFLU
	 pehzx/xLhYFe0qDouKUWtfNhbxtxepJP8/ohbkYcuPaS22ZBh3uOy6Lh9tH1yGN/Sa
	 J477aufpJhJI/psggvY6BwSD4k1A98xHSTBmBd3PxoXhG7Jywoe+9dlHh54LR5JUIK
	 3B1NE2LPeKjckp/cG6y2sBPmamM6lJCVxbA26kpl5Py3t8n8XpGdABBZds0KN3tEIt
	 bA526D0GvlEaZ/wQWDQMW6ywPQLY8/g5M7BARF0Q6pvVKJw/SxAzisuOVY8cLvfjyK
	 ljBDrZ5Dw0u9A==
Date: Tue, 21 Apr 2026 14:43:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v8 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260421214316.GB37143@quark>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>

On Mon, Apr 20, 2026 at 01:46:47PM +0200, Andrey Albershteyn wrote:
> This series based on v7.0 with Christoph's read ioends patchset [1].
> 
> kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=b4/fsverity

FYI: the git repository doesn't match what was actually sent out.  For
example the patch "ovl: use core fsverity ensure info interface" is a
bit different.  The version in git (incorrectly, I think) ignores the
error code, while the patch returns it.

- Eric
