Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0AE1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298651; cv=none; b=JizVBWrjMPI6ISLh4fBoj0BP+Y+XsdgqGg1d7KpV1CQjd63KWdrY9CPgNpqP0dqFqSbY1MB0/CrtGgQ2GjtLTMdw9Ik5rVk3SK+tPbBitPiR74bucFR5JV/hszLUBYVAkIGqmYA21vkVXkeoJ8THUhS2drqNDfoNJ8vntaObMUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298651; c=relaxed/simple;
	bh=h71Ou648OvJo9rnre5rjCyni3WRPq5ExdBsgyZsWk6g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nwrxzKBRESUCqUd9Xs+rcfuMdntY+L5wPVI8Ii2XZiWNtzEKXTVH7cOVYVp4syPZwbYe/x5rDp+87NLrFtulgZRgX4duptqBedAXn4gxhvMZcsJWLSiSF3KRcmwoRKDlz8OiK9xIUVasLM5ecp4BQ/VtkVM+zI1SztMKGihKWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyUwlQSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyUwlQSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E68C32786;
	Tue, 30 Jul 2024 00:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298650;
	bh=h71Ou648OvJo9rnre5rjCyni3WRPq5ExdBsgyZsWk6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TyUwlQSed/SytdSYSLhwYBwSGUVDNiSTOCcPjDZiGeFRp93Ly90B89K155NBrCuwc
	 kx9WJjHorAvKT1XFM3MD2n1k7TrQbADqQS5zuzi/FfLYYx7JQMBmosTH69IC9WHqT6
	 rY+BBLaAd1iAW9NGabvNOPJSFCAktjTRRpPxolmyHfR1n3GcfdQwKQ5RshLXRMSJAk
	 vkzYw8GnHUutusL9pjxKnTzmu20orjebwuRqsa7oZqsRp1nDmcWQ70/cf+1rTtTRNa
	 IGGbbEkRuuQCpWodLSpmHmgK9tetUA83flJ6MtV6WIjrG/YgUj5h4M4zLU3xH2OysY
	 WZkpgCjw16P4Q==
Date: Mon, 29 Jul 2024 17:17:30 -0700
Subject: [PATCHSET v30.9 04/23] xfsprogs: set and validate dir/attr block
 owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844879.1345343.7289627876555507553.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

There are a couple of significatn changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number, we instead change libxfs to allow callers of the dir
and xattr code the ability to set an explicit owner number to be written
into the header fields of any new blocks that are created.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dirattr-validate-owners-6.10
---
Commits in this patchset:
 * xfs_{db,repair}: add an explicit owner field to xfs_da_args
---
 db/namei.c      |    1 +
 repair/phase6.c |    3 +++
 2 files changed, 4 insertions(+)

