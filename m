Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711610;
	b=pT9HEelC+TI0yQfB+vZNbQ3Gbu9N0li7u1KuCwz8i1iR5rfOSO/fjMrBr1TxBjtGZ6DF
	 9uX2XXllvOdnGnuGZlz6gsUT8Kwczo0Y0O5j/YRXi2Kq0pVFKeS8sr2igJaNuti6D9gTf
	 XcbwPz6vGDldCyaYXBA+xkIMQGmeoUw369iZtlz4IsTcguKAISzMmkFQSI6AdY7GvV0ah
	 Nd/WXnJhoIMDsH5BFVnulxa9Au1U75K9UmuVq4LwOoRRUcfmdcwStWs7WFaGYo4A0nj/D
	 K+zuCgSec5evK1Jrz9kx+Yqp3z4HXvE7y7pycCdXJapw3RoVa6uUxL/aWR2a5Icw7Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kOGxYNVW2wrnLOTIHiu/pqDSoEBKFVNoXpaDmv0t4qk=;
	b=GAFHu0Q5GOju6WU4SqDmuW8fTYU/jsMW68Yjjxm1jye/Ui2GuEHrvYnVr9O/nZ7v/6If
	 +MR+bsTVwanIQQUVUN5IPUd3i3iJStzKwKyao5cDmw3lvdHBzbHwgw+c3cVuONks1HNgy
	 6dKN3ig7T/tXicS0qw09m3TWdgqS2JqE4L/pzj1llhprUsPjjCRM0v9Fd0pDZxn+hYuyJ
	 3u2p7iefH5F6lEjsudgNznhKT67Fm5bYHZuAudEC0v7QM4CH8hoaPS5S7RPdwy1ZRsCBo
	 9X/pZT5lnbIiZdZUB1lcyjGJ9BhbUS9hMDI+oCaLvLUcZj0Lcy7YlgyMsRMavJo7Bxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mWTqMjoe;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000BA606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 16:46:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 000BA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mWTqMjoe
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so45123285e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795711608; x=1796316408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kOGxYNVW2wrnLOTIHiu/pqDSoEBKFVNoXpaDmv0t4qk=;
        b=mWTqMjoewMbxm4L+HwwCYbHs5P5GKC6kRgs75+ndfpy1KinlVB3mITXX5C88eYq6b3
         VNAzCjruyin9iQudAvRhVLM68l8NaQgQ1GZE1k8Qu53Wycsjz0Bvd3qeio+reW6X5EEe
         aKMPueMuKiQ8qTq4er2gIpGLA53F6MJjIjSIkg/FaAZNsQDItSqFG4QpI19Bi8FBUxcx
         e/NzqpBVUC4mnwATYCldtNOqo1N7/emObYPjnUkcw7Fj7i6vSGfsD4IopIfqe3uqJ/Qp
         HNT2X/fS5ri8L/uiFKky87S9KHHu/HN5lHZ151L3WwXHFG4MbhCot+Fzz42jIhRLNoCE
         lDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795711608; x=1796316408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kOGxYNVW2wrnLOTIHiu/pqDSoEBKFVNoXpaDmv0t4qk=;
        b=MT1BbJSq7zjISMu+evJf/iLa9jdhW0JV7lku7YvQxmUsjrU2TX/dCNigpFO9h3cNRM
         VK5pHVxlvyoyqZdfK30i6iDVMBy2MLBvrfwcznh8+ROS13X7eQclpWy925QmshcZ5A9L
         y6uO4b4Rvkk3vZdDfjmWpOx0wPj4BKp0k9CWsi38y5bmYVG4xqljUnpgP/AygidzKgo0
         dnyWOrW6fIVKZjaNg9lOYxW4SeqLaK4kIciiGlXMbB2MFK+0vTSjvuwBhcCMdnohhUnm
         eAEfzXSKOERP7S5E/iIsALKbm+kXg6Y33Y/wt4KXrC7/f9epHi/lTtkrTNQjEVONk8xq
         wN9w==
X-Forwarded-Encrypted: i=1; AL+hErHIcA8uoQdgn0nNkceCFhneYQ/KIcfEDLgVORhgVhJpj7IuqTsYBU+Ja2LESwtCDaHU1TePELVgZdk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/b4iQPD+o98Ui7fR9axWxQvRHb0dn4XKsRtjEG7Xw/LRTgkQ0v
	hmkBRaJICPMnDnZaWGdlAO0Y9hHq3LAt8bhiOrHuvxUC9rmA5SZ+Jzw+
X-Gm-Gg: AZFdTZc8/BnFnmKoEPw6NOAhDBksxyjG0MAVAWXNC7DhAD98QbiWioJ4pa2r9MBXNWG
	CDLU+EHha5qOFiQmCynxj45M5knJvteBSNnKZqzUjwMD8vpiWwbQmrkJz1BzNfkp0Oxov5+t9Fg
	gpecw32Ax2KjrxDf8rViE3f9zHyjsqcCKrxZQA2KOqFGeSGz7QJuSnrwq+8q/IMEiWdeb284mYp
	Yw46lAli17Fnl8p9gEuOfcIMEBlHqoe/DrpFImrJhPmlLjKBJX24LJTRf/ivZepcDka2zKQrEjY
	iZzw9xQvHhyZP6UvYFzjoVTaEQeehTEOgK4XeyLwmR1pHsd5X9AF7wg0NvPLZ4w3MVaO9M2fNgf
	rATjJw+ZFYCSZAMk9JMPPFccDaF+RvZPOOsum6S149v1357rphED034jrqbxNg7TNwVHygZHw+T
	VoWGjp/qUd2PXtma+jPXpMGLWrE/JtkjTyI5oU6FC/43zAmvk+R8cNbXdaqf4rA8B1OuYNWS4f+
	+NWKT2N8UnjqlPwaUaPvcUQsZQqoe4CbTjkqXxQ79o5lEddlIgsbOFMgkBzHHI5fWwl4bVB6kd/
	XJ8pKTQQYOCYFQ80OryICwsAVxUTf1Y7UB7OscsQ8pzEEd/hrcA2k+bAktQVQgKLDO3LHqTY/xx
	80BVJx0FSf/3YpGVTZh8G1G9fDoJNtjiKOYRt0A==
X-Received: by 2002:a05:600c:1d09:b0:4bb:66fd:ad68 with SMTP id 5b1f17b1804b1-4bb888160cdmr462163425e9.14.1795711608055;
        Thu, 26 Nov 2026 08:46:48 -0800 (PST)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bbab390cf5sm103533445e9.7.2026.11.26.08.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:46:47 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dgc@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	linux-xfs@vger.kernel.org,
	syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com
Subject: [PATCH] xfs: wait for buffer unpinning before shutdown completion
Date: Thu, 26 Nov 2026 17:46:02 +0100
Message-ID: <20261126164604.158012-1-parri.andrea@gmail.com>
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

Changing an XFS filesystem label while forcing log shutdown can trigger a
use-after-free in the CIL push worker, as reported by syzbot:

    BUG: KASAN: slab-use-after-free in __list_splice include/linux/list.h:577 [inline]
    BUG: KASAN: slab-use-after-free in list_splice_init include/linux/list.h:619 [inline]
    BUG: KASAN: slab-use-after-free in xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
    BUG: KASAN: slab-use-after-free in xlog_cil_push_work+0x986/0x2a90 fs/xfs/xfs_log_cil.c:1417
    Write of size 8 at addr ffff88803ac995b0 by task kworker/u8:8/1160

    Allocated by task 6137:
     xfs_buf_item_init+0x6a/0x6e0 fs/xfs/xfs_buf_item.c:872
     _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
     __xfs_trans_getsb+0x65/0x4a0 fs/xfs/xfs_trans_buf.c:191
     xfs_log_sb+0x43/0x200 fs/xfs/libxfs/xfs_sb.c:1327
     xfs_sync_sb_buf+0xc2/0x290 fs/xfs/libxfs/xfs_sb.c:1479
     xfs_ioc_setlabel+0x1d7/0x340 fs/xfs/xfs_ioctl.c:1081

    Freed by task 6137:
     xfs_buf_ioend+0x235/0x790 fs/xfs/xfs_buf.c:1167
     xfs_buf_iowait+0x133/0x420 fs/xfs/xfs_buf.c:1336
     xfs_bwrite+0x5f/0xe0 fs/xfs/xfs_buf.c:1239
     xfs_sync_sb_buf+0x172/0x290 fs/xfs/libxfs/xfs_sb.c:1489
     xfs_ioc_setlabel+0x1d7/0x340 fs/xfs/xfs_ioctl.c:1081

xfs_buf_submit() completes a buffer immediately when the log is shut
down.  It bypasses xfs_buf_wait_unpin(), so xfs_buf_item_done() can free
the buffer log item while the CIL still owns its pinning reference.  A
later CIL push or checkpoint abort then accesses the freed item.

Quotacheck hits the same problem at mount time:
xfs_buf_delwri_submit() passes pinned buffers to xfs_buf_submit() and
relies on it to wait for them to be unpinned.

This became a use-after-free with commit d2fe5c4c8d25 ("xfs: rearrange
code in xfs_buf_item.c").  Before that commit, xfs_buf_item_relse()
returned early while bli_refcount was non-zero, leaving the buffer log
item to the CIL abort.  It now asserts that the count is zero and frees
the item.

Wait for write buffers to become unpinned before checking log shutdown.
xfs_buf_item_unpin() drops b_pin_count and wakes waiters before it
takes the buffer lock to fail the buffer, so waiting with the buffer
locked does not deadlock against the CIL abort.

On a shut down log the CIL is aborted, and the buffer unpinned, by the
next log force; the periodic log worker issues one if nothing else
does.  Pinned buffers on a live log are already waited for in the same
way.

syzbot's C reproducer ran under a KVM guest with KASAN, PREEMPT_RT,
four CPUs and five workers.  With this change it completed 191 seconds of
active workload and 2,208 XFS mounts without a KASAN report.  With the
change reverted, KASAN reported the UAF after 74 seconds and 664 mounts.

OpenAI Codex analyzed the reports, implemented the suggested change,
drafted this changelog, and ran the tests described above.  Claude Code
reviewed the change and revised this changelog.

Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Cc: stable@vger.kernel.org
Reported-by: syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d8e687768d0f38c1f09
Reported-by: syzbot+a4fde844548510369112@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a4fde844548510369112
Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/aqI6v-_dc2DDSbgB@dread
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---

Jeffin, Cc'ing you because this touches the BLI lifetime that your log
item reference counting conversion reworks.  This is the short-term
xfs_buf_submit() fix Dave described in the thread linked above.  It is
meant to be small enough to backport and does not replace that work.

Processing of emailed #syz test commands is currently disabled (see
https://github.com/google/syzkaller/issues/8122), so the functional test
results come only from local runs of syzbot's C reproducer.  Three later
10-minute runs of the unpatched kernel did not reproduce the UAF, so the
191-second fixed-kernel run provides only weak evidence that the race is
fixed.

 fs/xfs/xfs_buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629c1..4acd0c3451da9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1382,6 +1382,9 @@ xfs_buf_submit(
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
+	if (bp->b_flags & XBF_WRITE)
+		xfs_buf_wait_unpin(bp);
+
 	/*
 	 * On log shutdown we stale and complete the buffer immediately. We can
 	 * be called to read the superblock before the log has been set up, so
@@ -1402,9 +1405,6 @@ xfs_buf_submit(
 		goto ioerror;
 	}
 
-	if (bp->b_flags & XBF_WRITE)
-		xfs_buf_wait_unpin(bp);
-
 	/*
 	 * Make sure we capture only current IO errors rather than stale errors
 	 * left over from previous use of the buffer (e.g. failed readahead).
-- 
2.53.0

