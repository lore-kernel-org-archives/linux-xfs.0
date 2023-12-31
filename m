Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA64B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgtDT0iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397F8C433C8;
	Sun, 31 Dec 2023 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051926;
	bh=caZklgeNGBzEdxzOSLjk3QdNW1AyT56CGs+aSWVf4zc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GgtDT0iZR+4I1SrfJ1C7BxNpigSNV3TNFykbvyC9jSXtHuBpq8Yc8TTrvmkMtcFnR
	 xeSXWKfz9yH17FDMIf40aeTRHVlqnrmiroN4qlrABjqKah8dj7GukeqwCuqKoG/Zga
	 i0Ht53Jeh3wPsPf4E7DiZaPr23ntJYHb6SjDec9RtME/xi2bq4I1W2qKXfpGahUJ6c
	 dZeKQgtoxuRAfahAtAEDSKohu/ARKZ0Lq1+bGsjjSuht+8tRWmziWg5CXOZUP2CSzv
	 1Qc4mhirIeT4l6R2v+P7AmeWZeh3+Ke/GL4NqUw/nLyl+n5zP+hNTG0sTxyRuakyqa
	 IdxyRP95T2qRQ==
Date: Sun, 31 Dec 2023 11:45:25 -0800
Subject: [PATCHSET v29.0 22/40] xfsprogs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997300.1796932.8121789737419955958.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

This series employs atomic extent swapping to enable safe reconstruction
of extended attribute data attached to a file.  Because xattrs do not
have any redundant information to draw off of, we can at best salvage
as much data as we can and build a new structure.

Rebuilding an extended attribute structure consists of these three
steps:

First, we walk the existing attributes to salvage as many of them as we
can, by adding them as new attributes attached to the repair tempfile.
We need to add a new xfile-based data structure to hold blobs of
arbitrary length to stage the xattr names and values.

Second, we write the salvaged attributes to a temporary file, and use
atomic extent swaps to exchange the entire attribute fork between the
two files.

Finally, we reap the old xattr blocks (which are now in the temporary
file) as carefully as we can.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-xattrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-xattrs
---
 libxfs/xfs_attr.c      |    2 +-
 libxfs/xfs_attr.h      |    2 ++
 libxfs/xfs_da_format.h |    5 +++++
 libxfs/xfs_swapext.c   |    2 +-
 libxfs/xfs_swapext.h   |    1 +
 5 files changed, 10 insertions(+), 2 deletions(-)

