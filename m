Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883141A77C
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 23:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207824; cv=none; b=jjQ+C8wzhnEbtO19VumBvcC8HAIk/BEHamN+LnZMLo0o5Sqq+h/zRe+uNo1+N0JbVGrmsb3VhUiHEo0CrsF9Y5OKEfbJdTHIFaQvb4Abf1ih1/mvJWYMtqLhm7SZHZzzP69GMABkIhaSUtqNaPaH6Eb50pFzW290nZx0uKPqZvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207824; c=relaxed/simple;
	bh=yXeThnqDkkqQfZuxk0/UWy3aO+ZnELynhrbLzksgHI4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YeJlufsl08XT+nzWwSY1Ky5xXbdbBpihXs+lnwmPdWQRUF+np+S43JSZp/YWd/Vy9i+u3YtzYYl+xOSY93ZoC1fuTo7naH9xznb9Fh3BsXqXLkbGr58nnUj7tRWlLEBB+cOvS10go7KS6y94CnaH5DCggGIgv5t24BBHjet+52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sj5b9uc4; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=yrwTXPMc; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sj5b9uc4";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="yrwTXPMc"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NNEMX8047257
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=tePV
	uFSvZh3YZ0vx9H5UbQsBPQSfTF32xq8p5PG2Idg=; b=sj5b9uc4LsyptVKr+OoE
	eTMaUxHRYpb0oukkyF9M/sqlvTEOh384V1RPIGb0H5/FOmaet2XLIrc41yPXv2He
	5xvT4roMGFGCne6FCJbUVnbuC3jjxf0MUi9N6xftBPxSoh4Q9Mq2IMEkS1NBavIC
	0xfX39reA6e3SCDTn64JhDwVB/Jx7SaEY/Y53RxEloAMuf+DHyy9QP0335/gjXjJ
	lMT1QPKwXyWbKt4it30YDciqfjjzF/mjEEYDvbazsLjWRAqlID1SgoPHe1wMJTKl
	dXgcBH0+SK2UrTX7hW46hENyx8jdx1jBYhZ33z+T0/gS4377Lc9EqSGL3aa7UFKW
	ZA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gvhrem5k7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:56:59 -0400 (EDT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so2743646a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790207818; x=1790812618; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tePVuFSvZh3YZ0vx9H5UbQsBPQSfTF32xq8p5PG2Idg=;
        b=yrwTXPMcEJinzT4ktvTbKKrgLFxQ56hHVJ86zqbTwJyyA96yhmNTV1a3mqiyFqL0al
         nDZQyFK56u3mZpR09kakpJnLpQS4CbWuUeJNuJtGz250l1xXTkAp/1rssRDiW67vuZqF
         3LwtG/YrNHT0PTPErTI3GGt8Z3wD7BsmvvFS1bI5UWFWhp6qrnnJp/irfzIjThBphy7C
         vBruNu9BzXH433BW1GE0Qi/y8D3EgYqUP7JH0oIPUqFZeSRi6PKGbTAxNQ2xCypOdXeD
         durIt2Kl3L+R1ntqStICQdVWeM91ACG6qDwfCoroMHPfiSKZf1LcWGiOJE1P4/tt+PqB
         ZYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207818; x=1790812618;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tePVuFSvZh3YZ0vx9H5UbQsBPQSfTF32xq8p5PG2Idg=;
        b=nOQ6x8WM8hvkKA7RnLOGX5b11zw7XZTv4p4Id84IBjvowq5EyR4FDPtZmtfh60vgeM
         0A8Xs3Q4W7JXaxCE5dNwQ17AYGHCF8R3O+i9NlxeOOWO/wEbTgPmOXelm7n9MemHFtRg
         Y5zuQcYoPBpDSB0YhGxyp37yNel++O70wNx5jjxSId9MvGHzh8R+2X9My1Iwyzwd9Pob
         og1KVxVaCg7mGeXPtN/EoHll3THKzsl45k5ohIAtrLGDorX0kMGEX1+/RbUUrDPMne0A
         iYxhbd9bovXPrTtQleqjdu9OFpB1llAdbBbZgBo1xQ0++neFrC95QzvgyfYe6+oKvRpn
         61KA==
X-Forwarded-Encrypted: i=1; AKwUvBxHgwsIbl7ahTvqbGhwogPHaMs+o4prLD+OjmYH9fJZ0BDXSRVvtwIxordewjkiHZv4iRqwmlqyPhY=@vger.kernel.org
X-Gm-Message-State: AFuF++lBavA2aDxEK1zUYm7eRV0nlpPIjhScouTQjUCvel5iqsZDfXiB
	YhByl9pqIby8Jl3rQbUnrlB76OocRG/DTkjCVi7G3olue2y/gqyekLkEkCmNz5WtGYQyONUuI2O
	UmeEOrWfpu05hnnteOLWymvlj8oMANrVOgRWIRmhMA15kST1NNtlOletXgEzkiSdJ9Q==
X-Gm-Gg: AYBFou2+SI/kFQKF2bbgh/dffwqhenwd3XaPK/afyAtSBWrJblbU4c3V5kcCRU6Pum8
	lkDv+J5FGy0AVELPHK/Oh5CtZ4f5L4dVs4I2s9omUAU/bqpOL+4SzPH89w5v/WTeK7prIJSsPZM
	5RKwVHFXPUf3Nm9TIJx3pWxtY5FpsCb8GeyHNOQY/9fl376O/DdvlBj/Y8/sZy+wrcSK6UfeYeG
	bjyS6J3brDCanjOPt9V4nUcj+tPyRGkWdTQOrMU/ok6fL0Shtuj2TAy8FR4IrFiEUjF9q/1FCwU
	3jhDXiIOnRYX4ehk3x7Ubb9kcRCy5n31QCerfaXHPG4fERgjO3i9JIxgDKXbigib/Lp+8J67FQB
	7FgBRTp3SkuhGiTUObUxEwZkeDS34H2KwJd64A14S8wxVvQ==
X-Received: by 2002:a17:90a:d603:b0:39e:4d1e:d47c with SMTP id 98e67ed59e1d1-3a098606bdamr610952a91.25.1790207818515;
        Wed, 23 Sep 2026 16:56:58 -0700 (PDT)
X-Received: by 2002:a17:90a:d603:b0:39e:4d1e:d47c with SMTP id 98e67ed59e1d1-3a098606bdamr610921a91.25.1790207817951;
        Wed, 23 Sep 2026 16:56:57 -0700 (PDT)
Received: from [127.0.1.1] (RED-LION-HO.car2.Seattle1.Level3.net. [4.53.155.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976ca5f9sm1331613a91.14.2026.09.23.16.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:56:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 23 Sep 2026 19:56:35 -0400
Subject: [PATCH v5 2/9] block: take i_rwsem for the direct I/O write
 fallback
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-blkdev-fixes-v5-2-89e60d66eb38@columbia.edu>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
In-Reply-To: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        John Garry <john.garry@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sashiko <sashiko-bot@kernel.org>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790207813; l=4766;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yXeThnqDkkqQfZuxk0/UWy3aO+ZnELynhrbLzksgHI4=;
 b=QkG2d8Jbv7plkdNQIPKBKPZEtuwiBr0JNrWEczqcHSyaxtBfP4cb6kna3/skQP8mwhum01j+g
 xPTvsnpqIsgAJj1MhM7jYr4Q0lcCwmgWXpAHraJW1U79pTS3KeTw8CI
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: 7Kw5yNhCtjb-uzzjeCfJOcVPSMNGpD_w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX6nPpJTHsOcBi
 3EoTWBcz9HTJ9vGfO43OLHhMGPB3cwDouOtZhuYNWgpCOwU3kRoVSyJDGp80Kx7IwsDQWqUaGT8
 dX2oamztm88mOjNqgyv4IBGDTb7OrPgOBBsFE8WakNXeZNywBDR8h+i9PSZ0c9sSdRbnMxsUnSd
 PP/16bTBzinfAiwq4AoaKlZfLHU7kq8jEBs8nMTRKfD/lrlZK/6UcUEpchxFCnfqGLVV26rkNgD
 25JQMU4HhwJFjRQ5GBaeBQ9/pr39moT27oqCUF/5ZMLz3HFLp0eVbQuZj+FW+KhDijC348srcFD
 TZVv61jsMCtCrbvZQzgJXnVx1DP6VOlAlNsmEpMCIznclQXAcIzaZb4glwCoVYRRQ5Q24vNzhbI
 IjD6ggSq9zTK5+qbQjBefWKvHAj5XqR4qMVMPZX4LkPi5DVcqADrjVgdAdcQN8qYMDP4foguUow
 f91+81dKsdosIvCUmFw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX2oNxkmmSqk5H
 MTIrQMWZ0mqwJEyMvBokzXbu5SiGMvO3lpEGwdrBGVNi8DXxEuKUQLKnr8j1n2wAbz3j+OibmwW
 9f8jAMV+LjxVww+HWvXShwfuags6E2L9Q5w+wLYQoC6x1mEUQMbb
X-Authority-Analysis: v=2.4 cv=J/A/fwnS c=1 sm=1 tr=0 ts=6ab4674b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=6aZ3Ysb2zzbY2sELL/OBJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=NEAV23lmAAAA:8 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=JF9118EUAAAA:8
 a=HaKTZzbUtGO3MgJEFeMA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
 a=GvGzcOZaWPEFPQC_NcjD:22 a=xVlTc564ipvMDusKsbsT:22
X-Proofpoint-GUID: 7Kw5yNhCtjb-uzzjeCfJOcVPSMNGpD_w
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11914
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 malwarescore=0 phishscore=0
 suspectscore=0 lowpriorityscore=10 bulkscore=10 spamscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609230100

Commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") closed a race between set_blocksize() and block device I/O: with
large sector size support, set_blocksize() can change i_blkbits and the
mapping's minimum folio order while a concurrent reader still holds a
folio of the old, smaller order, leading to crashes. In particular, it
made blkdev_write_iter() wrap buffered writes in inode_lock_shared().

However, the direct I/O fallback path was missed in that conversion.
blkdev_write_iter() passes blkdev_buffered_write() as an argument to
direct_write_fallback() with no lock held. A direct write that completes
only partially then finishes as a buffered write with no protection.

This can cause a BUG by racing partial direct writes against
ioctl(BLKBSZSET). Writer threads issue O_DIRECT pwritev() with a
two-segment iovec whose second segment is an unreadable PROT_NONE
mapping. The direct path then writes the first segment, fails to pin the
second, and returns short, entering the fallback. A second thread keeps
toggling the second segment's protection so that some fallbacks get past
fault_in_iov_iter_readable() and reach the page cache, a third thread
populates the page cache with folios of the current block size via
pread() and readahead(), and a fourth thread toggles the block size
between 512 bytes and 64K with BLKBSZSET. The minimum folio order only
moves with block sizes above PAGE_SIZE, i.e. with
CONFIG_TRANSPARENT_HUGEPAGE raising BLK_MAX_BLOCK_SIZE to 64K.

On a CONFIG_DEBUG_VM kernel this yields the following BUG:

  page dumped because: VM_BUG_ON_FOLIO(folio_order(folio) < mapping_min_folio_order(mapping))
  kernel BUG at mm/filemap.c:858!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:__filemap_add_folio+0x860/0x8d0
  Call Trace:
   filemap_add_folio+0xc9/0x1f0
   __filemap_get_folio_mpol+0x240/0x660
   iomap_write_begin+0xa87/0xd70
   iomap_file_buffered_write+0x304/0x6a0
   blkdev_write_iter+0x255/0x510
   do_iter_readv_writev+0x23d/0x3c0
   vfs_writev+0x211/0x7d0
   do_pwritev+0x121/0x190
   do_syscall_64+0x121/0x630
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The same workload also trips WARN_ON_ONCE(pos >= folio_pos(folio) +
fsize) in iomap_trim_folio_range().

Fix this by calling blkdev_buffered_write() in the fallback path under
inode_lock_shared(), matching the plain buffered-write branch. With the
fix the same workload runs clean.

A short IOCB_NOWAIT direct write reaches the same fallback. Taking
i_rwsem there can now block behind set_blocksize(), and the fallback
already blocks on writeback of the data it copied in
direct_write_fallback(). blkdev_write_iter() already rejects a purely
buffered IOCB_NOWAIT write with -EOPNOTSUPP, so do not enter the
fallback for IOCB_NOWAIT at all: return the bytes the direct path
already wrote, or -EAGAIN if none, and let the caller retry.

The reproducer used was written by an LLM, and is available at [1].

[1] https://gist.github.com/tzussman/69d06bc57d42a42989eb038b1b5aeb74

Fixes: 3c20917120ce ("block/bdev: enable large folio support for large logical block sizes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 8d74d0e57f43..7ff78b448659 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -770,9 +770,26 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
-		if (ret >= 0 && iov_iter_count(from))
-			ret = direct_write_fallback(iocb, from, ret,
-					blkdev_buffered_write(iocb, from));
+		if (ret >= 0 && iov_iter_count(from)) {
+			if (iocb->ki_flags & IOCB_NOWAIT) {
+				/*
+				 * The buffered fallback blocks on i_rwsem and
+				 * on writeback of the data it copied: return
+				 * the short direct write instead and let the
+				 * caller retry.
+				 */
+				if (!ret)
+					ret = -EAGAIN;
+			} else {
+				ssize_t ret2;
+
+				inode_lock_shared(bd_inode);
+				ret2 = blkdev_buffered_write(iocb, from);
+				inode_unlock_shared(bd_inode);
+				ret = direct_write_fallback(iocb, from, ret,
+							    ret2);
+			}
+		}
 	} else {
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with

-- 
2.39.5

