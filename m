Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC609199252
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971254; cv=none; b=GYe17iSrUFKZozaM1YoHBpiIaMwqxNmGEZsHr6Qn5jPl23UdwjFAgFDq/VsXCm3nbELFhJBRZRa4dX2BaXOjRy53vE4zHxig7bGBEVugG6yFFbHTiehlMycmEVcAetP/ybyXbZWUxLfZPqH9uTohwrAN3mUrfKRwc+DvqJT6o90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971254; c=relaxed/simple;
	bh=rjcjcUtOkU9OKHkjVTxpRD2EnXlU6+lL+b9He+Z9I9s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ARsQZICQJ3CfHr9RzmSF6ewsLwuHvHWslcMrn43K+DllpMiObPTisSkFdLVqyHgoql8AjaOzIfWp0hpLQcy88IrvekGWJGElVG5dvTQM66V3Xahu9rWvLLUWjTmZJ7EKQa8RU84EohFvNm6xIm+usPeeEJYBNPRfz83uv7ocu/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3gdHiLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3gdHiLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73053C4CECC;
	Mon, 18 Nov 2024 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971253;
	bh=rjcjcUtOkU9OKHkjVTxpRD2EnXlU6+lL+b9He+Z9I9s=;
	h=Date:Subject:From:To:Cc:From;
	b=k3gdHiLB+8Hf3XqrGvwnyn6hpUeBs9oeHVdspiU5S4LcjH6fNWWwTiX3OPTz99bRy
	 18OpDGWxfF5UYN15UVYYP99FYMhBGNP50hsrgVWGWowZylj3ZNS2F1lkQbRCpxOQuX
	 EMkIFYW6OvYSCk2A6YyJaa92IvrSbgxfPj6gxeWnEHFUrD5hVLig37lLORJQXnjyJW
	 ytYKgFPCvYFSi3cmyC6gqPZHuwETvcvspZRH7/RBIBpaKrMVFcR6Z+QFev42oz8/Lt
	 3YxNYXQju9vqbrAgvBv8/l3s4Cm5AeM8POOnF0tzOtn2Jrx+eN8j8ldzhJZlp7Wx3H
	 /NX2XEhBusFaA==
Date: Mon, 18 Nov 2024 15:07:32 -0800
Subject: [PATCHSET] xfsprogs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.12-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.12-fixes
---
Commits in this patchset:
 * xfs_repair: fix crasher in pf_queuing_worker
 * xfs_repair: synthesize incore inode tree records when required
---
 repair/dino_chunks.c |   28 ++++++++++++++++++++++++++++
 repair/prefetch.c    |    2 ++
 2 files changed, 30 insertions(+)

