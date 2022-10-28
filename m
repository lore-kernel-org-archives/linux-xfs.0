Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842CEECAAA1
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 18:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJ1StR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 14:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJ1StQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 14:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB35244C40
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 11:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666982897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p9SkpW/EZzU2RUfuzHHojeeNxOUT3l9bKHgpaTv899o=;
        b=Cdx71miXhHCda8Q0A18JD/7bmHwJip7TmOlskVaU4pkGnKxMsdSeW7CTEQeUQvh+Fo/PNS
        o/96PB9cB38m9qfd66mSBklz4Z/xQcEvcg0CV7UaxDnk9/TMPAB3P7lcq9PPbVpcBr07OV
        obCeJCtUPpVQaGswaPaA0IJ5n4VE0F4=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-xCvyzTmKPLina6A9l49JGQ-1; Fri, 28 Oct 2022 14:48:16 -0400
X-MC-Unique: xCvyzTmKPLina6A9l49JGQ-1
Received: by mail-vs1-f72.google.com with SMTP id f128-20020a676a86000000b003aa2cc4af81so1593372vsc.23
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 11:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9SkpW/EZzU2RUfuzHHojeeNxOUT3l9bKHgpaTv899o=;
        b=Wq+WpqbjbfZHZafrsoud03sftv7cJ7PiJyJ2s64LOr4uTCE3ritNWj+zJTPa9X1jV8
         HUk6wMoSf0ubyKkmhzVxJGKlnoTpqLFM5yHXFkkMbwiiitg2PBxS9BRqqXLobrHhL4gk
         fAUYXywC0a9xkKoPpW68S1yy3+Ro6Kl3wDHis+eqQayesaHnjak2PI0yoIqvrN+9IiD/
         6PcmYP4QoeaYcfBp7W17vt4Rq2b2pO/nuoV7NX0EwzQyBgIBBWucXJqvQViipTHbQnKE
         QrLAJ3Aiaj1H8BvzH2UjdlKlgI8XTJ80ziVNHWvrCFQQph+qHusJsfSxoYyCoYSuAtEb
         9XKw==
X-Gm-Message-State: ACrzQf3Y6rpWEbZIYjsMlQYUZCXLgIVKasbHQOrFXAi04Z9CD3v53Be6
        +g8X8EgIeDkIjG0suhEabxPRnNUYnA1ZHlS+y1ebZkgeJ3xYjIaj2gOmg7wjM6yxa7K5aOOfQF7
        HMk8ZFJScJAPDpOMHqSdpaGevT5FYWjI5wbnOSg3xn2BwyuijhaI0+KWJ/sOcg5/xoH4Yo2g=
X-Received: by 2002:ad4:4d11:0:b0:4bb:5ad6:a9d9 with SMTP id l17-20020ad44d11000000b004bb5ad6a9d9mr632003qvl.67.1666981603870;
        Fri, 28 Oct 2022 11:26:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5BEvfeXOWn84zrVUyNpoVLoXIaa92r7YsGMtOKsVKkDtRh+nPipVuFSrMFEvAWrnpXU/8Vxg==
X-Received: by 2002:ad4:4d11:0:b0:4bb:5ad6:a9d9 with SMTP id l17-20020ad44d11000000b004bb5ad6a9d9mr631983qvl.67.1666981603506;
        Fri, 28 Oct 2022 11:26:43 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bq33-20020a05620a46a100b006bb366779a4sm3399282qkb.6.2022.10.28.11.26.43
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 11:26:43 -0700 (PDT)
Date:   Fri, 28 Oct 2022 14:26:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y1we59XylviZs+Ry@bfoster>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028131109.977581-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 09:11:09AM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Here's a quick prototype of "option 3" described in my previous mail.
> This has been spot tested and confirmed to prevent the original stale
> data exposure problem. More thorough regression testing is still
> required. Barring unforeseen issues with that, however, I think this is
> tentatively my new preferred option. The primary reason for that is it
> avoids looking at extent state and is more in line with what iomap based
> zeroing should be doing more generically.
> 
> Because of that, I think this provides a bit more opportunity for follow
> on fixes (there are other truncate/zeroing problems I've come across
> during this investigation that still need fixing), cleanup and
> consolidation of the zeroing code. For example, I think the trajectory
> of this could look something like:
> 
> - Genericize a bit more to handle all truncates.
> - Repurpose iomap_truncate_page() (currently only used by XFS) into a
>   unique implementation from zero range that does explicit zeroing
>   instead of relying on pagecache truncate.
> - Refactor XFS ranged zeroing to an abstraction that uses a combination
>   of iomap_zero_range() and the new iomap_truncate_page().
> 

After playing with this and thinking a bit more about the above, I think
I managed to come up with an iomap_truncate_page() prototype that DTRT
based on this. Only spot tested so far, needs to pass iomap_flags to the
other bmbt_to_iomap() calls to handle the cow fork, undoubtedly has
other bugs/warts, etc. etc. This is just a quick prototype to
demonstrate the idea, which is essentially to check dirty state along
with extent state while under lock and transfer that state back to iomap
so it can decide whether it can shortcut or forcibly perform the zero.

In a nutshell, IOMAP_TRUNC_PAGE asks the fs to check dirty state while
under lock and implies that the range is sub-block (single page).
IOMAP_F_TRUNC_PAGE on the imap informs iomap that the range was in fact
dirty, so perform the zero via buffered write regardless of extent
state.

Brian

--- 8< ---

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13..14a9734b2838 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -899,7 +899,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 	loff_t written = 0;
 
 	/* already zeroed?  we're done. */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+	if ((srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) &&
+	    !(srcmap->flags & IOMAP_F_TRUNC_PAGE))
 		return length;
 
 	do {
@@ -916,6 +917,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		if (bytes > folio_size(folio) - offset)
 			bytes = folio_size(folio) - offset;
 
+		trace_printk("%d: ino 0x%lx offset 0x%lx bytes 0x%lx\n",
+			__LINE__, folio->mapping->host->i_ino, offset, bytes);
 		folio_zero_range(folio, offset, bytes);
 		folio_mark_accessed(folio);
 
@@ -933,6 +936,17 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 	return written;
 }
 
+static int
+__iomap_zero_range(struct iomap_iter *iter, bool *did_zero,
+		   const struct iomap_ops *ops)
+{
+	int ret;
+
+	while ((ret = iomap_iter(iter, ops)) > 0)
+		iter->processed = iomap_zero_iter(iter, did_zero);
+	return ret;
+}
+
 int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops)
@@ -943,11 +957,8 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		.len		= len,
 		.flags		= IOMAP_ZERO,
 	};
-	int ret;
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_zero_iter(&iter, did_zero);
-	return ret;
+	return __iomap_zero_range(&iter, did_zero, ops);
 }
 EXPORT_SYMBOL_GPL(iomap_zero_range);
 
@@ -957,11 +968,17 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 {
 	unsigned int blocksize = i_blocksize(inode);
 	unsigned int off = pos & (blocksize - 1);
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= blocksize - off,
+		.flags		= IOMAP_ZERO | IOMAP_TRUNC_PAGE,
+	};
 
 	/* Block boundary? Nothing to do */
 	if (!off)
 		return 0;
-	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops);
+	return __iomap_zero_range(&iter, did_zero, ops);
 }
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 07da03976ec1..16d9b838e82d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -915,6 +915,7 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 	unsigned int		lockmode = XFS_ILOCK_EXCL;
+	u16			iomap_flags = 0;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -942,6 +943,10 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		goto out_unlock;
 
+	if ((flags & IOMAP_TRUNC_PAGE) &&
+	    filemap_range_needs_writeback(VFS_I(ip)->i_mapping, offset, offset))
+			iomap_flags |= IOMAP_F_TRUNC_PAGE;
+
 	/*
 	 * Search the data fork first to look up our source mapping.  We
 	 * always need the data fork map, as we have to return it to the
@@ -1100,7 +1105,7 @@ xfs_buffered_write_iomap_begin(
 
 found_imap:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags);
 
 found_cow:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..3c40a81d6da0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -840,16 +840,6 @@ xfs_setattr_size(
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..6f9b4f991720 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -56,6 +56,7 @@ struct vm_fault;
 #define IOMAP_F_MERGED		0x08
 #define IOMAP_F_BUFFER_HEAD	0x10
 #define IOMAP_F_ZONE_APPEND	0x20
+#define IOMAP_F_TRUNC_PAGE	0x40
 
 /*
  * Flags set by the core iomap code during operations:
@@ -146,6 +147,7 @@ struct iomap_page_ops {
 #else
 #define IOMAP_DAX		0
 #endif /* CONFIG_FS_DAX */
+#define IOMAP_TRUNC_PAGE	(1 << 9)
 
 struct iomap_ops {
 	/*

