Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4182E145B35
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307391; cv=none; b=Tx6dYUfNvMpC6phYcM1te4bkBuNNpbZsZjWqvEXsAsIjbLxXt03ms2l0HqRCsienKcFRWucOC9+XSWebdOdW5b+TfHghJEWqljX3j1NOpuzvBml4GF1Yye7HmhlvAN4Zq03Ctqc3JQ7lKlXFfZErcyEZhPnrFa5nPRb8BL/NUOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307391; c=relaxed/simple;
	bh=b09U4kGt90aHGUPv4AKsmJ2qQwaBviUXcXmiY6DoWsg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=o82D/ZP3dPgOPIXVeQEiwZ5TrzgxZndkWG+Yo3Hjg8E+oFeeRPph0+87y6i6mgjMYSlc2qtFZ6uNcqrjt7kjDkwM26o16zSEH6S/AozeDurf2fi/dDCHiBCHdIEuGJmISLjKw//UITN3c7TPGgGx29zTLj/My0SMSWF9YUOgczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7c7NHNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7c7NHNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B225FC32786;
	Tue, 30 Jul 2024 02:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307390;
	bh=b09U4kGt90aHGUPv4AKsmJ2qQwaBviUXcXmiY6DoWsg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H7c7NHNS5Bj5bFCWEP2av2HYWgohGfrl+qiHQtatIjVAjczXRoAkOqbJ/Q3cDn81l
	 A6reGS3vCMEPV08QEBBxtN9tlpzV8Poz/fcHhmLOKcSgu5nLw2sIRxDa8Dv9QUVzsv
	 Kg0JdqATJFjTj3N7SUIwAZcoyEY5C8tOuxIE0bbMDa0wesqZgeqw73eMuMOzlFtIHt
	 0himaMzsK32v6OUrpnDKMGSN1DAi/wW10Vj3qXKIYy1b1o7rcxAVhNb0Dss2wH5I8b
	 oKy0NnsRJPnAsk/bUJrS8S3sv/SkulvVwtbks9JYcwch4km3MP6AKsnzS8/AvB9Lgc
	 0J+HcbRrnxVqQ==
Date: Mon, 29 Jul 2024 19:43:10 -0700
Subject: [GIT PULL 11/23] xfs_scrub: detect deceptive filename extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458858.1455085.1385987165268927699.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 474ff27d466c053f1cd51024e6b0c5a741a2d4bd:

xfs_scrub: try to repair space metadata before file metadata (2024-07-29 17:01:08 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-detect-deceptive-extensions-6.10_2024-07-29

for you to fetch changes up to 746ee95b71649b4ae515893ffa3bbe7b5e815d0d:

xfs_scrub: dump unicode points (2024-07-29 17:01:09 -0700)

----------------------------------------------------------------
xfs_scrub: detect deceptive filename extensions [v30.9 11/28]

In early 2023, malware researchers disclosed a phishing attack that was
targeted at people running Linux workstations.  The attack vector
involved the use of filenames containing what looked like a file
extension but instead contained a lookalike for the full stop (".")
and a common extension ("pdf").  Enhance xfs_scrub phase 5 to detect
these types of attacks and warn the system administrator.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (13):
xfs_scrub: use proper UChar string iterators
xfs_scrub: hoist code that removes ignorable characters
xfs_scrub: add a couple of omitted invisible code points
xfs_scrub: avoid potential UAF after freeing a duplicate name entry
xfs_scrub: guard against libicu returning negative buffer lengths
xfs_scrub: hoist non-rendering character predicate
xfs_scrub: store bad flags with the name entry
xfs_scrub: rename UNICRASH_ZERO_WIDTH to UNICRASH_INVISIBLE
xfs_scrub: type-coerce the UNICRASH_* flags
xfs_scrub: reduce size of struct name_entry
xfs_scrub: rename struct unicrash.normalizer
xfs_scrub: report deceptive file extensions
xfs_scrub: dump unicode points

scrub/unicrash.c | 532 ++++++++++++++++++++++++++++++++++++++++++++-----------
1 file changed, 426 insertions(+), 106 deletions(-)

