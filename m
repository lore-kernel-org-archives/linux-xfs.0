Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E40147A42
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7KCrRh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FE4C433C7;
	Wed, 20 Dec 2023 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092348;
	bh=FbcUE8+gDuNBRHRx9R5Vy1Xo/ay0HCOuH2HQJQqAHuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P7KCrRh5qJ8Dgi3AvNGeJe++9eoaEgLA2cFhynlPGITxHswNI+QipkCGUNQHZGqAI
	 0JkDlpDmPsoV2AoV8KDV6kn3E+EQlNgoIeqN6eOXeUDCx5+U7CKbwjmOldBB7y8mme
	 qRRB/Z2qaUUtxhCibrg7bhaRXLod8G135XDB62vTSo5ryJTvvkRQNwONlkL4kfhTIB
	 2eDg4quEpy59aTrTXxt/Z/iYOHP6ihu7/JoRbJRAD8CycHS1CKN4P5ieyszMV4KbMn
	 vNX40Pt14tefL7gt84SkPtM/LFIWCvz7AyQSEZk+zOypSgEj2wiSs6AcZVTuYz4dKy
	 VfuLSuLjHdIrw==
Date: Wed, 20 Dec 2023 09:12:28 -0800
Subject: [PATCH 4/5] xfs_copy: actually do directio writes to block devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309218416.1607770.6525312328250244890.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
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

Not sure why block device targets don't get O_DIRECT in !buffered mode,
but it's misleading when the copy completes instantly only to stall
forever due to fsync-on-close.  Adjust the "write last sector" code to
allocate a properly aligned buffer.

In removing the onstack buffer for EOD writes, this also corrects the
buffer being larger than necessary -- the old code declared an array of
32768 pointers, whereas all we really need is an aligned 32768-byte
buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index d9a14a95..bcc807ed 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -832,13 +832,9 @@ main(int argc, char **argv)
 			do_out(_("Creating file %s\n"), target[i].name);
 
 			open_flags |= O_CREAT;
-			if (!buffered_output)
-				open_flags |= O_DIRECT;
 			write_last_block = 1;
 		} else if (S_ISREG(statbuf.st_mode))  {
 			open_flags |= O_TRUNC;
-			if (!buffered_output)
-				open_flags |= O_DIRECT;
 			write_last_block = 1;
 		} else  {
 			/*
@@ -855,6 +851,8 @@ main(int argc, char **argv)
 				exit(1);
 			}
 		}
+		if (!buffered_output)
+			open_flags |= O_DIRECT;
 
 		target[i].fd = open(target[i].name, open_flags, 0644);
 		if (target[i].fd < 0)  {
@@ -887,14 +885,15 @@ main(int argc, char **argv)
 				}
 			}
 		} else  {
-			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
+			char	*lb = memalign(wbuf_align, XFS_MAX_SECTORSIZE);
 			off64_t	off;
 			ssize_t	len;
 
 			/* ensure device files are sufficiently large */
+			memset(lb, 0, XFS_MAX_SECTORSIZE);
 
 			off = mp->m_sb.sb_dblocks * source_blocksize;
-			off -= sizeof(lb);
+			off -= XFS_MAX_SECTORSIZE;
 			len = pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off);
 			if (len < 0) {
 				do_log(_("%s:  failed to write last block\n"),
@@ -911,6 +910,7 @@ main(int argc, char **argv)
 					target[i].name);
 				exit(1);
 			}
+			free(lb);
 		}
 	}
 

