Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C5139579;
	Wed, 15 Oct 2025 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546250; cv=none; b=i4IRSRRpLJ9z+ll3wXmyO+Q8VT0aUAsoHYXEPKv2xn0CeD8doh+Kb/KFj8A+vcbY2A8JlsjS8DXM/vLwDzF//R/LZxR/R5CKe7BxTnsN67CSqEukMON0KHZH63LbvlGjlfiTg62wO9OeHDiR4ntAF3F09b5w5zfJgoj48ePTzeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546250; c=relaxed/simple;
	bh=KIFF5MXsBf0s/UC6KzbKuvJhesQYJMTyVR+rt7Z8SMY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tqhpw4g4swTt0xa6zSdr5FfK3YcCtJAmGBimubgsd3EJVixWIm7qVti0WTZQc308pjk0DXdeh8+RKALR7cAEnLeUg3Q1nZHnTYLG4B17RrW25NSDufoL21jMwoT/GyVDuXonbgLrS5nHYZyYdDVq4D6djzfhmjcjQ/wjmdFIQzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1qGgfCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1qGgfCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48973C4CEF8;
	Wed, 15 Oct 2025 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546250;
	bh=KIFF5MXsBf0s/UC6KzbKuvJhesQYJMTyVR+rt7Z8SMY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C1qGgfCGC+8jLnpYTW+zLb1yFXxU2qG3ipJfnT8LYrYl+HYTdRaeMDA75Vn/m+BOc
	 lQJjc4UA5FXmx0YPXgXjBZ8QvPvW+VirGme0zjY2v2dwxWUilk1PCiT0+AVpYm0E29
	 L1WXKg3XEO2DfgZAv2m62EEQFxyhbc0+okg2TqI1mJoZHHlOfnwUQ0b/P6hi4ihx9h
	 Lnete7IX+QsUVeJsjBP0AdaHJ0w8eIkRHinsHAVyUEOIZQe/QKnm4u3TezRN21gnY9
	 5R/ZNsThm09zUrGJvG2OUem1+ig6hEcj1CsRZGHGqjvxNqbj9UpSF+uKyykZeenmip
	 U8vviR0V/3ZJw==
Date: Wed, 15 Oct 2025 09:37:29 -0700
Subject: [PATCH 3/8] generic/742: avoid infinite loop if no fiemap results
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176054617951.2391029.15086649161940357832.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
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

