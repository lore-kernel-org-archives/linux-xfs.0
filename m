Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3B53B8124
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105830; cv=none; b=dvNpvncDtvPfoO6nUuYltG3nl8Rb95Px/F85pgZN9R4Qt/sd5mA5k1i2krcm9ENpNCADUsUtqOeptpgrqW/tllr7+/fsGCuth0hFQqGahRrENmgK8p0hi/Sos9xh95UT26hivT5puaOezgAPlyrN+UFxEr+lTIBD9aJCW6+KLEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105830; c=relaxed/simple;
	bh=8l9NYVw4Kt/wOJBcZ+a96YFO5ubRngV14d9B46ApIRY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T7nWXN5+0mVABrSYoZlvHQLTutlSvGw0YXhhu5YC5IqNlNT3l/jtytt9Ws6M35QeFkc+el4eSQUQ6c5ObACr2xPq2VbcHcizyWV1zU6m1vQrisjs/BkBaPap7Xa6Szaj9LUViRS4NYT+S0zg+1DIbp6zbmv7rzYwM5DDUaM6Cs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjZSUMfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjZSUMfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E111F00893;
	Wed, 10 Jun 2026 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781105828;
	bh=eLQ7SCkgLZ/sNKejtNui4cdEKhU8nDcnIX+C76YA5Ws=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TjZSUMfuJkm8EnDpp2LfJuSKSYcF8GgEtgGHieDj4SZ505iObGe7QEFSJeuwC+CgY
	 KSEzj4uzB0zebW3qbyAlqGOE+q0wVvOrCmuvHEHslPJIAjrf2iEto60CiJKO9Mq0RQ
	 NXsCVDdJC93cYBkJRGFlRl00Js1yH8szXCD/DFrlPPQKtz+lhYI50+pwfsmQVOMgU2
	 V05dK4LuCCPRbZh5GReMeFzaMMurNdssq1wzS+fpI8IU3kh0/iNBv8/sNu6QHE2Ciy
	 aR6wlCqzeluix9bCzUxNzI1fHKPzg5jK5nUAOccdyCW3eDIFfWRqqOxleIoDj3tKaz
	 bphJHd3Hg9NKQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
In-Reply-To: <20260610045724.GS6095@frogsfrogsfrogs>
References: <20260610045724.GS6095@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix pointer arithmetic error on 32-bit systems
Message-Id: <178110582671.150581.6343225154891812347.b4-ty@b4>
Date: Wed, 10 Jun 2026 17:37:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 09 Jun 2026 21:57:24 -0700, Darrick J. Wong wrote:
> The translation of the old XFS_BMBT_KEY_ADDR macro into a static
> function is not correct on 32-bit systems because the sizeof() argument
> went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
> xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
> this turns out ok because they are the same size, but on 32-bit systems
> this is catastrophic because they are not the same size.  So far there
> have been no complaints, most likely because the xfs developers urge
> against running it on 32-bit systems.  But this needs fixing asap.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix pointer arithmetic error on 32-bit systems
      commit: 84eec3f7fc73144d1a230c9e8ad92721e37dcaab

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

