Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D566EB64;
	Tue, 27 Aug 2024 18:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784337; cv=none; b=D+fciCXxvux1/xlWtq58XtPRj9J78THthCv7pM60UILDCd9QW19bygl6PalF4AjuW9iU6V3Skg5jllDilcopqcSpjZMSLeHSquZnovtUTTPoiMjRIFn7xPUTVCXmNY5/e5w5Q5If2POp9H7mcLEeLFA9yVlxj85CQ81PYpmX8sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784337; c=relaxed/simple;
	bh=0751bTLRIRfZ/PH3DyJn025BcAs9+07JJKkR40alXpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDtvSNzqZVtFDCViflKCJWjWVA1m/U4y+yKnbzhlU4yyiJH5V7CSxV86IrK/aEDR68YSe1ZnxW/plmtEukYUPE9bOkt5fXNdfvD56zv5gfdDeDh7e3y0UVC44WGMS33M3YQIeJMOcM1PHKJBlE86cRgfitsa4jlpUKMyNG521LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxVp1oC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxVp1oC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB48CC4FE98;
	Tue, 27 Aug 2024 18:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784337;
	bh=0751bTLRIRfZ/PH3DyJn025BcAs9+07JJKkR40alXpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gxVp1oC/vzMXElfSSIkwn0lBgJpYR4Dc55PRH4XqaCL99v6PA8W2Ojc1+VPrrlP84
	 TPTavgqXb1DHgKzA7Zc9bKmx5d5DzvdgCUvhi0oyzTNdPkNY2GCnFO5RX6L4UR2fRQ
	 L3fMncU+zbx9nEqaQZh6fOLu6cOUY8iFB0CD52VplpCmGmLKAiMzD4clF3mCBByqlP
	 g43KnpRs7CNLYftC0GpWvCjK0kQr3X+C26JcrvTXMdG2IMOg4RvGv0HnKopkOGT5SW
	 ZBlxMKj8D1+AOIvpSOod4Q6P5C5xP8ZAmLwAaOKOeuANpiJAQgZ6nev76beqEqDGBP
	 aSrtl8xZKovFQ==
Date: Tue, 27 Aug 2024 11:45:36 -0700
Subject: [PATCHSET v31.0 5/5] fstests: xfs filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423759.2039792.1261370258750521007.stgit@frogsfrogsfrogs>
In-Reply-To: <20240827184204.GM6047@frogsfrogsfrogs>
References: <20240827184204.GM6047@frogsfrogsfrogs>
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

It would be very useful if system administrators could set properties for a
given xfs filesystem to control its behavior.  This we can do easily and
extensibly by setting ATTR_ROOT (aka "trusted") extended attributes on the root
directory.  To prevent this from becoming a weird free for all, let's add some
library and tooling support so that sysadmins simply run the xfs_property
program to administer these properties.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=filesystem-properties

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=filesystem-properties
---
Commits in this patchset:
 * xfs: functional testing for filesystem properties
---
 common/config       |    1 
 common/xfs          |   14 ++++-
 doc/group-names.txt |    1 
 tests/generic/062   |    4 +
 tests/xfs/1886      |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1886.out  |   53 ++++++++++++++++++++
 tests/xfs/1887      |  122 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1887.out  |   46 +++++++++++++++++
 tests/xfs/1888      |   66 +++++++++++++++++++++++++
 tests/xfs/1888.out  |    9 +++
 tests/xfs/1889      |   63 +++++++++++++++++++++++
 tests/xfs/1889.out  |    8 +++
 12 files changed, 522 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1886
 create mode 100644 tests/xfs/1886.out
 create mode 100755 tests/xfs/1887
 create mode 100644 tests/xfs/1887.out
 create mode 100755 tests/xfs/1888
 create mode 100644 tests/xfs/1888.out
 create mode 100755 tests/xfs/1889
 create mode 100644 tests/xfs/1889.out

