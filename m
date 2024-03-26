Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74955788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421778; cv=none; b=EyzFk7boPb28tqsugbfb2AKdfyjzgoRN7RzwBH4MqFa33rVgylVs99shVW3Pw+VPKFJAkpGnGSkkJ+A1RpKXeLbq4V8S86NnAcuN08SmSz+o/g/bgVHPNe++G8EwaL8wK2uMdDy9PFJfFabFUOpWpWjbFHDvUCoAYaa36sL1TgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421778; c=relaxed/simple;
	bh=qeBoLSQ9bEyhMwGza8nH5VPT3AY4tpA7At8eQtlLFIA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KnSSdRVBCnng3oMpyBK9f/CKqTldGrPWHwUCeZBihYc9rqTuvgJRBA4GmhnfvR6UVLCbc0ui2+jyrEAbd2BRscEhHNTKV+lKbxjDrduRhfzCfYJrDIXRlRc7iRCuL4IwsNaPotLj4cDKIxO2hAwPgOTvnlFGfL0CIcPpSack9oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrXDJrDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrXDJrDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F938C433C7;
	Tue, 26 Mar 2024 02:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421778;
	bh=qeBoLSQ9bEyhMwGza8nH5VPT3AY4tpA7At8eQtlLFIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LrXDJrDqPOY+aUvRbm1onc4Bh25bt/YKsUwRK5horoSRYdRggaScygJr7UsPFqIjJ
	 yitH3SN3geWEsAjRA6V88+jj7l0UD0zD/FcIx0v56gyn2ugx5DKRwICd5WewV1lzvQ
	 EEOxPralFE8Zr1nx1E3DWSIVqNsQAUCdzIVO/vmxjmDpoCNFq5XNu+CdoEa6nRNe1e
	 6AHYkksECu1dRn8hnDKlrHJx9ZqZ8O6WarbbmM6pycqBN9fLklZ/achdHJtag/3y1P
	 WUazXSmFBTjVo2g51UvoZtM3pgZpGoQeAcKP9U7sltz3GJhz3p18CHgbgag1B2Qg6d
	 bWntcMho9mVTQ==
Date: Mon, 25 Mar 2024 19:56:17 -0700
Subject: [PATCHSET 06/18] mkfs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142129320.2214436.15874795221168392835.stgit@frogsfrogsfrogs>
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

For a long time, the maintainers have had a gut feeling that we could
optimize performance of XFS filesystems on non-mechanical storage by
scaling the number of allocation groups to be a multiple of the CPU
count.

With modern ~2022 hardware, it is common for systems to have more than
four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
The default mkfs geometry still defaults to 4 AGs regardless of core
count, which was settled on in the age of spinning rust.

This patchset adds a different computation for AG count and log size
that is based entirely on a desired level of concurrency.  If we detect
storage that is non-rotational (or the sysadmin provides a CLI option),
then we will try to match the AG count to the CPU count to minimize AGF
contention and make the log large enough to minimize grant head
contention.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=mkfs-scale-geo-on-ssds
---
Commits in this patchset:
 * mkfs: allow sizing allocation groups for concurrency
 * mkfs: allow sizing internal logs for concurrency
---
 man/man8/mkfs.xfs.8.in |   46 +++++++++
 mkfs/xfs_mkfs.c        |  251 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 291 insertions(+), 6 deletions(-)

