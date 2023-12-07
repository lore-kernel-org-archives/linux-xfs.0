Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772981845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iW4QGqFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4149FC433C8;
	Thu,  7 Dec 2023 02:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915795;
	bh=XzhH07IelkXuVZWPLVE3SmIlZXxblDBZ37jOtwcM9eg=;
	h=Date:Subject:From:To:Cc:From;
	b=iW4QGqFKfPpbRsX8KbjP9LKLCvpMwJImk2wNML3ec6hehiD255x7Jfhy96AmJTNXh
	 GH+2SbVa0apEKK5gMPKu2e61J9V9qq3xpdXTk+tdKLkC3meDjgoIdeRsX0zQnKr2n9
	 t1bjym+EtZBkgRSFvG8Ff+Lk6x4VzxyNUBovVEPBk7x6vaePdXV/tSezC8sobeVRtv
	 aIDfkv7u8NQKi3IN1OFQiMcMhI1VEm56UJAUJJs2YvE3xiAOwBBrUrwVMyqwroUgLa
	 8DYXgSpeGjL+f0Nh6a3CPUY5wRLKoC82HOjaep18cZvU39Z53UrGjRKsrav0kkpB6A
	 p/8FJNtCj21RA==
Date: Wed, 06 Dec 2023 18:23:14 -0800
Subject: [PATCHSET 0/1] xfs: fix growfsrt failure during rt volume attach
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191563642.1133893.14966073508617867491.stgit@frogsfrogsfrogs>
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

One more series to fix a transaction reservation overrun while
trying to attach a very large rt volume to a filesystem.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-growfsrt-failures-6.8
---
 fs/xfs/xfs_rtalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

