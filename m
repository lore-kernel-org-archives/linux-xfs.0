Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D292D29A2;
	Wed, 19 Feb 2025 00:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925967; cv=none; b=JHPqPRKG/5h2tq1ATG+oiaH/0MrJOBj9YP6oK9fbVqDEpXex/AnOCYIN8Lb1yi5mkRfiZF1VvAL5Rw7Y4KDb6tkm8qK4p6XtYvasuDGsuc3f5a/FjEu2YnEwv5S5W1Gl1jLDeoT/q8IekTILY8lunUEDIhUT/56VgTuSNmV47S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925967; c=relaxed/simple;
	bh=8/w+NKANEqa0YtROLmaOo4ku7nAKYwN/C0rsVNTWDSg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKulyR0ep+nSdWnnL3Oz7nTsMdhtbQHXFs3af07FydvnXAVw+FZ8D1FHz47ZzlQCTLJyqeNimR+8v6hUUMIzRLo9VES0waks8qaz6uR/l9M3stlnj28LRgjPILNkk4OsJ9s9UDmVp2FxYFdzM+8C4KzKQjpT/+7X663IDX/X9UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6AR0SwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6AR0SwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47762C4CEE2;
	Wed, 19 Feb 2025 00:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739925967;
	bh=8/w+NKANEqa0YtROLmaOo4ku7nAKYwN/C0rsVNTWDSg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D6AR0SwNKuRCNIrUXWHwj9EIDIFxxuOLjvZUoZ+kqzKr6ofde5+Z2HbdRtSHNWSgw
	 eH/afVt+nTcQLSa0sp7KYLzxJgmV1CIeT9uIGtWw5J3cHHPMz0N85aDuvudNt78PLd
	 uX/VNKGbGM8dW3tQMjy4NG+04oN9pQL+QYClLAKUxLn4xOivC57n0LlAQnl7EdefBM
	 wfcokSi0vwrQUFeCa4gKhfoYer6tlQFdPigCncFGGrOge0JshR0YYUtvYn9YgVFxQL
	 VVFFMOE5oVxEGtq6JeouiuGadV7aIuSoRUEucS3s8cVNFOpX0/bsfFePIuDW1OEl3h
	 MHzkynIvAtlgA==
Date: Tue, 18 Feb 2025 16:46:06 -0800
Subject: [PATCHSET 01/12] fstests: more random fixes for v2025.02.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=more-fixes
---
Commits in this patchset:
 * dio-writeback-race: fix missing mode in O_CREAT
 * dio_writeback_race: align the directio buffer to base page size
---
 src/dio-writeback-race.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

