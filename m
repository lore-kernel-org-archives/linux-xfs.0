Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9AF128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421966; cv=none; b=ZaC0rtEESPnCJVQ6ClA0j2nyG4Rtwb6ktDn3ZK8gugqNrk52lF4Z9S3b3x/6a8VknxUdwCyMyBWRvbskEvLOEH39zAJsgfl/AWxSscF4uJyEK1P89pevsjC36Vei7Z3KvDmisdDcLXYvA5SqJO7TEbl8n7CK4DSilO/dV36Op9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421966; c=relaxed/simple;
	bh=qoLU+bjU8waAGnHx2XuOkl7u/4gPw/dy5m4LpLec27A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n8Jqail4bhTkaFcsgnyBbYIa1oDurjgRMi9+Tiwrzy7wB10u9rn7RLjqlxQzo2QftYKtApAfUuHPoce84g1L/pEtVBP3xT34OvH9fj11VCBTfp+uuSx+kTtZv1GyknlQukrKmcIbyXXhU0IFZv3JspuYWXQEfokxtVR8K2TrG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUPEna+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUPEna+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D37C433F1;
	Tue, 26 Mar 2024 02:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421966;
	bh=qoLU+bjU8waAGnHx2XuOkl7u/4gPw/dy5m4LpLec27A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WUPEna+VSwu5OYl21+1c/J7IkrLRAEyr2ugusNdV9jU5Lt1U08QsxLIAer++zuF+g
	 HdRe+xIlqzfbJjoex/SkdlEdT59/ryrkGGieeZrBGnyu3ahaHUoEEngU6bnSTMtUHQ
	 KbobH14wyJ+DyRIV5v083bFVlnhEUAIUuE9lUQu+14cxQtZotM2Fp67FYEFW0JyefH
	 5bd1sjqp/+IGdmcElDvXErsX6H9pvButFS9iGJdxH5MZUe6tPZCaTtYG+xsl76H5FS
	 ZKnuTEs/Bc+Tb+a1ogly2mFGdUrgGyReeTOSeLzuhcp/gdB2UpsbxMnejV7rWYUkx7
	 UUof+p9wTUPkg==
Date: Mon, 25 Mar 2024 19:59:25 -0700
Subject: [PATCHSET v29.4 18/18] mkfs: cleanups for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142135429.2220355.9379791574025871779.stgit@frogsfrogsfrogs>
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

Clean up mkfs' open-coded symlink handling code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-6.9-cleanups
---
Commits in this patchset:
 * mkfs: use libxfs to create symlinks
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

