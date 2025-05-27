Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BBF2AD25
	for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 23:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748386897; cv=none; b=ozYFwMUpG/L+YEM8kFJOMYYBO34SIOMpKZd5UrVca+PQ5UfklWi0Xw7C/KEKK3Z1rUEMZnuC6KqtmPHaCnHBhtz3a0mkzoqB8odhcGDDkUhhPyE1VlIJ1e2MqfkAuTkSEAzaoiWyQz9ECqXNcJGubdyLCCxYsikmeE1vr8dDLM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748386897; c=relaxed/simple;
	bh=6wMk0upusvsrcV3K/kbRTrBd4+mRAjJwz5Iqz99ps1s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=LXIxdhithC5Fab/lYh9GWAenQ/qWRfuQTtsuOX1L/7PINKOdCaIS79TDBVrYSrKwmi3XWvEBX0jRLNpEZKjOS9r0uX6MY3Y3sE41ENBvrb47NRj8zkWN1EXhsAZAxvTkjCkauZ76iuTmpmX7yGn52Lp+Gn9did3BfGxKP1p9H0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SvScP52m; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SvScP52m"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3dd24c86779so23915685ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 16:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748386894; x=1748991694; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6rTbiCmjjbN/JHxlP0DLYSOX8zuWN8s6UZOsd1AF/I=;
        b=SvScP52mTmwyRRmwAaRpsXB3Dt2BZe5uHB8icPhq/RywHoXoM/7LIQdku7ewW/CYk+
         4SomwjeAFStGwZqDEPtRC2UTgI2B0bQJjAFxKxK2WYWPlbccMf+aoo15j4dM1PKyWkHa
         Ca2a49DRKO+1BEvi+OQp7WBkZwJoF0UuCrXsUT+1+/pxZR2fXz1o0Y9Lebrln4rU2LKc
         1NtNwzmAn3OFpwiCzQssG7yDGl+dD9035FYtDIcIEEoeHhtWft+ebYz4aLuDN4ZsrHfW
         sZr1IkemAEFDs3lMrMCROG0+ZCFN34YLqNvTlwD2dx6oMfTG70s+1f7z8yJMIZ5FPDOC
         NZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748386894; x=1748991694;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k6rTbiCmjjbN/JHxlP0DLYSOX8zuWN8s6UZOsd1AF/I=;
        b=qmr8sZ1CFwoSpNwypo8aq1sAOrjvXfJClflrLI+3v9FYXTz/UtVhrby/HPjjtLdO5J
         1zvCqOPbrYwjjR0KSjCN0USxhJ7D/mcJPckXFyUKGWo5Ko5U6B8P2f05P/p+JoUvnZPR
         bp3zHQXOS6zgRsjySfULCGgUWsiFT7l6jfRwSttM2iOzcLabzfnU04/Gx/y2sOuZaaI7
         EvFG2nhpoSuc2L+yvuiJie2jabNj8z3/zujtsI3WtJQsvqaG2W8hBbVdeiWl7a/BFO8I
         UG8IcFbJYWTMs4hC/BTLcb+z/MK10poqdgsjMPdkX+OoV6AkwJN5tIYgijnoRrxXEQXH
         FNqA==
X-Gm-Message-State: AOJu0YwvyWV7wAxvv9GKYE6VyYT/P9TYVqDgzK/+4kUqZSaZVc6RB1mr
	u4cLnYJL333IHB2tdhAKfLGmOKciJSruEoyo19zPyCemNBsB7arYrmw4IXoYg6nhbTM=
X-Gm-Gg: ASbGncu983HXjM5PqaP4iyGkiQatLqLwEkPQ90jR09xbHpqtApgOG210zMssXHcFze/
	7vf5jori21tkwndRadEEz2SJVWZj49y3CBc/whTTPcRQv+PYu0noXPdOsCIQGuqu6JnjmsAT/zB
	AdGPKwZhs3A/sDO3t5MyMHAXO6YDZiyUbWcKLzaQJnHs01n5z8rRm54L5HAY2Hc71ig0S8puDvJ
	TF+8qatF0KnmGTQLILqybmGbvOOVS02B5/x7tSP8uqLgAk+ltfp79EPjsBQK3n4ZXer7z3P19mi
	7clAisTlYY+eOXSsxmVu9U+iOYWWyI/RgB/miYl8z44L+hgI
X-Google-Smtp-Source: AGHT+IFCPZcH4Q+O0/XhcV1Lnj/5J9GAAtYeCSVOTE4/ayccaf0y5RXjPwR49JO/76OR4QeS2YRGrA==
X-Received: by 2002:a05:6e02:b43:b0:3dc:7fa4:842 with SMTP id e9e14a558f8ab-3dc9b733c3amr148852365ab.17.1748386893627;
        Tue, 27 May 2025 16:01:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd89bef216sm816425ab.45.2025.05.27.16.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 16:01:32 -0700 (PDT)
Message-ID: <5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk>
Date: Tue, 27 May 2025 17:01:31 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] iomap: don't lose folio dropbehind state for overwrites
To: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Language: en-US
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

Since this is the 3rd flag that will cause XFS to punt the completion to
a workqueue, add a helper so that each one of them can get appropriately
commented.

This fixes extra page cache being instantiated when the write performed
is an overwrite, rather than newly instantiated blocks.

Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Since v1:
- Add xfs_ioend_needs_wq_completion() helper as per Dave's suggestion

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
index 26a04a783489..63151feb9c3f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -436,6 +436,25 @@ xfs_map_blocks(
 	return 0;
 }
 
+static bool
+xfs_ioend_needs_wq_completion(
+	struct iomap_ioend	*ioend)
+{
+	/* Changing inode size requires a transaction. */
+	if (xfs_ioend_is_append(ioend))
+		return true;
+
+	/* Extent manipulation requires a transaction. */
+	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
+		return true;
+
+	/* Page cache invalidation cannot be done in irq context. */
+	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
+		return true;
+
+	return false;
+}
+
 static int
 xfs_submit_ioend(
 	struct iomap_writepage_ctx *wpc,
@@ -460,8 +479,7 @@ xfs_submit_ioend(
 	memalloc_nofs_restore(nofs_flag);
 
 	/* send ioends that might require a transaction to the completion wq */
-	if (xfs_ioend_is_append(ioend) ||
-	    (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED)))
+	if (xfs_ioend_needs_wq_completion(ioend))
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

