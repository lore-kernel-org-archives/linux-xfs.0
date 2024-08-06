Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795FE28DD1;
	Tue,  6 Aug 2024 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968344; cv=none; b=UVgYtZUjnmD0EDzCQOMLkxz3gPhtMyikH+ZOgU35/YAnRgw3X9WBUfpNOUpdyZktaLxLY3squ+QAm/BqBi1b0WLB2tbKO9HcnWfuPtkRBbwcxKYF9ttRChvMiGJg3/dXDoPXKGtuRDLHrDAUT4KOqsvAoE5Yn5kKfEnNMPCmEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968344; c=relaxed/simple;
	bh=Hmaackh+V2CpXovY5pq6BR3v51iYHDkgzFUJ/Jl7rSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPw49D1pCexiIap70lch/pldzfktljislAfECXaf3rk+/pQKuRijVwDvYrHraor4UicK+SxYzy24d2jN+3gMxrveHKUFg5tcG3OzrtPgOZ+KjGSF9maNZf7P0cudfNNH5/JS+vOdJqjiz6ajNzRsKc6IFUuKQ32RIb5VNGf43Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iiazwn1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iiazwn1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021DBC32786;
	Tue,  6 Aug 2024 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968344;
	bh=Hmaackh+V2CpXovY5pq6BR3v51iYHDkgzFUJ/Jl7rSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Iiazwn1E5g7X8gqDP4yZueQPIdNFxXBfxpI8dU7xoCOI+KsU8MBTv4MzX/VXb+EIm
	 jKnnSrSSxIw7Wj1Q5b3583DEPuL3NgITnpIFjXq4tQC/1WtXXt9feqtdLzth4+AaCc
	 R+bughpZQvc0bM2JqHsafQYxOTwOEjmLwNJ71tERUZtvOZchMnsBgrr7soZERJ4qQY
	 hayq8YAbYbh9WvVhfcZwrPDUPbey+2vEGfPJ/FBnQweNDJ4rZs62aEIe9VSP3DUOa0
	 Ya4jlkbGkFDnPWNphQ1EyxNbpEkbQrMKdChUzneHW0nWzw/cksVxWmP1b0TD5BrCRD
	 mzysnBbXCxY1Q==
Date: Tue, 06 Aug 2024 11:19:03 -0700
Subject: [PATCHSET v30.10 3/3] debian: enable xfs_scrub_all by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825957.3193535.4840133667179783866.stgit@frogsfrogsfrogs>
In-Reply-To: <20240806181452.GE623936@frogsfrogsfrogs>
References: <20240806181452.GE623936@frogsfrogsfrogs>
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

Update our packaging to enable the background xfs_scrub timer by default.
This won't do much unless the sysadmin sets the autofsck fs property or
formats a filesystem with backref metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debian-autofsck-6.10
---
Commits in this patchset:
 * debian: enable xfs_scrub_all systemd timer services by default
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

