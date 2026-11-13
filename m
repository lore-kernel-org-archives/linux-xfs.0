Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582182;
	b=KXPGUwvcC0ia9rs6GAHyLsfPNEvQ//6jPRdNUdOnw9//DgRAcesJ1lFkMfHLYWGg12ys
	 A65zEBsxtmCIPastNoAc1gDHJyQH1kDdSmhjdu3L3188e8HdMcjaWplLwTruqDt1r4ZfZ
	 c2hYuaEv9/l8lvDi1jsNLEJMC/6PP1ZA4ZtU0MydLBQKixkWV+ciwPkjMtKOvowusJa8I
	 VCdw8lQQSSRKBdKPDnfzdtqXBMVBZrLMrIxCnK/rOzwJEBh+0PQWUSv89061t7C6wWC8H
	 hSa54+omOBHe/VolfhCRtg0PxZIHY8N8Z0CMQUY/KAkINvqO7xCtZWljMWARtLLF37g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582182;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=pyCq0NqkWUNbbpN2bi3/AvWqxCKTwLjFR2xE9UGzNYg=;
	b=PlzZPEKQ/lwykyktQTdvbKMjmzEliWvMKa9qVfwHN6lgfvlDpUP6IbSM8l7ebH3tJmCs
	 HvUrg1/MjgBSLJiWOsj7i3APt3qHkENdI4cy6RRbqllRg86O/A3CAfHo+OVrpEWCeCRvt
	 vPbD+8FbwQgZzx+xFfwtNVy5ZA/S9vujlnreifCwrSw0CvHvZi4lylQNFKblpIufYzfLN
	 vKTjYFkyHXfSRrpgFIkGTUkl6YWZNqyUtOr4QQMvYSlc6XT8AVYlBCv0jkCjzg6dvdJML
	 L8qq7cwwNX8sw9iq1l3F2J71e1Th/ekHNDWljuj5+AC/5Fioon1MdQBs65cqmus3qSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=plJ3a7SK;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD5C606A323;
	Fri, 13 Nov 2026 15:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD5C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=plJ3a7SK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=pyCq0NqkWUNbbpN2bi3/AvWqxCKTwLjFR2xE9UGzNYg=; b=plJ3a7SKuHDKsijoOtYJLNzd4B
	SJHg8Gi/AqZkN3WGUS4n8El3WbYaRU/XAfhDGmwtNbjw6HVUx1ZWRuzbOCyI7yiOXiSIucgECMW08
	l5AqewP/loZED/u7oP1h5rcrNXl611bMsV99CKEeft75Y4EkD5RpVOU/x5S8Vx5RRP8K6I+3tDbTj
	BzneIzYYZj00JXhPVwWge8OjBy4dXrJ83g6sU59yMU14FKH+tk9UbOLo/hhjvhG0lCimjzTViDbWQ
	pJISlA9grtvfcsHsUqPppgjP+u91s+dMp/zh7XYA0pZ9KPGQEt8fTX1XuyfMAfsWN5HHb5Qf6jdnT
	o1R6W30w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRsnp-00EpoX-0E;
	Fri, 13 Nov 2026 15:02:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 13 Nov 2026 07:02:17 -0800
Subject: [PATCH] iomap: don't update i_size of block devices on buffered
 write
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-iomap-bdev-isize-v1-1-699603b589da@debian.org>
X-B4-Tracking: v=1; b=H4sIAHgm92oC/x2MQQqAIBAAvyJ7bqEtUOor0UFzqz1UohCR+Pek4
 8DMZEgchROMKkPkW5JcZwVqFCy7PTdG8ZWhaztNRD3KddiAzvONVX4ZrTak9TIYcgZqFiKv8vz
 LaS7lA0NDnTliAAAA
X-Change-ID: 20261113-iomap-bdev-isize-a67166c971b7
To: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Hannes Reinecke <hare@suse.de>, Pankaj Raghav <p.raghav@samsung.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2852; i=leitao@debian.org;
 h=from:subject:message-id; bh=M/pgn12mnH/26a7TA8n6ANx9y8OZg9GkxYYG2atBOgA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq9yadmRLzrxGKs3AoxKma8P6Rf6CCENNLueOJ3
 SxRRHnDzNKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavcmnQAKCRA1o5Of/Hh3
 bQOwD/937/2daeq15i60vn65fr4oiPKmWDWI7sY9PA/Kuv55RKc8PFrkaRTUSTQKIE01OQZTUtQ
 ak5NkoEnG9x0MyXJywaTKDGeQZc1q0yNNtgIVpbilYGIhx74DtZBo7E7l2arH7/EPYyM/crEtxc
 QSP9L0CjvOe1NRxOoZIXXZUEjWylEdpzCf8TLLsYtvgimwg+qhxw767NtmEjjelyCO8x9y7+Xa6
 DxyV/9/vZ8GRzUUPSsWPXoODByN1knw/SSZolCyljgzduCSMiucrKMWM1xVLjtiv+2owvq/XnJj
 RkbBe4JCAw8rXu3l2jFEXdeiyqMml5FST3JSccNdcUCxncaKt1BDRQzY82HlAl2LjspjgUzKPoo
 5f25nhwxLtj1a3uOCgrrtdhnBm7rc/a/x9wzSQrg4qWPlI7EtTfOKXVHwR/OFq9yibBmki3veRE
 PMuhVZuskItjMgD2KzcvAFGL6DcvinvEAIT3wC8NSS99WP7RrnvXCHwHQ1uY21rz0yHuobL9rot
 0VRwzJSobQ8e1ZkGeh6Ku3RoklH5hZO2QnxEvwHKrmtEg9/xH5iWtf4S0qMuTJtE60RyUWByhVb
 nSNb0lCRJj1NJ6eJVQIpZu5UF0nUa5TkCgOmNcxpu5QxJRN9dmy8RYN4glYGzZBF1+wSNA6dHGs
 GNWvfubNmvLQabg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

We are seeing this warning on an arm64 linux-next host while the ublk
selftests run (stress_01 deletes the ublk disks under fio buffered
writes):

  WARNING: mm/truncate.c:902 at pagecache_isize_extended+0x37c/0x490, CPU#40: iou-wrk-3496756/3497370
  Call trace:
   pagecache_isize_extended+0x37c/0x490 (P)
   iomap_file_buffered_write+0x38c/0x5d0
   blkdev_buffered_write+0xcc/0x138
   blkdev_write_iter+0x32c/0x4e0
   io_write+0x77c/0xff8

The theory is that the disk shrank under the write. del_gendisk() sets
the capacity to 0, which writes the bdev inode's i_size under
bd_size_lock only. A writer whose mapping predates that reads
old_size == 0 in iomap_write_iter(), sets i_size to pos + written and
calls pagecache_isize_extended(inode, 0, pos). blkdev_buffered_write()
holds i_rwsem shared, so a writer at a lower offset can store a smaller
i_size in between, and WARN_ON(to > inode->i_size) fires. Even without
the warning, the write path regrows the size of a dead disk. The block
layer owns that size (bdev_set_nr_sectors()), and blkdev_write_end()
never touched it before the switch to iomap.

A reproducer on linux-next supports the theory: 128 threads doing 64K
buffered writes to a loop device, while another thread flips its
capacity between 1M and 1G with LOOP_SET_STATUS64, hit the warning 6
to 18 times per 30 second run (4 runs). With this patch it never fires,
and data written through the page cache still reads back intact.

Skip the size update and pagecache_isize_extended() for block devices.

Fixes: 487c607df790 ("block: use iomap for writes to block devices")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/iomap/buffered-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d5f7d..3a171a70e6adde 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1256,14 +1256,15 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + written > old_size &&
+		if (pos + written > old_size && !S_ISBLK(iter->inode->i_mode) &&
 		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
 		__iomap_put_folio(iter, write_ops, written, folio);
 
-		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
+		if (old_size < pos && !S_ISBLK(iter->inode->i_mode) &&
+		    !(iter->iomap.flags & IOMAP_F_FSVERITY))
 			pagecache_isize_extended(iter->inode, old_size, pos);
 
 		cond_resched();

---
base-commit: 6d582d78fad9d828e575ca0cdcff8ea47a77220b
change-id: 20261113-iomap-bdev-isize-a67166c971b7

Best regards,
--  
Breno Leitao <leitao@debian.org>

