Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E0E15AF6
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393123; cv=none; b=eJx23McbtjEuv7FrPs2dVb8+1uhMbVfMRR17Jv73T0OXsewtyQbDzCe+OajQ6092hn4t20gS+Jgv0I+Shg5fC+4Azb68U2EYVQNFyw32nJeoKHRMNNQgX8/eYvGjJdjms1tTOsJvphsw6TxggYp6zfTPAEHZZbT8HrKPz9VErSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393123; c=relaxed/simple;
	bh=VCpKA0NS4BSdNI9FovvMfz67t/eOSIyTY7Ws4QfJQyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0nWjsf+cFoFjKZVsqyWKJcdVtZ3zgLd0lKyydUxIQK0MYDGjrcItztbaU7HPIAsTYknpMDmoUnC7TkMfdiZN+Kcs599lVWEJp2HpYA+Dj0bW1MdMHipii+zV0zpspxwgk5GnEvzeSto1/NoBjr+Jn/jsq51a5KWZUwBcggvAZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=os7cdbsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="os7cdbsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6CBC4CEEB;
	Tue,  1 Jul 2025 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393123;
	bh=VCpKA0NS4BSdNI9FovvMfz67t/eOSIyTY7Ws4QfJQyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=os7cdbsPZ+21TMp/+Dkb858BWerPQGGstadV/Qw9G0AnIm+wREfSDrI8C2FyH61l0
	 zwR0E2WMKlG9nDeS2Kbo6jqPi7KeF1o8+WP5YIYt3L694qcPvjIAtvG1i19N0dX/72
	 kLVc8jvkeexVoIi7CACG26tJ/D+YVPEfyoVMcKSrF3PCssa3DBz7nqAq2KAgSRa85j
	 0lUSSRJaScsMvDmrtP+jjheRMmzR4DXst3c0ZH3BeQ5PZTrmOAq7pshI46Y61/upIF
	 XlViiEPHFJlU0zZFxmQtFwTwSdu98iPpJM+2SFEsLFBiWoyfRSsXy4OcBslDJ4AkM4
	 RYZDYsnr8NrmA==
Date: Tue, 01 Jul 2025 11:05:22 -0700
Subject: [PATCHSET 3/3] xfs_scrub: drop EXPERIMENTAL warning
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175139304129.916487.5190678533940893960.stgit@frogsfrogsfrogs>
In-Reply-To: <20250701180311.GL10009@frogsfrogsfrogs>
References: <20250701180311.GL10009@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Drop the EXPERIMENTAL warning on xfs_scrub now that we've done so for the
kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-6.16
---
Commits in this patchset:
 * xfs_scrub: remove EXPERIMENTAL warnings
---
 man/man8/xfs_scrub.8 |    6 ------
 scrub/xfs_scrub.c    |    3 ---
 2 files changed, 9 deletions(-)

