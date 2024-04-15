Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94340156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224183; cv=none; b=KyIbHGTszhcV4pBNLAlCLTsMo6Ns8OYSuO1AmVg2rgBkz6h9dZ4gGa2rzbCJDZEZjXrIQrkhBKZuTSXltCrVyY5dVixw0g0AvmYcRn6xAiyuKsFzdLv4CtnlZo2Cay9+oHMDaYpZZQmku7FhiKiYZ+iIWmnzkP6YUf9tpWN/EeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224183; c=relaxed/simple;
	bh=y3a66VaxJ5nh9Jh2hfBaBbsGjPjs4KurKhDhtqdkqmg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rP+js+ZzgOqLaXDp+0M4tKMpdrNVOtjDtUJQKUeGBfb2KaEOuMD6UeZVswtT3tCz81likFD0jAx7z5fptGTOO6CLoxDLt1l8auVGvAZdNiifFsy8m3G5+FwzK63OAmKU65XR7paOhbWNIYK23/MpD/De5yXt/XpupQ3cCU8YFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZbKmecQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZbKmecQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA8CC113CC;
	Mon, 15 Apr 2024 23:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224183;
	bh=y3a66VaxJ5nh9Jh2hfBaBbsGjPjs4KurKhDhtqdkqmg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AZbKmecQh5alpC1QhSXaLRnADKWLjEWRrOO0t5GVJR0FrHE/SHdzwUFbQhL1syOv3
	 R7PLAst5WJMqYMwBao5tz5wBLHd+ZuU241gROsm2kYI9rVeAYHVplQpWniyOiWlGo0
	 znxHs7YVtWBPKxM0opxrFnQf3hBNbgrx7fL4RHfieacg1J496qMAbpx2ZioqtFczTE
	 IH/ZdNBxU2CZUWyrgiWCOV0Xoy/so0IqcsMiG/LOlxdNJw5PFGOH5JlEY7AxA/7vbF
	 Oew5NnB+y0sytwiISid26222m/437wwuSiY1klh73G5064wcrmYc53RHkx6At91vmJ
	 HqfmwOSSXlD1Q==
Date: Mon, 15 Apr 2024 16:36:22 -0700
Subject: [PATCHSET v30.3 11/16] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384642.89634.337913867524185398.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

The patches in this set adds the ability to repair the target buffer of
a symbolic link, using the same salvage, rebuild, and swap strategy used
everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink-6.10
---
Commits in this patchset:
 * xfs: expose xfs_bmap_local_to_extents for online repair
 * xfs: pass the owner to xfs_symlink_write_target
 * xfs: online repair of symbolic links
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    7 
 fs/xfs/libxfs/xfs_symlink_remote.h |    7 
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  506 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |   13 +
 fs/xfs/scrub/trace.h               |   46 +++
 fs/xfs/xfs_symlink.c               |    4 
 12 files changed, 609 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

