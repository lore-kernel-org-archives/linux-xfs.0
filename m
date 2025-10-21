Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9818434D90E;
	Tue, 21 Oct 2025 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071999; cv=none; b=lRXO7XjYAqQNX5j4jvQEB0X2SAjpsBLwMX3SgL07zZoGQO9nsyrPDMjqR2hEXk+g/aosVzTvdq0KZXBVBpEIxm2NVt0/mWpy3U0RXK9pS7IRfNZ1To64WdSH5WYO7grNVU1s9gz0f/6cqRn+I298w411QGzW/m1gvNurQa7jAUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071999; c=relaxed/simple;
	bh=0BdoGRF7fp1C7lIibc/ZlcYyxrHHRVzHNRAs7UnylFg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+NOr7SpT2JvMfoBHCM7qHXyEA+KK3ZUXbfaYJ++U5I1Cgv9EPxIxKh1gdsTP+h2bATDOUS8UBXnpuYebOY3RYuPCLG6D5j5PhvC/UhtSZKjMGkyXCyN0E/3Cd5gNv+zMTgezaAzLAqoGlAyIoMXQg3QFUQbdcxdKqK5WinrqM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEjVDmVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEjVDmVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70114C4CEF1;
	Tue, 21 Oct 2025 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071999;
	bh=0BdoGRF7fp1C7lIibc/ZlcYyxrHHRVzHNRAs7UnylFg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bEjVDmVIprY7JeryCo3jiKZfWre5xd1S9PPBNXnLtjcxUCh/u4HwnTAKKlI5eG+h8
	 fe9jPyumwn+atstkRK+TyHjNbVFS1A4nvFS8TA1Qs6Gu857O5+K7p1EwtO97n+gjGF
	 tb7wI3gn+T3MuZHOss2R/PSgibbiZBvWKjFkYjdhRwvUYUxYAjpuk/ae9s5/jffgzk
	 UNFrM7bDXfYqIu9CoNjqqe14R3lbTYAkccOnUjQvDrZsL49uq+Ye7FeBzayY33bBro
	 n+00uVJJ5zas4XzRN3G8b5W2I+S4ggrf7lqdg+9jh34/rIILn/DkKvrfBDasnf9Jfr
	 H1HG3XEjQXTRg==
Date: Tue, 21 Oct 2025 11:39:58 -0700
Subject: [PATCH 03/11] generic/742: avoid infinite loop if no fiemap results
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188725.4163693.2812181528595050867.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The fiemap-fault program employed this program looks for deadlocks
between FIEMAP and file page faults by calling the FIEMAP ioctl with a
buffer pointer that is mmaped file range.  Unfortunately, the FIEMAP
loop can enter an infinite loop if FIEMAP reports zero extents because
it never changes the last variable.

This shouldn't happen if the filesystem is working correctly, but it
turns out that there's a bug in libext2fs' punch-range code that causes
punch-alternating to unmap all the double-indirect blocks in the file.
This causes the while loop to run forever because last never increases,
which then means that testing fuse2fs with ext2/ext3 grinds to a halt
because fstests doesn't enforce a per-testcase time limit.

Avoid this situation by bailing out if the loop doesn't make forward
progress.

Cc: <fstests@vger.kernel.org> # v2024.03.31
Fixes: 34cdaf0831ee42 ("generic: add a regression test for fiemap into an mmap range")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 src/fiemap-fault.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/src/fiemap-fault.c b/src/fiemap-fault.c
index 73260068054ede..2bb474c083986d 100644
--- a/src/fiemap-fault.c
+++ b/src/fiemap-fault.c
@@ -55,17 +55,29 @@ int main(int argc, char *argv[])
 				  sizeof(struct fiemap_extent);
 
 	while (last < sz) {
+		size_t old_start;
 		int i;
 
-		fiemap->fm_start = last;
+		fiemap->fm_start = old_start = last;
 		fiemap->fm_length = sz - last;
 
 		ret = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
 		if (ret < 0)
 			err(1, "fiemap failed %d", errno);
+		if (fiemap->fm_mapped_extents == 0) {
+			fprintf(stderr, "%s: fiemap returned 0 extents!\n",
+				argv[0]);
+			return 1;
+		}
 		for (i = 0; i < fiemap->fm_mapped_extents; i++)
 		       last = fiemap->fm_extents[i].fe_logical +
 			       fiemap->fm_extents[i].fe_length;
+
+		if (last <= old_start) {
+			fprintf(stderr, "%s: fiemap made no progress!\n",
+				argv[0]);
+			return 1;
+		}
 	}
 
 	munmap(buf, sz);

