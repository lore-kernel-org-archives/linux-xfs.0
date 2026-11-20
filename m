Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190036;
	b=BOa3J592wLWirqK7AJSPwuovgbDLRKFHtwzxIbRfY/8/21P6dJY2Xg5Aj0ZVtJSVMqn8
	 x6zGzresnLPP1LBU9tpiDHQMqFcNP5Md3yoN+JP3mDW6B4togb3RqYLAbdsCyJEYRUuye
	 ljnTUR/x8c9vksfJlpBvu5JOemJ2kgva3Uvk79NdqUB7W4q0f+Ivf8mNqPnC16LZkrIwo
	 FPfiXmEciH3WxdVI5QeM2pWQ6Z0qziQNsc5OJo/BXj8qgvhaEU6KSaKyPAfizYTTAjno2
	 ErvWFQjDzTHPN4/iqXj80kfdNnqLCvCGiXomA5xRJPbtmqQJK6Lz4LTC+r0M7mkdgHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ETEjCRJqTj2rcNQGoOiUFzLxZ0618BE5SBDlsxU9kIQ=;
	b=cyzY4MNWFp9SOHsjpBtLkZdBXb0ZDTxcVBBpGWXkLvV9ZnMN6gx15bDyYwVvoxUC4jyR
	 4QCYx3G5eaB8riqkSNBUmLPvcTjZW85gCvDmG/reDu8HY1im6QvQxXkvkpAuDJJXJsOzE
	 jP4tGdgXqo40o85tk+j/GsrJt4AUHdJXfMbSGyor9NSvcd5qlUiCNmcXiHRD777+ffjOZ
	 sZiOy2msl7idxppL7mfK9iH6CuTD5vd5OiT7bDuB9SwRp6XOk427qQC3LYN4RYddpChVC
	 YFvWoMugN0EURsXNIakHexbtoUztMXg05555dlmfUvlk9Cgk4jh111f8SsVrDqU002w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik3ISORV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560560A2600;
	Fri, 20 Nov 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik3ISORV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1FA1F000C4;
	Fri, 20 Nov 2026 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190035;
	bh=ETEjCRJqTj2rcNQGoOiUFzLxZ0618BE5SBDlsxU9kIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik3ISORVw1eoMJOwfI0KgGK5y31QoAyanFb4Y3ShFXUYimJxc2d+lHdECp6wbpq/X
	 +bGCs1jwb/rlqfI6/FUiKQbdeEyHzVLGB1b7X+86YfAF6dajtzPI2BMboiez0JfozO
	 im55TIYLktdcPKj/QB6YFAlC8Q8P/h6+bXLM5OM2/67VAeOuhCxwszEC8j1A1nvGqD
	 LwkNma1hLPoNfH93m71sTQOQ1oGZyjsAsdJkop1aYgGr3A1/9LKPQfihMLfF0S8kVN
	 n+FfHX2l1SB7cu1rcBxaf8vbzQM526/l/njvCIDv3GSodQeQ+BFsxtjgelGFaSGEgH
	 JqeRlGV7msHZA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk,
	Boris Burkov <boris@bur.io>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/7] fs: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Date: Fri, 20 Nov 2026 16:50:24 +0100
Message-ID: <20261120155032.187246-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155032.187246-1-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
Filesystems could return verity status with GETFLAGS, attempting to then
pass FS_VERITY_FL to SETFLAGS is not allowed.

The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
doesn't work on BTRFS for fsverity inodes.

Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
no-op. The file_get/setattr() path is fine here as this flag is cleared
right before fileattr_set_prepare(). The future fsverity support in XFS
would also need it.

Cc: Boris Burkov <boris@bur.io>
Cc: David Sterba <dsterba@suse.com>
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/file_attr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..81bf55f9b255 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -199,6 +199,16 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (err)
 		return err;
 
+	/*
+	 * FS_VERITY_FL is settable only via FS_IOC_ENABLE_VERITY; never through
+	 * fileattr
+	 *
+	 * Treat it as a no-op so the FS_IOC_GETFLAGS/SETFLAGS round-trip
+	 * doesn't break for other flags
+	 */
+	fa->flags &= ~FS_VERITY_FL;
+	fa->fsx_xflags &= ~FS_XFLAG_VERITY;
+
 	/*
 	 * Project Quota ID state is only allowed to change from within the init
 	 * namespace. Enforce that restriction only if we are trying to change
-- 
2.54.0

