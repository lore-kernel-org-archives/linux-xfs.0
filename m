Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D7919CC23
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725300967; cv=none; b=IUg4pcR/p5UUvvfwHr98bMinxxWLG149/7+a47fMxA0Y+puSDP0yiBSbhezkBcaxOQUUfk+0sedS8fvBBhn5Fsxpf6Qd6kvxraFA+CAMZFLL7IVA3MFlvcI6apbrWI6AC0uH/jPwJRUPdiUY64m4SW7OIWlkBaKc9hTM1Y6Sepo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725300967; c=relaxed/simple;
	bh=yYH7pfjhh2qYHqyIVKa+s/lKJgUGmdbCnRsQ/YoeGe4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hDsI+OOhYLCdkTvNV52YPadNs65Ko/eeIPairFxSYWl9rdxJ+mA64cV2s4++ftQ7CFfkh/msKpyjwwszqpY1Tj3OgY3wv4431PN/xmPcUtYeASU1le3rrvLEGokifnhJcE42xdMp6FNG+97s694wuspsXD/+GZuyfIhJT3r8VW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZZvEzTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZZvEzTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BABBC4CEC2;
	Mon,  2 Sep 2024 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725300967;
	bh=yYH7pfjhh2qYHqyIVKa+s/lKJgUGmdbCnRsQ/YoeGe4=;
	h=Date:From:To:Cc:Subject:From;
	b=uZZvEzTFfukuDbawkIM7vw/ogXEZvNh9niOrAa0vRoOevojcDbEfsY+c6JoBsQTfq
	 QbYJizIy1/H5IRWaSfyw3EWkq1fcVfNYay5Pv5yUBbJZFP/l/DEm87DlqCCPU+VlT+
	 cjbDOyBHUXqPaUY+TRNbFS5KbpBm0hnm4iy3fktlro+lC7W6m5z/MM0zl4alKcUQwO
	 Mt9a1JSuly+iO+7bWs+o07E/rF6DG/Ac3mwkSzkOlXB5cMUMuZdpx0qDjZrnYylyG0
	 THnBlqGKmp/lwYMEYgKRYXxftKv/r/sxq/AG2ucg24CdwNN5Sn7iBF7N7t3cw2c9XH
	 SeLKCiUA2KzSA==
Date: Mon, 2 Sep 2024 11:16:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB 6.12] xfs: a ton of bugfixes and cleanups
Message-ID: <20240902181606.GX6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

6.12 is (allegedly) an LTS release, and as it's end of summer vacation
time in the northern hemisphere, the most that I'm going to get done for
this cycle is bug fixes and cleanups in preparation for metadata
directories and realtime allocation groups.

Christoph and I have finished reviewing this big batch of changes and I
think they're ready to be merged.  I'm resending the entire series so
that the patches are recorded in the list archives, and will follow it
with a pile of pull requests for actual merging.

--D

