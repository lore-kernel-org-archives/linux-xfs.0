Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794544266;
	b=gK95iZLe2PFgHXPqr8Kzwt6Z4RmWm/LtSjm+KHRCc6hxkHkwxb4N4hNbY65l06GB0YEh
	 hL5Cp9u6duVgdplO4Pp+rephefMIkYKsAT9L2RhASMyqDihAFuBTihQ/TINEIoxniwa9c
	 y0tRB25zeGb2UOPxLPrnyMEGHq7bA8GvYinaMeWuuk9CxPkzu1R1ggu/ZtyWgx4SfEmzw
	 Ta26SAqwf5DO1O0/ZJJ9dATcfVXOxdoydJ9UO4Q7bjk6OetMlpi0sjhtBDIOgw6mXTmIz
	 CBlEnyNDhuFBVczqtpzjjYbUv5hrF4tA+r7z85CETLGGHoRGKgFWgzDURr+OKJVWNVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794544266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=++DzozSDXGoGQ0O1+uMvDLSlApNVfPaQr26d6Yana4s=;
	b=vS546qnJcu0JmeSCWszEtfCz+tx8p2NRFLq4cHzIP2FAxRxOsi3WPHss3b+nXHQ8XqH6
	 YznVjbFLfguSZSkeget5KOXn9oO2Y13LjwCXd82tuzEcubwZiu95DgLflRa7//gE3fXhx
	 TknFLcbYogtYCTYk5kaB8RSxaLA7dvXBh/ApK6zwhFOSLpxzSPdNXeL8CndudqE2X1Bui
	 pvMnlYUM8Bh5f6FzH85uneFeIRhCBRNOx4YEX2vN4WsugMXX+r3IHGS/V7JQLO3xz/eFe
	 dgF4K+JAtehngPF8iiYCNRfF9oJNfpEPZOOqktHUDuyDaRPw/qDNDP6SuGSbrxVrW6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=G9eIfylm;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2490606A327
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 04:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2490606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=G9eIfylm
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e503815adso77867185a.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 20:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794544265; x=1795149065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=++DzozSDXGoGQ0O1+uMvDLSlApNVfPaQr26d6Yana4s=;
        b=G9eIfylmt5CojRvIIXwiGqovzH3PjwsiBaGIjEcKbWvZ6g+OCGYrpEV7Lqw4fTbJzN
         QE0QymcMBlylboQ4+VeJVXL2dSi8rNFWS0uTvYylwTLoaLpI+MJZZ0HTlGJe4j27LCPt
         96BcFFdT/fYtrX987TeDwZSsd7hR42gka05D5UkcxoF5930mMa0Kc0V/abyoHS5cLW92
         /NdKfBOZBuPFvLh3a0exZZe7AL1dEqi8aEn1685/9kOHu6pEPAU7DyY7BulfgdZKJ9xk
         QGOJzLrJyHQj4+AiACGTe/mxqDAtxv7ylCN5/3snDDk8Fd3SCpAqU/GE6GN+sPB7HUtW
         nLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794544265; x=1795149065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=++DzozSDXGoGQ0O1+uMvDLSlApNVfPaQr26d6Yana4s=;
        b=n4Ib5YGSToCJ4lW1Pib2jfZVc0f1Xv6AZopQ1zVxC9P4q2UIi9UDCZQkf9kAjMFiFO
         BuhiD1QzSKVk7B0lfRzq9joGcx9AQK19azlQBHiDMtSqQt1KKYeS6bkjF8qU6/tmCxoh
         eX+WjBWWBAavE9ONRC17ACa1yPs3VkgK8CGA4DpcIaZxQhLPra8nLFfA5yizdUFzr8YF
         8gGbiMDMxjL3EjsoEDt4E/zvC61AoPM+tPqWUDwYnGT7JjWLOuZXr39VLPQykIYSfzSP
         GWta+DFtVZOSikcO9B7xxJBn1NdZPNXgH5Al+N1SygMvP4O6/ghGdvZfwDpapw7u7YHd
         ACGQ==
X-Forwarded-Encrypted: i=1; AL+hErHpG8obOtkfOYQcOoGY5bJOKmWqoCNwkj/NGVdmlpsOeM9JZ1A1yq4oVjUBTWPEkcUR2jHwRhwxTrg=@vger.kernel.org
X-Gm-Message-State: APuU4Z89VEm46m88F8bTiYh4YhMmxZHqQUz11672eTv5KbSEpq7H/am/
	ctIDQCIkx3WZ2l1bHiEuyjzvJK1rUB7X150cpDQrbUXd3ydbUuzttbH70g/uPVs81Q==
X-Gm-Gg: AYBFou1jgx8UvDkhhn3YcdSWrUZ7v5ji9yKAWRVU4mhiCQ1yJJ/itLV10j3gB9gcRvY
	aIRlOLAAPQpSZa/7/V2WufmpSK/mOXM/ep2JAR648jcW2ldWqPYVofDwbUbUQGKaks+xR5Vy0ha
	Pnnw/TdA6G8xcJq+jpo70NyBn6Zp6F3z8dlGUyyUJoMqLVpXA17SN4NvJtNNFPHjdtAfRJ5Z4tF
	HbIFVKTQRwJKbh//Z/EZVPkL1SrMi+nbdISGBNv7tBMxKpTrw+t+yyyJaAhY/jQ4BvfOrfvC2Ae
	gRB9Q6YCLvO9gxG7f3vDXXH0utL3G/bv1M/vNINffG+9syc+UXhSRzxyPbnPX6hxT4evoMadr/+
	Umiu1q18wH6LZHIsyFjjifmtl3bn6N9qcm5/qA/IJh1wAoY2r2Xfm5mXRCbXYfIZiVcTOcW2JYR
	gM5qZNBtKF8mqJ9L7JlYi+ZqIe0nsf+hgCYbiqailqAetazjn7zGms/qeqJzo9bRJqx2VwOgjYK
	BDEAI1rgC1h+m5XLXENoknnhPYm5+Asf01Um4DdV6WEA7Mpz2rl9aujlfM70Qtu0mZfhKw1MVk4
	A8Czo7E6Tcs6U5e8CHQsS7aklsrF29BGlwKcLTt8ECcVDRFkxCecnz+bLIX2VahiBUrlxTSDog=
	=
X-Received: by 2002:a05:620a:6192:b0:939:b099:d52f with SMTP id af79cd13be357-9494ba7dfd0mr226368285a.20.1794544264634;
        Thu, 12 Nov 2026 20:31:04 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8f9576sm96595585a.42.2026.11.12.20.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:31:03 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] xfs: do not let tr_atomic_ioend raise the minimum log size
Date: Thu, 12 Nov 2026 23:30:55 -0500
Message-ID: <20261113043055.2578595-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
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

Commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
added the tr_atomic_ioend reservation and made
xfs_log_calc_trans_resv_for_minlogblocks() copy it from the running
filesystem.

However, the copy has the current log count of tr_itruncate. On a
filesystem with rmapbt and without reflink that count is 4, while the
function puts the old count of 2 back for tr_itruncate itself. As of
now, the minimum log size of such a filesystem is larger than the one
its mkfs.xfs used, and the filesystem does not mount any more when its
log has the old minimum size.

The issue can be reproduced with mkfs.xfs from xfsprogs 5.13:

    truncate -s 512M xfs.img
    mkfs.xfs -m rmapbt=1,reflink=0 xfs.img
    mount -o loop xfs.img /mnt

Before commit b1e09178b73a ("xfs: commit CoW-based atomic writes
atomically"), the mount succeeds.

After that commit, it fails with EINVAL:

    XFS (loop0): Log size 878 blocks too small, minimum size is 962 blocks
    XFS (loop0): AAIEEE! Log failed size checks. Abort!

This patch will use the old log count for the copy as well. These
filesystems have no reflink, so they never use this reservation.

Fixes: b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
mkfs.xfs 4.9 to 5.13 give such a log to an rmapbt=1,reflink=0
filesystem below 1 GiB, or up to 16 GiB with -d su=256k,sw=4.

Application impact (Ubuntu 26.04 user space): udisks2 2.10.91 is asked
to mount a filesystem made as above ("udisksctl mount -b /dev/vda"). On
v6.15, it mounts it at /run/media/root/STICK513. On v6.16, it fails
with "Error mounting /dev/vda ... wrong fs type, bad option, bad
superblock".

Tested on xfs for-next with 45 images made by mkfs.xfs 4.9 to 6.6: 26
do not mount without this patch, all mount with it, and the largest
reservation is the same as on v6.15.

 fs/xfs/libxfs/xfs_log_rlimit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 37712b2f8757..9454c91e9fb3 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -128,6 +128,8 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 		resv->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 		resv->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+		/* tr_atomic_ioend starts as a copy of tr_itruncate. */
+		resv->tr_atomic_ioend.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	}
 
 	/*

base-commit: 48326a2382d80715475d10ce98734ac65d2d2150
-- 
2.53.0

