Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6201B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ah/c9ewh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A80AC433C7;
	Sun, 31 Dec 2023 19:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051832;
	bh=qEyqdIWEycEYthINiPputfW8OHdoiE/yxCT12MhhvwA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ah/c9ewhswaL+U4X5pU6nyCA5sTPMr51wKCSjofAa49VUtocZZI8MhYKhT+hqta2v
	 ms2xpnI8e/dQTkVry84oY73yLfAwG1d2ICOLKaQm7TmFzAqHFmH+ku+XVVzTk61zhU
	 qrw7DlelhZfej/Qu4pymfahreAQn6qpJ6Rb1CIiVncI4GTTFj0eJbZg9MfvOdyV5gG
	 93EDWCi16+Bw/1/P5NHuc2wAme0zwjhUakzktp6JjdalLh8XqmReRi3KcDd8jMgecB
	 nKX5RaFBk5N8f0mDLIEl5ZkwgGeUViKbtpkT7xQDAXLRhF1YgsuE1jgWlb0wFbss2a
	 eHz02Y1Bf++zw==
Date: Sun, 31 Dec 2023 11:43:52 -0800
Subject: [PATCHSET v29.0 16/40] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups
---
 libxfs/Makefile     |    1 +
 libxfs/defer_item.c |   71 ++++++++++++++++++++++++++++++++-------------------
 libxfs/defer_item.h |   13 +++++++++
 libxfs/xfs_bmap.c   |   21 ++-------------
 libxfs/xfs_bmap.h   |    7 +++--
 5 files changed, 65 insertions(+), 48 deletions(-)
 create mode 100644 libxfs/defer_item.h

