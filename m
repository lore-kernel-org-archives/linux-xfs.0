Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA55DF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307281; cv=none; b=QKxvaaKFbcwKyE68QZmIKkHJbzD76/bih4rBAIcNHAnvmQ1v9eh7/eEVwmTpHeKycfOiD4kz7BXmr25ZICcIjM0W8CaeUD7CvTK4D1xOE55FRH6g8n2PoK6hnDzq8zf6tXQCtJnFDCsl8WE6L8JUNAxhwtrVKgzW8HOuI1id6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307281; c=relaxed/simple;
	bh=WwVgIj+CpF6oPGfeH8lETlK0yhxodXct2d8wDQXgLvU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=tWS1IZnGk5dRVnZ8ZKNOLNYlxmrYPePzg9c8o7SRIZ70rGSH0aWLr/4yUEvZN6Q6eJI1JUnJoRtTiMaLxKAO95XJfN+1tBGiFWtOJKPfvEswHEncGaTODUCsQXvUcJWtyMtaSDI4FtKaY9+kpJ0Z2YWh5S9QUzp2wsiFl3G22/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fi9PabsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fi9PabsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C29C32786;
	Tue, 30 Jul 2024 02:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307281;
	bh=WwVgIj+CpF6oPGfeH8lETlK0yhxodXct2d8wDQXgLvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fi9PabsDE02P/tSuDPCCA3kAeEamJoq3rIuku0pd8KvJMPOJJKHaDp4Jq+8yp+BJx
	 hS4F9YcO8YtB97MYt/0ECE3hWj2f3L5uJGt0WA4EUs8+fpgq3VsAfaZWtrMFKN4DUf
	 qEh5G8Wez4+Ta4jhq3dup7vMOBKXGV8VVY6GfhEh0xVnFhy3Hysz3gTyxmyd//Cf77
	 O2dC89gdwwtyPH2PX33wRd+oyM2nAeDxRslN0nTE29IUNCpiUefYVbe/dDRa4kSAQq
	 oE0eVQw0QXBHyRQKlfTQo+fW0nvA2rEP1J+Kc+1fmMbL59ePWfm3SJAF7D4Vjyoy4w
	 szFE8N4Rf5XRA==
Date: Mon, 29 Jul 2024 19:41:20 -0700
Subject: [GIT PULL 04/23] xfsprogs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458153.1455085.12133559083527891309.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 39e346ba525c51dd2f405ed5d6368db712fac586:

mkfs: add a formatting option for exchange-range (2024-07-29 17:01:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/dirattr-validate-owners-6.10_2024-07-29

for you to fetch changes up to 7e74984e652fab200bc7319d7c3d90f6ae36be2e:

xfs_{db,repair}: add an explicit owner field to xfs_da_args (2024-07-29 17:01:06 -0700)

----------------------------------------------------------------
xfsprogs: set and validate dir/attr block owners [v30.9 04/28]

There are a couple of significatn changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number, we instead change libxfs to allow callers of the dir
and xattr code the ability to set an explicit owner number to be written
into the header fields of any new blocks that are created.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs_{db,repair}: add an explicit owner field to xfs_da_args

db/namei.c      | 1 +
repair/phase6.c | 3 +++
2 files changed, 4 insertions(+)

