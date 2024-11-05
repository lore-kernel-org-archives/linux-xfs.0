Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E29F21219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844358; cv=none; b=MqE6X9U7v/8F3Kc8n5Er32fK8HlhN4AD5AmrDjQLk3cQOlzKU1OP5GQx+YUXt5ZFW04TFoqcVcJdYHY7LIAKscdsw+6Mjmc8Hfl4g8jSo+qUSIXf2emLm6CrKmhh/tf/YlIHOZ5e4jChUhmLkakzwFYpdwonVAXdc9W6CN5hGPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844358; c=relaxed/simple;
	bh=HiX2EMdw2rhaojIu/oJlR58n24PplqS3Rm5pPU1fNiQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ixz/AY8GQTwzdBq6yTezNU8iFw6pKqLmkQLoFqk+xDe12ukEnktueeu5oh5EwcAAqM2fCpcDxU6mqrAX6SwIW/TcHoIBuWg7rX0TciNq7CDesIvz4jybN6K9B5JNrrqUX7/7F79LlDUoPY0vBW35kuB6U3A5/fpQSCbgpTGl1lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huxv1HLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huxv1HLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E0DC4CECF;
	Tue,  5 Nov 2024 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844358;
	bh=HiX2EMdw2rhaojIu/oJlR58n24PplqS3Rm5pPU1fNiQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=huxv1HLsSfx6hQlx7T/bYCDepabb8Rh1xi/zpvCGv+Ft16pXDwx2ZfIbtDLmxQaKt
	 h2dORPho7nMdrKeYghs6yGBnIlKD2yNKChtlV2J06VS/QhcjeJl8qwVgCENB3VOhkc
	 Y9TcO84TLqcLtL8vYZV6WzocYWajMYnc72nmIvM63ntnEaBdOACdkrsuGruZYgBp/M
	 fK8H15uVPM3hrvK40Yrbf5GHwLFu9JqFLbvojIog0qV7ksU9UuS9vbLXRnbbiEu2hk
	 mfoQsNcADhh3VtNAhnBYqgIJDTfxzCSre7s0O6D3Ez1jpqeDmsnpVFNMD6bJn3TD8l
	 8iFOVSpBOIFvg==
Date: Tue, 05 Nov 2024 14:05:57 -0800
Subject: [PATCHSET v5.5 08/10] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas-6.13
---
Commits in this patchset:
 * xfs: fix chown with rt quota
 * xfs: advertise realtime quota support in the xqm stat files
 * xfs: report realtime block quota limits on realtime directories
 * xfs: create quota preallocation watermarks for realtime quota
 * xfs: reserve quota for realtime files correctly
 * xfs: enable realtime quota again
---
 fs/xfs/xfs_dquot.c       |   37 +++++++++++++-----------
 fs/xfs/xfs_dquot.h       |   18 +++++++++---
 fs/xfs/xfs_iomap.c       |   37 +++++++++++++++++++-----
 fs/xfs/xfs_qm.c          |   72 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_qm_bhv.c      |   18 ++++++++----
 fs/xfs/xfs_quota.h       |   12 ++++----
 fs/xfs/xfs_rtalloc.c     |    4 ++-
 fs/xfs/xfs_stats.c       |    7 +++-
 fs/xfs/xfs_super.c       |   11 +++----
 fs/xfs/xfs_trans.c       |   31 +++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   11 +++++++
 11 files changed, 182 insertions(+), 76 deletions(-)

