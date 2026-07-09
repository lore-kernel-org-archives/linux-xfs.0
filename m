Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4BB3CB2DF
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 06:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578418; cv=none; b=tHjET4YGy2ik+esCKEBj8Pn7UFJvWak8T8FgT9RaUIrepxZmLj1R4bwq1btD8pBUKYYyxU7b8T0kMmrgMWSC1jRc8ENuyyVLJOpt28UfRwTiX4sluxZwLbqdiUXtuTrAOcGK8X50cIxucyEX9tuNSaRcgGZMTdraWhyeDe6iqDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578418; c=relaxed/simple;
	bh=f4085wpgeHY2EXKrc97t4Zu5evbO07duIfIpVYHCKmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CU2hZ5lxBPoAfwqJRIGHIG3W3MP/ysUq5RnsE7Pr+e9DXH1Fp/0E1rWd7y1Qqfn80x4MdlKD6nuo77+vtM4Otck9Z0z7lhKiySqON+QDoxc8ma8Yu9Gpuku/GE4FWmduIcbdZ8pqIuQbTTgNfyS6wgY/1040rZdKBEADnQMg7E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iTAZEAH1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XgkZkmni; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iTAZEAH1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgkZkmni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783578408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PuqStaiSbRQsVsWgk7EHZfKWUiW4l5xja6N2MV8cWZ4=;
	b=iTAZEAH1olT4nQgrUyS3O8XhVyhnFthT0K/yHl6qeDgl1HKVxjxhWK6RAqr5ozIWF5CsE3
	rXyypWaYR6wjFh/2E/KJcG1rJLI0ZGruaaIybbGo07aT9T7r8g5j3OM4L703yaQ403gPfn
	zHjvMjKuCW7tNKljcj+tRJl7+TGBrX8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-V1K3RpkdP-axCqHdpbwWMg-1; Thu, 09 Jul 2026 02:26:46 -0400
X-MC-Unique: V1K3RpkdP-axCqHdpbwWMg-1
X-Mimecast-MFC-AGG-ID: V1K3RpkdP-axCqHdpbwWMg_1783578406
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e8004d60eso331410885a.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 23:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783578406; x=1784183206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PuqStaiSbRQsVsWgk7EHZfKWUiW4l5xja6N2MV8cWZ4=;
        b=XgkZkmniJdT49Xvvo2WGu+fQmmUK77kiPhuL2pQ8+hqZ3N1Jm51ohmIw+F568ghf+J
         gfzr8ET9Gyp2ZjxrIGtvAQ5doNZTCa4Y19EYXYp6zk9FSUAxLrPmKrKHy3sUdsAdEib0
         iXVYG3N1Mh4w1cOz5J5dTqTkmgPLlA4V9bWZRPbwPlXplJbDdyvV0dwGbHyO70ccGBxI
         4wUKdRPZ9TEPEK2orjiaXgBaj2kmYFZc9EJKnJwd28vuFJNY/qCgoBUGhQvBD+C0f/eC
         R5MhRUcinonuzOIEA1sN2n3jpCWPPZm18xQmTvoY4TBgWEqGYnOO7IH/9ubxIOQu7giH
         FaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783578406; x=1784183206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PuqStaiSbRQsVsWgk7EHZfKWUiW4l5xja6N2MV8cWZ4=;
        b=bkOVCU4H8krryN/O39e8gj3kMiXqqyh/vM9UrEl180sxGePtT+/eGL8ttik3DQmQxj
         8MxdAFjNGtpf1V/VEZKB1RwMHO8aTdlPzpjwEKcCQxnyeLhAFPrH/yPPpqCPHH5uALZa
         vrktAewocbGaBgR46VTARPGmrpZbb3knN65CVAhIR2h4l2gqqWReo2ptQbIGkHYqEjdA
         LZtQ7VoiuQ415WjAqBOfIbUlB3T7/QOuk9v2s6RsT5rLobMkuIpPaeV7eqsXGdSraJDL
         vvlp47QHsAOg3eCDDS7k7fD0EKFOT2f1QFEfeR9ySJrnC+jU2E9adEN1Dlbado2A2y/N
         t6ng==
X-Gm-Message-State: AOJu0YwO3ZHxqarKo6Vif3UkREbdsObex3Q+Mp8ZYfJtRtndc1qlQhJS
	O/c2RDHGZd0/buRigheWxF3nGxD7i8ZkebScJgLYNKZidMCwFU+8/sMl7ZKWuxlq+bkR26Bl2Jq
	cYmwJSAPWp/e7u9AgWxiavxnYmDMljl0GWyvEl5pJctY+SOiJV/JBEoKK6gflusdKEiseI3gLQd
	KePkkAwpH40eASJxwcKuKqu6AVZEETT4PhZC3uwbmezNJtOPTT
X-Gm-Gg: AfdE7cmEEGMUvbTdz/p8YcGx/5TI4uZR4LtZP4IUuXWb4g7fEUi/pkzjerllZu0lryB
	LnaZUlXfceH30KI7SL/WIt424amLxkCAMFCp85KP/as4aY92qrHGw+m09nfO54lo4HSnYs+Q3J3
	1b7DFNnhp40eAJtJNGcKtCGfk8RrxGblJOkV3dfhLagUjNykxh7Eb//sUyls0cJZyWBo05m5CWF
	ADy68GUaEs7Fc6u6HoxK2qtASHfz2M8Wsa/i8BsyMMIxB9L4R2tgoWNmxx2anvYowyjQVWgFUPr
	w/bmIqt3xwrjJZk/9J0g0hVOStiW7DZFASxZSzaR9wtLn4+7pvVsXPkLxNfFxEdzPvLt5xdm7xo
	s+6T6apCwKbz2LTgIkE7wgg5dW+QECgvcd4/bu3xZbYEHP++lfo1VwaDcmEy9HugFN317Yx5DSh
	Qi
X-Received: by 2002:a05:620a:1d05:b0:92e:6a8d:38ba with SMTP id af79cd13be357-92ecf6c7189mr534435085a.56.1783578406161;
        Wed, 08 Jul 2026 23:26:46 -0700 (PDT)
X-Received: by 2002:a05:620a:1d05:b0:92e:6a8d:38ba with SMTP id af79cd13be357-92ecf6c7189mr534431985a.56.1783578405621;
        Wed, 08 Jul 2026 23:26:45 -0700 (PDT)
Received: from upstream-xfs-test ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90c92634sm1601832985a.27.2026.07.08.23.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 23:26:45 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: dchinner@redhat.com,
	bfoster@redhat.com,
	hch@lst.de,
	djwong@kernel.org,
	cem@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] xfs: punch COW fork delalloc on COW writeback failure
Date: Thu,  9 Jul 2026 06:26:22 +0000
Message-ID: <20260709062622.2939412-1-ravising@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a COW writeback I/O fails, xfs_end_ioend_write() cancels the COW
fork extents and punches out any overlapping delalloc blocks.  Currently
the delalloc punch targets XFS_DATA_FORK, but on the error path
xfs_reflink_end_cow() is never called, so the COW fork extents have not
been moved to the data fork yet.  Any overlapping delalloc that needs to
be cleaned up is therefore still in the COW fork.

Punching the data fork is incorrect because it can remove delalloc
reservations that belong to a concurrent buffered write.  In particular,
the convert_delay path in xfs_buffered_write_iomap_begin() drops the
ILOCK before calling xfs_bmapi_convert_delalloc(), and a concurrent COW
writeback failure punching data fork delalloc during this window causes
xfs_bmapi_convert_one_delalloc() to find the extent missing and trigger
a WARN_ON_ONCE(whichfork != XFS_COW_FORK).

This is the same class of wrong-fork issue fixed by commit f6f91d290c8b
("xfs: punch delalloc extents from the COW fork for COW writes") for the
xfs_buffered_write_iomap_end() path.

Fix xfs_end_ioend_write() to punch delalloc from XFS_COW_FORK instead
of XFS_DATA_FORK for IOMAP_IOEND_SHARED ioends.

Fixes: 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW writeback failure")
Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 fs/xfs/xfs_aops.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..8268a3f80398 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -131,11 +131,11 @@ xfs_end_ioend_write(
 	}

 	/*
-	 * Clean up all COW blocks and underlying data fork delalloc blocks on
-	 * I/O error. The delalloc punch is required because this ioend was
-	 * mapped to blocks in the COW fork and the associated pages are no
-	 * longer dirty. If we don't remove delalloc blocks here, they become
-	 * stale and can corrupt free space accounting on unmount.
+	 * Clean up COW blocks and COW fork delalloc blocks on I/O error.
+	 * On the error path xfs_reflink_end_cow() is never called, so the
+	 * COW fork extents have not been moved to the data fork yet.  Any
+	 * overlapping delalloc that needs to be cleaned up is therefore
+	 * still in the COW fork.
 	 */
 	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
@@ -153,7 +153,7 @@ xfs_end_ioend_write(
 		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
 			ASSERT(!is_zoned);
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
+			xfs_bmap_punch_delalloc_range(ip, XFS_COW_FORK, offset,
 					offset + size, NULL);
 		}
 		goto done;
--
2.39.3

