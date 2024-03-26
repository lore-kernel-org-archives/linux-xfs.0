Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D112838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421888; cv=none; b=IKnQuOLZrYbfE2T/JDoA2Rb/yOxbWXit5elSo5KYjEm6RI0pmfbVwrmRipN2/9/QYqTCB+YEIjIun+nI6QvQsDa6yJ6juANzStKHdsit7ZUxb4ycxvSqLQca1DKZ+HBRGUwDhSFGoio0PBmmeO9YWfzWBKUkrMfsn5hewgBQmJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421888; c=relaxed/simple;
	bh=0NRCOAS3YE2Ktww4wjey9UB3vbj1teziNNCAN+45XG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kumYVWOh0wETyI6E8O4nciKHmq8mQ1oK2bwmZNw6qL9JHTEu9+bONevGPZ03JQkFuRj6osCneRUvgoGo8ry1LlFMytj3IhGx+iNB9W1irtB07MVGwVCYDz07tD4Xb/Md7XyMlK3yrKtEKCPGAZ23Cy2PCUZ+/Ui9F7tfP3gkTDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqYCnL8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqYCnL8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07601C433C7;
	Tue, 26 Mar 2024 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421888;
	bh=0NRCOAS3YE2Ktww4wjey9UB3vbj1teziNNCAN+45XG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CqYCnL8/kFBSqh6ESMGjbXv3KTLeVHGGM14LBh2ZAlhny1SjhvO1M8xEGBstlgyNU
	 L/UN6LiCn4CHpj9Rb4ur4mseclkN1j6u6lITEc0fJdUaaaBqNDhtk+iLNksNgl3Odz
	 YsgpfigEk2MnTPgv1vUuxEmK2rUdR9nXNNfJLtLd1sJbGPZs2ZazR2eAHkCs8t8Q2+
	 HuZz23K+r+yV0ImSRaLFEUEnZXHSR9QJbKvOMu0pk2W58yH/7DIY0yVvV5/SRQIBCI
	 AbGvAyV2ICaME5KmaApXHM7bzBoSdlDrHmnvW3aPYh3trSiFEi4D9NcyFDmSRkzOy2
	 14Opf+U5QzO1g==
Date: Mon, 25 Mar 2024 19:58:07 -0700
Subject: [PATCHSET v29.4 13/18] xfsprogs: widen BUI formats to support
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133662.2218014.2765506825958026665.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bmap-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-bmap-intents
---
Commits in this patchset:
 * xfs: add a realtime flag to the bmap update log redo items
---
 libxfs/defer_item.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

