Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 19:01:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7421EJL006564
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 19:01:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73F3C355A86
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 19:02:25 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id MAvYlMTpe608C2hh for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 19:02:25 -0700 (PDT)
Date: Mon, 4 Aug 2008 04:02:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/26] generic btree implementation, version 3
Message-ID: <20080804020226.GA9995@lst.de>
References: <20080804013158.GA8819@lst.de> <20080804015425.GE6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804015425.GE6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 11:54:25AM +1000, Dave Chinner wrote:
> > With all these changes the stats for this series are now:
> > 
> >  37 files changed, 6309 insertions(+), 7873 deletions(-)
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  631577	   4227	   3092	 638896	  9bfb0	fs/xfs/xfs.ko.base
> >  614298	   4435	   3124	 621857	  97d21	fs/xfs/xfs.ko.btree
> 
> FWIW, this aggregate doesn't show the real picture of the savings.
> What is really interesting is how small the individual
> implementations become....

hch@bigmac:~/work/linux-2.6-xfs$ wc -l fs/xfs/xfs{_alloc,_ialloc,_bmap,}_btree.c
   409 fs/xfs/xfs_alloc_btree.c
   309 fs/xfs/xfs_ialloc_btree.c
   858 fs/xfs/xfs_bmap_btree.c
  3813 fs/xfs/xfs_btree.c
  5389 total

hch@bigmac:~/work/linux-2.6-xfs$ size
fs/xfs/xfs{_alloc,_ialloc,_bmap,}_btree.o
   text	   data	    bss	    dec	    hex	filename
   2335	      0	      4	   2339	    923	fs/xfs/xfs_alloc_btree.o
   1589	      0	      4	   1593	    639	fs/xfs_ialloc_btree.o
   5827	      0	      4	   5831	   16c7 fs/xfs/xfs_bmap_btree.o
  32785	      0	      4	  32789	   8015 fs/xfs/xfs_btree.o

In comparism for the old code:

hch@bigmac:~/work/linux-2.6-xfs$ wc -l fs/xfs/xfs{_alloc,_ialloc,_bmap,}_btree.c
  2211 fs/xfs/xfs_alloc_btree.c
  2078 fs/xfs/xfs_ialloc_btree.c
  2610 fs/xfs/xfs_bmap_btree.c
   914 fs/xfs/xfs_btree.c
  7813 total

hch@bigmac:~/work/linux-2.6-xfs$ size fs/xfs/xfs{_alloc,_ialloc,_bmap,}_btree.o
   text	   data	    bss	    dec	    hex	filename
  13383	      0	      0	  13383	   3447	fs/xfs/xfs_alloc_btree.o
  12923	      0	      0	  12923	   327b fs/xfs/xfs_ialloc_btree.o
  28870	     22	      4	  28896	   70e0	fs/xfs/xfs_bmap_btree.o
   7062	      0	      4	   7066	   1b9a fs/xfs/xfs_btree.o
