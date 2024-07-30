Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BBC33E8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307516; cv=none; b=LBkmQub/6RXOkjpgsxG2dv1vxBPtAHWVDGCCKUw8LFs9TcdvLtI+2cJr4wOMTeD8txotHeqhqrMJTunkNj0ARjr4nYne2I6GoQGcP/VmA1SGhYxKW2OM22CJDmbC+zJOvoWRZVjeeg7IaZClwRDru9pz3/qMVYX/NXyqV5TcI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307516; c=relaxed/simple;
	bh=pfO75AwBlHiit0FmmTiKn+JUQo3zU/it/zQ51MR73fE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=iE3ILazuQdKdULuexUoiT8EKWYsrqqAxNz4LkwRYN+8jqqquwMaTNjjHZTBxId8JCcyiHAQ9U96eDigUjVzNaDf0qo36soKlit7rd9qw/vAYFPMizOnXMzj+Kfb3kdRLhXRRMDZpD4f9MoLLT5bXpmeVk6Qb5DJRURG/QSxtfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/VLWY3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/VLWY3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C38C32786;
	Tue, 30 Jul 2024 02:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307516;
	bh=pfO75AwBlHiit0FmmTiKn+JUQo3zU/it/zQ51MR73fE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a/VLWY3ftJKpdQID07BUuiPKRxVnrGrRBIktoWGsB2huVsspeGsMONvCFVoBAa12P
	 fiBaU57QLR1qNfvFV2m4uyFPrAYBAOyBEPMflkrBbGnznOuGGKn4wCtSfwEskTNfHq
	 XGPcjhltv/TMs0vRHZ2k0pn9nriZxkzkW1VsORR9F4lfdTL6JhiOL0vRfE+3jm1v2r
	 +6AaXkhKuJSOi+ZezO/CABHLC13hHYgU2rxW3R2YF1hfnOmydlhEiWg5F5qP0CdFtg
	 6qSIAT4jK3ZYlwjGyhk1aLxpHOEmlsUA5xi+w0B8S4sHF0y5aSEeCbU7/cpv6je7RZ
	 1WHM3VS1vK4dQ==
Date: Mon, 29 Jul 2024 19:45:15 -0700
Subject: [GIT PULL 19/23] xfsprogs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459716.1455085.11463372520280928902.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit b2677fa4f4009abf8de4c15960a2e97dd5370d41:

mkfs: enable formatting with parent pointers (2024-07-29 17:01:12 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-pptrs-6.10_2024-07-29

for you to fetch changes up to 4b327cc2f5d03b772dd6d3352cbe28452cd41ef0:

man2: update ioctl_xfs_scrub_metadata.2 for parent pointers (2024-07-29 17:01:12 -0700)

----------------------------------------------------------------
xfsprogs: scrubbing for parent pointers [v13.8 19/28]

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: create a blob array data structure
man2: update ioctl_xfs_scrub_metadata.2 for parent pointers

libxfs/Makefile                     |   2 +
libxfs/xfblob.c                     | 147 ++++++++++++++++++++++++++++++++++++
libxfs/xfblob.h                     |  24 ++++++
libxfs/xfile.c                      |  11 +++
libxfs/xfile.h                      |   1 +
man/man2/ioctl_xfs_scrub_metadata.2 |  20 ++++-
6 files changed, 201 insertions(+), 4 deletions(-)
create mode 100644 libxfs/xfblob.c
create mode 100644 libxfs/xfblob.h

