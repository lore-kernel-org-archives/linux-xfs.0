Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 06:07:03 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANE6sTP030138
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 06:06:57 -0800
Date: Fri, 23 Nov 2007 13:43:02 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix up xfs_buf_associate_memory()
Message-ID: <20071123134302.GA4256@infradead.org>
References: <47465712.1050000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47465712.1050000@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 23, 2007 at 03:29:06PM +1100, Lachlan McIlroy wrote:
> Fixed a few bugs in xfs_buf_associate_memory() including:
> 
> - calculation of 'page_count' was incorrect as it did not
>   consider the offset of 'mem' into the first page.  The
>   logic to bump 'page_count' didn't work if 'len' was <=
>   PAGE_CACHE_SIZE (ie offset = 3k, len = 2k).
> - setting b_buffer_length to 'len' is incorrect if
>   'offset' is > 0.  Set it to the total length of the
>   buffer.
> - I suspect that passing a non-aligned address into
>   mem_to_page() for the first page may have been causing
>   issues - don't know but just tidy up that code anyway.
> 
> These fixes prevent an data corruption issue that can
> occur during log replay.

Last time I tried to clean up this gem everything went bezerk, so be
aware :)


--- fs/xfs/linux-2.6/xfs_buf.c_1.247	2007-11-23 12:03:16.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_buf.c	2007-11-23 12:02:32.000000000 +1100
@@ -726,14 +726,14 @@ xfs_buf_associate_memory(
 	int			rval;
 	int			i = 0;
 	size_t			ptr;
+	size_t			buflen;
 	off_t			offset;
 	int			page_count;
 
+	ptr = (size_t) mem & PAGE_CACHE_MASK;
+	offset = (off_t) mem - (off_t) ptr;

Casting pointers to size_t or off_t makes little sense, these should be
unsigned long.  And using a variable name of ptr is quite odd :)

+	while (i < bp->b_page_count) {
+		bp->b_pages[i++] = mem_to_page((void *)ptr);
 		ptr += PAGE_CACHE_SIZE;
 	}

This could be much cleaner written as:

	for (i = 0; i < bp->b_page_count; i++) {
		bp->b_pages[i] = mem_to_page((void *)ptr);
		ptr += PAGE_CACHE_SIZE;
	}
