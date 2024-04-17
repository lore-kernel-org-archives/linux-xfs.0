Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83DC5811E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388593; cv=none; b=EyP12CB5f9hqcexMXvl2QQteKTjhUqeVov4ntfMjeLKyBUSj8+7Utt0C4neXRkOKdF69iSLXUncozwwB+8gb3nUFGYQlkNTQTJQ/s+orbs7/Lj4WXunHnBhvVxLTLr/t/yj3I8rPxMfj9DqWugbjFdBl/B7+JYlVmD9RqA0/UFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388593; c=relaxed/simple;
	bh=vWruoL1SRL9mgaMwGTw6Ae6BKjq5L+FMG+Av5MQ6YPQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3UQH+gFBMV7T3vmtCxX/sMjrAr54NcgTs1xWKrtOjspInGMoOUKyQqYba+NHVXKHgCVxk3mLXJOr06G+EGB1SHXlANGPz8WkhpMDsoJo22a/cdrFUCgin5Fsbq15YAaQIPHizYpA8Jh02zXnWTKxAET9KEW24VBPiEUzC1Tz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xo47elSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xo47elSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD20C3277B;
	Wed, 17 Apr 2024 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388593;
	bh=vWruoL1SRL9mgaMwGTw6Ae6BKjq5L+FMG+Av5MQ6YPQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xo47elSV9dlEhzqaBYf972rjjjNiSSPQyG35N4ELbeKP1TM+qkKcuJPUaeem3RKZv
	 ZOo/Sj4qXBzFaBkDBgwvDruCd9hhbZv4whP50hja8m9r/wRD6L7eM1HOgJL9gwJqhS
	 VmN9xsUhpPbM+FowKy7NQ6w247A/LxvhUMcysqaf0miM19dnpjWQh4qPIf602Fadbs
	 PbwCf4QNoZPBLX9gJPE50auzkz3EgjZv7PoYPiQ2jNBvQ01GR5DIxm50Xfs9zrwU+p
	 EsJ7KB+GZolOe4hwDA2A1FIwzziIXa6wPIlhkknTMEgIHbX3YkudgzUTgFo1bqtdC+
	 02pqQEvbWbn9g==
Date: Wed, 17 Apr 2024 14:16:32 -0700
Subject: [PATCHSET 05/11] xfs_repair: faster btree bulkloading
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338843644.1855656.3052850818331228701.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

Two improvements for xfs_repair: first, we adjust the btree bulk
loader's slack computation to match the kernel.  Second, we make the
bulk loader write as many records as w can per ->get_records call.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulkload-faster-6.8
---
Commits in this patchset:
 * xfs_repair: adjust btree bulkloading slack computations to match online repair
 * xfs_repair: bulk load records into new btree blocks
---
 repair/agbtree.c  |  161 ++++++++++++++++++++++++++++++-----------------------
 repair/bulkload.c |    9 ++-
 2 files changed, 95 insertions(+), 75 deletions(-)

