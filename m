Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ED73630A2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299718; cv=none; b=SIgZZpoRe88Ril+YRVudNxfTqA4jzd13eG8M4EMEFazUzM3wtR4X9HpWyExcyKgFG1v2jKkVt8XNBiBNuTe0w3oygzv3NaOAjQHXJa7AJILhbxd7Ycx6YF6IsiEwDkeyWwhrF74w2oyKP/ToNl5Y45rIvXRrUUk3kkHLCXPEzOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299718; c=relaxed/simple;
	bh=+BB8RXK0CJ/PXSUG9uxKt6YqU+4p64ziZhpXRcxXTTc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bZpSzBmLmmJWEruxM5oQvDdlB1ZztXCN4uZf6vG+AlFuAaagTJ8qv8rSZq6ZW+Hh2l2X7uhlsHzJb38wsIzVxauwF22tvlhKI0eHoaCWLYns9UNUrYqCKQCmFCO4Wn+1Ci0LYsBPcXkAAL6//lywOYkuiHczpjNDG8dI2VZ5tTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BotK2cg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BotK2cg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C01CC4CEF7;
	Mon, 23 Mar 2026 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774299718;
	bh=+BB8RXK0CJ/PXSUG9uxKt6YqU+4p64ziZhpXRcxXTTc=;
	h=Date:From:To:Cc:Subject:From;
	b=BotK2cg+NqdanPv5KW0msf3mrUGBtsfmloWtO4oer3dMruyN5bItMb6rCJAacJZV8
	 cufPHsWphfUaWb3UmYbX0Byu09oW4V27/Ts7wTjFlcys5NUAHqj4bqb8z7F5iskhSu
	 VD6khBy486WPeGIM0Me5/wVEzYjjTqmS50YoVYA5BhljxbpmL7oTPsCu0z00AGrH1v
	 BPObRFcOiqR97q1m2FvC4lv9sdzc3B4qSSec2OgzNo7YQ4+sArUU52eXUacvoDgLMO
	 xIv7yXWQ4c8w73Xx2eKwfVyVTThVA7f1t+klDe0NdD5+pgyx4QLmWc3/8UqSaII6mm
	 EH2uc2ypIskfA==
Date: Mon, 23 Mar 2026 14:01:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH 1/3] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <20260323210157.GM6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xlog_recovery_iget* never set @ip to a valid pointer if they return
zero, so this irele will walk off a dangling pointer.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 354472bf45f145..fe909bc44c3a79 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -653,7 +653,6 @@ xfs_attri_recover_work(
 		break;
 	}
 	if (error) {
-		xfs_irele(ip);
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
 				sizeof(*attrp));
 		return ERR_PTR(-EFSCORRUPTED);
