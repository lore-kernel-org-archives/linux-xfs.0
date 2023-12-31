Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16DB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I61MQhvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87464C433C7;
	Sun, 31 Dec 2023 19:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051644;
	bh=9qcPGj4P4LaqlCUYWRIYa+XUznm7h9JsQQ8CN8LPRIk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I61MQhvpUwA6zUpY0zs3Egr6jO81k8z2SK23EUe6+01HJpR8k7VpydwIwI+ftBeJG
	 trHiNmpBtEIYuwuZo0Xr5Y5HMFumREt/ea3dScUkT51aaWtR4xTSZb1d3Ji2K6iT4f
	 A+KIflbd3PXwU2/4X7JsRZ3VJpr8DWPsNZ+45xeeJhZeQUcxxxM3xf1uc+b0NTNyx7
	 jVmI9SPzpFDpUj2r1597qZvf0pUQolXatay/E8tsSciiiNnkmpr5TWpZPsqQfRNMeA
	 DLWJaHUDKYFINgvXQyhFkwy4+oMqwmRG/Q3Fn2qPjGbRL8oc6Qx93ZTAKXvksALbeW
	 E+VFwlAvBxKTQ==
Date: Sun, 31 Dec 2023 11:40:44 -0800
Subject: [PATCHSET v29.0 04/40] xfs: repair inode mode by scanning dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990101.1793320.2115612026823880865.stgit@frogsfrogsfrogs>
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

One missing piece of functionality in the inode record repair code is
figuring out what to do with a file whose mode is so corrupt that we
cannot tell us the type of the file.  Originally this was done by
guessing the mode from the ondisk inode contents, but Christoph didn't
like that because it read from data fork block 0, which could be user
controlled data.

Therefore, I've replaced all that with a directory scanner that looks
for any dirents that point to the file with the garbage mode.  If so,
the ftype in the dirent will tell us exactly what mode to set on the
file.  Since users cannot directly write to the ftype field of a dirent,
this should be safe.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inode-mode

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inode-mode
---
 libxfs/xfs_da_format.h |   11 +++++++++++
 libxfs/xfs_dir2.c      |    6 ++++++
 libxfs/xfs_dir2.h      |   10 ++++++++++
 repair/phase6.c        |    4 ----
 4 files changed, 27 insertions(+), 4 deletions(-)

