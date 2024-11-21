Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5529A0
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147926; cv=none; b=GaJYdvC6kqCM+7DZ6YqjIhQ6uyhUXEyW1f1b+PIPxiGMCX0kX9kmoWakU/N/uMkF3IpEebpTZMXJiE4maP3hL3Ai1aYtBrPlUK/JmguAjDEzgO8UQRDVewI+fAkUpMtNSE5nX+k7nuoMyyQ0TMJNUKWgnb0L8/MsnucWO0Hqod4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147926; c=relaxed/simple;
	bh=dxF0EqoRLD/Fnqe2WMkoxC5Sb5c7kIiwtEbW8DMIk8g=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZSC2XMh08aEzp1z7kBmc0L/BIPpGhdKndVGGCZpjw29klCkxNDJEPdconsNZNMx62AF4U+gaBGMffjHXkgJoQD0BoYIbdVDWzhnE9kvPQzjcQ62mh7vY8UM+G4tD5Y/LblPMll4E1pc0kqdlzZKvQD0kChR/08TNGaavabTnQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOk/CcQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOk/CcQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A09C4CECD;
	Thu, 21 Nov 2024 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147926;
	bh=dxF0EqoRLD/Fnqe2WMkoxC5Sb5c7kIiwtEbW8DMIk8g=;
	h=Date:Subject:From:To:Cc:From;
	b=uOk/CcQfEN6klaikK3mrpQpr615XgAgcajfJnCBk+WiUNubCPurhDPcCuHSLveRMN
	 G2ELaM/dNvIXMPY1BbxO4qZTaukdFJ9PBsg1L7hLIfY0LsFnIHr9H7CNyk0mMKm4nR
	 3vmZJ8FDwx7n79LEldM5MZ4sf//xGZwb/bHujCEgNIgXzRsIkC5SWqpx2zC0hB2oCR
	 aBXD42iheNySeL5D7gjJGfjvhSxdawDmX0OciTN3Y1x2Ua6fgWeH2mcsG1410z185b
	 wqoc/JIdF5gYyVWJJU2Y2Hny71w2PhbIF3oT9mI4Kvjf/1QH5uCLmt+41lcET35AtN
	 Y1gJJXTK3M6VQ==
Date: Wed, 20 Nov 2024 16:12:05 -0800
Subject: [GIT PULL 1/2] libxfs: new code for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, chizhiling@kylinos.cn, dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173214788559.2961979.515137054202208714.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 67297671cbae3043e495312964470d31f4b9e5e7:

xfs_spaceman: add dependency on libhandle target (2024-11-06 16:58:55 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-sync-6.12_2024-11-20

for you to fetch changes up to 0cc807347d5a47d106b6196606e01297aa3a5f31:

xfs: Reduce unnecessary searches when searching for the best extents (2024-11-20 16:03:44 -0800)

----------------------------------------------------------------
libxfs: new code for 6.12 [01/17]

New code for 6.12.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Chi Zhiling (1):
xfs: Reduce unnecessary searches when searching for the best extents

libxfs/xfs_alloc.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

