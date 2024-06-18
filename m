Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C34C8F;
	Tue, 18 Jun 2024 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671997; cv=none; b=L8gYsWeHLPuQz3cX6q9lsFfNzEtPR/xu3lDX6k5rzCm6nNh/ySePIDuWH2c69Yd9hGEEtJc0rW3nreG7X/Zp8w1CvbSqOx8I5kidTDzUhzneyNDsfpzTwnb08Z5sKhdqamjkbhVPhPkO2ISb4aZb0OJTm64b40tbXQ+eW2dA60Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671997; c=relaxed/simple;
	bh=b57VUNRoeDJyWhSqyJ9kLR1dE7J/DKI92hDKx876Jbo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cFdqmBDR5XO73TdjaDveB2wjt/ONv9S5ozTp2TkahGiNZLqbXyDGvmtUIGxLDUrB77SlsQLaoYE04YXFtV8o2znityPgzVa9p2BluSedbSMq54rDuBnR0dsHgvncor8svC5E8sJLngEXfI9ACkcinw83Nnb02jBYB+7VzBx61lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LX+tCJ6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LX+tCJ6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3470C4AF1D;
	Tue, 18 Jun 2024 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671996;
	bh=b57VUNRoeDJyWhSqyJ9kLR1dE7J/DKI92hDKx876Jbo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LX+tCJ6MdO8JT5MWNBvdJkqZpffytnVfCoEk/vBOwD+FU7fqM7hsvenhmg5y8R/WU
	 4d8oLwVnI3OzfYtpRKGGXW4xYlKdfnMpYOgfahnrdaX5d6gyldGj/4BRtvutbKq63t
	 GRaxiO3T22ot6+gJ1YQj6wq2+c89/drHszIb87dhY5+3zQS9pJZG6qtejOj9fZ2eUs
	 yaxDaIKNFRECRSJi5h+riQ6F//oLxCd8qgRjLT+Y4xlFJ3N04842IUqK8w3Yn6iTjK
	 8F2JiKTfiZM5D6vdFVyLleTkD4i5Lg4Ev8fJFUYkmFqM/999PJ0eaThdaZUKi27yBm
	 UmFzGn5w38YpQ==
Date: Mon, 17 Jun 2024 17:53:16 -0700
Subject: [PATCH 1/2] xfs/348: partially revert dbcc549317 ("xfs/348: golden
 output is not correct")
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171867147055.794588.9928537254200607808.stgit@frogsfrogsfrogs>
In-Reply-To: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs>
References: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

In kernel commit 1eb70f54c445f ("xfs: validate inode fork size against
fork format"), we incorrectly started flagging as corrupt symlinks with
short targets that would fit in the inode core but are remote.  The
kernel has historically written out symlinks this way and read them back
in, so we're fixing that.

The 1eb70 change came with change dbcc to fstests to adjust the golden
output; since we're adjusting the kernel back to old behavior, we need
to adjust the test too.

Fixes: dbcc549317 ("xfs/348: golden output is not correct")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/348.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/348.out b/tests/xfs/348.out
index 9130f42af7..591b1a77a6 100644
--- a/tests/xfs/348.out
+++ b/tests/xfs/348.out
@@ -240,7 +240,7 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 stat: cannot statx 'SCRATCH_MNT/test/DIR': Structure needs cleaning
-stat: cannot statx 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
 stat: cannot statx 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
 stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
 stat: cannot statx 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning

