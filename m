Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474993A6F11;
	Fri,  4 Sep 2026 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522422; cv=none; b=H6rHsIP6fUfWc/8oflpFR6iGXV+CmSzofVhBGchn3pfYnWVJQ2cJ5izO0vy27VY33Q5KonER0XSkck8SbhuoxqwHQbBQvI3WxHnOai+SQRYqHZYE8L68v1NfCG66qCy7lMBfSc8cpq/dEaym+3K8deHB99SM23X5jqQEP7KaWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522422; c=relaxed/simple;
	bh=No7RxpqQJwgIJeJlpjDe0CUFOgagiIf6Q+PYrkQFE4Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lgNpQOlqyodcf1XRXVFue9i/aoUfPHgrIDBiAGSTO19Ugh9vnG1vGIduTgm9AELWUSyiePDw2dF8w0NjtZrw7wrFnpBpsfqEnWiQjSn6fSctx86v5TVgokih4MECN60DjPCiiUdZFMy7lM0yIYpkDQIAKVAY6chXoxzVFhTcswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyUwTLQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyUwTLQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F9B1F00A3D;
	Fri,  4 Sep 2026 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788522420;
	bh=YtoXJyjR8/C4xJI+BwDO07bbXr32ODV2nIQdgU3Ckes=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fyUwTLQJRIXJp3VrqRYW2BjefRQK3/yM2//HHtDeYWKcwMbsT2ITfarC6sEqHhSy+
	 ymtgATA8JI9+st+FWhugXaEfosw+GvPR1dnY2a7XIGbVjTr/sije6RImMVr7wE7zpZ
	 aPD0itVbBEhkbabofDoVZx/1srlFatDsPlMjmgcgqhO0XLJwtGWgPitMCLyGIZm68g
	 VfnHtW/aWlE8FOlN9TBfq7T+/AJChI+dHincbPxaEK95Kl30NKrc6i2NlJBIEjXVpS
	 HgVNoJWJw8FCXtbzNjElJESHOwoN3Eq7TRId4p4khzqcm9ypr2T0+vNjv9RNNWkKZJ
	 yBaMlbnbNKdIA==
From: Christian Brauner <brauner@kernel.org>
To: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, 
 linux-fsdevel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Cc: changfengnan@bytedance.com, kbusch@kernel.org, 
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 libaokun@linux.alibaba.com, bfoster@redhat.com, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter
 iomap_next() model
Message-Id: <20260904-darauf-relikt-plazieren-5dbecdd0ae68@brauner>
Date: Fri, 04 Sep 2026 13:46:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7

On Wed, 29 Jul 2026 12:27:15 -0700, Joanne Koong wrote:
> This series implements a suggestion by Christoph for finishing the conversion
> of iomap to an iterator model. This revives Matthew's previous RFC [1], which
> had the same intention.
> 
> Every iomap operation currently drives its iteration through a struct
> iomap_ops, which contains two callbacks, ->iomap_begin() and ->iomap_end().
> iomap_iter() only ever sees these as pointers, so every step of every
> iteration is an indirect call, including on the hottest paths.
> 
> [...]

Applied to the vfs-7.3.iomap.final branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap.final branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap.final

[20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
        https://git.kernel.org/vfs/vfs/c/71864822ce32
[21/22] iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
        https://git.kernel.org/vfs/vfs/c/2a3b6fe7a17f
[22/22] Documentation: iomap: update docs to reflect iomap_iter_next model
        https://git.kernel.org/vfs/vfs/c/e16ceb1b6c03

