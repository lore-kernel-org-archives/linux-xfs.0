Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC91FB3
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147758; cv=none; b=t2FferxU7LxKJeVdPu51JhLi/nsMssmvH3M8unZx0GV7zX3e1Qw+Fzc8fny9C+O90ctFfDo3/OsqGzXuBo+TDtAQMh8KmJ7nXkWHVlLyMlhtYALB8NSWkCT3qMBoNwJDJMBeg50WARypQCQ6laRx51TUn7sVWN2EsOlUMRPxYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147758; c=relaxed/simple;
	bh=QOprdwHxtiRl2iLJMI9EclOGQokjqUq09FKeLPDixOI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5T67ia5Dvioqphq7B2fwumJePh7kdkTEV7dyvOAzJmFdsjeq2yI9giIECPZg5xzQGpcoW8rO+BMYSTupA8wXhi8ZiqSF9kkZ37TNCxt5hSLsTvhUhM1BMXvRLWOb5qLtf4doxhAXdjme2l4R2GriIo1TNTjTO+qmrJ6FfCk8mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3A28qV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3A28qV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74132C4CECD;
	Thu, 21 Nov 2024 00:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147758;
	bh=QOprdwHxtiRl2iLJMI9EclOGQokjqUq09FKeLPDixOI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A3A28qV5CxOt5HbAX/K/arHcBVoztupDPgFgDQxV4jzXzAoQWjjadgDWhfwOCLv8e
	 8qPgzYfL8J6tkvnM7Cm/EWaUgT5xN2VFp0bv3QE0hs19ck0bEc0D/q60TmVvvfvK8N
	 i2lH4XuusIOfK9XfWdFlSScubXbshfJytx++id+Acj9JkMkkLv7on5qYX+QaSZrRKY
	 iL2f6MfLMg3Pki4dbSuk76YqQBIxO3SfUD12ByXKzZdENSNCK+bQFpaNdPVdrxizPn
	 bYg/JNCi+/2+3MZVi/GcK7kXw1OZEHGMi8fKGJXq45hF59yl5qYjP63XXUvXb/xRDd
	 WZ9xjfRZD1JNA==
Date: Wed, 20 Nov 2024 16:09:17 -0800
Subject: [PATCH 1/2] xfs_repair: fix crasher in pf_queuing_worker
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173214768846.2957531.5698670827220673337.stgit@frogsfrogsfrogs>
In-Reply-To: <173214768829.2957531.4071177223892485486.stgit@frogsfrogsfrogs>
References: <173214768829.2957531.4071177223892485486.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't walk off the end of the inode records when we're skipping inodes
for prefetching.  The skip loop doesn't make sense to me -- why we
ignore the first N inodes but don't care what number they are makes
little sense to me.  But let's fix xfs/155 to crash less, eh?

Cc: <linux-xfs@vger.kernel.org> # v2.10.0
Fixes: 2556c98bd9e6b2 ("Perform true sequential bulk read prefetching in xfs_repair Merge of master-melb:xfs-cmds:29147a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/prefetch.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index 998797e3696bac..0772ecef9d73eb 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -764,6 +764,8 @@ pf_queuing_worker(
 			irec = next_ino_rec(irec);
 			num_inos += XFS_INODES_PER_CHUNK;
 		}
+		if (!irec)
+			break;
 
 		if (args->dirs_only && cur_irec->ino_isa_dir == 0)
 			continue;

