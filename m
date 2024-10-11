Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525DFC13D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607923; cv=none; b=FcrhnJ3FFpdxgZ2JjtMDbaYFQfETtx/0Os7GwQf0I/XuSi2KCn6UegBT6lwVKscauSGmGPYLn/SzFoQU/bl48HLgZagj8ypNBcZ4DMG3BLA1LTIlzJO+UM8oj3tp7QvgOMmkt3JpD7v1KZbEJyGwCjfMh1bJpBZKAID7II4kJcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607923; c=relaxed/simple;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g8l0MjrFZGgebRri6H1mxcsPQEAnSVKIdiSAoyD/2ZJckzeQJ6wVdbcyooiB90gEUH1P9kwBsTPEJwj2rZRHxJo1yo79jNJ7WvFiJMuR/e6EIZB4QbJKJCsPS+cpa+6dgslYujQx4f3yCNZbPtatT0glfUyUCikUnyyauD8xEhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feParT69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feParT69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F57C4CED2;
	Fri, 11 Oct 2024 00:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607922;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=feParT698lv8bZKInkALKgs26uxWBsimMcM6NZH2MzZZxeAiHocTiYitgn5Yh/8mD
	 3UUaHZ+5oKA9z9sW6SPemnD1RWC7usz54IrpfvqtQ53BNU3XCgyBev/wT6KLl5qWX5
	 e1t07ZIJPekTa8eOJFjkyFH9bc7EsnLfYoU9qCPVJJj6jzFVE2Gjnbpc9rYWhICRWA
	 VmRo5ikLvBjayNBG4WIIOKNHv6KyAKLRYv/stX+now/3Xa9/vAF93SQu9CsA/2zDT5
	 hQxn0KQVsx0z8/0bc5Vs0AlVWLkczm0u36/Pj0wJMOndpY2D+qzFDXBSidXUvaSRPU
	 kVU6/jDYpuFJA==
Date: Thu, 10 Oct 2024 17:52:02 -0700
Subject: [PATCH 14/28] xfs: mark quota inodes as metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642258.4176876.16785227194653378716.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're creating quota files at mount time, make sure to mark them as
metadir inodes if appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec983cca9adaed..b94d6f192e7258 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -824,6 +824,8 @@ xfs_qm_qino_alloc(
 			xfs_trans_cancel(tp);
 			return error;
 		}
+		if (xfs_has_metadir(mp))
+			xfs_metafile_set_iflag(tp, *ipp, metafile_type);
 	}
 
 	/*

