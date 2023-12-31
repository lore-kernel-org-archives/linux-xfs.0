Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D7C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3moGxEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01A8C433C7;
	Sun, 31 Dec 2023 22:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062139;
	bh=FufdpvNb4JVmLp41eQlzQFvV+Ql8h9yNw1ERx+/GC0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E3moGxENyUcUF8LoMJp8JIb3xZ3eXIwJgotwo+BvpmAMP4n27RxPh/++nKyI2mIw3
	 q5xtm0GgjCv4l/fRaatr6jPO6N0Md4Ut+VI+opy2YuwL7btUQ2q+ZZTnRwKAiB2H13
	 T/i0wuhKgEK18bpNIF+o9Is5n3ZAA2Fif1kBi7dCvOERYM4QqN2cBgp8aKwxEL7/9d
	 LKip0J4gzvvry2LaDuXji7VupOALfRzm38ODUxoEwOIrwbt8FoYUZrx8837dfQVT/V
	 V+49pGsqyerGFbnwVFFLWnViLqWrPUkNsQjNxChvQjaOpfWqSBqwbWf97FkWJQOTgO
	 brNlALCx3JxEA==
Date: Sun, 31 Dec 2023 14:35:39 -0800
Subject: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998305.1797172.6971280830194810433.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
References: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
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

v2/v3 inodes use di_nlink and not di_onlink; and v1 inodes use di_onlink
and not di_nlink.  Whichever field is not in use, make sure its contents
are zero, and teach xfs_scrub to fix that if it is.

This clears a bunch of missing scrub failure errors in xfs/385 for
core.onlink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 82cf64db938..aee581d53c8 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -488,6 +488,14 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	if (dip->di_version > 1) {
+		if (dip->di_onlink)
+			return __this_address;
+	} else {
+		if (dip->di_nlink)
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))

