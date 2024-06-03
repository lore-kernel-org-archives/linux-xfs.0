Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594A3F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440880; cv=none; b=IEmXD/tPYttnPtoVR86IDZdEZpcyAVhSKX2E/tP1FBpsrdmc+hETdzFs++Uhw8a84XMXnlXBM3TQ/WIo2nGen+jk4US764EEUqaMa7M8DdiWCoeo9YryfHS7hZ6bQMjPSVwWxtTwnSo8Od7bVLSBLvBmdGLrRH/cMRpbJ6J2UEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440880; c=relaxed/simple;
	bh=BfkShuIzyDA9VrmdIasu45z6U2qJI2SAuwMAyPwyILc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzR0taniOGW9fPfNj8xg8gztNKBC6pBaGtrYF+nMit3KsA6l2ayrVxrE4cfRgB9Ssl+AIIPI4JiR9ud1k7mmQ0laRWpzDtO8it1dt97igBIDImlciOh0xktf+/mtgfoWb/Cg0MerGshzpF1C8hXLd9gxKzNMRnM0uY/AovdFw48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQ/Ugj3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQ/Ugj3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32166C2BD10;
	Mon,  3 Jun 2024 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440880;
	bh=BfkShuIzyDA9VrmdIasu45z6U2qJI2SAuwMAyPwyILc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uQ/Ugj3W3yNFpTmyhBm0pxqeA7jZjS7P//i3Q9zvkpe/Xl0at3lfS4YFbipiuFU0c
	 uCwFZDhj4PSlQFUfMxzkLH5Wa8NENC3wKkzEwvDjVMHdND7C/Um7SbcRUdvToqw8kt
	 HezZhKj25wqXkB56XqE7ot2cbsYnWRIXMxFBjx+qmk7OqR67cVFj/BEZg/q/zCoDni
	 649D6y5eAdDxPH4wqb81270Lh/kYr2EjzxRvOpiQT69oie0x+BQpDz9AUTdxHZjqL0
	 92qsFZsRApfhxrU9k8QBMEn3p8QCprAcjUaSmJYleW6OwCpQtJB7b1paNxfaN/OC8q
	 wVwopVd7qU5HA==
Date: Mon, 03 Jun 2024 11:54:39 -0700
Subject: [PATCH 010/111] xfs: create a predicate to determine if two xfs_names
 are the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039517.1443973.16631624416675448143.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: d9c0775897147bab54410611ac2659a7477c770c

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_dir2.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 7d7cd8d80..8497d041f 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -24,6 +24,18 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	if (n1 == n2)
+		return true;
+	if (n1->len != n2->len)
+		return false;
+	return !memcmp(n1->name, n2->name, n1->len);
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */

