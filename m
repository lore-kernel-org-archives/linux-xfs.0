Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B75E38FEF9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309839; cv=none; b=tyt+pOLoTMPlN6HXmbe2Z5eB/WLJ1qP5P98MpSmMWDL5M73R+M0rYA/kB3GlpypbSmtfbEOnQ1AivivRngumZAdGaGdamR07JHJQgxcgy2b29UUuDESK3np6pwYR3J+tHGTt7GfRNn6+ubLQLWuA2JyyDwEjecMusfQcWOyHV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309839; c=relaxed/simple;
	bh=MVG7tzLueMcfwQT8SbQZlzhW1sFX4HGUUowGUj7nvzg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h37ihsDPxUaaGB85YkbbWoqYRZoV+RsgaQISmHIT65Jvp6VQ6kn8bpnEftiWAWrmA4A+pV211ptKrjYSL6fVVUX6ZZkePOLM+Zusu18vSzLISrzo5AkFPzEmoP6a1AhWLctWufeMUETEmvX8Q1fbt2H0Q/xtKq3QW1NjAfXnYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zt4oVVT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zt4oVVT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC5C16AAE;
	Tue, 13 Jan 2026 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309839;
	bh=MVG7tzLueMcfwQT8SbQZlzhW1sFX4HGUUowGUj7nvzg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Zt4oVVT0tSXSL7ZOracwqV87duG/Y1W6FO4RfYdMLKhlCZuJjBxIER1Zql9EVZJR2
	 7pREkZlyEfyaBvkdMlcFTymmf73+sKPytg4peQ4jrkQXe+XoBONDVykFCcXbQ4zTM+
	 9aPe7UTfoyQJJCpcwlbMK79LiBefdiOBxZ+dIAAauuw8O3S04XeiUlNUULgiMgrrq9
	 bvXpOcRTjHqjDJ9jr13WxKz1wjeseF/+v4mlmuvyHduLpMCNy0+YPliDitq13j/SrD
	 J3uuEMTb2lfP0zSVfhs/J5Z0XPy11ONjn/RsWNFuLs5HspsWMbKQZHogE0iM0XaBgU
	 gSqYf2Jaw0C2w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260109151901.2376971-1-hch@lst.de>
References: <20260109151901.2376971-1-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: mark __xfs_rtgroup_extents static
Message-Id: <176830983825.127908.6103402667165479894.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:38 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 09 Jan 2026 16:18:53 +0100, Christoph Hellwig wrote:
> __xfs_rtgroup_extents is not used outside of xfs_rtgroup.c, so mark it
> static.  Move it and xfs_rtgroup_extents up in the file to avoid forward
> declarations.
> 
> 

Applied to for-next, thanks!

[1/2] xfs: mark __xfs_rtgroup_extents static
      commit: e0aea42a32984a6fd13410aed7afd3bd0caeb1c1
[2/2] xfs: fix an overly long line in xfs_rtgroup_calc_geometry
      commit: baed03efe223b1649320e835d7e0c03b3dde0b0c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

