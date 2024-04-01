Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B7F1C0DE7;
	Mon,  1 Apr 2024 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990149; cv=none; b=CCquAxidOwa2dKRQF3NfDDC6fbpw0wn50+oju5p1tHrMJ0+dz0h7mH7b89kORezrkh72VmsNOOR9wiKwj5TXr5y33vJmUEb3rXKvcQV3aNByFEfROsqYAFhkJV54f0pZc9JsOJmraI6nThK+s8igtyaIO6EXT74koO2xH6h9j3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990149; c=relaxed/simple;
	bh=0KvWmWtWYfpFwEo/k1DrrYxy+OjaVJx54ea+lSefr+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbXU+Cg61ezkuSGHXdGYHIhmH5gNNogJcaKj5wei9luqgWQ75wbiqJ95fisXQKA+wEyoYcXZ3Lkz2iwYIiRnM5X81IDVXvzWQRx+jykUYpKWMlKr/XrQZ63lC6ABQ3cRPUr0AcKVLTD9xkNi/60wx2795+807SwQgClnOXJP2e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRKIjJCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRKIjJCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CDEC433C7;
	Mon,  1 Apr 2024 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990149;
	bh=0KvWmWtWYfpFwEo/k1DrrYxy+OjaVJx54ea+lSefr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRKIjJClYG6cYF5F8evqf1XtUv2fud25fYCMDm+07O4NhP1gp9q7gkHaPTHdCG9qQ
	 jyr0lGjQUzumZ4oF57yI1EbAQ0NX/5C87I9VCHwcE15mBaz4ewuRNmPCkBnZiHD5TB
	 I8E0mVGcm7+b7pOAViYR8li52/ocaUJTBTDViS1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 261/396] xfs: fix 32-bit truncation in xfs_compute_rextslog
Date: Mon,  1 Apr 2024 17:45:10 +0200
Message-ID: <20240401152555.688745253@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit cf8f0e6c1429be7652869059ea44696b72d5b726 upstream.

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1133,13 +1133,15 @@ xfs_rtalloc_extent_is_free(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 


