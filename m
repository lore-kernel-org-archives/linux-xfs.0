Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6DDC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D77C20661
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="LUSWbRWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfLBTcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:32:20 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43429 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbfLBTcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 14:32:20 -0500
Received: by mail-pg1-f178.google.com with SMTP id b1so145969pgq.10
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 11:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MlsPcMei+XU5vtSeEQJddD3dOAUs3WU4+gESuYo3Vc0=;
        b=LUSWbRWfawto6Owi36yxRRE3olHednqlxnd0JtDZdxd8J4qnbrjwnXrlKeI+NphgKZ
         xNpW2+oCfdYjRf9RsRebj3u4QfHrGl/Y8YlQ0MO5050pHdSEUZZaM5+3g+mP1LwryA2v
         jEbl7T6lEQ+JsI3HXNVt0j/HDCN5TvOsFnDJY49HdUnjNOu9Xw95Hy8u0+D8cb3UBXBY
         bns+k54FO5ClmgjCUvFS2m3WuB9lkkkbl+hJTO69VHGBhfZNJ3ukZ8QXoetXRKy08hrj
         /tz42qAXv3cju13/EaKD+PidwrUZIi/uS1DY/E4cw4XdL3zh1oh44h8X/M22lY+15cXT
         vWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MlsPcMei+XU5vtSeEQJddD3dOAUs3WU4+gESuYo3Vc0=;
        b=s+Kyl/AD9JSJ+vLOg+oAWimw7VH9j8gGAzwYmtK5a5dpnLz1QxNWNnYzFnYWb49+fm
         6dqkSPDxk/YbfgUPXyUGFZd9rXXp5hQYe+n/6uwOJg0zqm6sd3HIGce/6TA2/GNGQRS4
         6vJDcnTRUrxIMcZeAjyKC+iVDo3/NZ5JOPeSRAkI5rl3sWybAo6CFF1N73RG4UXSpMot
         +lP+zGhLuIusMISiiOjSGCwpva7py1lme924YtJ49elzpEbosTYOyC7VHy1On3UtlegG
         LY0ObmwTck68xi0956RnxnZ/+IP3YvOp/dx7GUqQYzUCurPaEw8u09ms+V90bVXp2UCN
         dBag==
X-Gm-Message-State: APjAAAWZ3vCXwhITj9R1k9JvLQKf0SViWasWcnOfpgFLWu7Z16td52r0
        nC4m1Tn9oi9rhK2LU6BlAGqZvw==
X-Google-Smtp-Source: APXvYqxO0NsXW06gh2npuH10XOAhHluVA8Ucip5ZFaRZ7u9FUhdFnEE4ppuKZORa7U5PA+/hKqg8Ew==
X-Received: by 2002:a62:1a09:: with SMTP id a9mr328423pfa.64.1575315139582;
        Mon, 02 Dec 2019 11:32:19 -0800 (PST)
Received: from vader ([2620:10d:c090:200::3:4fcf])
        by smtp.gmail.com with ESMTPSA id b7sm167021pjo.3.2019.12.02.11.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:32:19 -0800 (PST)
Date:   Mon, 2 Dec 2019 11:32:18 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191202193218.GB809204@vader>
References: <20191126202714.GA667580@vader>
 <20191127003426.GP6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127003426.GP6219@magnolia>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 04:34:26PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> > Hello,
> > 
> > The following reproducer results in a transaction log overrun warning
> > for me:
> > 
> >   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> >   mount -o rtdev=/dev/vdc /dev/vdb /mnt
> >   fallocate -l 4G /mnt/foo
> > 
> > I've attached the full dmesg output. My guess at the problem is that the
> > tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> > bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> > this filesystem, which I do see in some of the log items). However, I'm not
> > familiar enough with the XFS transaction guts to confidently fix this. Can
> > someone please help me out?
> 
> Hmm...
> 
> /*
>  * In a write transaction we can allocate a maximum of 2
>  * extents.  This gives:
>  *    the inode getting the new extents: inode size
>  *    the inode's bmap btree: max depth * block size
>  *    the agfs of the ags from which the extents are allocated: 2 * sector
>  *    the superblock free block counter: sector size
>  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
>  * And the bmap_finish transaction can free bmap blocks in a join:
>  *    the agfs of the ags containing the blocks: 2 * sector size
>  *    the agfls of the ags containing the blocks: 2 * sector size
>  *    the super block free block counter: sector size
>  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
>  */
> STATIC uint
> xfs_calc_write_reservation(...);
> 
> So this means that the rt allocator can burn through at most ...
> 1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
> ... worth of log reservation as part of setting bits in the rtbitmap and
> fiddling with the rtsummary information.
> 
> Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
> is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
> reservation.
> 
> So I think you're right, and the fix is probably? to cap ralen further
> in xfs_bmap_rtalloc().  Does the following patch fix it?
> 
> --D

Yup, that seems to fix it.

Reported-and-tested-by: Omar Sandoval <osandov@fb.com>

Thanks, Darrick!
