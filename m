Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590FBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXU+GhJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72A5C433C8;
	Sun, 31 Dec 2023 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053004;
	bh=sQW7I7Tfu3DhEPvdZe9dUGpzAZ2d6XCIriK0F4OTicw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DXU+GhJ4l2yajOtf4BYZZQ1G5X1CVb5odsfDQzWtHgDVV1t97dW38Is7yWEXJjB2p
	 nbxt2fdcs/MeklOgBw9RiSGRUAhX65YfRnjTdgc14jACr3drhyHKBjpBEyjM+sMx+s
	 OcUWVjsuODAyo/fXUtqbTtYRnGIZ+jwItWPMAAYN3ORe9KeZDNtLuVDIBDPUuxGMN1
	 9s5eWvNTEHHk4OGYvnY8aaUK8e1EEuJ35IAjaxOFH0ZBi6tsVlKGi/yq3csydTzUul
	 tz2SOx0Q26KXbXVu1cv/w/fA4i9YUROgo6GnxOnrisj/2ecDdLHvy59wyA7YSQFaWI
	 df+eURBcPv6mA==
Date: Sun, 31 Dec 2023 12:03:24 -0800
Subject: [PATCHSET v13.0 2/2] xfs-documentation: document parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036539.1829491.7832722721100300824.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

This patch documents the parent pointers tree feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs
---
 .../allocation_groups.asciidoc                     |    4 +
 .../extended_attributes.asciidoc                   |   94 ++++++++++++++++++++
 2 files changed, 98 insertions(+)

