Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB162DDA8;
	Tue, 26 Nov 2024 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584283; cv=none; b=Q7jgTkEwJYzjh1VR5w/PfxCDHzLgMcH6UxDARaa17GqKU5uzW+bQylfyowqqM75IbLPbS+fOiXNrmblMiXx714EYPuNRxV9mxN4PwrDIvE72/Brfj/rZQpDD4junw1QN4QkUFd8kFCNMA6OPNElCQrpR6CuVb9roNek0k9IsLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584283; c=relaxed/simple;
	bh=2G1Nfh9p/id1mM/S/o+W/pEL7/5+lwMas6aaETT186o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MKFc+zAFou++2N0+29/4Im3dKf2w7e2S2JQ7HdlwM+cJrlw1en87uWwIDc+ETzXNKC3l8C6qmHHMyoOEDnctSvCbO0qwhiY2wY2qavA+BfxiJJbqYTgmWjvPMlzaXY8l74RYrk7Ksitt5GeKr+Z5dH/8ydq0g/vjG5kAEVLpOkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTY2qtt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTY2qtt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3CC4CECE;
	Tue, 26 Nov 2024 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584283;
	bh=2G1Nfh9p/id1mM/S/o+W/pEL7/5+lwMas6aaETT186o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZTY2qtt6xtLWlIjGcFnXNo4BgeypQ0JRZePCb/FokAUtd8W2wqEHQYN2j4VEFDUH7
	 nIGQHNRi+V593eWDZR/DZHhJfwvbCJ3Oumk4kuIdF4PjybOQtRiw/4Rfp4ywNR7U6c
	 2upnH3TJ6+hlLPOhg9g5bP8bBK5qHSBtwYPwrRDAnODp0IUBhnb+KSmeDdLThDq7ET
	 +g7W11AsO1krd5rG3Va1Hw5v0vrT1DKhOl6J05dYNh2xhJoAapvr8hqQvpKh9AFvp/
	 rbzqPrKtmWFgO6VNGsMOWN7T+sELwglt0rrqrmCOhW2G6PXMkZ7/U9cz1/C3GYnAMM
	 855zy1o64pvhw==
Date: Mon, 25 Nov 2024 17:24:43 -0800
Subject: [PATCH 16/16] xfs/122: add tests for commitrange structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395315.4031902.9082361530245352300.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE,
which was added in 6.12.  This will be the last ever addition to
xfs/122, because in 6.13 we moved the ondisk structure checks to libxfs
after which we'll be able to _notrun this test on newer codebases.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 60d8294551b1c8..4dc7d7d0a3602b 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -76,6 +76,7 @@ sizeof(struct xfs_bulk_ireq) = 64
 sizeof(struct xfs_bulkstat) = 192
 sizeof(struct xfs_bulkstat_req) = 64
 sizeof(struct xfs_clone_args) = 32
+sizeof(struct xfs_commit_range) = 88
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
 sizeof(struct xfs_da3_blkinfo) = 56

