Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F43B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzpBupTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2869C433C8;
	Sun, 31 Dec 2023 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051347;
	bh=wSBSRztnqz8c1ykIZKziW0N/CA9WlaBqF+zKpPGY0i8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VzpBupTAkqADhHTdSyrKlILrY5QMTLEfPUrmZ0/Nmv1aGaYfNYMne+gyDreRNvV8e
	 N41T3/EF2XxGFlF7/zsX4s+QK38vRukaJyHnvrwyfVimP60pa0i/0RnMyIta0lQNDI
	 Vn7rx+LsG2vcAclO79yXgb3hT1msuPYPBrqi4PpOpam76lG3Qz9mP6gw6l3YyFqZu2
	 2+iajNC2HfvLtkYKzrl3z6bEYbidS0jBOCg5Pb3QycOp9mNXSxRoJlqEXy/TYyaUvk
	 86SeFdikkjMgxZv/JL/darmTJvDCEZjQY8t8am4c8RcZBp5U8lEN/nfCPXx+DCEP26
	 mIQP/kO1BSSTQ==
Date: Sun, 31 Dec 2023 11:35:47 -0800
Subject: [PATCHSET v2.0 05/15] xfs: enable FITRIM for the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846958.1763756.2429460281828066199.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

One thing that's been missing for a long time is the ability to tell
underlying storage that it can unmap the unused space on the realtime
device.  This short series exposes this functionality through FITRIM.
Callers that want ranged FITRIM should be aware that the realtime space
exists in the offset range after the data device.  However, it is
anticipated that most callers pass in offset=0 len=-1ULL and will not
notice or care.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-discard
---
 fs/xfs/xfs_discard.c |  225 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h   |   29 ++++++
 2 files changed, 248 insertions(+), 6 deletions(-)

