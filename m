Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6522798F3
	for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748360627; cv=none; b=SgzGbrzfNdvDpsB6gTCA+RT3kPfFqHAbgtrWK2oUO+QKK/VyKCjHFoePydvEOF6ESx/8qCiyVWs+E4ccd1xRx2qAZ8TocZ7o1Q4Qs2S2oBj6Yn8Dk5OGDe9lMpKIatRBqDBRGfwKDIMGshJetMCwCbSdZ9kVC3y9zaYjdx5ffBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748360627; c=relaxed/simple;
	bh=fvBOC7wo2sNRkj71TeIg1Rg3qmmpT5om/ZfFNlWdBnc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=OOIQNrFW47RbqdCNG9xWyFLcjI4reiP9r/IAYEHn6y1s8F+JMYNA0yVQyrzYWFtndMN9mGGAcnw5cWXTC9t+03x1d4nVIShe7PP5XBP1hm3Gg/KcwSktb20e90OHxQAMoXmuX8SkO9biCJ3fy0fZTyb8kb/w253AivHRaXqeqBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xzhTJu1C; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xzhTJu1C"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3dc729471e3so10877195ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748360624; x=1748965424; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqeQdOhkH14ppIXNPXbtKnFvRT5SLIn7XArQrv8eW9k=;
        b=xzhTJu1CC4gAikHEXXsTsq35rtX2Al6R6cPYsqKbvPP5u2ZsL6bH5N1fVrJOcBNDhy
         pCrSafgKHzr2aIflpjYNnjYGC/yB0k3pbrA1yqQVKPz/g305ZqOSWghhKNQLxmeIUv60
         A64rhwoRDmCfI2oHAu1JIZkq/mbcqoN3aqrKpPUiDWkBE1yH3Y7mFACvkh8ecZGw9Lua
         H7pAvpK90M8vxEUcovM6YmTqb92bxNWX/9vys6GekR2nxHxvZbty+DSR75vlMYxhWMdw
         9RpC1VpaHEMB5lAM5/MzNg/tneGf9+dApEWPTC4QSwxW4djB66QJB3/2ljJlIoUzcDcW
         qOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748360624; x=1748965424;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uqeQdOhkH14ppIXNPXbtKnFvRT5SLIn7XArQrv8eW9k=;
        b=Cula55Z7NZdpgLqb9kr1MsYsoXv80FMy6lJfQ4+h0JAGxTWrRtA1zLnwFN8jfqK0o8
         862mekCENRbz1vJxV2Tu+mbd/0gx9X6S1ZlzfOuce2bk43zp0Rdnkt7+TkfDVtj6IAQW
         MeRD900qY/ismsQhNr7SkM/ZCgRlXuaddB/j/Bm5bAOl450P3vflRambZN+KR/rs9Pbx
         NRO+l37uiuozgW8kdjDgv6GR2hKzf4o09hwfDUwf+ykH7j9XuLIGwsbiFimicbhhw61u
         CKtGEe2gw9CnrO7+h0mFe4ax0rXYD4iXAMCuu/1qJApTuEiRunD09eHnywVa5XU6tlIk
         zYxg==
X-Gm-Message-State: AOJu0YyNnFASgAd9NSdlh5LOeyLZq0M6oAQ+wLm596RokL8y7TIU1Vl7
	Ttxae+bb4uYbUIXUtxGdK0bUEwsT8ZNG75rvv9043LLnVfwt3sOpAW9UkH8k8eZ4BO3VXXH3ZzZ
	NidCo
X-Gm-Gg: ASbGnct/gj9VHL7MLWAuJUSJ/bOcmbhd5S3b5F1keZWnjFrNqVvFypgNG7TCWUrLjNI
	uqz0XtM5go42u4RE6Xs9Ck3IHFgjPjPVXlo3p5u99ekvz01J1nLHOThZm7qwp6b+EU0fD7GUhlj
	QGjaxopjwQdakkZwEqFmJMEUvpV7ZuUeMj11Y6BjWkYY92c4/IHjRZnCQbNKpq1z1fXzzhBCVRi
	AQ1DfRD1BGtMEkPMnIs0JJP3rBZ7cbr4zO6g6kniL4EchwIerN31Ht+eHkQaf4iwaQqopP8gu0g
	J5rSl/T8R/SfsPs7nahSBWVSZmWmjsxd30qlfj+ZfJu9BoU=
X-Google-Smtp-Source: AGHT+IHe2IrTll2ZTLGHqAOutq0YESdy8gZfreCZKFWEEtFmStrNp/az6Vx+7kBl0sAdcFnJmLsm3A==
X-Received: by 2002:a05:6e02:3183:b0:3dc:787f:2bc4 with SMTP id e9e14a558f8ab-3dc9b70fff5mr159011985ab.18.1748360624054;
        Tue, 27 May 2025 08:43:44 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4af62dsm5208667173.109.2025.05.27.08.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 08:43:43 -0700 (PDT)
Message-ID: <a61432ad-fa05-4547-ab82-8d2f74d84038@kernel.dk>
Date: Tue, 27 May 2025 09:43:42 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] iomap: don't lose folio dropbehind state for overwrites
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

DONTCACHE I/O must have the completion punted to a workqueue, just like
what is done for unwritten extents, as the completion needs task context
to perform the invalidation of the folio(s). However, if writeback is
started off filemap_fdatawrite_range() off generic_sync() and it's an
overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
don't look at the folio being added and no further state is passed down
to help it know that this is a dropbehind/DONTCACHE write.

Check if the folio being added is marked as dropbehind, and set
IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
the decision making of completion context in xfs_submit_ioend().
Additionally include this ioend flag in the NOMERGE flags, to avoid
mixing it with unrelated IO.

This fixes extra page cache being instantiated when the write performed
is an overwrite, rather than newly instantiated blocks.

Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Found this one while testing the unrelated issue of invalidation being a
bit broken before 6.15 release. We need this to ensure that overwrites
also prune correctly, just like unwritten extents currently do.

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 233abf598f65..3729391a18f3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1691,6 +1691,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
+	if (folio_test_dropbehind(folio))
+		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 26a04a783489..1b7a006402ea 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -436,6 +436,9 @@ xfs_map_blocks(
 	return 0;
 }
 
+#define IOEND_WQ_FLAGS	(IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED | \
+			 IOMAP_IOEND_DONTCACHE)
+
 static int
 xfs_submit_ioend(
 	struct iomap_writepage_ctx *wpc,
@@ -460,8 +463,7 @@ xfs_submit_ioend(
 	memalloc_nofs_restore(nofs_flag);
 
 	/* send ioends that might require a transaction to the completion wq */
-	if (xfs_ioend_is_append(ioend) ||
-	    (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED)))
+	if (xfs_ioend_is_append(ioend) || ioend->io_flags & IOEND_WQ_FLAGS)
 		ioend->io_bio.bi_end_io = xfs_end_bio;
 
 	if (status)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 68416b135151..522644d62f30 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -377,13 +377,16 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
+/* is DONTCACHE I/O */
+#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
+	 IOMAP_IOEND_DONTCACHE)
 
 /*
  * Structure for writeback I/O completions.

-- 
Jens Axboe

