Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1D804
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831145; cv=none; b=SJN2GGaAR264G/WNrIiykyJ6JwrrDyM5yUGBZSAV1zEewMGSnOZs0CC958dGMjjD7vRCgwD/1EgWD7WtXK4pQXFJx8bPyV4MfceJyW0rVdIUBv3me8z3x2XVE4Y8ucW13VfW5vHUAsLDRPKkQj/CDJKpn/dQL8+BDiVrXjRKgmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831145; c=relaxed/simple;
	bh=HwLdylRtbL4k68jI7JZ6hnXv4sIKjvorvVxsvoVMcVQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HevEb3ZQE4fAPqI25H4mhcdnkYzX7Q86Nnji/+Alnqecty4nrA9IximpuN7aEbZk2wrzmZuM2LRN7sZ0UkQLgsd3fzqmiLtiIBROn/22ers3WHAr3OJGaGuPMDrvrGWLrOLhZpobNlNO0wRpwVLRSCnn0RWK2WrT5SnHAPHygmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7qcs9rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7qcs9rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B899AC4CEC6;
	Wed,  2 Oct 2024 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831144;
	bh=HwLdylRtbL4k68jI7JZ6hnXv4sIKjvorvVxsvoVMcVQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n7qcs9rQrpvZjevRlXl+Rbnej9g5b+9KAahsxjsbUtJmTGl/4/K6nfK8dI4zH1Oki
	 XHaDlLbb63GjrEAI0a20rxcAUq5gLm9RZPMOKYdD1+z+z0D22/xCLxcTLEgj3/feP8
	 GTyd2R0qZHsCN4r+BkR2jACIJ33eR/RbttCHD1XCHNETbe0CeNydh6UxBM7++v9foq
	 6y+3N8NdgPbVPmD5PhDwJdoxgdFKQimiKlmOIhVeOHmwZs2P4IaErUTPx8XZ6kMlPV
	 l0YWqLtmlwIilTwbh9TBaSZnxHH+BImBU98erf2gnS0JiRomatIE/dUJd8rVPV9CJk
	 1mrEXFQJJmtJQ==
Date: Tue, 01 Oct 2024 18:05:44 -0700
Subject: [PATCHSET v2.5 6/6] mkfs: clean up inode initialization code
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103720.4038865.18392358908456498224.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
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

Just a couple of patches to clean up the realtime metadata inode
creation code in mkfs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-icreate-cleanups-6.11
---
Commits in this patchset:
 * mkfs: clean up the rtinit() function
 * mkfs: break up the rest of the rtinit() function
---
 mkfs/proto.c |  198 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 124 insertions(+), 74 deletions(-)

