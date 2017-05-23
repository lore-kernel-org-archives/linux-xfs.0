Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750792AbdEWN16 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 09:27:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2F16285A0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2017 13:27:57 +0000 (UTC)
Date: Tue, 23 May 2017 09:27:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix off-by-one on max nr_pages in
 xfs_find_get_desired_pgoff()
Message-ID: <20170523132756.GD6543@bfoster.bfoster>
References: <20170521075939.18071-1-eguan@redhat.com>
 <20170523123536.GC6543@bfoster.bfoster>
 <20170523130028.GA7250@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523130028.GA7250@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 09:00:28PM +0800, Eryu Guan wrote:
> On Tue, May 23, 2017 at 08:35:39AM -0400, Brian Foster wrote:
> > On Sun, May 21, 2017 at 03:59:39PM +0800, Eryu Guan wrote:
> > > xfs_find_get_desired_pgoff() is used to search for offset of hole or
> > > data in page range [index, end] (both inclusive), and the max number
> > > of pages to search should be at least one, if end == index.
> > > Otherwise the only page is missed and no hole or data is found,
> > > which is not correct.
> > > 
> > > When block size is smaller than page size, this can be demonstrated
> > > by preallocating a file with size smaller than page size and writing
> > > data to the last block. E.g. run this xfs_io command on a 1k block
> > > size XFS on x86_64 host.
> > > 
> > >   # xfs_io -fc "falloc 0 3k" -c "pwrite 2k 1k" \
> > >   	    -c "seek -d 0" /mnt/xfs/testfile
> > >   wrote 1024/1024 bytes at offset 2048
> > >   1 KiB, 1 ops; 0.0000 sec (33.675 MiB/sec and 34482.7586 ops/sec)
> > >   Whence  Result
> > >   DATA    EOF
> > > 
> > 
> > Ok, so this does look like a different problem.
> > 
> > > Data at offset 2k was missed, and lseek(2) returned ENXIO.
> > > 
> > > This is unconvered by generic/285 subtest 07 and 08 on ppc64 host,
> > > where pagesize is 64k. Because a recent change to generic/285
> > > reduced the preallocated file size to smaller than 64k.
> > > 
> > > Cc: stable@vger.kernel.org # v3.7+
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > 
> > Could we fold this patch into Jan's patch 2 or vice versa (retaining
> > Eryu's commit log and credit)?
> > 
> > > ---
> > >  fs/xfs/xfs_file.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 35703a8..aefa213 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1049,7 +1049,7 @@ xfs_find_get_desired_pgoff(
> > >  		unsigned	nr_pages;
> > >  		unsigned int	i;
> > >  
> > > -		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
> > > +		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
> > 
> > Kind of a nit, but could we do the following?
> > 
> > 		want = min_t(pgoff_t, end - index + 1, PAGEVEC_SIZE);
> > 
> > It seems more clear to me given that end would be inclusive after Jan's
> > patch.
> 
> I thought about it too, but I searched for other places doing the same
> calculation and they are all comparing (end-index) with (PAGEVEC_SIZE-1)
> then plus one, e.g. mm/truncate.c::invalidate_inode_pages2_range(). I
> guess it's meant to prevent (end - index + 1) from overflowing, i.e.
> (end(ULONG_MAX) - index(0) + 1).
> 

Ah, I see. Disregard this comment then, thanks!

Brian

> Thanks for the review!
> 
> Eryu
> 
> > 
> > Brian
> > 
> > >  		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
> > >  					  want);
> > >  		/*
> > > -- 
> > > 2.9.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
