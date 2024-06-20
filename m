Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284F59167;
	Thu, 20 Jun 2024 21:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917251; cv=none; b=U5vXdps6v4GU/PtpoN0EupxM8MMVIl8DftM/n0IQxg+WzmWTJIzbRbpRS1akRc61q1gXDGXZvLKmBIQB+BptsjLjKGP/HXkMu8q1wFraxn5KRllRkwIKJF+ANH/Zl1CW4T/h6zIFbf6RY23GoPqXXmhdIPezY4iwDFBFRJnimXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917251; c=relaxed/simple;
	bh=unjyLAS7Nb5MKrLrElUID9FFUnFpvF45Fnb/9FgSTyc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kR5pciTXyS4pflWkYTNLyq/drCYmTMljWoc7VZQ1VeaT3VD2Gc/bN6X3/PFKe7+FuBR2tnNzneicWLVW/W0kBqLje9uk+EibaxEgFBLsr5+X3drCpxrMYc5nA4E2+e95zhjaqIK7oRRAB4T0bLCl32utGs89TTOF+N2d5duK+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQGLk+8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQGLk+8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722CC2BD10;
	Thu, 20 Jun 2024 21:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917251;
	bh=unjyLAS7Nb5MKrLrElUID9FFUnFpvF45Fnb/9FgSTyc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bQGLk+8tXc+1QB8M/wvCzpg4BpKQq71B/eyqsAoqKqxNkolBl0KgIQvghSiut6sRe
	 J+yGhNNu5uZvNtcsOIZZ/XJ3hGOABY9PXt5F+0exIjFGmNFluhh2OxKyr1yZ7nGyAF
	 EgMBryPfgfO170jpFYdo0sg8Oe0gajRmA6OIrdhCpnmvP57xPneuJw+zoIunDfl2+3
	 s3cBqL9xKLkUzPfgjElPG5CoMtQy8LVOE/h7ixV44iBogAD/0PaMlgcLfnWusExg+N
	 oH/JW1wRf6rUe5yBVMqm4fDwbvSciVpbeyflHWe7L7WqxPoTNpxOTVjGTdE0XrBogI
	 Syq8/5IwrH//Q==
Date: Thu, 20 Jun 2024 14:00:50 -0700
Subject: [PATCH 1/2] xfs/348: partially revert dbcc549317 ("xfs/348: golden
 output is not correct")
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171891670893.3035892.5306696762363556992.stgit@frogsfrogsfrogs>
In-Reply-To: <171891670876.3035892.9416209648004785171.stgit@frogsfrogsfrogs>
References: <171891670876.3035892.9416209648004785171.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

