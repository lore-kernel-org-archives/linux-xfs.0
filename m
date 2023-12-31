Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA8BA22;
	Sun, 31 Dec 2023 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPIY6CO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D05C433C7;
	Sun, 31 Dec 2023 19:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052723;
	bh=Pdy3J2gP4tpgXDTymcjrGD0ArEXy5+oEaMaWO6HH8qk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pPIY6CO/JOo0N5q+6VEIDgDf3NlozS/g6FtTW9O5dKbyw9WIMWE3UmVRi0gI9+Zti
	 xF23XvnsLehzuL1X6Bn6ptiboAift55McbEaBki/uIHEsMsrRYoiqqZn1gifTHQhlw
	 rqWmGX6XZsJWc/mtdMAKIvfFQKJkzYTL0EHuFwdfVYpSBF4Kw8TZ+m75foq1n3pKxO
	 RFU3bmE+6PT+G2afIv6DgDMm96gBEmh1glgpeqG7RGB+afP2ZlUECr935rzsUU6nXG
	 djddAG7xpEAhZgw1ZkNhIATLL3HKl0K6K/+y1tYYCzlsEqtytiMpLLTDXZIxPxkOn7
	 CrfLL0dfeqaSA==
Date: Sun, 31 Dec 2023 11:58:42 -0800
Subject: [PATCHSET v29.0 7/8] fstests: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405027514.1824048.6297780130013618126.stgit@frogsfrogsfrogs>
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

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram
---
 tests/xfs/004 |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

