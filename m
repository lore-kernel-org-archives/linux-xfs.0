Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C87146D5A;
	Mon, 16 Mar 2026 23:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703739; cv=none; b=mipK3P/NYHuVu5B1GBuy7k2IRHXnBniwbuz5My72x3BMSbHRMadekZqwCLQRUHEvEoYuokZlWUdnggv0VCBDcRFtO9p8jSgGFtcorhA+/R292IIwDZbrwT31sZaQoYrBmp/MBCr0zzdVdgaSIO8VglxckFJHVdfJmjyNRP6cPBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703739; c=relaxed/simple;
	bh=RBhTUhD6RmvH0U1qEVkkP88JB2pe7Ug7fvscAArvZR8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=guQwc7Tn2A7YylMPNiL0nVytDC68Tr+4pkLZZBG5cuJc5ua+1i3u9/tYoW+kWMW0ueJsJjmo1gaE+nXrbmvPW7OPgadrJ4RZqv2yG22EBI3jhjFCKleNmekwGVZLd5FND43KUwH1wRqbKaFBUyQadepSPDmhpqlLzV64U1tmIc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cct2t42c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cct2t42c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D5C19421;
	Mon, 16 Mar 2026 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773703738;
	bh=RBhTUhD6RmvH0U1qEVkkP88JB2pe7Ug7fvscAArvZR8=;
	h=Date:Subject:From:To:Cc:From;
	b=cct2t42cmb40Cg0+T06OmP9+ZRI0QYOT+N6gkbz7/eCnDd4Ocl1P9L81ROzcxKkDg
	 5SAb9pwD6i0a5gSfAOEpYWUaa0oC4VDGTB6syuFNmt4PB87dyIGn/cwv4nfhW7Sxro
	 W3au6LymF7SARM3Zpth1t9pDpeFgzRZUhfazm+DK5XucIPhXBAJEOOf/T5XaDU5doX
	 fwkXVlhOjJF/t6D4A83iGvaFdBm4JPWBsmFUNmv9tTxZWWYjjm1QmRrqJTagoCsZUw
	 ckeyU85H09gDogqeI8kJ9L8Sih9mVbiqI4gOAFelpJ1lBr3w1dGNXKlHU5neWVEwNH
	 D0BjntUOM8y/w==
Date: Mon, 16 Mar 2026 16:28:58 -0700
Subject: [PATCHSET] fstests: fixes for autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

These are miscellaneous bug fixes for the queued-up self healing
fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring-fixes
---
Commits in this patchset:
 * common: ignore stderr for the two new svcname helpers
 * xfs/6{59-61}: force xfs_healer to run
 * xfs/805: adjust for new autofsck fsproperty defaults
---
 common/xfs        |    4 ++--
 tests/xfs/659     |    3 +++
 tests/xfs/660     |    3 +++
 tests/xfs/661     |    4 ++++
 tests/xfs/805     |    7 +------
 tests/xfs/805.out |    1 -
 6 files changed, 13 insertions(+), 9 deletions(-)

