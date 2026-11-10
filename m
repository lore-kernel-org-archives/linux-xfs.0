Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235863;
	b=xh5RWAGjawgG0QzXTEAv70uSzYFkoSlkBF6zD3Ew194YYej7FroBJa0mfparnAAbqnjf
	 qeoucufSB4zWsTYKH+eKqs9YoE5zzsehsTEoYO65FilUpiy4VN58uL2oyVrxu1OramSd9
	 1CZen/dBp/a1YXkcEqdqxLXS9R2HToq9CUmqCKNOyRqJ7vWx9b5s5asJeEs83cht32PQX
	 F+himBA37s3+ArbBckTtE5+pwQdDvbr1teuhWYzaGqHfCVnCGOfXeRuGdO+a2DNzZ6/ow
	 rykK5n7ifJ6HVNqlG69HdFoIRulIvekvUk81nIDgBghGF4v1njcvYsy8+DyshTO11zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235863;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NLMKIDNS0W+hRZrbeHxhMvOg5FNPrjZOhNLGTUzUEbE=;
	b=qu2717t5FUsdLjDPBAXv+EbZoM6PIgyQvIWHpk+L+apgBhKl5RyR/p5kNocXVajviZ5c
	 H0TBfNDUQdjSXm/UWuLhumRNM8G7AXmZM7hN4yMe9I44GSUuW2O2SADmt5HY9Y2+MJ55d
	 T7dFNY8sGOTfPv/bizesV88zTLYlvAAvkkJSLxBXnB4yG2TP+B89agPz8qrnDpDLtVHDv
	 9xOPW2C1A7X97PY7+GCTLwGvJ5TLhRSF0hEaHkiLPzcfiuv2rCsDAtRbqancOdxA6QDsa
	 RmzizMgT8Jg3e89Urmv9nP1xPl2XH1bRXkQ5ISg2MUB/x83Nm/t+9YbqMppJnVETYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=lHj5Zd37;
	arc=none smtp.remote-ip=162.62.57.137
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918A5606A322
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 14:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 918A5606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=lHj5Zd37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794235856; bh=NLMKIDNS0W+hRZrbeHxhMvOg5FNPrjZOhNLGTUzUEbE=;
	h=From:To:Cc:Subject:Date;
	b=lHj5Zd376aCOj5EsgrXJvhiZWHdv9090xAvzjqVW93W8iqmuPv2seSZMXZFMHrBDz
	 mjE3yKP+dZ3MCmysuOW8ALyyCwrBTcQsG3q3S2zZwSe1DXe6DCAUZY1bxwoHHu+sX5
	 WuW68TXOreQAN20jXBIj2dQQ8fx/rRF8Qwk+wJJs=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id CB6B4ABE; Mon, 09 Nov 2026 22:50:54 +0800
X-QQ-mid: xmsmtpt1794235854trwi3sxqs
Message-ID: <tencent_ADBE1F465A9C5A4CFBA28A7D6AA39C527509@qq.com>
X-QQ-XMAILINFO: MaaIYtAFx2QD0GUF2GDzc4mPbcAQbXzx3QuNxssYGFMpC1WX+Cmu5xbVnI5qcy
	 XgziiZUN+t5+lNWAZiiKU0HYaQ5p8ClUJOKk+iDEavpMX6eMcR9ZI4LVHMcaOnuSit8gn0AufJVh
	 AUpk5UITIL4+XZRncvB068pYXPwCd9QE17FHdDWXoerhYAkk8bTvmmb8MH2Lktf5CTOTkp27Sqim
	 Q4W86IS3WRmkCrNvQBbsEPWeiX31zn+Mum/OhbgHSda56sazxltLZycaT3xry/zRKohl1Vn2jQ45
	 CQhCIfZNTX1kmamO5YhTihYkzA9j05uc7CPjcY4US+LBwXXI75kAV1Y1pv02glbrNEhyfjuLQ4xY
	 IEA4ehsprVp8aOqcYatrShwFRQ3rvvjTS3JkE/uT9jCYYlzxkLwa40sEIJSOrR+2wqzU4s+c4RzX
	 XFyX4MtA8yd9vPYcDoHXy6DoIwTMzcJMfAjVt+mUeHv2v6AEh6Oju40oLYIvyh/pUCUYYjyHd0Qv
	 ufBwMzPlKi22UQ85X4qkU2Ny9amwQvUSoV51Pbuo7sb7+s6CjgtqaiKzLErAmkcJ/flJ1hLgv+Z6
	 7YAznlLl+nHqkjvbNQd4Rrd0rRmNGDIwTz4cBe0dCg+ILFMRTH3SJyCnXfzfh38WiQWhKV81uA2G
	 q0pa3JzE7z81V8bBdWYwL0/QyXGgd7T9hsvugdzzgfmMpn+BmMD9yE6AG2ktBHSAcojvyoYRF8e6
	 SuYFX045xCKdl9umsTn5km/tBorof96Ad+ZvwxQmav/tgSMgBfm2644aIbtLIfvaGv7EnHPBLIGm
	 pTv+RPDc6x9hp+up2KSA967sV0a5ADvcnxTmXcHT7DMgLhtVLLWTllVWuA7aIwzClewF9QVDYR46
	 VGsdG14j3WtgleoXhsHDM2EEgP+YCNXYxXHGtyS7mQ54W9/y7zfo6HkPGd+x+iMPQboyRaKsmqdw
	 FluR4gKVpvOOmg5Xw6rKNCM4G0d+t+xKwXwHHBvjmtrfkdG0oij68HhxId1NMtAPYyvafG3/kAaV
	 rw5iivF5olUOp0zYv0KJgN47QhlYp/WKRzlPJNRRkBHQ8vZ6of8JnuEnAGtgSQFnU05FJBqQ==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
Subject: [PATCH] xfs: check the region index against ri_total in buffer
Date: Tue, 10 Nov 2026 14:00:00 +0800
X-OQ-MSGID: <patch-xfs-ritotal-20261110@qq.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Both xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer()
walk the buffer data map run by run and index item->ri_buf[] with a
counter that is advanced once per run. The number of runs in the
on-disk bitmap has no relationship to the number of regions the log
item actually carries (ri_total, from blf_size), and the only bound
on the index is an ASSERT - either the mid-loop ASSERT on ri_buf[i]
or the trailing ASSERT(i =3D=3D item->ri_total) - both of which compile
away on production kernels.

A crafted buffer log item with a data map that contains more runs
than blf_size claims regions walks the index past the end of ri_buf[]
and reads ri_buf[i].iov_base out of bounds. The destination side of
do_reg_buffer() is already validated for real since the CVE-2026-80536
fix ("... the only thing bounding the copy is an ASSERT(), which
compiles away on production kernels"); the source index was left to
the ASSERTs in both functions.

Validate the index before each ri_buf[] use, in both functions:

  xlog_recover_do_reg_buffer(): i >=3D item->ri_total at the top of the
  loop body, reported as a bad buffer log item.

  xlog_recover_do_inode_buffer(): item_index >=3D item->ri_total right
  after the run-advance loop.

Tested with two crafted dirty-log images (mount(2) alone): one hits
do_reg_buffer (16 runs, blf_size 2), one hits do_inode_buffer
(alternating map, blf_size 2). Both previously produced
KASAN: slab-out-of-bounds; with this patch both fail recovery with
the new message, and the unmodified images still mount.

Reported-by: Guikun Yang <yangguikun19@qq.com>  (bug reports of 2026-11-09, <=
c40-xfs-inodebuf-item-index-20261109@qq.com> and <c41-xfs-regbuf-run-index-20=
261109@qq.com>)
Signed-off-by: Guikun Yang <yangguikun19@qq.com>
---
 fs/xfs/xfs_buf_item_recover.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 1111111..2222222 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -479,6 +479,13 @@ xlog_recover_do_reg_buffer(
 		nbits =3D xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
 		ASSERT(nbits > 0);
+		if (XFS_IS_CORRUPT(mp, i >=3D item->ri_total)) {
+			xfs_alert(mp,
+"Bad buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%llx.",
+				i, item->ri_total, xfs_buf_daddr(bp));
+			return -EFSCORRUPTED;
+		}
 		ASSERT(item->ri_buf[i].iov_base !=3D NULL);
 		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK =3D=3D 0);
 		/*
@@ -688,6 +695,13 @@ xlog_recover_do_inode_buffer(
 			nbits =3D xfs_contig_bits(buf_f->blf_data_map,
 						buf_f->blf_map_size, bit);
 			ASSERT(nbits > 0);
+			if (XFS_IS_CORRUPT(mp, item_index >=3D item->ri_total)) {
+				xfs_alert(mp,
+"Bad inode buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%=
llx.",
+					item_index, item->ri_total,
+					xfs_buf_daddr(bp));
+				return -EFSCORRUPTED;
+			}
 			reg_buf_offset =3D bit << XFS_BLF_SHIFT;
 			reg_buf_bytes =3D nbits << XFS_BLF_SHIFT;
 			item_index++;

Fixes: 658fa68b6f34 ("xfs: refactor log recovery buffer item dispatch for pas=
s2 commit functions")
--
2.43.0

