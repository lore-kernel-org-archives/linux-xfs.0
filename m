Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4032D148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529426; cv=none; b=QxN1iFq/0kCQA/QQ5Wyjzd6ADue+YEeR+OzWNx76/BZXGDbM2qywnbyk/3nMcVAPS7aTo6wQxbp6LnmPZzAfj9WZ7YCGxumK4+GxQYNOja86OQmpv/JnKXy6x/K9vL4qMOAHohQtP6WoweJ8dQqjKcUOEPIEVApFbSn5Ajxi0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529426; c=relaxed/simple;
	bh=q4lay0O7Hk/yYYg696jBQ5QmCgtE8NeoflfGnkh161g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjoJ1ADyOWGayJyb3nqYsZ5CKU0as4/b+VPZF0cml0pz7i6vydPW1fKMweXtcuNYKVhvRgmzr2nXp56294IhgCD2pHm07kUftqlpIEsqF0fHwgHWEy5YxbpspFhHf7biqYqqPFlA8bXftadOIoZRJThzxVtaHEcMjWNPG88/M/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEm16Kl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEm16Kl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E4EC4CED1;
	Fri,  6 Dec 2024 23:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529426;
	bh=q4lay0O7Hk/yYYg696jBQ5QmCgtE8NeoflfGnkh161g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BEm16Kl0v4W6DRqYMd7Be00rGwCoWNtfXru90cMQHjr/sO8KaNOnzi/ZQImUENXgX
	 HiH3xzVKnuV5QmyYtLyvMWVS46Ii6EppV+yq1xwgfPv9wpPDKywWf9iBp/5WR8DVZP
	 45AzT/Opke0iOOBX9GD3DmWoKGYmgaZn5nJP9rrhfglWSvNm9jLxb90OgfD/sPO+Hg
	 wd/A0eilMdmLt8HBQbTUinRiD0xQRUWdsUubsKUSPfJx3wz5H5UsSDQ4em1dTpWbp8
	 upFJ6/8ul8yOW8HQH3cLplemUbgP0vggk//6MYMlVDvhxJjIkf7dX7TfoDZ4fV2hOU
	 OlrcWNkb6i7XQ==
Date: Fri, 06 Dec 2024 15:57:05 -0800
Subject: [PATCH 22/46] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750331.124560.16924279203812191459.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a2c28367396a85f2d9cfb22acfcedcff08dd1c3c

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index cd9457ed5873fe..f56ff9f43c218f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -719,10 +719,12 @@ union xfs_rtword_raw {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index f9c0d241590104..7be76490a31879 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -300,6 +300,8 @@ xfs_suminfo_get(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(info->rtg);
 	return info->old;
 }
 
@@ -312,6 +314,11 @@ xfs_suminfo_add(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp)) {
+		be32_add_cpu(&info->rtg, delta);
+		return be32_to_cpu(info->rtg);
+	}
+
 	info->old += delta;
 	return info->old;
 }

