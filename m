Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331C1B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531573; cv=none; b=HNkAZKB+yGw4egFTJHxkzIzSBtg5dkZ9Nlr+mJflmKRaJnsfFOxpSEqyKVoCxICMztFwSs25RNs7C240inYx9j3evlCpmrCBB8VF7rMuIfKv2hcIO8OENnC5sKW7eUPzEHyf5AncOD+B+LXDzeNCvKeUYKt9/flZAh43vDHKnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531573; c=relaxed/simple;
	bh=n5VL95sZiyi8lkh/EhcpxpwDb/d8hdWb/tBwWZax1Jk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyVaSDmpkJbQgRRv8MofEJ+3rMWwNgvC0hcI8nRML+MRsNgESth4aFhyFO+W8SCsezsLyvlDpvqxPadE7ODMuETvz4pPwMNVG0+lDW+Paa0HanWLH0QTuRSh/cKYhl2WJMV5ZblHyycjeZvR23nehTjFeHS4xUsjUrplfWxFLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiiNhEn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiiNhEn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0837FC4CEE3;
	Thu, 24 Apr 2025 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531573;
	bh=n5VL95sZiyi8lkh/EhcpxpwDb/d8hdWb/tBwWZax1Jk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZiiNhEn9xJVdwpn9rddchf4/wZbWpr1yTvrpL5IlEu6RLNzDtMzVuIoKsj7oJqgkY
	 9HpGKprzfukxcUl58ZQBph69IH8eQ+1wkjBG/HNnls/z+7EnNoBxCN4GY89bDtYFmc
	 68aQ7ol+kBZjynssnM/AT4UPOiU8GnS+iDbEppQPd0iZP3M/swICHNsbkDPjoZh/V9
	 JNtY++aoDaf6m1Wv7D1kG9MnQpjP88oini5a1mGgkh08oQQ1COzKpZsRimi2eSSK5F
	 LMQ4iawCGhyvG3/OWDC/nJvdUfVNsZ+/A6NyPsV1HQ12DvxQtzw5N/+TKpWzjzBhX/
	 HfKUpT5eQCxAg==
Date: Thu, 24 Apr 2025 14:52:52 -0700
Subject: [PATCH 1/5] man: fix missing cachestat manpage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, ritesh.list@gmail.com, linux-xfs@vger.kernel.org
Message-ID: <174553149338.1175632.2723141122621347164.stgit@frogsfrogsfrogs>
In-Reply-To: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix missing cachestat documentation so that xfs/293 doesn't fail.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_io.8 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index df508054b01cae..726e25af272242 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1101,6 +1101,9 @@ .SH FILE I/O COMMANDS
 Do not print timing information at all.
 .PD
 .RE
+.TP
+.BI "cachestat off len
+Print page cache statistics for the given file range.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP

