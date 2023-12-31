Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E1AB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zl4L/zSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A8C433C7;
	Sun, 31 Dec 2023 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051175;
	bh=PGPVJQTHQtyyjgmH9bTkE3lrIoKm2Y/jaE19SaBN7RU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zl4L/zSEmI+S5QnZM1kNagWmgFRLKF/6+aBDaiIQZYKni4D2N5YRPg4X8fFygoZS5
	 VChTGDsoKcvl68rYEgnmam+S2iGr6JzpxTkmRGx+i8Xu5P2nb5O9LRkhXh6nPEqzKb
	 J3UE5rWtMMUWzMTXHwVvpCqh7wHqovTFZO+oLQnxHjv/2tT6RwvD9TJnvO3kRMcPsV
	 85D4HbMZ5uDaHoP1D27IsQ7uVTLjYS6NSFAbf6VhuOUddM4GeJaQ65Kmz+T06K5cqy
	 koJYbo8hixvrbgluhlmFZZzqUvqLtcovFUsZLljlNgQaECsESuszQJD9O5153HIOVH
	 qE2tG9y/Ay1hg==
Date: Sun, 31 Dec 2023 11:32:55 -0800
Subject: [PATCHSET v13.0 1/7] xfs: design documentation for online fsck,
 part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404839471.1756140.4033459504904771587.stgit@frogsfrogsfrogs>
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

This series updates the design documentation for online fsck to reflect
the final design of the parent pointers feature as well as the
implementation of online fsck for the new metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=online-fsck-design
---
 .../filesystems/xfs-online-fsck-design.rst         |  349 +++++++++++++++-----
 1 file changed, 260 insertions(+), 89 deletions(-)

