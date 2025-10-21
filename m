Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D02E7BDD;
	Tue, 21 Oct 2025 09:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039455; cv=none; b=CXscnrlO8UuVC5RGvrkeujDusFdRF3egHv+eAYC5wkyKd3g7nYmWQmsSAYzvdcTN1KBW0rcjLaBqre+Wv3pVr0or7g1ojrGJE/7vD2tHfX4SPcyno+5BtSwpyKh5vcO9i22c2UsfHKzn/YyqP9Zgh5ZTRpV3gNjb/SYZnB6Cs3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039455; c=relaxed/simple;
	bh=ZsCo/EDF6FwJc+2uSEWFJl0x6Cly1yBcU94yzW2S++Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dIJcUXqm/cco7mQR8/ZUIkp/8mlM2ASiAeVkQhwMfJfbEdeUsZIaT08bCWBsgnDjRCqdNZShCkuTCzgJlp5b2OGFY+S5yC7+2Z01Vmc7VucZOZOxlX3W1JCfEPvFyB1VvaDX8PF6lumI01Pt4GMP3EpaqMHt6/jmsHNrKF0/bsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+D7i9UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+D7i9UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F733C4CEFD;
	Tue, 21 Oct 2025 09:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039455;
	bh=ZsCo/EDF6FwJc+2uSEWFJl0x6Cly1yBcU94yzW2S++Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=n+D7i9UHeYhsS7ZM2fOF6S8H35q0uMw4CUl2ygVmr71wTZheonUN1u7KDF2Dxh8pO
	 8TWl65+K5SguxdBAUK6Y+iKxfZuZzQwCzqICsKN4bDX7hkYR28GrFoO2gJ+kHeeAFM
	 +9tpVhusNh/o0bIJMxQwnl/USyc3s5xxJDayUFDjugQoxBQJC/UrvjbqSwC0T12kGl
	 ZA6zP4hLJbu+XKB6W6SGPOGWS92Iom77Myw0Ms/tm1MrFsxkJ/oLJag542lbV917Q8
	 YhktxCjS5pQUbuGUlXBnmjWr4CB3CyAGoEkLrYEQ6fsloyXgYRLt+ktYrPaNAiWFAn
	 T6EwBDnwo+j5w==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
References: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
Subject: Re: [PATCH] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
Message-Id: <176103945397.16579.3795504519403612906.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Oct 2025 10:48:46 +0200, Geert Uytterhoeven wrote:
> Currently, XFS_ONLINE_SCRUB_STATS selects DEBUG_FS.  However, DEBUG_FS
> is meant for debugging, and people may want to disable it on production
> systems.  Since commit 0ff51a1fd786f47b ("xfs: enable online fsck by
> default in Kconfig")), XFS_ONLINE_SCRUB_STATS is enabled by default,
> forcing DEBUG_FS enabled too.
> 
> Fix this by replacing the selection of DEBUG_FS by a dependency on
> DEBUG_FS, which is what most other options controlling the gathering and
> exposing of statistics do.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
      commit: f5caeb3689ea2d8a8c0790d9eea68b63e8f15496

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

