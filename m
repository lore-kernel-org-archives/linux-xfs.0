Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3148C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 00:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBJAAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjBJAAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 19:00:02 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2176BD0E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 16:00:00 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id n2so2458634pfo.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 16:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkMbKSlnqf03fRNpxQRgKnFt0PdnCr4YyYfUcmaKrcQ=;
        b=rmdVTHpuIjyjugAgRSSFjayyZWuWnKhBESRkR6/PC4cbRl2U7M6cBGVsDNCaE4Km61
         4hHXt46Z/QWU0U9ExMVhpMhTQLQsi73bdls82Z0SP6wnmd4emKTrGgi68o1hmBhVW6YI
         ldGBdaPykI1xoqj+YOjbmNh2ey6EnVKnmu9JVEgRgJW28iyRgnCsXmETq9R8dAoZ4oYm
         Bw99O2Gs1FYvrKj8eLsAMHe0ERU8VNGdtn60iSKVWa18lKjWyq/FL/61+xhxEhkLv1F1
         0k8sVIwf7oj6vqMsN3dad5vF9jevgyqfhFBDkv4Leag9+zNJ8Us2c4tScw7Gk52BY/rk
         7aAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkMbKSlnqf03fRNpxQRgKnFt0PdnCr4YyYfUcmaKrcQ=;
        b=GaDqgpIwPDHOiFJpF+hK7xlzoraHjM7UqY0m15yi8fM7h9S7MAJB61i+NLqYnD5Xip
         BmHurFOcd0omVNTp3OPrqj0CrbElH9EFknsPDPj2UaMNBZ3t7XdtZR4Rq2ujB7eaPQmX
         QrlUjeWkw0gaspAQ4RTCXmO7AM9VDt9e1J+ZfGmuyR8w81m1OFDaLCoBD07L/6j11tau
         YQsd54dCAyi9Q5Zhm2kvWY4D6vVZIA/5WRvDfD6lxZqzpeDXnsCu/fVKknBJv4tcbzre
         RTFLw0qBS4JOEyeMKBK+7Hiuqrm/u6Z2N+3EddjYZOaXGrVOwRbwyJ3ZPbLK5blZ4Mct
         qROg==
X-Gm-Message-State: AO0yUKVFBAjYmfG08coXQyrmWJ9ugobAs7EJ05y757iKUxbo8MxZaDVq
        A+YnEqnfs1oip1Abu1ieEdvetg==
X-Google-Smtp-Source: AK7set9CzGAd4tb7coOb+C5EUgVnngLccxyHGhgQjb5yGzDntGLcivjsQMd2BxBiu+2TA+wIYOGoag==
X-Received: by 2002:a05:6a00:c84:b0:5a6:cbdc:2a1a with SMTP id a4-20020a056a000c8400b005a6cbdc2a1amr7505153pfv.2.1675987199663;
        Thu, 09 Feb 2023 15:59:59 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b00593a01d93ecsm1961817pfe.208.2023.02.09.15.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 15:59:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQGpX-00DQQj-Cu; Fri, 10 Feb 2023 10:59:55 +1100
Date:   Fri, 10 Feb 2023 10:59:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Remove xfs_filemap_map_pages() wrapper
Message-ID: <20230209235955.GH360264@dread.disaster.area>
References: <20230208145335.307287-1-willy@infradead.org>
 <20230208145335.307287-2-willy@infradead.org>
 <Y+PQN8cLdOXST20D@magnolia>
 <Y+PX5tPyOP2KQqoD@casper.infradead.org>
 <20230208215311.GC360264@dread.disaster.area>
 <Y+ReBH8DFxf+Iab4@casper.infradead.org>
 <20230209215358.GG360264@dread.disaster.area>
 <Y+V07dcDoxP4mjbJ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+V07dcDoxP4mjbJ@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2023 at 10:34:21PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 10, 2023 at 08:53:58AM +1100, Dave Chinner wrote:
> > On Thu, Feb 09, 2023 at 02:44:20AM +0000, Matthew Wilcox wrote:
> > > On Thu, Feb 09, 2023 at 08:53:11AM +1100, Dave Chinner wrote:
> > > > > If XFS really needs it,
> > > > > it can trylock the semaphore and return 0 if it fails, falling back to
> > > > > the ->fault path.  But I don't think XFS actually needs it.
> > > > >
> > > > > The ->map_pages path trylocks the folio, checks the folio->mapping,
> > > > > checks uptodate, then checks beyond EOF (not relevant to hole punch).
> > > > > Then it takes the page table lock and puts the page(s) into the page
> > > > > tables, unlocks the folio and moves on to the next folio.
> > > > > 
> > > > > The hole-punch path, like the truncate path, takes the folio lock,
> > > > > unmaps the folio (which will take the page table lock) and removes
> > > > > it from the page cache.
> > > > > 
> > > > > So what's the race?
> > > > 
> > > > Hole punch is a multi-folio operation, so while we are operating on
> > > > invalidating one folio, another folio in the range we've already
> > > > invalidated could be instantiated and mapped, leaving mapped
> > > > up-to-date pages over a range we *require* the page cache to empty.
> > > 
> > > Nope.  ->map_pages is defined to _not_ instantiate new pages.
> > > If there are uptodate pages in the page cache, they can be mapped, but
> > > missing pages will be skipped, and left to ->fault to bring in.
> > 
> > Sure, but *at the time this change was made* other operations could
> > instantiate pages whilst an invalidate was running, and then
> > ->map_pages could also find them and map them whilst that
> > invalidation was still running. i.e. the race conditions that
> > existed before the mapping->invalidate_lock was introduced (ie. we
> > couldn't intercept read page faults instantiating pages in the page
> > cache at all) didn't require ->map_pages to instantiate the page for
> > it to be able to expose incorrect data to userspace when page faults
> > raced with an ongoing invalidation operation.
> > 
> > While this may not be able to happen now if everything is using the
> > mapping->invalidate_lock correctly (because read faults are now
> > intercepted before they can instatiate new page cache pages), it
> > doesn't mean it wasn't possible in the past.....
> 
> Sorry, still not getting it.  Here's the scenario I think you're
> talking about.  We have three threads (probably in different tasks
> or they may end up getting synchronized on the page table locks).
> 
> Thread 1 is calling FALLOC_FL_PUNCH_HOLE over a nice wide range.
> Thread 2 has the file mmaped and takes a read page fault.
> Thread 3 also has the file mmaped and also takes a read page fault.
> 
> Thread 2 calls filemap_map_pages and finds the pages gone.  It proceeds
> to call xfs_filemap_fault() which calls filemap_fault() without
> taking any XFS locks.  filemap_fault() kicks off some readahead which
> allocates some pages & puts them in the page cache.  It calls into
> xfs_vm_readahead() which calls iomap_readahead() without taking any XFS
> locks.  iomap_readahead() will then call back into xfs_read_iomap_begin()
> which takes the XFS_ILOCK_SHARED.
> 
> Since thread 1 is holding XFS_IOLOCK_EXCL, I presume thread 2 will
> block at this point until thread 1 is done.

No, because XFS_IOLOCK is not the same lock as XFS_ILOCK.

IOLOCK (inode->i_rwsem) and MMAPLOCK(mapping->invalidate_lock)
serialise user access to user data (i.e. page cache and direct IO).

ILOCK (xfs_inode->i_ilock) serialises access to internal XFS inode
metadata such as the extent list.

The lock ordering is IOLOCK -> MMAPLOCK -> folio lock -> ILOCK, as
described in fs/xfs/xfs_inode.c

In the case we are talking about here, operations such as fallocate
operate directly on the extent map protected by the ILOCK, so they
first have to serialise user access to the data (i.e. take the
IOLOCK, MMAPLOCK, run inode_dio_wait() to drain running IOs, run
break_layouts() to recall remote pNFS access delegations and
serialise DAX accesses, etc), then flush any remaining dirty cached
data (which may require allocation and hence taking the ILOCK) and
then (maybe) invalidate the cached data over the range that is about
to be operated on.

Only once we hold all these locks and have performed all these user
data operations whilst holding those locks can we then take the
ILOCK and directly manipulate the extent map knowing we have locked
out all avenues of user data modification whilst we modify the
extent map and change the user data contained in the file.

> At this point, the page
> is still not uptodate, so thread 3 will not map the page if it finds it
> in >map_pages.
> 
> Or have I misunderstood XFS inode locking?  Entirely possible, it
> seems quite complicated.

Yes, it is, but as every other filesystem has encountered the same
problems that XFS has been dealing with since day zero they've grown
exactly the same locking requirements. Some of these are VFS locks
(i_rwsem, invalidate_lock) or infrastructure (inode_dio_wait()), but
over the long term linux filesystems and the VFS have been trending
towards the original XFS locking model that it inherited from Irix
30 years ago, not the other way around.

> Nevertheless, it seems to me that if there's
> locking that's missing, there's ample opportunities for XFS to take those
> missing locks in the (slow) fault path, and not take them in the (fast)
> map_pages path.

If you go back to the series that introduced the
mapping->invalidate_lock and the XFS conversion to use it for the
MMAPLOCK in commit 2433480a7e1d ("xfs: Convert to use
invalidate_lock"), that's what pulled filemap_fault() out from under
the MMAPLOCK.

i.e. we used to run the entire fault path under the MMAPLOCK to try
to avoid issues with read faults instantiating new pages whilst we
were invalidating pages in the same mapping.  i.e. we used to
serialise both the read fault and write fault path entirely against
invalidation.  The conversion to the invalidate_lock drove the
locking further into the filemap_fault path, so we didn't need to
take it for read faults anymore. We still have to the take it for
write faults (i.e. ->page_mkwrite) because the page cache is already
populated and we still need to serialise ->page_mkwrite against
truncate, hole punch, etc.

Maybe we didn't need to lock the ->map_pages() path, but after
seeing data corruption issues caused by user directed speculative
page cache readahead via fadvise() and readahead() syscalls racing
with operations that need exclusive invalidation, I didn't think
that was a chance worth taking.

So, as I've already said, it's entirely possible that we don't need
the MMAPLOCK in this path anymore. All I want is a concrete
explanation of how the page fault and VFS paths now serialise
against invalidation to prevent these historic invalidation race
conditions from ever occurring again in the commit message.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
