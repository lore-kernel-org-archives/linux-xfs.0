Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4623BCFD
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758022553; cv=none; b=A5Fz/Kzi40MGWYhk4K8atzJT9+BctWnz9ws1CVctdSnwZj5ZA9d3mslMhqI0/RoCJjfJRt/P7teiVZ3z1ozh+vD7gyIp034WjFqLfUoA5hDCCsgNejGh8TjL3FO4miojG2gbVNY4J6tkD6w2qQ+WRvJn7N5PLEiMIxbpJkkAhtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758022553; c=relaxed/simple;
	bh=5eC/5oXmR3faUvzA1tJLhjCwjcy9E0TVWXD5PPsEtkg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AAa5SzOc0Izp3zGwL/M+MN9hJ+Nb7fAPhq58hDXlsBiqox+A99U6Io/HPdmLBQJ6usbwiHU9davXcK3WzJqxwXMctLUxlso0ukpIiQ9jmn7yNaJS02/nu+DrmTl57GRhvb+JoRrVcrtHfpWmCtDyZpKUve3kOK54XpBJDidqfsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRu7ViXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRu7ViXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0CBC4CEEB
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 11:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758022552;
	bh=5eC/5oXmR3faUvzA1tJLhjCwjcy9E0TVWXD5PPsEtkg=;
	h=Date:From:To:Subject:From;
	b=SRu7ViXzf3TKFu26FRoRavPU0SEkWRNAc4OWWRIMgDZwecXsyQgwgQjw7gM0oHWqH
	 faKc26h9tAdf2LA0IcmLO2mQ0YHejZCyHylT3B2HIoROwGEvACtMWLOi3vup3DTRHH
	 ckAjrtnWygzoYetV13m18fqb+7fxjJtN2NwQ17dayEcNeUoU4fpHfJpgKf1FilMje7
	 ZdCdQaKNkD1t5lc5+6EwANoUqYwkdFWWtdxF4rudcWikbKMSplaOL0gX6Tgn6WJtpG
	 yqbwfv5WcV7qbPfJMAT0iRRGXIxHcN7ho1YiruLispbL5RRQl+wF6W8CJNl6nfZ8Pa
	 YZ/pKJRcRKYqA==
Date: Tue, 16 Sep 2025 13:35:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8e2cdd8e18ff
Message-ID: <gwbvkskiujqwpmsgu737w3puxjdk7d46gjcadcubj2fg6qkp66@l3jrzeaa7p2h>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

8e2cdd8e18ff xfs: adjust the hint based zone allocation policy

21 new commits:

Bagas Sanjaya (1):
      [e3df98d30369] xfs: extend removed sysctls table

Christoph Hellwig (17):
      [eff866860788] xfs: remove the xlog_op_header_t typedef
      [05f17dcbfd5d] xfs: remove the xfs_trans_header_t typedef
      [476688c8ac60] xfs: remove the xfs_extent_t typedef
      [7eaf684bc489] xfs: remove the xfs_extent32_t typedef
      [72628b6f459e] xfs: remove the xfs_extent64_t typedef
      [655d9ec7bd9e] xfs: remove the xfs_efi_log_format_t typedef
      [68c9f8444ae9] xfs: remove the xfs_efi_log_format_32_t typedef
      [3fe5abc2bf4d] xfs: remove the xfs_efi_log_format_64_t typedef
      [0a33d5ad8a46] xfs: remove the xfs_efd_log_format_t typedef
      [a0cb349672f9] xfs: remove the unused xfs_efd_log_format_32_t typedef
      [3dde08b64c98] xfs: remove the unused xfs_efd_log_format_64_t typedef
      [1b5c7cc8f8c5] xfs: remove the unused xfs_buf_log_format_t typedef
      [ae1ef3272b31] xfs: remove the unused xfs_dq_logformat_t typedef
      [bf0013f59ccd] xfs: remove the unused xfs_qoff_logformat_t typedef
      [3e5bdfe48e1f] xfs: remove the unused xfs_log_iovec_t typedef
      [0b737f4ac1d3] xfs: rename the old_crc variable in xlog_recover_process
      [e747883c7d73] xfs: fix log CRC mismatches between i386 and other architectures

Hans Holmberg (2):
      [0301dae732a5] xfs: refactor hint based zone allocation
      [8e2cdd8e18ff] xfs: adjust the hint based zone allocation policy

Code Diffstat:

 Documentation/admin-guide/xfs.rst |  18 +++---
 fs/xfs/libxfs/xfs_log_format.h    | 113 +++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_log_recover.h   |   2 +-
 fs/xfs/libxfs/xfs_ondisk.h        |   2 +
 fs/xfs/xfs_extfree_item.c         |   4 +-
 fs/xfs/xfs_extfree_item.h         |   4 +-
 fs/xfs/xfs_log.c                  |  27 ++++-----
 fs/xfs/xfs_log_priv.h             |   4 +-
 fs/xfs/xfs_log_recover.c          |  34 +++++++----
 fs/xfs/xfs_zone_alloc.c           | 116 ++++++++++++++++++--------------------
 10 files changed, 182 insertions(+), 142 deletions(-)
