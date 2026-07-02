Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949331355D;
	Thu,  2 Jul 2026 03:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964681; cv=none; b=eUJHnHw+3oUCKyg2zaA6YkVuAWesUaZ/O5BvSHv5iddWZeg3qJMbVwnhFNGrEBJVwfM5mQ4u8OiRbJqVU5u4nbIuwH6y8PEwJUsprsnfKDAI7hDVaKcCkzyalS+xXH2f2RcB3zUWuOobQNzApJ+W/yI111geyRWnJYq0f/0iO3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964681; c=relaxed/simple;
	bh=WhzWlFnu6IBC9eYJNClKpeNc/2A052zBvtJVlsgemYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhC305VjMiM07O3UDFRzLZYsYNJKXzqfmfAn1LTZh55zryqiBGK2XlPDRuAE0CyfcMGOrcrOLHq5pEjmMvyTakKE52ZNBGAWEMTYqX4AITZ0Q4zZ7dGZlIeDLKoUZvYsxyLJZoCXsqAcrBBwIfAY3Jyd2uolgvupRHA7VAC+B4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MheCOwVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MheCOwVz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F2FA41F000E9;
	Thu,  2 Jul 2026 03:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782964680;
	bh=36RtH3OPZV3uXCMbtG148eWFhq5Gh1ziqBmvF+CPq/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MheCOwVzIk/+VZSlHTP4j9DjUWDSlFAL/P+5RqGTKRnBzwyeDyThlQzpUX65KSf+p
	 gCODxhjvJfq1L3BlwqFR7kR7pCu54sjjmkFLUK1d5UMN5iMzX/uzzv25X0YzDkslnE
	 2ewEZ6yPaApCPbAtFA7h3Qxet3/jBLfYpeFox6PK9iAGax6bnh5L/tSgdwu5ptmU4u
	 GIJWaNo8ZQTTk/evTC58H4mC8aODr9o17jRtySeIWUCnG3Y8m1VduYabYuvoB73dOZ
	 suJjQVdaZrsr2jUfHuTMc+lfmsaU7fG82r3BzceEf9h5oaQUWb5DFxYdy/7b4szSxw
	 PW0ymCjbVMK5Q==
Date: Wed, 1 Jul 2026 20:57:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs/65[56]: don't unset SCRATCH_RTDEV here
Message-ID: <20260702035759.GB9381@frogsfrogsfrogs>
References: <20260702035523.GA9381@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702035523.GA9381@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Both of these tests claim that they have to unset SCRATCH_RTDEV to avoid
formatting failures due to the rt bitmap consuming all the space in the
"small" data device.  However, the format doesn't constrain the size of
the data device, so the justification doesn't apply.  Remove the whole
thing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/655 |    4 ----
 tests/xfs/656 |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/tests/xfs/655 b/tests/xfs/655
index a4162d70b321f9..9d09cc00053138 100755
--- a/tests/xfs/655
+++ b/tests/xfs/655
@@ -24,10 +24,6 @@ _require_scratch_nocheck
 _require_scratch_xfs_crc # can't detect minor corruption w/o crc
 _require_xfs_io_command healthmon
 
-# Disable the scratch rt device to avoid test failures relating to the rt
-# bitmap consuming all the free space in our small data device.
-unset SCRATCH_RTDEV
-
 echo "Format and mount"
 _scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
diff --git a/tests/xfs/656 b/tests/xfs/656
index df91bbdacea222..5d2d2e55c3d21c 100755
--- a/tests/xfs/656
+++ b/tests/xfs/656
@@ -40,10 +40,6 @@ filter_healer_errors() {
 		uniq
 }
 
-# Disable the scratch rt device to avoid test failures relating to the rt
-# bitmap consuming all the free space in our small data device.
-unset SCRATCH_RTDEV
-
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init no_log
