Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7384D3F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391766; cv=none; b=AeQA2W3VB7WafZmY+CpOzTUznWWFPKhoSkq8TOn51qfqAHIl67DblWyKBh82zlnllgeJ88QVyTxZV6GXd0Op7R+oyVFH8hWB9kyauPKKTGev6j4xctPtpieyeztBcabMDgjl60WfzrJgh+kRbp43j5FxKx5+iusdEcO5YHxKNXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391766; c=relaxed/simple;
	bh=XT2qYlCPbd5270/xfKjNIdilSHusJd4UTJwTGFL0M1c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=ddQwpLqlm3yF6/QV91L3rkifU5b7dZ2X6YWNekNjrTLACBTr/qZcKygt9BvcMzXn3yZII6K2eISpRLcgIz+gIesrGgMYJCwTry85iDPjU3IBomaJXX1EB4HpqvRSeZLrDNRS6beMl4vs3y4LX5r102Rd4yGF17SNXfnK/yLnL64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=br4Xi0NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="br4Xi0NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A3C072AA;
	Wed, 17 Apr 2024 22:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391765;
	bh=XT2qYlCPbd5270/xfKjNIdilSHusJd4UTJwTGFL0M1c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=br4Xi0NLDjlg+c9Mj8NuemyVIni4hJCTMlmxRuQKEev4CC7txUgTKoUr4rrmbt3o2
	 vswDGtk9MigR8VQlCEbkTEGEE/NlGN9WsPSV8KyDiWNYNlT5EYltzMdUGvZ8S50mJ3
	 rHcvjTqSSeVOqGb877X1NGib/2pfhT7opMfs77COif6xBR3Ujni82opxUPksNIfs0b
	 GZSWs2ZQoV18o1a39veXjAWa8zHc5UQjB7wrBPumeBVFLsjJnB1JbIcHWcxtbJfMFl
	 T5IJ+44M4PeWE/2lty0fjzYL+OTqBRY8IXHI9tU4IIh+hsHgjBw/GFdxzv5hQmyJbp
	 zTE+XrEthYd8g==
Date: Wed, 17 Apr 2024 15:09:25 -0700
Subject: [GIT PULL 08/11] mkfs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339161075.1911630.9987481844220519797.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 53bf0604e104bc053778495faef94b3570582aac:

mkfs: use a sensible log sector size default (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-scale-geo-on-ssds-6.8_2024-04-17

for you to fetch changes up to c02a18733fc0a0e1b607f75e90962b3adc27c8fa:

mkfs: allow sizing internal logs for concurrency (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
mkfs: scale shards on ssds [08/20]

For a long time, the maintainers have had a gut feeling that we could
optimize performance of XFS filesystems on non-mechanical storage by
scaling the number of allocation groups to be a multiple of the CPU
count.

With modern ~2022 hardware, it is common for systems to have more than
four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
The default mkfs geometry still defaults to 4 AGs regardless of core
count, which was settled on in the age of spinning rust.

This patchset adds a different computation for AG count and log size
that is based entirely on a desired level of concurrency.  If we detect
storage that is non-rotational (or the sysadmin provides a CLI option),
then we will try to match the AG count to the CPU count to minimize AGF
contention and make the log large enough to minimize grant head
contention.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
mkfs: allow sizing allocation groups for concurrency
mkfs: allow sizing internal logs for concurrency

man/man8/mkfs.xfs.8.in |  46 +++++++++
mkfs/xfs_mkfs.c        | 251 +++++++++++++++++++++++++++++++++++++++++++++++--
2 files changed, 291 insertions(+), 6 deletions(-)

