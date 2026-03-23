Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748E531F9A0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291717; cv=none; b=PMe6LHudESYvJwzIlphBubjLlLy1+S+GHwKdI4siIb1d1ekkNdgpWYOkKKZta1voIF6241GLWQivIvMF58S0a8nFWHHczkT+kLHYGs6slZgIxhVk+/pVkIlmPYSGx88CqOCtXzaMq794aD4P8YjKEzhLRzxXHQ8g3KKAcOEyZcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291717; c=relaxed/simple;
	bh=b5C34FoUc0zxqJPttP8/Pe5OieiCtsWzRFDnaAvQ4v0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rUQ765XCrj76/1ph8SRTpjNqqRlgyQReXkWIAshsjI/JWGstjTVB//FNROwzzoDo3dRhU5FAk4aTUNt7kOVDEexy2cBHSnQMNllDjRgyIjWjBmxOR8wNnh/QkHNj4HpzZHCFMc5j1XwJhmas6t+HjFXWx+LJcWHzbUcCyD7bidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0oCAI/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0oCAI/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A135C4CEF7;
	Mon, 23 Mar 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291717;
	bh=b5C34FoUc0zxqJPttP8/Pe5OieiCtsWzRFDnaAvQ4v0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h0oCAI/N0s48Qir/7p49YcqTN406HzlHMqmzwDbLuBa6jy2Qu3B8DPs6NdYLvo6So
	 aSTUu3nOSiquJYq0DkXeUIdx0nGGVCdXgEU+l1wPPVvHk7Lhz44b3IzOlUd54ehv6a
	 mO345ovi+mkVQSRPALD3QJYnsLfmBEtTTyBjyaqyEM3/928NNNdmQEw2A05TNImh+6
	 xpJf4tB4ugkWbs6FgWYMQyMxgV7EZquoAFNnsgjNVkBe+YAhg7N0egTblsD6Ca0BUY
	 I970LvUHiwUVrzpHBTbiri19CGWhJlkRJ9pO8lwRAYTkaPltyVg1N7F84SteupkuUK
	 Ck+laKVnQQ9xw==
Date: Mon, 23 Mar 2026 11:48:36 -0700
Subject: [PATCH 28/40] xfs: don't validate error tags in the I/O path
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hans.holmberg@wdc.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177429121255.2266274.15907224920778076100.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b8862a09d8256a9037293f1da3b4617b21de26f1

We can trust XFS developers enough to not pass random stuff to
XFS_ERROR_TEST/DELAY.  Open code the validity check in xfs_errortag_add,
which is the only place that receives unvalidated error tag values from
user space, and drop the now pointless xfs_errortag_enabled helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_errortag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 57e47077c75a2a..b7d98471684bf1 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -53,7 +53,7 @@
  * Drop-writes support removed because write error handling cannot trash
  * pre-existing delalloc extents in any useful way anymore. We retain the
  * definition so that we can reject it as an invalid value in
- * xfs_errortag_valid().
+ * xfs_errortag_add().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29

