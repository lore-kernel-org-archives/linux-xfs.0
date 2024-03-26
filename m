Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3312838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421747; cv=none; b=gCtK2daVAMSQB5JsGvnheArdDpSZAktfNGABvOsOR54B2/vJTvDi4reZZfGHWxAGMh1kr+1uCp6Ped3HpgBZxFf4mibtajrSKUradUX7KXX3XpFHVkDe7P+VGbv/al8PyHVZjm7jeG96Bef9OdhWlfroA8/VCVA25Lg+mHypZDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421747; c=relaxed/simple;
	bh=PRK+J9qRM1lYW3DExCkn9loP/25oxXm6mWhiNO5szUU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHFbI6dm+Lk4gBmwDc2duYPwUvkm9n+PvDZXdqAr0+rmOrglOV33x8dts7N4/tYpD177wysNuRwI5cDAp4nKrXJtnjsEtEy5rQfWNmG1KgBlF2TEjff048Y8bP8s9oEwO/9HnjvajO+Ij9pW+7TQdnnpXbNhr3NkndZMBirpO2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JD/XoD+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JD/XoD+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C1C433C7;
	Tue, 26 Mar 2024 02:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421746;
	bh=PRK+J9qRM1lYW3DExCkn9loP/25oxXm6mWhiNO5szUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JD/XoD+iGg9kXLXACjcGuRhgQc+QLMa9/1C7I15GYxHwycDeJeCSCbB8ARSRLIfKz
	 NmuBREe6x7ZdK7DUPKoIFilISgCdzmtFwYCcKstvUZkGkEt1AzTJTtu4OC8NU6FXrn
	 YL6YYtRRrQGtXyzq+My++E/f74cgkb2HblQ0WmDcrrOnt/S8JkoW91UvbubGdvXNZY
	 XXXkvD0Or2l0SyFZv9BvxwbHQXgI9exOHp28OwQHolaKzsS5FCmZpjdM/TayJhtzJl
	 KuGd+eogyQjOb4Sh4/Z2tPLCQ20Am/IaELUZHvkyB8IsrTNmZ3YlMdkVRxOslK+BH7
	 OkTmy1sO2gVwQ==
Date: Mon, 25 Mar 2024 19:55:46 -0700
Subject: [PATCHSET 04/18] xfsprogs: bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for xfsprogs for 6.8.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes
---
Commits in this patchset:
 * xfs_repair: double-check with shortform attr verifiers
 * xfs_db: fix alignment checks in getbitval
 * xfs_scrub: fix threadcount estimates for phase 6
 * xfs_scrub: don't fail while reporting media scan errors
 * xfs_io: add linux madvise advice codes
---
 db/bit.c             |    9 +++---
 io/madvise.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/attr_repair.c |   17 +++++++++++
 scrub/phase6.c       |   30 ++++++++++++++-----
 4 files changed, 119 insertions(+), 14 deletions(-)

