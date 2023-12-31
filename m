Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B76B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTBFrY14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E50C433C8;
	Sun, 31 Dec 2023 19:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052129;
	bh=8pmZkD8otgsFYe/TMoAML6ytUpdCHFgE0vDed57G6mo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JTBFrY14jMn+k6/j2kmVmCreh+hMoAKqgStXjsLChtELBXsD3VdNqmdo0zvcSNjup
	 qKuoVuy6MUMk8n87Kvesg5dQf/PKNy5tYaGflMKUZVnmW2nm88x0ymhGk0j1NgKom1
	 SpPvMzmT0Fqb5cYGfgAXrEAKZsnI8Xs/aqJQN4oIOwgB65ZFO4CISEQou4sNLgn0vp
	 usHjPOaetXOxXFBDjBEBvnLMg1QYIVj+PMfLaEot5R+mh2sV1cJWB+FyQdYVyx7Qlq
	 gQqaaSiFoysqiThXWQ41n1hFgK7apGUHyBZSgqig7fKdsyixklOQrX+3NLWb/7UACo
	 IyKidy/oW4zxw==
Date: Sun, 31 Dec 2023 11:48:49 -0800
Subject: [PATCHSET v29.0 35/40] xfs_scrub_all: fixes for systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
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

This patchset ties up some problems in the xfs_scrub_all program and
service, which are essential for finding mounted filesystems to scrub
and creating the background service instances that do the scrub.

First, we need to fix various errors in pathname escaping, because
systemd does /not/ like slashes in service names.  Then, teach
xfs_scrub_all to deal with systemd restarts causing it to think that a
scrub has finished before the service actually finishes.  Finally,
implement a signal handler so that SIGINT (console ^C) and SIGTERM
(systemd stopping the service) shut down the xfs_scrub@ services
correctly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scruball-service-fixes
---
 scrub/xfs_scrub_all.in |  157 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 125 insertions(+), 32 deletions(-)

