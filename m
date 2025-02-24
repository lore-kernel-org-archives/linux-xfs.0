Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C27024166E
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740384883; cv=none; b=m5tS5rOYkwNc/cO5qYd3aUrSK0cL9BCDw8fA2tx32B2hwuMng1qkN71ZjHP0y8AnHpub0kXl+VCE0tQPPxe6Onzh97dn28ODQn888I87Lu0vNuv1bl7lDoloFeLBivpWlhxoa4Fd+1HBQsyt5LIjo30Dw6wpkxGSWHV29z4nYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740384883; c=relaxed/simple;
	bh=oe2FyQpDi+XexZe/0gZrbR4F62iNxsAIMF/U5rlF8BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WdheEBJVg4xPmy8dZ+m7sAaoQukyG8//IjKwb7Ef6IAwPQt4KggQ7NcM0XtAdUMZ5gYq/q802dshBlLbCgnxGPE7TEZ8RBt9NyVfhK6BDMMZPO5CLIeygOFRQ4RDiyF6/q1XTlXuYF/eTT3r2OmMi066VFmhKZluu8g3R5adryY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=lByyWHai; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="lByyWHai"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-221050f3f00so89041415ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 00:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740384880; x=1740989680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n59C1mxnlqsVZDv+OXEoyoWE/LCHOE1N8E2Z0O569dM=;
        b=lByyWHaiC+WiEErxkPqA0M74SH9tASd9NyfWsYUjzIW3LkBcvIvQ9YNU4DI9Y/D9nU
         uZMKgmGPDKmdkFhr/eQ2lwWZAcc3QnXEi+LGVrlEBIQG22pK7/EljwlDAp7b11FyA7FO
         S3uQCVxRCJ9Khpesug7glVI5morIO/PFaw2XFX46LUbhOR7LwfuEmAp3WbH1XmDdeQP1
         kK0BBWKO7QFWc88Kvc7e1J7GHww50mU5ISjiGz2vlzu6rgfNp610OC9xwHUxQGPX2Q9k
         mrf3Sgb9W1Ij1VCpOJAq6T9uEXk/XCHMd1MlHXgH8kfhDtkUTGQmbLoSZNmEc2Wu5ufE
         j22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740384880; x=1740989680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n59C1mxnlqsVZDv+OXEoyoWE/LCHOE1N8E2Z0O569dM=;
        b=j7fVs4xceo1JBrVsGq+KJ1ifdgtEYDleiuobYdAGGE9bNHaD35+ubxHJpgNlBWjPnm
         gowA8ChfFFAmiueSeH4SfCpLKmSJkJ4OYnVBm0aK8M9+tb9rQyf9pB02qZe2BnQl/bqf
         tryqnXJ+gsRAMI1pVwKn0xT+jiJgjcpUUo66pgm63ur97HqPxogqNcBG/prRd7RWUJHL
         jjssndyg+nSy0xwEXtOm/BXOVWjjklBS1W3MUhove3/lfNq0s359yVImVFY+kGgGU424
         w06N6ifNH+pjIXi5mQFYC4YrQWALY0h0L/Ge8AOPALPse7840du0SYVvqI1nKFVkyOB6
         r8aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp5bQydQEMcZ892XKA+QlLWpMgUJwqBKlVyBMYY/UhCUAjxBrImIB7mWcR13TX6XgKm1suzh5TEUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKpRJQTL0DadUhcCSf1n0rWQyS5GsX850n848S6qFcJpgHWTFJ
	iHMBbymxM0VtMAbNzrq1YvQ4PWvD2Hxg6Om7wKWWyBrDRC0Tpj56wGmk3QmnQ7zWqZ8mKIzKW3C
	DJrI3HeEqzdJl6T/RDEhYjbB4ntAjz9/QHcLRue+6//Od5STrAy4pxFoFtTpzE7CZtneUy875JF
	34UqGedU2BfMuHx11XoCoTLuVlLcMANwGHTV9lK+mpMsjeAFSlw3er6kJ2zNpjIvcoqKG9q8dkk
	PUeD/hSp608z8iR+v8ZIBo2WEh+Z1FHy0u4nmXvE+G4iYMli+Zylyredn2jn8OuKrXnnDEe3NH3
	IZR+F6a1AW3rcRQjGGGSSith3fkt/ywO9A==
X-Gm-Gg: ASbGnctcKfiA2ucdkCGuNIDnrN/FS9OpTUp+HlyfeDb1116Slb1sz29scDvuYnGVyGQ
	guhbICvyC4kW8ITLMXb6k+q63Wa047Yh23ydWX5nhwBoTh4TNHFVZig8nIT/NfAeRMH5tceV3SY
	5H49VNolQxkBNP6FjOISuWcHI8gFLOQ9wQa5db49lQiHROwMTgLD81P9QMMNpaQ/UZQHawz76MD
	H9DWMZXkY8i1VEs70G/HZ0z0k4vQ1SQVXHhrCRai/Owbc1XABVMgwntRZkIHlcUTcZ5+qiN3+8d
	uJ7J0OkO1SatApXSoLBhzM7U/GKk3A==
X-Google-Smtp-Source: AGHT+IGZML+QeMBAJSjHG5iq0A0nDtnil2LVDOPQzKcK170nIopsu8yPUqb4/J1ur3vn2QrKyGEe6w==
X-Received: by 2002:a05:6a20:7f85:b0:1ee:d6ff:5acd with SMTP id adf61e73a8af0-1eef3c568e9mr25167734637.6.1740384880406;
        Mon, 24 Feb 2025 00:14:40 -0800 (PST)
Received: from localhost.localdomain ([2a09:bac5:7a2:24be::3a9:82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ae1ee4febb2sm10280324a12.51.2025.02.24.00.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 00:14:39 -0800 (PST)
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	hch@lst.de,
	willy@infradead.org,
	"Raphael S. Carvalho" <raphaelsc@scylladb.com>
Subject: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
Date: Mon, 24 Feb 2025 05:13:28 -0300
Message-ID: <20250224081328.18090-1-raphaelsc@scylladb.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

original report:
https://lore.kernel.org/all/CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com/T/

When doing buffered writes with FGP_NOWAIT, under memory pressure, the system
returned ENOMEM despite there being plenty of available memory, to be reclaimed
from page cache. The user space used io_uring interface, which in turn submits
I/O with FGP_NOWAIT (the fast path).

retsnoop pointed to iomap_get_folio:

00:34:16.180612 -> 00:34:16.180651 TID/PID 253786/253721
(reactor-1/combined_tests):

                    entry_SYSCALL_64_after_hwframe+0x76
                    do_syscall_64+0x82
                    __do_sys_io_uring_enter+0x265
                    io_submit_sqes+0x209
                    io_issue_sqe+0x5b
                    io_write+0xdd
                    xfs_file_buffered_write+0x84
                    iomap_file_buffered_write+0x1a6
    32us [-ENOMEM]  iomap_write_begin+0x408
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096 foliop=0xffffb32c296b7b80
!    4us [-ENOMEM]  iomap_get_folio
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096

This is likely a regression caused by 66dabbb65d67 ("mm: return an ERR_PTR
from __filemap_get_folio"), which moved error handling from
io_map_get_folio() to __filemap_get_folio(), but broke FGP_NOWAIT handling, so
ENOMEM is being escaped to user space. Had it correctly returned -EAGAIN with
NOWAIT, either io_uring or user space itself would be able to retry the
request.
It's not enough to patch io_uring since the iomap interface is the one
responsible for it, and pwritev2(RWF_NOWAIT) and AIO interfaces must return
the proper error too.

The patch was tested with scylladb test suite (its original reproducer), and
the tests all pass now when memory is pressured.

Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
Signed-off-by: Raphael S. Carvalho <raphaelsc@scylladb.com>
---
 mm/filemap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 804d7365680c..d7646e73f481 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1986,8 +1986,12 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 
 		if (err == -EEXIST)
 			goto repeat;
-		if (err)
+		if (err) {
+			/* Prevents -ENOMEM from escaping to user space with FGP_NOWAIT */
+			if ((fgp_flags & FGP_NOWAIT) && err == -ENOMEM)
+				err = -EAGAIN;
 			return ERR_PTR(err);
+		}
 		/*
 		 * filemap_add_folio locks the page, and for mmap
 		 * we expect an unlocked page.
-- 
2.48.1

