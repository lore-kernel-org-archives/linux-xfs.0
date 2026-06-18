Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2651614A4F0;
	Thu, 18 Jun 2026 05:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781761138; cv=none; b=lH72tbdpRgOiiDuDDRmuKjIvABlGLXc9g8jOSkbd14b6Bt+7rdHPe/xnr1i8/Db3Ie7k/JOtjTj8ciSaXaHL7Epnz0FjBJ0GLUzRcHqkFVs0HWLX2QuOr84+tB4wmphnLXzFgCi4ARsCMr5ys6Crpwp1V5VYXdwnj3Tw0P2xx+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781761138; c=relaxed/simple;
	bh=IkbVrwSXsN+LvCQbZHgrWhSk0jDjOlOVX5PZneGM/CI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WwKSxUW5jYB98UxrUS519Q7262+Pbjlc1Q0h5z0xGgIDULxd5Shwr0dLiwxQfQon1Ct/rEL76+IUMtZCNsLSvngHwQew39wZTUA0t4/8J+4/DQcW5EhqCH+i8goQbV6JNT9OGJ/BlnM/QLinqBiF8yTb4tF5Xt3KXBpuxHKBYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Il5uT2Zy; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Il5uT2Zy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781761119;
	bh=Jfjicr/Uq6rXbROf/o9dsOjgPOIpx39JW65GVsjEOEM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Il5uT2ZyZ2T70GqmhtkQ0nzjrc3G9BMh85+yap6+eA9KpFXCAKVBu5PAYq4apG4ko
	 zf3jy194S/zGgfX4+S8SpGrokXdP+Lijb/tvScYCbiE0HrRYfPYAEiJ9YkC9sHFGJr
	 Q40HCSMonc7cQGt/i0N7EMDqZfeHFXsSPvTK4wWk=
X-QQ-mid: esmtpsz16t1781761104t36f65629
X-QQ-Originating-IP: QGumPhGBLA4UrIrRdFdheu4Zip1xZw4KbM6pb6SvPBM=
Received: from uos-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 18 Jun 2026 13:38:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9772218393939188370
EX-QQ-RecipientCnt: 5
From: Morduan Zang <zhangdandan@uniontech.com>
To: brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	Morduan Zang <zhangdandan@uniontech.com>
Subject: [PATCH] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Thu, 18 Jun 2026 13:38:20 +0800
Message-ID: <863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MCg5+ArSTX6coVIP43qz2U0EKxT1jP4fk/AIzb429zJLAhsHB53oOFHx
	qUaq9yes93BiknZ3fhRyAF9rFV/2IqFBjTmb+ea+C7m9JPavgbxJXRiJlaz1BGY9NqmG6ej
	tkRbQB8387BHdwffv+P9MsSoGi7xH8gd97BA7HWsRlTIfhdPpE+I59TBRUfjdIX82SujiUR
	z/v3UZ6tBzS7tW5EqUIWQwdbhvGnV3SENe4okfrNVPw+nQ6HqND/0APT4b7SJWxjCQ4gaSN
	M1VMcvlqJUb1j5qcCrOWBNzuUrHMkM7upgs5YrKVIUiz7kJMhE2If8bfJWFWgkef7iQsC5w
	9TE1mqslX2qTFtwxf192tS9pHhzHbuhO5mBELrUAIPFjJI4KsgKNj6QXs02ljk4LDl0Bs1M
	ka2Uk+3VEZl5Z5aqcRZ19UdvzazbS2woXlfCIMD35n1QgcIumERvnReB0PeLkznTKsm++i8
	KBKpAZHvsIzJ3SRjvmtK3R2Mb4uXyIf3fyZ6IxVdbYp/nBluy+v1u8gpPVXKY88GrNEASS/
	idrW/e8yeE7OpnGDgIIMRgzZpOEWbMGM6GeXsd0ZPXtiR8XPnQXexe791mnfBMaa8hMBJN4
	5bSZsJKroydI0xl4u57Z4wa1Okebye8zo8UNz2HHa98zRZbiNzKDlOcnf6R0MII0d101OPg
	Nr2h1gNiWY8+F1w1IGNTjcqkDHuArFtXeYuAkcXEftbMJoq/lXuoZ6TylJ7f6L1GLY9TgdY
	ctu4NND7BKWEzZ9Rmq6KY7zgfKZrZ+o3kB9dAxNifet4NKb7yQZ+MNKO+rl4fvQfgJd/9TK
	3KAUgQMzJg/3/EojkOzoFrB3C0T1dTAS7jSfTixE1ufadXxNUB51hL2iipyKOR5o0Ulo5/h
	L+4mYu3q24snF8zDHqHmp0TT/o6t3+uWSDDyKnb8SKStH7n2/bHRaK7N0ChEvoPNfebWn7Q
	gQB7VH3yx1f8YzFNCLjwQaz75J+/aN1lZtWXh1pPh8DTKhJ5a0F4ZBlqPyhSxYcT4xCSFxt
	hjtXO+T03TUTjLOpUn0bx9dhIT/iXULkSh2z9X2w==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

iomap: fix zero padding data issue in concurrent append writes
changed ioend accounting so that io_size tracks only valid data
within EOF.  This trims io_size when a writeback range extends
past end_pos:

    ioend->io_size += map_len;
	if (ioend->io_offset + ioend->io_size > end_pos)
            ioend->io_size = end_pos - ioend->io_offset;

However, ioend can be created before a concurrent truncate shrinks
the file.  In that case, end_pos can move below ioend->io_offset
before the trim happens.  The subtraction then becomes negative, but
the result is stored in size_t io_size, causing an unsigned wrap to
a huge value.

A wrapped io_size can mislead append detection and corrupt
completion-time size handling, since filesystem end_io paths consume
io_size for decisions such as on-disk EOF updates and unwritten/COW
completion ranges.

Fix this by clamping io_size to zero when EOF has moved to or before
the ioend start offset.  This preserves the original intent of trimming
io_size to valid in-EOF data while avoiding the underflow.

Fixes: 51d20d1dacbe ("iomap: fix zero padding data issue in concurrent append writes")
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 fs/iomap/ioend.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..0c391a66db6f 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -297,8 +297,12 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	 * appending writes.
 	 */
 	ioend->io_size += map_len;
-	if (ioend->io_offset + ioend->io_size > end_pos)
-		ioend->io_size = end_pos - ioend->io_offset;
+	if (ioend->io_offset + ioend->io_size > end_pos) {
+		if (end_pos > ioend->io_offset)
+			ioend->io_size = end_pos - ioend->io_offset;
+		else
+			ioend->io_size = 0;
+	}
 
 	wbc_account_cgroup_owner(wpc->wbc, folio, map_len);
 	return map_len;
-- 
2.50.1

