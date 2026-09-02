Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C01155757;
	Wed,  2 Sep 2026 05:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327710; cv=none; b=NDcrs3clf7GCPVg2Jt1Mjwhc6AyllEiVs56jwbdo7/spu4xiagh9CXio9FktWWV9G+jDylSKc8N5ly5cjbD9x4Qkvvtpw03waFgtonLuCHW+2os3Cpmx8wU2McWzXsbWJ5Ac2rjQSrefJEz/C1VTkr9CYAL0X8JdedYRaixEYhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327710; c=relaxed/simple;
	bh=mSwtLAWYTecE/QF/6/L5WpTAyE3Z0s2WPmHvq2Z/UNE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=B7XkPg3Xfqhv440PekguH8xeTdEQgS/tFHYDiNB63tN2oR1GVVmK6YuR7nx/SnhIGwEy7aluFby1w90XuPmjvJtPwwEpYqsd69dUbE2LuULFW9zcxo6hMD5g48zNHw0GCE5VA1sSb/UeYoW/Y8VVzRy1b8A36f808/66QgMRka4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mX+RLmEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mX+RLmEI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 10F811F000E9;
	Wed,  2 Sep 2026 05:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327709;
	bh=ZTHzZ+UqiNSLYlQoPdoshxswa1kcKclDGu1CC+/OU5c=;
	h=Date:Subject:From:To:Cc;
	b=mX+RLmEIWQrlWOn6Tlx8jaIKJx7IMEvS8aPJvxCInTNYmw3gqQl7hVt9SMjiJ2tt3
	 9IeLSNlzygIzwiE7PuMsE4EkWxwriX2hnAojD3smUt+Y5dZ/P5mb15qfvJIY4it+t4
	 tNGp1dTzoPzRaEAdSKKrWlaW6o1q4iloi08H193xAQtTTcTRWB9YfzcQaFqJLKlP8w
	 iaxWbnl1gXz5yh+saEpBcZBY7oR/Rz0FiYwEDT0Tce7Svt6tMAD2sgJVRijc6A9dpf
	 kmZkwtO0ywf/FzpFCW+Rch8IURrCPnIrxH32F4umsKc2b6ZSfOvaodfIQo5s3PO2Uc
	 fTXsG8svC/EGQ==
Date: Tue, 01 Sep 2026 22:41:48 -0700
Subject: [PATCHSET v3 4/5] xfs: LLM-inspired bug fixes, part 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's an eighth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add rvbs, tweak commit messages, do more cleanup of healthmon lists
v3: add more rvbs, address more review comments

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-8
---
Commits in this patchset:
 * xfs: always set xfs_healthmon::first_event when inserting at front of list
 * xfs: move healthmon event merge tracepoint
 * xfs: port healthmon event list to list_head
 * xfs: merge healthmon insert/push helpers
 * xfs: check healthmon outbuffer space correctly
 * xfs: bump lost_prev_errors if we lose even the healthmon lost event
 * xfs: report nonexistent parents as a filesystem corruption
 * xfs: destroy seen inode bitmap when we fail to add a dirpath
---
 fs/xfs/scrub/trace.h          |   33 +++++++++++
 fs/xfs/xfs_healthmon.h        |    5 +-
 fs/xfs/xfs_trace.h            |    4 +
 fs/xfs/scrub/dirtree.c        |   31 ++++++++++
 fs/xfs/scrub/dirtree_repair.c |    1 
 fs/xfs/xfs_healthmon.c        |  124 +++++++++++++++++++++--------------------
 6 files changed, 131 insertions(+), 67 deletions(-)

Unreviewed patches in this series are:

[PATCHSET v3 4/5] xfs: LLM-inspired bug fixes, part 8
  [PATCH 2/8] xfs: move healthmon event merge tracepoint
  [PATCH 3/8] xfs: port healthmon event list to list_head
