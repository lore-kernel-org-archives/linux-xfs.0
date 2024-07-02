Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C8F7462
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881406; cv=none; b=kOBpsJsLD3Vwv6VM1twJ9sUkc+6SJvfOONo3IuwYpE2PpvIed1lO3APYXgEW6A7Q8w493sycVD4UMUINoq22kh5jn+G7zo662+f+ERjAUQEseEyw9pCTKvOOxbDrgAA7at7qRZ9bpqN3S6vJJuI//obJwoaKj6koPJP/i7F+J4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881406; c=relaxed/simple;
	bh=wY42YlcPExz/z5TGKQzVesHl8Vow1ag3PtLhQYpa0hU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aS4ijGC6ypDCuA5TVmndkIVlV2bvYF1fcI+8x1HYbVTEBFFGJlpsqE+FrjKYyWWIUSzb//O/IXwcAvEfkN8Ba1bkQQybnfCBnyfKa+gRDfXY6x5TwECgYYZ9Ksoc7paZfZQWzfMfDf5m4hMEjmLNdg7jMKyBKL1f72ehnGG9gLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiUIdaYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiUIdaYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F86C116B1;
	Tue,  2 Jul 2024 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881406;
	bh=wY42YlcPExz/z5TGKQzVesHl8Vow1ag3PtLhQYpa0hU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SiUIdaYx9dEgXKGM6FsTBY1UqdE4vlF3co1PrLIK4ZWI6sex24TBRBznQa2Ttn4vf
	 KrCFyZUb7sxp6ftuClh0lzoF0h6UKZkdoyWCsTLwrHQB1KO//yBFsJIAsKACrDphIW
	 ZlArlDZCGYw2Fi2zHsTA+q0PePqH67qYcfsfVcPB0/tpQYFkVN2Wafwx4VHhzNTT90
	 hv0nnak41lbi1FUwGmekOy4Sw74YOIzSzaqkCXqlg7O5FCx+jOFQNVgVtFrRTLDVIm
	 r+dHatDv2RC3z/w/mXbTdPh0LuO0eQ13hjtLs9QYuQg7JD4gL2wD9rn1g1H8QcTit5
	 P816jnVbE9qvA==
Date: Mon, 01 Jul 2024 17:50:05 -0700
Subject: [PATCHSET v30.7 03/16] xfs_scrub: detect deceptive filename
 extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

In early 2023, malware researchers disclosed a phishing attack that was
targeted at people running Linux workstations.  The attack vector
involved the use of filenames containing what looked like a file
extension but instead contained a lookalike for the full stop (".")
and a common extension ("pdf").  Enhance xfs_scrub phase 5 to detect
these types of attacks and warn the system administrator.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-deceptive-extensions

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-detect-deceptive-extensions
---
Commits in this patchset:
 * xfs_scrub: use proper UChar string iterators
 * xfs_scrub: hoist code that removes ignorable characters
 * xfs_scrub: add a couple of omitted invisible code points
 * xfs_scrub: avoid potential UAF after freeing a duplicate name entry
 * xfs_scrub: guard against libicu returning negative buffer lengths
 * xfs_scrub: hoist non-rendering character predicate
 * xfs_scrub: store bad flags with the name entry
 * xfs_scrub: rename UNICRASH_ZERO_WIDTH to UNICRASH_INVISIBLE
 * xfs_scrub: type-coerce the UNICRASH_* flags
 * xfs_scrub: reduce size of struct name_entry
 * xfs_scrub: rename struct unicrash.normalizer
 * xfs_scrub: report deceptive file extensions
 * xfs_scrub: dump unicode points
---
 scrub/unicrash.c |  530 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 424 insertions(+), 106 deletions(-)

