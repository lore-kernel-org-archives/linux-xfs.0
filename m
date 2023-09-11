Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA092EE49A4
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 00:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjIKACd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Sep 2023 20:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjIKACc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2023 20:02:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C1018B
        for <linux-xfs@vger.kernel.org>; Sun, 10 Sep 2023 17:02:28 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-570a432468bso3424957a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 10 Sep 2023 17:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694390547; x=1694995347; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BuWXcolwPZF0Fjx2Nrn9ky4gQs3B+XaH1BVryYGb0Co=;
        b=c8KN4FLkfPCUHTfiy19GYLycQcT8gBVwY7jkwh1ccK8Pj3LGUfdcnnaY0XgpuSwAnM
         DtAft9TFaQb/PHFAzwEOhh/9bK1WK2xyP9MJQv9uLFDtQcWaTvf0HHvvkeJ8S0UtTARU
         aYHvfBbnobRYSHY1vLgZcTeV3GT7+zy/afyNZD6npqzG2xnWVDY88vW8xxU1zLXfuQL/
         9RgKrlKSYqHzFgLAyGtZmuU2ueKCMdEz2LRW5apemrfKDFe5KVbEkajA0EXNluPJd9xi
         2sjP6aDZLJfq7qInJUgP1JyUSA4Lc0q5sR+WJ9+Bj5+HdDUHoRZbimNEycVs6dtFEl9H
         knpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694390547; x=1694995347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BuWXcolwPZF0Fjx2Nrn9ky4gQs3B+XaH1BVryYGb0Co=;
        b=MREDbwliZYpQhz0UJWZ/yIc+8M7JaU7oGaPiU42WcCGu8xBjX2dM4nHVikRsm6UfSt
         xXiFNRlc+PIeKoLFdscOKnJUHM7/DacYrAPZ2Dr0e087DzOrhSUxqX9chkJEhp1pe3ko
         C2+bmyEPCNZ9mYDX48+Oh3m8WsthGBKBO98evjrjjVDSCdAwODAyvi+f595MIAk2N8Fg
         Y3VWjwnqnvtZ+ag5U655WLznoUIcdDy/0PohLXsOPyjLI54GOqiZzHSUAbcwn+Gr0smK
         PosU/cDKKm3QnmtdDj1KVBFLMgnQ0h3QOEOZyYS48uTAZtC1g2Ccj3fAuMxM6k9AP69p
         mqyg==
X-Gm-Message-State: AOJu0Yw1eu/2BwF/6tgbjx77ps/GHgZczrshMB8RfnZZxU2qDKO2yXnd
        nwEJSIZZqCj1cGWAMSip08cHvQ==
X-Google-Smtp-Source: AGHT+IFQ++RMuB2iOMKQJRmWJ07rzBy0hTVUbQZHy9DpVP7lEXHFez2sgjbuucCLul0nqDJHfTsy7Q==
X-Received: by 2002:a17:90b:ec5:b0:26d:4d1c:5395 with SMTP id gz5-20020a17090b0ec500b0026d4d1c5395mr15420486pjb.18.1694390547083;
        Sun, 10 Sep 2023 17:02:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id bt22-20020a17090af01600b002612150d958sm6285602pjb.16.2023.09.10.17.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Sep 2023 17:02:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qfUNj-00DYQy-2l;
        Mon, 11 Sep 2023 10:02:23 +1000
Date:   Mon, 11 Sep 2023 10:02:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Why doesn't XFS need ->launder_folio?
Message-ID: <ZP5ZD0v6IEiauFHB@dread.disaster.area>
References: <ZPs0I9ZTxfAQtyI9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPs0I9ZTxfAQtyI9@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 08, 2023 at 03:48:03PM +0100, Matthew Wilcox wrote:
> I want to remove ->launder_folio.  So I'm looking at commit e3db7691e9f3
> which introduced ->launder_page.  The race described there is pretty
> clear:
> 
>      invalidate_inode_pages2() may find the dirty bit has been set on a page
>      owing to the fact that the page may still be mapped after it was locked.
>      Only after the call to unmap_mapping_range() are we sure that the page
>      can no longer be dirtied.
> 
> ie this happens:
> 
> Task A				Task B
> mmaps a file, writes to page A
> 				open(O_DIRECT)
> 				read()
> 				kiocb_invalidate_pages()
> 				filemap_write_and_wait_range()
> 				__filemap_fdatawrite_range()
> 				filemap_fdatawrite_wbc()
> 				do_writepages()
> 				iomap_writepages()
> 				write_cache_pages()
> 				page A gets cleaned
> writes to page A again
> 				invalidate_inode_pages2_range()
> 				folio_mapped() is true, so we unmap it
> 				folio_launder() returns 0
> 				invalidate_complete_folio2() returns 0
> 				ret = -EBUSY
> 				kiocb_invalidate_pages() returns EBUSY
> 
> and the DIO read fails, despite it being totally reasonable to return
> the now-stale data on storage.

I think you've read the __iomap_dio_rw() call path incorrectly -
kiocb_invalidate_pages() is only called from the DIO write
submission call path, not the DIO read call path.

For a DIO read, we only call kiocb_write_and_wait() to write back
dirty cached pages and we don't invalidate anything in the page
cache. Hence IO submission never calls
invalidate_inode_pages2_range(), so the data returned by the DIO
read will only contain the first write. On DIO read completion, we
still don't do any page cache invalidation, so AFAICT it returns
stale data that doesn't include the second mmap write task A made to
the file while the DIO read was in progress.

This looks like the iomap DIO read path is working as intended to
me...

> A DIO write would be a different matter;
> we really do need to get page A out of cache.

No, I don't think we need to.

On a dio write, if invalidate_inode_pages2_range() fails with -EBUSY
as per above it will result in iomap_dio_rw() returning -ENOTBLK to
the filesystem. That gets caught at xfs_file_write_iter() and the
DIO write is then executed as buffered IO instead. This means the
write is then directed through the page cache and so second write
that Task A made is captured and does not get lost.

IOWs, this looks like it is all working as it is supposed to,
without the need to implement ->launder_folio()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
