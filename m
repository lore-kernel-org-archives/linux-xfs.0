Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794133355;
	b=meWn/gZnry/oZr3J3GTvBNlFwsTeR0rWvQ9ySGKe/RYqnJUPv1J6vr8x4RGMY/ArESi4
	 N+DoWDk9Vjaf8x9DUp5tTZ7YbL5wRRxhfot8VSxfLPQFkulLf/O4VC/d7WcIguJZGz+/S
	 P0+wn7NcqQApG8kagiCK6jPWU6Nn1ynHRHJnOnWmGUE6MnOOpOz+Q5FXoOezDqMkZxpBh
	 2UH6IZUDtqji3XOsHs2sppLln9IyqdBjl1V2HKmIgO/Mm968RSQyY0CXLQ5o6QPTkDrAO
	 zShTU+e1h12tzqqbRBcQ2jLl5uSlVGzYUv3eMiw72DcuuztfuJahhmYr40mADZjakNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794133355;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=/I1zO9HH0V2GpmeOKiJWpPneEtLjajeHktpf8ycjH5M=;
	b=ptyLdT4NO0p7KvGin3PDs7x/5jtnNTTc76vBRRY5PQ/lCFfW8ymLAwKgIpfyV6Vxf6hv
	 /9D4NdT63OvWz1Yb3sEIMzUspeeMy3Cc9dbOAwhT4cOeVh5VVCdGHJuHU7swWn4GSRwsS
	 HQ/I1Td8MikEnSMkcRtnZg2RyjAFknUoUB3PyVA/f0nB8oKYbvWJcbng2uW1DztN09JZ+
	 NkOfKCkk42P8aA2sLdQcTyJGgV9xkbLh8j3hEWSI0OpMTHfdJPwfeYaMxWo8vQXH8RzTe
	 8Whrka9IYAuoYhAb0naX+6icjLQnnPNUlknjzclJA7pbV2gERQ+0lFgn//4rq3CGvDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EoG41wrj;
	arc=none smtp.remote-ip=203.205.221.235
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E000E606A31C;
	Sun,  8 Nov 2026 10:22:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E000E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EoG41wrj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794133350; bh=/I1zO9HH0V2GpmeOKiJWpPneEtLjajeHktpf8ycjH5M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EoG41wrjebhnRjxnzITvFkfxYkI6uXSMH9wr1Ft9XJ6FQjCNyaFntRAYJ2KJKPloS
	 /3hz1lqrbkRFYnWnLM0Bq0G4zF7MIbk9LB0iQ2r7j+shuPoz74PR0MrRW3/FG6VFju
	 M69Bf2s3JkhHEzvwRfJZmwglgiYUZ04cB9+Zj+X0=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 59CAB045; Sun, 08 Nov 2026 18:22:28 +0800
X-QQ-mid: xmsmtpt1794133348txrfclu4n
Message-ID: <tencent_9EC4DD29C8D43B8AC647292A2C35EF3B7E05@qq.com>
X-QQ-XMAILINFO: NT7uTz3cNku2uzsPeZXeEuU1yxJo6KNWXctQQy9zQEvjRTvx0nbGXPyCrgwDmF
	 LRgTyozLZCI7YPKXKKqThIa0NOCHIErsO8Uy7e7xOTuVAsFCB3+Z9tCoSLvPuL24Jz4b+3zgUAJM
	 s0T5ozsP+rbgvf4bicYiIw/ESVbPtSUYFk+HTgccriXjjx+j9ieAJaYZ9BWaBKMqH9Quh2yKYiFD
	 NozYKRF+s+HHqlFuDHap2S2qiJMi2iqL5IfJnNrM99M4M9aK38j5VdbSyd6sPrjDTPwfNvACApJH
	 yqUaPvSDX9m/QTexvzFc94iQ2/8Bfp1+9UENnq+VfpB/Q/saYPTtEza7/7OyZHIxQWRzut/rcrjp
	 kwWyXCzVZsg8MiT8fE+vtTptLbLDUX5ZtWpIaEGpnn5OZSIecKpx6rFL/ikHMoE3e65h4pYc2ioH
	 EvXxDBD5/vmBmw1IaUr3i67N1tj3sLsIEZl2SjtHrj9d+fuSDZNv+owTYsWRjXv0cJN36OKbzcvX
	 HYy4skzqy86Hw4VmrXlsFRZUGWcqP1021BVc3N0bCBhLnKKb0rqPDfUfx09X+PZB111QDuKM1QpM
	 kQmySocTeKiobKoloPuz8dWkNcKOA5hXlN9GYy+euYIUopvKCUGlf+LzIvz8JL/RbX7m4f3XG4pY
	 L6k7/KUa4h41U3MYXZ3wR7z3BFUD2C+HLLPiu0nqje2YkF4WiDCumGkL8RsRr2AHbb7W+DAwFKck
	 6qAfHJvEUsrRXIYVtSkZrCI2oHIeck3c23cOH46oJ18fTLzU6WsRQJ8Jgm8F/UrEFG6cncbgWiGi
	 wWgEMSEokp3wSbPEEDgcILahBlBOdvXFGdHB2RvsaWg0Pd6qgS4dV9kGOT6G2wRj5t7IibjtTjto
	 PO1G3A9UwWFeuE2ZiSXldbXpQID8fufeXD4SNAPIU+MOAW3Rs3WHKGfNa7WrwZyXVgUM/wrLGP+/
	 NJ3R4aHw0N5zE603U8CVTyr1KIelq6UJp0TAMmEItfg9TQnfQVTMbEoSwiEbSzrNvH5ofQf8GNph
	 fn4vl6RwYV+469IGuEoB+SwBWXm/CkbOwnyFSmM9kRmLkucLusL/84BzyOb3Y=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c34-xfs-ilf-len-oob-20261108@qq.com>
In-Reply-To: <c30-xfs-wascont-rideref-20261107@qq.com>
References: <c30-xfs-wascont-rideref-20261107@qq.com>
 <c31-xfs-logged-sb-geometry-20261107@qq.com>
Date: Sun, 08 Nov 2026 12:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

One more from the same recovery path - this time in the inode item
handling, a different asymmetry from the two reported above.

## 6. ilf_len is used as the buffer read length without requiring
   whole filesystem blocks

xlog_recover_inode_commit_pass2() passes the logged ilf_len (a basic
block count) straight to xfs_buf_read()
(fs/xfs/xfs_inode_item_recover.c:351):

  error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
                 0, &bp, &xfs_inode_buf_ops);

Nothing requires ilf_len to cover whole filesystem blocks. The
verifier, however, computes the number of inodes from the buffer
length rounded up (fs/xfs/libxfs/xfs_inode_buf.c):

  ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
  for (i = 0; i < ni; i++) {
          dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
          unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
          ...

With a 512-byte block size on the log and a 4k filesystem block,
ilf_len = 1 reads a single 512-byte buffer (kmalloc-512), the rounding
produces 1 FSB * 8 inodes, and the loop walks 4096 bytes - reading
past the slab from the second inode on:

  BUG: KASAN: slab-out-of-bounds in xfs_inode_buf_verify+...
  Read of size 2 ...
   xfs_inode_buf_verify -> xfs_buf_read -> xlog_recover_inode_commit_pass2
  Allocated by: kmalloc-512 (the buffer from xfs_buf_read)

The readahead path passes ilf_len through unbounded as well
(fs/xfs/xfs_inode_item_recover.c:36,41).

9232301894 ("xfs: bound inode fork length against the fork size during
log recovery") added bounds for the logged fork regions in this same
function, but the buffer read length itself is still unchecked - the
same log record carries both fields, one is now bounded and the other
is not.

## Reproducer

The dirty-log image from a normal crash is modified in five bytes:
ilf_len in the inode log item from 32 to 1, plus the four CRC bytes of
the log record. ilf_blkno and ilf_boffset keep their original values.
The unmodified image recovers and mounts cleanly; the modified one
hits the KASAN report above at mount(2), 3/3.

## Suggested fix

The verifier is the defence layer for every caller, so bounding the
walk by what the buffer actually holds seems most robust:

  ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
  becomes something like
  ni = XFS_BB_TO_FSB(mp, min(bp->b_length, XFS_FSB_TO_BB(mp, 1))) * ...

or equivalently computing ni from the buffer length divided by the
inode size instead of rounding up to a filesystem block. Rejecting
non-block-aligned ilf_len before xfs_buf_read() would also work but
leaves the verifier as-is for other callers.

The reproducer (log scanner, image builder, ready-made image, serial
log) is available on request.

Thanks,
Guikun Yang

