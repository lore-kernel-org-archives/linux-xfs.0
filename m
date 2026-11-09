Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=43.163.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233674;
	b=IcF8oJcCKI29YpM7OHTA41rldFPrfvqgb32CHT/mO0shMGtNVc9kY8xR40XNpLhpBWVQ
	 vRGqBy48DHifNNirseq37sMdxBEHz8mduCBNNelAfuI5FM/zwTWJoP8l3UeKd2TAjPE2f
	 TuNFugWs/AvqT8R6OoRHVodkR9Ug582v0ArWKlRjv5NMxELVDH5Vm2wdqczC30v5qeLcb
	 Puu9Webzj6eX6UAIBxeNGRB5bD3NfMeJhGClPSbgXmdzDMvZD3f0WqXOGjrQJ8pwLrwIb
	 QdnKIRypVoddyqWalMD3lIBEUB7xrgvnNf5UOJFMdTocQrab0u/zO8zz5dp0siPVBfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233674;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=U3XoX8Nw0Tal77GwMdqrGGYUZCmFgFhNxOIA90gY8nQ=;
	b=EIRfpI5Aq1O5vPvF7+/ftQkuD4OC60BBFIeVaPPwo17wmSsL3fdIhGw7rFvypxva5ZzD
	 Sex2RfJonAvhijNHv0p1ijEcO59oycec1ASw1smnTzyRBy/PO28rLjDzfSUC9VUyaPemw
	 eVTNb9wW0BaVq4F0k5VuNq4ZgFPIcZ5sqrkjpuB6BZF0vdqFJG15/7H5EJmBUJBzIvXoa
	 LKx6Q/kxuWpirwRAcOp+bH8G9BDXbgZG+3rzsqYX5NGXcmaUK+wWoKTQsSpbZDebnP44u
	 TX8nxPi8gfDrtCirhTWbNYa+s2uYwueZIdy9mRqSfUNSvMNBNyKLAOL8/5ddun6rbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="o0Vq/1wS";
	arc=none smtp.remote-ip=43.163.128.53
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E6C606D822;
	Mon,  9 Nov 2026 14:14:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7E6C606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=o0Vq/1wS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794233663; bh=U3XoX8Nw0Tal77GwMdqrGGYUZCmFgFhNxOIA90gY8nQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=o0Vq/1wSvnh8oHAyAd7KmeHkSeqbkcIiNAXNO08KCHTzWoaTish1eSI7yc47khRLX
	 XtcbmZfJUDjRn2/l5g2yUxYvM9sA7a5xcyEdbZDrTZLrNOU9eKNh6Lp2M2LcSiVDSm
	 uvGZUEY7pK++HTX9RXtihNkGf6w0cSBMTMzZRCzc=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 394BB066; Mon, 09 Nov 2026 22:14:20 +0800
X-QQ-mid: xmsmtpt1794233660trmgo08rv
Message-ID: <tencent_FE47489CBE4C51A30A7C80A23C5373BE9909@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuVH1jRJ41AdyCx15hn/wMBLD47GU6/lKGYBnKcZrF1K8onWXBY9
	 7GLDIFJ5/s8gIDXXP5vw3dfwLqoXzCMUiObPGmSK3Be7TWd4LJb4MsaXubndtvw4OuPWRm3EH5Wq
	 fpUWVezt2QWYzAxhrrWBtQNskENzPB8uXfK2da0WlHA9Zh/q/SrWyLlAMRc/dou7xfS+u0OAVTK8
	 2ofPcdS5gRmNiDewDWjWUZ/M0nkIn63ClTM458yozXVIuSHOY7HO0ansxkB9MNrl1GsodLxScghW
	 uL4HutRysOsoUYGXZjd7tCkUqsblet4oLddrVoCGywCDinGR0Rq08uHai242uMXw1+AZ306q6/2F
	 bPmt27Zo2bnPb7U8kXVTnSwes4LT2YpveGCcPEm6lnArFEi5KuGebc0nw0qkxTxfbq8d9vzG5lwc
	 ChRuzpHrRvMEh3khw9ctP3exxPCzxMgKKGO7uuL7O1KM1wr13Y7g8tNhNHB6HCi2LoLz3jikrOGV
	 kI+zJ42PqIx2/FKfLYmQT7WmsPLspT/0CllsffafZDjopDJohRWgG9YK9/1e3Iepdr4giSG7HFTN
	 70O6Ovzxla5Xma+TXSwz43fQ74o67b2NXPV/NW34HUSxs6f4ErRTHWyvjEY34M/x7otCQdN6dv/n
	 xadrRcJRwk18YIwel18NE8opGu26GyOoMZH2v0pvW+aOssTzz702b5DHQLN4SHBXqwA1TdN39+oc
	 ymL+J+4g/lXhxOlqAYCpwN8lLUQnzJq2bMyPiZ0Al0odG6AnpuMiWtur/fmLq5GlLfyEn93CnPLS
	 4sDvJ4rj2pMx3dMfZOR50yBYljL/wUqHD4UR6FDkE/QQRwgDOy2raEHiiEoniqChwHRHJ9RD7IBn
	 XZhQC91gtj0i58tvL/OBg78ZQapqO5HGSctmzj/VNywy8XIiZhS1ZQb9f8QDyYFuvWPfQuGQ+vGI
	 6xF4too41na9M1moGcwAPDDwk6GSDtwkiZWxf1fJfj6s9OU1JzCI7SBoaoabtRdXPH6fVYexFF/D
	 75ur4b3dOref0eLjcCriU/N+h4wBdlRPYHy9Eh7v6sauNmjml4H8rZNR4gyg6p1z+SAGMQEJ/uf2
	 +wSgHNB49JzlEQKZiXNS9qGp6ZXtBgGOVdbPYx
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c41-xfs-regbuf-run-index-20261109@qq.com>
In-Reply-To: <c30-xfs-wascont-rideref-20261107@qq.com>
References: <c30-xfs-wascont-rideref-20261107@qq.com>
 <c31-xfs-logged-sb-geometry-20261107@qq.com>
 <c34-xfs-ilf-len-oob-20261108@qq.com>
 <c37-xfs-ilf-size-short-region-20261109@qq.com>
 <c40-xfs-inodebuf-item-index-20261109@qq.com>
Date: Mon, 09 Nov 2026 20:00:00 +0800
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

One correction and a related finding in the same function the
previous mail discussed.

## Correction to item 8

Item 8 said that xlog_recover_do_reg_buffer() validates the same
bitmap against the same ri_buf[] array. That holds for the
destination side only. On the source side this function is just as
unchecked as do_inode_buffer() - which is what the finding below is
about. Both functions need the same two guards, not one.

## 9. xlog_recover_do_reg_buffer() indexes ri_buf[] by bitmap runs
   without checking against ri_total

The loop advances the source index once per set-bit run and only
asserts about it (fs/xfs/xfs_buf_item_recover.c:464):

  i =3D 1;  /* 0 is the buf format structure */
  while (1) {
          bit =3D xfs_next_bit(buf_f->blf_data_map, buf_f->blf_map_size, bit);
          if (bit =3D=3D -1)
                  break;
          nbits =3D xfs_contig_bits(...);
          ASSERT(nbits > 0);
          ASSERT(item->ri_buf[i].iov_base !=3D NULL);      /* no-op */
          ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK =3D=3D 0);

          /* destination side: validated for real since CVE-2026-80536 */
          if (XFS_IS_CORRUPT(mp, BBTOB(bp->b_length) <
                          ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SH=
IFT)))
                  return -EFSCORRUPTED;

          if (item->ri_buf[i].iov_len < (nbits << XFS_BLF_SHIFT))
                  nbits =3D item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
          memcpy(..., item->ri_buf[i].iov_base, nbits << XFS_BLF_SHIFT);
          i++;
  }
  ASSERT(i =3D=3D item->ri_total);          /* still a no-op in HEAD */

The only bound on i is that trailing ASSERT. The number of
iterations is driven entirely by the dirty bitmap, which has no
relationship to ri_total (blf_size). The commit that added the
destination check says so in its own message:

  "The destination offset (bit/nbits) and the buffer size (from
   blf_len) are both attacker-controlled ... yet the only thing
   bounding the copy is an ASSERT(), which compiles away on
   production kernels."

The same argument applies to the source index that was left in
place.

## Reproducer

Five field changes on a real dirty-log image, all values legal except
the ones being forged: blf_flags 0x9000 -> 0 (regular buffer), blf_len
1 -> 8 (4 KiB, so the destination check passes), blf_blkno -> the
zeroed area of the device, blf_data_map 0x7 -> 0x55555555 (16 runs),
blf_size left at 2 (ri_total =3D 2). With 16 runs the index reaches 16
and ri_buf[2..15] are read out of bounds:

  BUG: KASAN: slab-out-of-bounds in xlog_recover_do_reg_buffer+0x676/0x740
  Read of size 8 ... by task init/1
   xlog_recover_do_reg_buffer -> xlog_recover_buf_commit_pass2
   -> xlog_recover_process_data -> xlog_do_recovery_pass -> xfs_log_mount

3/3 at mount(2); the unmodified image mounts cleanly. The function is
byte-identical to mainline as of 2026-11-09.

## Suggested fix

The same guard as item 8, applied to both functions:

  i++;
+ if (XFS_IS_CORRUPT(mp, i >=3D item->ri_total))
+         return -EFSCORRUPTED;

or better, check before the ri_buf[i] use at the top of each
iteration. With the destination check, the nbits clamp and this
index check in place, the ASSERTs can go away entirely.

The reproducer (image builder, ready-made image, serial log) is
available on request.

Thanks,
Guikun Yang

