Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E706366
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032762; cv=none; b=fijsSfOgZvi3j6HbRIKr9hweRxqM/HgSKjNq97xkw8h7KgwZx1Yd2udcelEkKOHEdoHrI+GoJpdB+W74m5vKhfS/4Idx1o1UxAXKEU6P4V9IBs1PSEi33mWkvN7Z5SESO6/AIF8F6kORWVC1Tn7KzbEyhXkitm72B0/eKFUg0Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032762; c=relaxed/simple;
	bh=Mvn96L+Yit1MBeO+SC+g4zsfMZ0Fm1naYklJp2wN5bs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DpGmo4LITGsaftnJPp7M48tarQ8gEdW9VOyu67Mgj74oA4ObNnXOlhDZVkUDTpocscKZThs0jjtHETDiT2ZbiVr4xLd3Q9o4G+i5YiSBZbNFg4AIYa/if+eKGeD7lAuUaFGBi3D9Gbw6/I3M5j4Dlx5CrbxTXLdEZ515eHvuwMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwBMa98k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwBMa98k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DD4C4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 07:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761032761;
	bh=Mvn96L+Yit1MBeO+SC+g4zsfMZ0Fm1naYklJp2wN5bs=;
	h=Date:From:To:Subject:From;
	b=TwBMa98ktIu8lLF7KUIERDd3boh9e7wdYKkH64uMflG79XfwQq8U1rptvLGdZZOOk
	 Iuc4I/2uYCl/9BB2+iKXk5LUnNAclMpTVZMKas073UmJ4h6fZJ2Oi16Wh3ewomL4Ft
	 5uVYunjehn+C3wiw0NPWI5BKjT3opbS65bGGWM4o8lSZ5X4mE+MceGeBuJll/YmTFs
	 QaOU8iM/xRuKdoPnB+cJW16akSkqkh+yv4f76MN5SilPpgjJA2L4pMkWL0HWAaWsA5
	 188v30pTVi0Cx12fYeD6PDJ2ZiFrVUJfrZVEPe67h7FgKGu4tkG2+h9CzsdYS8dMdK
	 7FxuxsQksF/Ew==
Date: Tue, 21 Oct 2025 09:45:57 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 211ddde0823f
Message-ID: <iyinq56jg7t3t65ugifgcw466tf4fpl5bjjqipnqupuseqjjbc@fjfadqtkhdbi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This just updates for-next to the next -rc2. As there are no patches
yet for 6.18-rc, this is an easy update.

The new head of the for-next branch is commit:

211ddde0823f Linux 6.18-rc2

Carlos
