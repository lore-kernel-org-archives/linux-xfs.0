Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D647A46
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYF+rUy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBF2C433C7;
	Wed, 20 Dec 2023 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092333;
	bh=3QRagIHFiY0eMAPMWTGafvaL+kh6tRwu+n2N9TL9E7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hYF+rUy1/CBwos2qbw1VFpcwIaMC8oIwG5snhWdRiz1h+EE+QT4ukno98iDT5SeWV
	 860Huuoy5EOjPn8k/ogxBplKBZ+QtOuo5X6ro/NxafQwlCrqV/WyZ2vvrnuR/uK+U+
	 WB/5Er7pd18KSx3WVdR5MCokMN8BYAPpbt2C9BYqYuLggF7xQAyYtrwmOSTReADETn
	 vqH8r1Pg0wpPjic69QB7kAYEDd8DHLL90vbf6phTOhmp+YZpqR/I8eu+UhAjhyvIZ+
	 o6BTfytjm+52n+fPWuP72BHNNsGZy6+N2VDewpzYyTSQ/MPuSv8D6hPBrFJP2a5VI5
	 T6BqPYQMocypQ==
Date: Wed, 20 Dec 2023 09:12:12 -0800
Subject: [PATCH 3/5] xfs_copy: distinguish short writes to EOD from runtime
 errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309218403.1607770.4299633539281504295.stgit@frogsfrogsfrogs>
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

Detect short writes to the end of the destination device and report
them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 79f65946..d9a14a95 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -889,18 +889,28 @@ main(int argc, char **argv)
 		} else  {
 			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
 			off64_t	off;
+			ssize_t	len;
 
 			/* ensure device files are sufficiently large */
 
 			off = mp->m_sb.sb_dblocks * source_blocksize;
 			off -= sizeof(lb);
-			if (pwrite(target[i].fd, lb, sizeof(lb), off) < 0)  {
+			len = pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off);
+			if (len < 0) {
 				do_log(_("%s:  failed to write last block\n"),
 					progname);
 				do_log(_("\tIs target \"%s\" too small?\n"),
 					target[i].name);
 				die_perror();
 			}
+			if (len != XFS_MAX_SECTORSIZE) {
+				do_log(
+ _("%s:  short write to last block: %zd bytes, %zu expected\n"),
+					progname, len, XFS_MAX_SECTORSIZE);
+				do_log(_("\tIs target \"%s\" too small?\n"),
+					target[i].name);
+				exit(1);
+			}
 		}
 	}
 

