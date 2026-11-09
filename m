Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217017;
	b=n5tcGXkg4s67pgpwfqGiqkHQ64Ty8nifz9wjZd31irg67dF6eNimXpncHZsu3ffLjjY+
	 /nc0KK/tUY65vTxyoQfBQXGgwMTaWCtjgeGWehtWZWcDPkQXezQNm5Lk16YjOtdEfi4zd
	 IPKvMgE9OOCWFmvkfEpdQNuUZj+RBaSFWsk/2JXJiNEJbzqI2zeY6bIZZQ0hMhErfeFTJ
	 hm13qDeCCEFsa3Np9R/VfocqqttXFGS8AZZ9kfi1lgMsmWnUNNccY0/stIKTV3ljYvPIL
	 UeMJyHTP6ryRXOMhp9bfzdVfXCTRFvbIUUWXoAn7X9Obn79md+MyMFGrWQrY1M+N7NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217017;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=7URVc7o3JRR1dDuSGzQQg3OWzgW0GODYI4wXosfFHtA=;
	b=gqKPjEGEHJD5/h9Gao1aizrEBUIPPY/yvxSkItkgjgkfZIYtCje8BM/9sw3e7kK7HT30
	 BqCvtiiGfNMFsbXWF3lD75UVP4ODmrf0AbWxaK/gRIaJ0KzJEfNyIh3bkDd+7juFqzKtG
	 iNta/0ZjGQBD8xw+PNxPigMIh3RtltSOsNzym8YGXOXKa1UyJ8MJzN8RUUQ2NQ9v55Z+Q
	 ZuPDvAV+jHzOPNiPQvqmfWvzpy09p+PmRbG4m37h1SXgo/aYXYfVUO5vYWUj+XqFvqExN
	 d106swGZvBiQzdfalXNYnoTvOwcvFaBD+sxL/Eyp+2wV/SmnC6HKExOU4J0rwoyQzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=yEZ1Mksu;
	arc=none smtp.remote-ip=203.205.221.173
Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B7606D803;
	Mon,  9 Nov 2026 09:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC9B7606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=yEZ1Mksu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794217006; bh=7URVc7o3JRR1dDuSGzQQg3OWzgW0GODYI4wXosfFHtA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=yEZ1MksujhPaJhu98nIjUvlf1ctJSt0H+I5O24X6afc/SFcwPyHnjuoY++GL1Ti05
	 T75Io3DstlSNzUlINVwxswZB/2lucRkmRuwwyuyyhGsbF8bQBLP0WlxPR1yUGcERSC
	 c3e8iQNO+GV6cy6T/41T0sC/IvFmhqC8YHrkU7cs=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 92C850F7; Mon, 09 Nov 2026 17:36:44 +0800
X-QQ-mid: xmsmtpt1794217004tc1070voo
Message-ID: <tencent_DAD4F5EF899176A741D3DF28321F85A8A207@qq.com>
X-QQ-XMAILINFO: OODIb+W0Qwy5KSr0WYfIZAi+bqaYGwW+ieLwq/7LyUfj0DbkgoGhS/10m4aPtk
	 B7vUB9FxTwyyJSi6A0xRDB/PTOAu1rbbqswK6AuVx08Ph+2I+Mr7f8P+QsCOzhNIMi68t6uMA8D3
	 vcGoflh5hlIdpb0GtUf9jLeTCLJFOeYBpf4xZebjn283oZ2shJjN/37PUcEy3xVy18L475V7D9e9
	 DpjkgHjdb2Cqb18QcmRQ2E7bSKLwc+AlmVZW5TQ7e7i3OgSjM12X6L3kT1pZiI2nj2RoI6rDc/NH
	 AO86lV67d177Z/MJx6bl2k+0d727DFv3UL1h5/7blMpvVp81/qie7GmF6Sz8KeTWZAZ5OFrcZZrF
	 xljSGRKnxXJBIekW3JALtAVmZEVO+NyU6rA/xoB1roo2hCF9hU73kRlDdFYppr5fAr6tvPyng7VS
	 Gimc1pmNLNg2CUb2V5jocBGHrZyAvRQRvxdgSVGZ+9C1AND6Et1Ok6TEvzH7eJbPVvY3gC1S8cTc
	 Lsrzzwtm6kaYEcRdxxl3XXXlv2n7Cm1SzebFTTiF0Aw2la+yrVmmOvXShnBqRLLEUe9jXQd4MJpN
	 AMygBCJBhTDk/oH2pUGt7XtI82PPSPUIVGyjhT2bEskzViFboV/SXr9y2cNmKGYbRvPwgL0SWXx7
	 muLEJcdUpO0A7tzAHyDh2MPoJb0T91G7IbJZ1D5kNkCn4ff5eOuqmFqtqBsGitAyXn7TrcPs2IFl
	 aE8h0D9AVIFRJFfhv7c77KjexrEiwSfBHyoUQ31TLJMzwyC25eUAaTBWaJZU2/ibW/Ulmpu/LNbI
	 26q8nYhtJvhOuyayMEQs3RVswlsVs2IWC99dbn7xWhnbghGjSZX6FYENE8O00t5xnufzoi+9C2CI
	 dvs4LnmULXzlkVScjI6lAvbCm2QTEVUE4B8QkEg8Let995SRum4imv/3C6GzLlwpSsqKS5nOAABM
	 SCDiLrP0M0MCWNmx7qlxD26cI8onL1LjXP9a3P8FGFJpEfYoO1jMjr3H9wxZEb5HR7+Okzqq3o+D
	 aAsk2mi7A7F+UZ1LDiNj3cPQrzNz5uwrjkh2P4ncbBKCiNg+LpwS/DtHWtVSD3t8WOyEP+vabPX3
	 9fKToKrgwLsoVtULkE6swWCShlVDY5GFzswVsM
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c40-xfs-inodebuf-item-index-20261109@qq.com>
In-Reply-To: <c30-xfs-wascont-rideref-20261107@qq.com>
References: <c30-xfs-wascont-rideref-20261107@qq.com>
 <c31-xfs-logged-sb-geometry-20261107@qq.com>
 <c34-xfs-ilf-len-oob-20261108@qq.com>
 <c37-xfs-ilf-size-short-region-20261109@qq.com>
Date: Mon, 09 Nov 2026 16:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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

One more from the buffer item handling, again a different mechanism:
the number of set-bit runs in the buffer data map drives an index into
ri_buf[] that is never checked against the number of regions the log
item actually carries.

## 8. xlog_recover_do_inode_buffer() indexes ri_buf[] by bitmap runs,
   unchecked against ri_total

The inode-buffer recovery walks di_next_unlinked fields and skips
forward through the buffer data map run by run
(fs/xfs/xfs_buf_item_recover.c:625):

  while (next_unlinked_offset >=3D (reg_buf_offset + reg_buf_bytes)) {
          ...
          bit =3D xfs_next_bit(buf_f->blf_data_map, buf_f->blf_map_size, bit);
          if (bit =3D=3D -1)
                  return 0;
          nbits =3D xfs_contig_bits(buf_f->blf_data_map, buf_f->blf_map_size,=
 bit);
          ...
          item_index++;
  }
  ...
  ASSERT(item->ri_buf[item_index].iov_base !=3D NULL);
  ...
  logged_nextp =3D item->ri_buf[item_index].iov_base + ...;

item_index is advanced once per set-bit run in blf_data_map, but
ri_buf[] has ri_total entries, where ri_total comes from blf_size -
the number of regions actually present in the log item. Nothing ties
the bitmap to blf_size: a data map with more runs than blf_size claims
regions walks item_index past the end of ri_buf[] and the ASSERTs are
the only guards, which compile away on non-DEBUG kernels.

The sibling path xlog_recover_do_reg_buffer() validates the same
bitmap against the same ri_buf[] array for the non-inode case and
clamps nbits to the region length - the asymmetry between the two
sisters in the same file is the whole bug.

## Reproducer

All field values are legal; nothing is forged out of range. A buffer
log item is turned into an inode-buffer type with blf_flags =3D 1,
blf_len =3D 8, blf_size =3D 2 (two regions), and a data map of 0x55555555
(alternating bits). The alternating map makes every inode skip a run:
item_index reaches 1 after i=3D0 and 3 after i=3D1, past ri_total =3D 2.
The blf_blkno is aimed at the zeroed area of the device so that
xlog_recover_get_buf_lsn() returns -1 and the item is replayed
immediately.

  BUG: KASAN: slab-out-of-bounds in xlog_recover_do_inode_buffer+0x5a4/0x620
  Read of size 8 at addr ...
   xlog_recover_do_inode_buffer -> xlog_recover_buf_commit_pass2
   -> ... -> xfs_log_mount -> xfs_mountfs
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

The read of size 8 is ri_buf[item_index].iov_base itself. 3/3 at
mount(2); the unmodified image mounts cleanly.

## Suggested fix

Two guards, mirroring do_reg_buffer():

  item_index++;
+ if (XFS_IS_CORRUPT(mp, item_index >=3D item->ri_total))
+         return -EFSCORRUPTED;

plus clamping nbits against item->ri_buf[item_index].iov_len the way
do_reg_buffer() does, so the region copy cannot run past the region.

Unchanged in mainline as of 2026-11-09 (the function is byte-identical
to the tree this was tested on).

The reproducer (image builder, ready-made image, serial log) is
available on request.

Thanks,
Guikun Yang

