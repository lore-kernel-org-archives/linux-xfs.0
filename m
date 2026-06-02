Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544237EFE2;
	Tue,  2 Jun 2026 10:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395026; cv=none; b=EnyKQm1C1NtlEdHz8gh+gPvJpesNzHhjmXemyURPf9itYCVVy34b4iDn0hb+B1Uy4jBMtL52PUUgiuO7Ov2Xk4YEOX3wd7mqdMzjqHljZ3AV0Bibd3JwnViLP6tz+cH79dUKiBuMzdQz/uIfzJEY28ZN5lcZYsTGvJKcdHY8c3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395026; c=relaxed/simple;
	bh=LHr7gBg6PtJCZf6/6mkuc3vnbKC5yndXujDfy0HTjfM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LhZdHQMKjLMG4U4eQaRr+g4Xj5/Ufv0oa3MKkd/LNLgTmujZ4yw5l09v5XvViJr4vwx3/dhKEWH1piN9f6o3Dt5aqv+6Ibc5bqBN5NIGt2GlRkKKb7xIQpB89Ufvhv3HiDpjWnspxlf7ZQmGGR65LMejGZZHmUvi6ARciHlHFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyfVmOmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyfVmOmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEB71F00898;
	Tue,  2 Jun 2026 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395024;
	bh=QUhM5h4C1WnXSL2tEPYUniUgKT/hUDIJ/vXilp+tDFQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MyfVmOmzX7hd/4gWE9I1HAP/tDKLvZhsRpaF0AF23wvS4sNb3Xx0sJuwzDIkbfDaY
	 FsjPXGFT3LWBJ11nfCzL1IsgItbFt8v/ksAh9q4fYdWKCRAccQxAc4jxDSN2NkQn0K
	 eY38uDZhStmD6xXuv8afkp2SHzSXcsbad+Ke/JhlJXTO7XIsGDNYOKscFTgMpf5sg8
	 jIW2Bk3szsshYcD+t0Twms+Bqnsaau186Rw1A/ruY0DQDE8M20cf3PbYzb7WGuGxs+
	 w47n+mxCjsQSBAa0DZ11hagsIDAIEDnl7/4kcTCJ7YlAYbw9I1tyAav6MqFcLlx2aQ
	 X9caJzyyrZdAg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:07 +0200
Subject: [PATCH RFC 1/8] fs, block: move blk_mode_t and fop_flags_t into
 <linux/types.h>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-1-bb0fd82f3861@kernel.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1762; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LHr7gBg6PtJCZf6/6mkuc3vnbKC5yndXujDfy0HTjfM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreGQ0tbvuCvNPbdnY7ncU9PyXVtSrr4UOXPnm57kl
 sqwU8b/OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZS6cHI8IFJyzT/iD9n3TUF
 yYePNC5UyCp2aSR8/9TYf9xL5drecIb/cbfU15913s30r980eIpVTc3qw1+uhF5de2BJ2qn/hsy
 TWQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

blk_mode_t and fop_flags_t are both plain 'unsigned int __bitwise' flag
typedefs, exactly like the gfp_t, slab_flags_t and fmode_t that already
live in <linux/types.h>. Move them there so they are available
everywhere without having to drag in a subsystem header.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/blkdev.h | 2 --
 include/linux/fs.h     | 2 --
 include/linux/types.h  | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 890128cdea1c..c8494d64a69d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -126,8 +126,6 @@ struct blk_integrity {
 	unsigned char				pi_tuple_size;
 };
 
-typedef unsigned int __bitwise blk_mode_t;
-
 /* open for reading */
 #define BLK_OPEN_READ		((__force blk_mode_t)(1 << 0))
 /* open for writing */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..e9346be8470f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1921,8 +1921,6 @@ struct dir_context {
 struct io_uring_cmd;
 struct offset_ctx;
 
-typedef unsigned int __bitwise fop_flags_t;
-
 struct file_operations {
 	struct module *owner;
 	fop_flags_t fop_flags;
diff --git a/include/linux/types.h b/include/linux/types.h
index 608050dbca6a..ef026585420b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -163,6 +163,8 @@ typedef u32 dma_addr_t;
 typedef unsigned int __bitwise gfp_t;
 typedef unsigned int __bitwise slab_flags_t;
 typedef unsigned int __bitwise fmode_t;
+typedef unsigned int __bitwise blk_mode_t;
+typedef unsigned int __bitwise fop_flags_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;

-- 
2.47.3

