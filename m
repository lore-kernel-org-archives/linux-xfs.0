Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E392DCF6C
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693025; cv=none; b=ov5+BkPw9l9l5y+galHrpFCBKGTPzQmCshif+rEeJU4722qnPgnjIRm7eLMnCQliz1jzaq0X5mvBJNGTUpH4ZWstYYwXZDbYyXKFv7yKomPO7wIMKKO62t2KmrXgoGDVBh2I+IMwtBm/XxKYBHUqe03Jz75e0BA3rnAvKSo4XBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693025; c=relaxed/simple;
	bh=Do+rpu1798e2sVQXOdNtc99sDNE1caizKnCRShjFSQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YhSMl4xxXyu8WH1s/lxDVvD4YiOHrEv7FAUMdLgCpfUKoKdJI1m7B/u4c65GLD3RwPKw1vaqG5bQSN7ptN494Sv0XBjrn7uYzPxFY8dH+Bw2R3VFQiMtFg/C7j849X/zI7CuozvhJds229TOHAuOxKNym1vbzW0PgSqY9FGnhL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKJZT1O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKJZT1O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B259C2BCB4;
	Mon, 20 Apr 2026 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693024;
	bh=Do+rpu1798e2sVQXOdNtc99sDNE1caizKnCRShjFSQo=;
	h=From:To:Cc:Subject:Date:From;
	b=aKJZT1O+/AIuYSp9BW0ja4wYkJbiPb1ekWVU5iVDRDqcWs0sn2qPo4qg+5otu4n3M
	 ZTRYMiZ7Ll2IoS4PIyTD/ErA2ojgKBdEPppI1uc9DGgz4mNT199kYnca0sEgKFdQAD
	 EHt7zj5hDBSSOjHjEEJA/M71qLQeQ4O24gcqLGn34xHgywU3QPI6JdQQV90gbXWO84
	 dbNtUknZUtkzKa4UukgwvOemDkgJNwkdFsIbNt48VF0LJBtuC6GQcBt0lHoFBg5bfK
	 bfXSrX1+SatYZrI4DlXwUU/G+hMLa2vGzM5KZVPVdZKmfh897Lq5z9OZMblA7jmeUV
	 GZ47Tv3wdGN2Q==
From: Niklas Cassel <cassel@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 0/2] xfs: add additional zoned sysfs attributes
Date: Mon, 20 Apr 2026 15:50:12 +0200
Message-ID: <20260420135011.624587-4-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=815; i=cassel@kernel.org; h=from:subject; bh=Do+rpu1798e2sVQXOdNtc99sDNE1caizKnCRShjFSQo=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDKf6QtvTVPYt8//xMwHpd+ZTUqOxV77KXiv+/0Rtf9Hz CsSfqd3d5SwMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BeAiUowMa7oLzty/ePGAFLfr d9m1t/bMkTeVmyqe/Kjg1Sqv1j3mvxh+7At6+EPB6FJgdL1Ij5Pb1VfaX7KfTpqkZzItoKJ1Bj8 jAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello all,

This series adds:
/sys/fs/xfs/<dev>/zoned/nr_free_zones
and
/sys/fs/xfs/<dev>/zoned/zonegc_required

These values are already available in /proc/<pid>/mountstats, however,
mountstats will unconditionally print the stats for all mounted zoned XFS
filesystems.

Making the same information in /sys/fs/xfs/<dev>/zoned/ makes it easier
for monitoring tools software to read the values for a specific filesystem.


Kind regards,
Niklas

Niklas Cassel (2):
  xfs: expose the number of free zones in sysfs
  xfs: expose the current zonegc required status in sysfs

 Documentation/admin-guide/xfs.rst |  8 ++++++++
 fs/xfs/xfs_sysfs.c                | 23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+)


base-commit: 2ffc6900d5c3a7cd59becda2aa67581d9bd3858e
-- 
2.53.0

