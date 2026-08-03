Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E1A409293;
	Mon,  3 Aug 2026 13:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763383; cv=none; b=TsVjBt2BoQz9kTjQCh+8ex9IW3sXZcMI6a5z0cMs3V554M5KrAuPEbutkoQ8fsvKBVwYPNLosqP+J48n3uZ+lXZUTyESxlJgIu0WQXpLQKKT2X+liPXHDXOgiWnpohB+yxjHwIJty9eFyNOFqt/8L9bxfspV48mR6YHHVivQZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763383; c=relaxed/simple;
	bh=Lb9Biq+DD++JUY+flC/0uH0E6hrJ0eLYiBA/gV5nQI4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ERRebUipPSF3zHbOocgrW62UKC1oxLCurMDAglMvxwohwAEA0Ci8WPPo6NknpebpYwuJeVzxieKIyFv6JaBEgYXS7v2SU3Xr13G519+9tg4LTtstKoGvc0C1WlhuI/iqh1OPaMk56KOnSSbYxwJS6DIl8DHjjbixSJU10bxhaUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVOAs7l2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVOAs7l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A6C1F000E9;
	Mon,  3 Aug 2026 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763375;
	bh=6AUbVHF/JsdMG8W87nQADeBszJs2o0aIq2vbV086hV4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EVOAs7l2/z0hG+Xmm7XdgeyQVcEahT06jy1TJFI/uxAwHRhGjVl4W7MZ9nNERAHcZ
	 j3bISj/e94NBMJNTiNleW1vTH15YUNYskX2kC+80jp+rvBxzcXBmMTWilosZPSqKtw
	 YK9RPE4zggOGl5T200SqJ/La0BUFoTW7VHoh1LpPC0LIgks+VoXV16/kl5dId/JFbb
	 knhrtYxwNUfZSqljqoOIny9TrCa4ybdaNxP0Gf43GEhK0Q5683a3M5YUjedcMdp+Ur
	 gD9acutl1uphYnVk5JcFYHrA0ykiP2l00xx/okCKtRxeqH39TeRnR/wkeotGr82JYE
	 pCiHOhP1hsvpg==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 2/2] xfs: LLM-inspired iunlink repair bug fixes
Message-Id: <178576337368.315832.7276081015664013624.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sun, 26 Jul 2026 22:22:54 -0700, Darrick J. Wong wrote:
> These bugfixes got started as part of a series of assorted bug fixes.
> However, in writing a test case to exercise weird corruption scenarios
> I discovered a few more fixes, so I decided to collect them all in a
> targeted series.
> 
> v2: add rvbs, fix a few minor coding errors, strengthen loop detection
> 
> [...]

Applied to for-next, thanks!

[01/10] xfs: hoist per-bucket unlinked list check to helper
        commit: 7cdafd8f10ebdf745ba6046b9fa67490c343a17f
[02/10] xfs: don't livelock in scrub on a circular unlinked list
        commit: 527eaaefddb6ec5c83a06c9a1559960dd6361753
[03/10] xfs: don't walk off the end of a null sc->sa.agi_bp in AGI repair
        commit: 1e96a00e0d3a00be6e4f368b2f18e2d345f813ce
[04/10] xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
        commit: 6b9cd540138a06660a843a519facc147060acbef
[05/10] xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
        commit: 5644fab990fc72406dddc91cbb8304659d77f3f1
[06/10] xfs: check xfarray iteration errors when committing unlinked inode lists
        commit: 2daf3ed5d059dec79c123aec42eb8d28e0c016d4
[07/10] xfs: fix allocated inodes that show up in the unlinked list
        commit: 68ab37650ce5195b4f4f8466444a36a78207840c
[08/10] xfs: fix another iunlink infinite loop bug in online fsck
        commit: 6d67c6b99f1fc07c64b97fcbc974c6f1ada7f622
[09/10] xfs: set the prev pointer when reinserting an inode on the unlinked list
        commit: af146cb7ff8ff5c54162f35c238f3ff1d5ad110f
[10/10] xfs: don't ignore runtime errors in xrep_iunlink_reload_next
        commit: 0052633527158b49762ab427e73924e4f8d25e6c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

