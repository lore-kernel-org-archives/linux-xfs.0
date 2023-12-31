Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524EBA22;
	Sun, 31 Dec 2023 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gu+SXD07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138B3C433C8;
	Sun, 31 Dec 2023 19:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052739;
	bh=1aZih+tu4snrRSLWZw7eq2jsapi67/sOFJn9Zp3vjSE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gu+SXD074Rh7yzDlCimOhjX6waWDghl1K6he8fLeojkTLDK5diEARbcFjzKfiyBOi
	 813fS23M1wYrb7SAE7DS3fjdW3GusIrRsGjEu6R2BHX/9eGu/uPIWiuKGRsAqOtQ2Q
	 TjNeOSxdkNXBkJtbfjU5pcnhnAaT7ytrRUpyH1xAByKqsNQpbnesXcqHlv3esefSCH
	 imANRwyHu5h3wK/QWdjE+m2UMv41wpPL4vyHsmSeRimYuSmh97zkRD1kCicKS0g6XZ
	 X64M6shTHiByU2/I4VOEyNNhsDQzRyuicU+XAVXF2F2DSF/LGY3dZeRACDKcLaLD2o
	 BH+azpQY4Q/2w==
Date: Sun, 31 Dec 2023 11:58:58 -0800
Subject: [PATCHSET 8/8] fstests: test upgrading older features
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405027821.1824126.5951508817499207936.stgit@frogsfrogsfrogs>
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

Here is a general regression test to make sure that we can invoke the
xfs_repair feature to add new features to V5 filesystems without errors.
There are already targeted functionality tests for inobtcount and
bigtime; this new one exists as a general upgrade exerciser.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-older-features
---
 tests/xfs/1856     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1856.out |    2 
 2 files changed, 249 insertions(+)
 create mode 100755 tests/xfs/1856
 create mode 100644 tests/xfs/1856.out

