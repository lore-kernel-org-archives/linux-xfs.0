Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF520F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440598; cv=none; b=VNuOG0YpyWhvMJBq8VoEQui7QO14c/r0vSDhsDthcUMeMLWwfLiphEQZlHY3rfQyKuwAcsbgAi5Zc3efmgzksXypAKpjmkTVGRnJUKM0ONUS4LzV8xNYXqZ9+H9TYvMcM7BKgQDrTyfirwjoPjOi1Ug7xRUxYsz5aSGllpOW0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440598; c=relaxed/simple;
	bh=57HospvtqtXG+MicIcdWjM2gbRpjB7GG6MBniRQrzFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqcJoSUPmEtAh8JnadF2Ko7KaiotbMb50B8qpqyLUK+VQSCv53L9hGACbnpTgNeWtH42Y2bQMZPz2MJrLf+6Ev4gAI89TtZqnXdLdiiUphghN1VUu1E3htl3NfbsU3//2jMCuzjaLnQNW9Zxu3OeiunNgnpB85DNoQrHrSTzsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqKAQEfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqKAQEfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B76BC2BD10;
	Mon,  3 Jun 2024 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440598;
	bh=57HospvtqtXG+MicIcdWjM2gbRpjB7GG6MBniRQrzFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LqKAQEfpLBDxdz1bPAW/QcVqGRdGQMpqzMJTsCcrW8c3ylHoZviPPyZXZVp9uS9/p
	 tmAy48tYNdwgBsE5JUapR3PhdU1mKAaMZVIE7VGbcM6BV6fnjNK6dargNKMf5YBFBA
	 wM38qGiLmZBvGAr4zUJTon84u7S6GROPEgHVxai3kt13GChoFuMDdCrdwuFkJNyjJi
	 aQWvJ0A2tQhjPeuF75F90RTONW5I+HxihLRt9yZDq7MxCHzD01W6+mwdH7vZ+B/QEV
	 82lwKiIS0oTPUH13fxCrXOAx2NAGV72740dH1N4EOtIJdUzftFs5W30kRbYTAesoJS
	 geaCldfek1SjA==
Date: Mon, 03 Jun 2024 11:49:57 -0700
Subject: [PATCHSET v30.5 05/10] xfs_spaceman: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042043.1449674.18402357291162524859.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

Update xfs_spaceman to handle the new health reporting code that was
merged in 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=spaceman-updates-6.9
---
Commits in this patchset:
 * xfs_spaceman: report the health of quota counts
 * xfs_spaceman: report health of inode link counts
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    8 ++++++++
 2 files changed, 11 insertions(+)

