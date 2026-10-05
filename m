Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A94D8DA0;
	Mon,  5 Oct 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223601; cv=none; b=tNbZWE0GQh3mys2Mjk6cwT1wZeRKFg4RAoolq5GpQUwRp7fhnPyiWvAdMHXYXGC5yqKWVneTGTX0bL1tPpCPsb3VJyX/YxkJc0Yuvz/qxsQfQVA1HNgpLMpQJHe3Kw+Z/9H5RWJ752pnlv/PO9SfNmOQk0b8Xu1rAzDJxHJyedU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223601; c=relaxed/simple;
	bh=HawUIoCt/2l2cq7CrO/lIOU2p3ZclzzJK8AQ5HfeqMs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O9M9+Q6up/XgUPjE5aitnv/XI4e5dKqrscIZhcj+BFLS5SO6MrcX4x1rPa7W4V63HDSYd0dIgLj38JTdrUBcV9FUL1QlhoCUFqQo+LlOKd1UWCsrE7wefgEDKZC+omN9pvIH7jJ5uMMlaN5hLu5WUTgjX5H+JyLxZBz6vldanj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9E41eUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9E41eUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62491F000FF;
	Mon,  5 Oct 2026 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223599;
	bh=M6rUZ6imDcXbL2YBGjTkeHq1vjIYlkdbdNMNOerwK5o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f9E41eUt9Y5o4NWIxPgH1W7MRZl7T0MZzYQ7gwZ6MNHq+ubDDvZuTseM/xxy6Pv8Y
	 3BJnHMJRCBL8yowwSJsfhC8XvkhUl83+ikrsbZit419XO10gPFrTRWa3MSo8GEsprC
	 OtHuKqAoZjX4y8fyKAXgvb9lhd0Fm7fw7rE9NaJxg9XI32A+Lr46Vsg1k+FXvRQwCY
	 /nGxMySHsO4ps0kRFke8YSmN8xKiM8P7aZpytAVIQd1uIpqAE7vRLb4MdxwcWShadc
	 mBe7SWrRT9C2S3I2N8eU1vPs2AswsrAKvfRl+jFTwTbMEQNBLm8izQBznJfljEnEyW
	 ADZ2HUTKoAOLA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 17
Message-Id: <179122359861.102066.17226085441305185653.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 22 Sep 2026 22:57:31 -0700, Darrick J. Wong wrote:
> Here's a seventeenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: compute the correct fdblocks/frextents for repair when they're negative
        commit: f98d007017acf0eaec2e116ff9c0ece735f61bb3
[02/12] xfs: mark cow extents bad if there's no rmap mapping for them
        commit: 2ffc0619c9c2881443c5fffb10db8f2bc0aa2ce8
[03/12] xfs: clear the symlink zapped flag if inline symlink is ok
        commit: f8d0d90f2e24b1f4a14796ae63cebfd820cadfcd
[04/12] xfs: reinitialize dquot block if non-first dquot can't load
        commit: faa9aa9e846332aaad78096a2cebfeafe68a7776
[05/12] xfs: fix inode btree repair when a cluster is larger than a chunk
        commit: 65b89ac3e8c2f041384f715a71b9d113edfa32e5
[06/12] xfs: fix integer overflow problem when setting large free areas
        commit: 7e55f84434f3a63d59feb8f89076d280ea9aa8e5
[07/12] xfs: fix buffer overflow in corrupt inline attr structure
        commit: 017dd7a84ff4cd2275eb62f4ee6d63c705bac107
[08/12] xfs: actually report corrupt xattrs as XFAIL during cross-referencing
        commit: b339cc253019518c61b8b150fb7ea727fdae59f4
[09/12] xfs: improve dir block reporting when cross-referencing dirents to pptrs
        commit: 559c9d4259aa4f0a3fc251c4c9ef6aa0c2d08116
[10/12] xfs: fix unnecessary dapos truncation in xchk_dir_walk
        commit: f60a2ef8d8a7ac6dedf4d0c3325cc3fc2fe0d948
[11/12] xfs: actually lock the metafile reservation when adjusting after repair
        commit: e53c620b3670fc0c162b5f768a10a3a17d0c04f6
[12/12] xfs: avoid cross-rtgroup reaping after a repair
        commit: d7c204d4ea7ef0cf0dac908388984c2936f1f94e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

