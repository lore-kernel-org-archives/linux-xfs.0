Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B577048989C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353503; cv=none; b=d4+c1RWlZmgoZEEg7TEBpb8p/5S4gUn4CSbjJBbV/L9u9fXREckYXW1j8rW+EmPKSh2UkoQIo9xEAyqP5cNVV01VCJoxxvpU7KWoQEtaa7uwXLeh4ByudgNezc7gA+RyE1roGVZ/k2bUhPeu3x6sNkycJyFRNie3+btOIjBnw9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353503; c=relaxed/simple;
	bh=7IF8vIjwJGWyprDwtisa7AuCLoZQ5785f7i8D4ueTSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E9UeBL32IgUqxxQ3X13B1+oMSu4eZUCposwQgtcfu8K7Gb6VNC9QBc3Kt1I+Q/pzkaOe9I45OnQ65eHWaztAWS1cXVJT2clo/SjSFN+nayBZtXYQuZyHHhvFe7LtsQ9+Ga6y0lfDjbI/qKiuyxubUeEDC7oAaEuvZfk57Os3sPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ez4scSX+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ez4scSX+"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cab973140bso19255735ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353494; x=1785958294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OIo/8/GMi79rKZq27Qcu4swN+9Qdc9OYyywJWHqBKe8=;
        b=ez4scSX+a+CBP372h+wKOAuoAzBn6ZzTWyyP1c/ECEyYBn0AaxpyHRnf5sA95Be2JJ
         Ekojnu1AaXFan9y8bVvZbHxFl9HA/ugbSIvDHcUupN8FFJadyDq7N+JQyC2UPhbLE1Qn
         5evfaony2+XKiNClqZQ04AR1xxMJ7/UzKr9qdlrNO0KI06T6BDGeMiEZ0nA8yB6s7fio
         h3aJSwkfGYaI1dZF1zzb8pk3WMioAiGaPTZYUfzVUmd/igXH9pNvkW/iu3oLHJuBVD5j
         oqbvFtwEaX/MKW2bO2nos9mDkZ+QhqffscQzPGWoo1RlZjMwRQcuwPe9ffPkjfINr34/
         A07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353494; x=1785958294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OIo/8/GMi79rKZq27Qcu4swN+9Qdc9OYyywJWHqBKe8=;
        b=EQtO5sdo/bARI3TFRIxi/6IqWXvTuDsl/wjsb2U97N/q7LQDBBMcDpGN7reTuLvGxE
         okOVknVveNDLiCXJHqEWuuUAxwdpv83LP9agIPSVupRdevkNTuLmx05xsIh3xW2r3ejf
         BMyp7WHkACRCpfU7Jj6vul08WBXjHWeg4+HfWmVSSgB9BB2VX17pbLIf1qpyk6rcfQsY
         0gAk2lPUtW6p67ZQEmtwB1ULha8WQP8tGDouTOZ4fnHL+M7hXIGu7FhO/OrlLqon0rgS
         qbMbFjraSvGXkrSS1EM3Yz/MWSN4fcKIwZg/+W16jUDeWNUuxwM53i4o8QAJVw/qm8Ht
         UEZg==
X-Gm-Message-State: AOJu0Yx9EWr+MEmDyIXbRGV6j19LwXmbjM2INuPWYqngIAD7nEHzNb/n
	ENgutZiFvEevOmORpFQtp1wL3xXUhsaFAckykHSyJTaTirtNzxju1g22rdF+sGHO9tY=
X-Gm-Gg: AR+sD13p3OS6SRa21xAuHezP5k/LQtZRVnM3/a8f0KhOIlhbHYGK67PvnfcCEZ5SDTi
	E/lHOH7UfEU8QokUytbDre5NkonqKPvt0PhQdFC+CPc+UtWIO9smL2jNOP58Clt40H1aOaYfkp0
	JDSnRkk9UqhTTyjbK+AZHhVVhEi3pVax4jZ437hpSitkXOHkewnQkubPFAN+Gth0WXhd7J/JNVX
	r8ug6ejoQg0lOYxKyLyKviXFEqHnr6p5Q6TXEj3hBuR8QwCYTc1oSZZlxAZqm6M+H3aeMzx5DUq
	T6Iuxs8GFDrQe9MmQrz0BFGh0OLbcyiTzSIWomeRtJrWEFaCyJIl6EaSfJa7qrmThmwq+Wx+wXM
	hPHneYtgO+im3qsVD9FWlJOL7KZL0ne8tf6NcJHx9lo8g34LfImhKJQKUADhSxksWa8yWC3mrnF
	tu9r1RRlbiYQCHroFOuNSrc5UEdmhRQ1tih5O38apXYfZXzMJSNr0SPoqX5Dw+ERqQiEK3KlRb/
	hc8fHk40m3WJKE9rtdMoZw6UQLz5sns0nIvrP87s1Q5
X-Received: by 2002:a05:6a20:9190:b0:3c0:9c19:65c2 with SMTP id adf61e73a8af0-3c8ba669616mr9373377637.74.1785353494203;
        Wed, 29 Jul 2026 12:31:34 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504db2c4csm12450394eec.28.2026.07.29.12.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:31:33 -0700 (PDT)
Sender: Weiming Shi <thebestswings@gmail.com>
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Xiang Mei <xmei5@asu.edu>,
	Brian Foster <bfoster@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: bound inode buffer log item replay by logged regions
Date: Wed, 29 Jul 2026 12:31:27 -0700
Message-ID: <20260729193127.3084301-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_do_inode_buffer() advances item_index once for every run of
set bits in the logged dirty bitmap, but ri_buf[] is populated only for
the regions present in the recovered log item.  A crafted inode buffer
log item can therefore make the dirty bitmap describe more runs than the
item has logged regions, and recovery reads past the end of ri_buf[]
before dereferencing the bogus iov_base pointer.

The ASSERT() that checks iov_base compiles away without CONFIG_XFS_DEBUG,
and evaluating it would already perform the out-of-bounds ri_buf[] read.
Check item_index against ri_cnt before the first ri_buf[item_index]
access instead, and fail recovery with -EFSCORRUPTED.

Found with KASAN on a CONFIG_XFS_DEBUG=n build by mounting a crafted XFS
image whose log contains an inode buffer item with more dirty bitmap runs
than logged regions:

 BUG: KASAN: slab-out-of-bounds in xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:701)
 Read of size 8 at addr ffff88801387d160 by task mount
 The buggy address is located 0 bytes to the right of
  allocated 32-byte region [ffff88801387d140, ffff88801387d160)
  xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:701)
  xlog_recover_buf_commit_pass2 (fs/xfs/xfs_buf_item_recover.c:1130)
  ...
 Oops: general protection fault, probably for non-canonical address
 RIP: 0010:xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:703)

After this change the crafted image fails recovery with -EFSCORRUPTED and
the mount is refused.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Kyle Zeng <kylebot@openai.com>
Link: https://lore.kernel.org/linux-xfs/20260611212314.4610-1-kylebot@openai.com/
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/linux-xfs/ajGB9o5Ys6itU3Rh@bfoster/
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b5..2c2d4a0027af 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -659,6 +659,13 @@ xlog_recover_do_inode_buffer(
 			reg_buf_offset = bit << XFS_BLF_SHIFT;
 			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
 			item_index++;
+
+			if (XFS_IS_CORRUPT(mp, item_index >= item->ri_cnt)) {
+				xfs_alert(mp,
+	"Bad inode buffer log item dirty bitmap: more dirty regions than the %d logged, for buffer at daddr 0x%llx.",
+					item->ri_cnt - 1, xfs_buf_daddr(bp));
+				return -EFSCORRUPTED;
+			}
 		}
 
 		/*
@@ -669,7 +676,6 @@ xlog_recover_do_inode_buffer(
 		if (next_unlinked_offset < reg_buf_offset)
 			continue;
 
-		ASSERT(item->ri_buf[item_index].iov_base != NULL);
 		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
 		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
 
-- 
2.43.0

