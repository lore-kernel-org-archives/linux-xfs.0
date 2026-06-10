Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D057C3BCD1C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105827; cv=none; b=QrodH4NgTv4QIRLO6AFv0EWWSP6zPNiLQ2hR4tiZecsPPHDQwI4Zm7jJB3uecj3tN1976gg6tGkpGc1uo+IeMW+lnde2wlHm/pwv1O5oluC2Buj0Zf5ElKH1gXTBMxYA+fTP30geX5JQ+AfJ0+2Bu6RYT6g1h29mFQkILw7aAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105827; c=relaxed/simple;
	bh=kZMX/5xvH4AqSQSEXZ02vziwF7MFKqkoRCWPhx58n6o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QvBjtzm6aMkD90lUgR3H1rmACl+pwtmwP9zggppUTTkRv+WEe2QX/G4eAFFfTTgCud6VNpRThmrNMZSq0qdra+Spx/6gPoypYnl179AMgB4KrmYGJtuur8UrEhsbVgaCmLkrjyvC+99scue+FXrEXC3oMM5JOZfpYzdPhXVB5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3RxZmJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3RxZmJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61121F00898;
	Wed, 10 Jun 2026 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781105826;
	bh=8fpUi1CCdSTKmL/a3wtD9w5VymkZrSjI9SZcnoOasDY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=E3RxZmJbKqKh9jjwWqJzcGrd/LSYv8H7X/XlPooFphGQ2rUdg00xwpsbCWs0PHeQZ
	 ubFlToVhCF6a5QiDPNVKbn9mYOnWCzQBQ+pfJ8it5cqeZVlvaNFvP99XJcypxZoFE0
	 Ue573epo10FDdQFz/B5IyM7RzjcQIxt1MXKaVpRYmF4/b56U1rmNf7+n/mGmsL7oCU
	 FPXUaNiWF4XuXTKihZtyyTqy4K0Tyu2jRdrKiwFkGpSXD6TOlrJZGcHeLCKBF/+dXp
	 uPHS8eAllGr0iz73yghCfW6hxalkpnp3PYSJyE6IpNvIIlQ01U4V/3+A/iywnn9a5y
	 xIHR2t59DiPaA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260609075350.1698528-1-hch@lst.de>
References: <20260609075350.1698528-1-hch@lst.de>
Subject: Re: [PATCH] xfs: initialize iomap->flags earlier in
 xfs_bmbt_to_iomap
Message-Id: <178110582490.150581.3528853457607568953.b4-ty@b4>
Date: Wed, 10 Jun 2026 17:37:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 09 Jun 2026 09:53:44 +0200, Christoph Hellwig wrote:
> Otherwise we lose the IOMAP_IOEND_BOUNDARY assingment for writes to the
> first block in a realtime group, and could cause incorrect merges for
> such writes.

Applied to for-next, thanks!

[1/1] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
      commit: 327e58826eb72f8bae9419cf1a4e722b57c85694

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

