Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C2034D934;
	Tue, 21 Oct 2025 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071392; cv=none; b=qfUQnfWv5qYVvgGEl0TXaX1pMlMYRZW41eaog4LBXJIG79xHi/3kNO9rmuHRpFJ4VVq6YP+SQqogthfM58/gpx2bb5XYY1+cCBuz/gxILjIb13Qa+mLoy5+VZaiq68zH0SnDRi+xS8WUCYoH1AQ6Cf65ZWxgXjwhzD5fe/WjbC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071392; c=relaxed/simple;
	bh=KroobyfjGtbRw4TLZ9lehX+1ZnkPoa52KLf+N0j9s6o=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Jxx5DDp6QlFhv47s3umFdqSRjygdAO3QTvvM9XxOQmReuSiPPesOdUhuYK7Hx446wZZmhy3ciPKFBg+Y7RfFnM/V29r2UM9BMFuEGdCdcoyjH0//q4MR9f2dPEe1RcgZ4UEbpDP1eyEq467vQkVC2bMzm/vThlhdgTfj9+8Uy9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxyGIEDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxyGIEDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465D5C4CEF5;
	Tue, 21 Oct 2025 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071391;
	bh=KroobyfjGtbRw4TLZ9lehX+1ZnkPoa52KLf+N0j9s6o=;
	h=Date:Subject:From:To:Cc:From;
	b=qxyGIEDeNbqBs8yUDUNc0jBbjF1wv1TNMofc9HEQALvkvdRQOXDqxTJjWiAz1RiM8
	 6EQaggoOlSce4IGxl00JyMdVicj9350Yr82GCXuS/IfyN4lxX9/KIJAm3IgM/sSKZ9
	 tR+fyPvzAxQg5yUWTUVxB1z1+bxGeFsDDr8bNyvzfntnGxYK5MOJoaCqWq2/TiDE6j
	 Y1g4BFaY1QK39vvgx9aAGHId9ifgGvui3s/t9m9tlTBdxhP8T0SmKWTlslCDR1wG4+
	 pSjrs3qItHbn7FlUz7zXZeHqDiDMTrQlL7QC2YZ8ofN3RHvIHPpD6C+Z31uf7dp0kb
	 ojnX5CUQxOVXA==
Date: Tue, 21 Oct 2025 11:29:50 -0700
Subject: [PATCHSET] xfs: random fixes for 6.18
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: oleksandr@natalenko.name, hch@lst.de, vbabka@suse.cz,
 stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Random fixes for 6.18.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.18-fixes
---
Commits in this patchset:
 * xfs: don't set bt_nr_sectors to a negative number
 * xfs: always warn about deprecated mount options
 * xfs: loudly complain about defunct mount options
 * xfs: fix locking in xchk_nlinks_collect_dir
---
 fs/xfs/xfs_buf.h      |    1 +
 fs/xfs/scrub/nlinks.c |   34 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.c      |    2 +-
 fs/xfs/xfs_super.c    |   45 +++++++++++++++++++++++++++++++++++----------
 4 files changed, 68 insertions(+), 14 deletions(-)

