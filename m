Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25A0B667;
	Sun, 31 Dec 2023 19:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4Mafbqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD2AC433C7;
	Sun, 31 Dec 2023 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052707;
	bh=cdHEVPFe9q7+Qrul5s2THlm5DmsKmd7LlcMCTBwugPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J4Mafbqs9+AOJANjTcwZHaKYUppMJf/kBNuGrU1RSpqPQ/PmDBr2bFY0VL3kEiPb/
	 xA4AVCUlOS/IOHMj9oEjc4Ju6X5QAwF+5uzymNmmEXDWgeY3jGlcaAvq3MZ9pKBzRL
	 6lxOwszhE87yEaIKzc64pjAPKXQX2kS97bkDIRNcshg7gQlPlZ6obWBaH0Kxnwaaux
	 PGgtBqG257/EEzB954INVTKGVmolzNRzM0SOBGoXxcGdQuEKilwos9AjKy2LjlQ8V5
	 ctWMtUxFRRfwn2+N+ATMV33nrsx3bkAsqysetct6b/L7Q0zyZejWBB5vItkEqgcqV0
	 f/TQto3BVRMbg==
Date: Sun, 31 Dec 2023 11:58:27 -0800
Subject: [PATCHSET v29.0 6/8] fstests: test systemd background services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405027211.1823970.7781854324106857081.stgit@frogsfrogsfrogs>
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

Add a couple of new tests to check that the systemd services for
xfs_scrub are at least minimally functional.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-improvements
---
 common/rc          |   22 ++++++++
 tests/xfs/1863     |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1863.out |    6 ++
 3 files changed, 164 insertions(+)
 create mode 100755 tests/xfs/1863
 create mode 100644 tests/xfs/1863.out

