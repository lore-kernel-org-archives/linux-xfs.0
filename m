Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E4746E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001234; cv=none; b=tYHlVVPT9PDLi/L2HIegyz/50M8pRT1EkVOc8wjtcXq4Hk6iQVStznxQyGdesJxA+NMDaeoYp4bNIZpLR7gXUGDy44GrUNaQJaCCt6+cS5bSJMOwRGX02OVaD4/A26zSX2gZJpwxvNaxSynKp1NFP2JVt1qdan0oBKCN8gaGTlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001234; c=relaxed/simple;
	bh=VCulwStEb+ZJT3XDWsXwjCl7zPQdYdku8ItGy0ebfwc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DC3K8P26F4CKTfjs8BCMTSa8UdWvso9qvQm14XTA/oL82huMiN2Ll5RwyW/H6exyghPdtjdw3oSWkfoEWwUMquyeLd0XvMu+d+6QwtRfpV3ywHuX65MOOyy2iV+nMEDpdOj5RtEK3GJpiDrcoSlpEpTZ72qYPl4C/fftHErtV5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5U+qGCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5U+qGCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C880C433F1;
	Tue, 27 Feb 2024 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001234;
	bh=VCulwStEb+ZJT3XDWsXwjCl7zPQdYdku8ItGy0ebfwc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l5U+qGCxipwVAYr/TJOkd9eJQU2TG9Nt1yHvk2ZULfzSgA+meEi4udWgNtchel6Lz
	 4Hkb/y/mRuUsf3aGJ4sV5LCDii3QKwlzVkiJQm2K3taaBHrwvv3gG83NfP+3iyV0uc
	 hMA7f4M1T3EdHLIPu9BCoP1mulTCsSG6a22o5pA2udqpDg5HRphbEfnmr9uua7NIzT
	 B71mVc58AxE7AzBJKCCtshrM8qiwiGvbu4ShQfV3YZE+IOBU7W6jv230TCAzxrlUrK
	 UN9j97Obwcc71HC2DZthGTf5WAmGg34iuAs0ruaaZP3PjQznS6ykDmvupViJWFghFx
	 RFVSXAo26JAaQ==
Date: Mon, 26 Feb 2024 18:33:53 -0800
Subject: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900016059.940004.4268890665789625903.stgit@frogsfrogsfrogs>
In-Reply-To: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 fs/xfs/scrub/inode_repair.c   |   12 ++++++++++++
 2 files changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d0dcce462bf42..d79002343d0b6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,14 @@ xfs_dinode_verify(
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
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 00d08eef32525..90893b423cf13 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -468,6 +468,17 @@ xrep_dinode_mode(
 	return 0;
 }
 
+/* Fix unused link count fields having nonzero values. */
+STATIC void
+xrep_dinode_nlinks(
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_version > 1)
+		dip->di_onlink = 0;
+	else
+		dip->di_nlink = 0;
+}
+
 /* Fix any conflicting flags that the verifiers complain about. */
 STATIC void
 xrep_dinode_flags(
@@ -1329,6 +1340,7 @@ xrep_dinode_core(
 	iget_error = xrep_dinode_mode(ri, dip);
 	if (iget_error)
 		goto write;
+	xrep_dinode_nlinks(dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);

