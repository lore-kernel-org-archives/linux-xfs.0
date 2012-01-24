Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OE5BJ5017637 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 08:05:11 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oaDlzyBihtGMHJq9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 06:05:09 -0800 (PST)
Date: Tue, 24 Jan 2012 15:05:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS problem
Message-ID: <20120124140503.GC18136@quack.suse.cz>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

  Just adding XFS list to catch more attention...

On Fri 20-01-12 15:55:18, Kelbel Junior wrote:
> Hello again ...
> 
> So ... after changing the memory allocator SLUB to SLAB in the Linux
> kernel and apply the patch mentioned below, the system was stable for
> 3 days and today it happened again delay to deliver content on the
> disc.
> 
> When I went to see if there was something wrong in /var/log/messages
> appear several times this block:
> 
> server012 kernel: XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250)
> server012 kernel: Pid: 24885, comm: kworker/0:3 Tainted: G W 2.6.38.8-cve #2
> server012 kernel: Call Trace:
> server012 kernel: [<ffffffff811cfc65>] ? kmem_alloc+0xa6/0xb4
> server012 kernel: [<ffffffff811cfc91>] ? kmem_realloc+0x1e/0x51
> server012 kernel: [<ffffffff811b7b4e>] ?
> xfs_iext_realloc_indirect+0x3e/0x46
> server012 kernel: [<ffffffff811b7cf6>] ? xfs_iext_irec_new+0x36/0xcf
> server012 kernel: [<ffffffff811cfc26>] ? kmem_alloc+0x67/0xb4
> server012 kernel: [<ffffffff811b8014>] ?
> xfs_iext_add_indirect_multi+0x195/0x1de
> server012 kernel: [<ffffffff811b8a66>] ? xfs_iext_add+0x1a6/0x1e2
> server012 kernel: [<ffffffff811a4523>] ? xfs_btree_update+0x68/0xb5
> server012 kernel: [<ffffffff811b8b36>] ? xfs_iext_insert+0x34/0x5f
> server012 kernel: [<ffffffff8119de57>] ?
> xfs_bmap_add_extent_unwritten_real+0xace/0xc47
> server012 kernel: [<ffffffff811b80e2>] ? xfs_iext_bno_to_irec+0x85/0xae
> server012 kernel: [<ffffffff8119f367>] ? xfs_bmap_add_extent+0x1fd/0x326
> server012 kernel: [<ffffffff811cfb13>] ? kmem_zone_alloc+0x67/0xb4
> server012 kernel: [<ffffffff811a30b7>] ? xfs_bmbt_init_cursor+0x3a/0x110
> server012 kernel: [<ffffffff811a1d9b>] ? xfs_bmapi+0x9ff/0xd3e
> server012 kernel: [<ffffffff811bc4a1>] ?
> xfs_iomap_write_unwritten+0x1d8/0x27d
> server012 kernel: [<ffffffff8120a7c6>] ? kobject_put+0x47/0x4c
> server012 kernel: [<ffffffff812dda57>] ? put_device+0x12/0x14
> server012 kernel: [<ffffffff811d02b0>] ? xfs_end_io+0x42/0x91
> server012 kernel: [<ffffffff81048789>] ? process_one_work+0x189/0x25e
> server012 kernel: [<ffffffff811d026e>] ? xfs_end_io+0x0/0x91
> server012 kernel: [<ffffffff81048b14>] ? worker_thread+0x132/0x24f
> server012 kernel: [<ffffffff810489e2>] ? worker_thread+0x0/0x24f
> server012 kernel: [<ffffffff8104d55f>] ? kthread+0x81/0x89
> server012 kernel: [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
> server012 kernel: [<ffffffff8104d4de>] ? kthread+0x0/0x89
> server012 kernel: [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
> 
> Has anyone seen or had this problem?
> 
> below "uname" on host:
> Linux server012 2.6.38.8 #2 SMP Tue Jan 17 10:17:05 BRST 2012 x86_64
> Intel(R) Core(TM) i3 CPU 540 @ 3.07GHz GenuineIntel GNU/Linux
> 
> 
> 
> Thanks.
> Kelbel Junior
> 
> 
> 
> 
> 2012/1/16 Kelbel Junior <jymmyjr@gmail.com>:
> > Hello, everybody.
> > It appeared that same error message when using kernel version 2.6.38.8 ...
> >
> > Several lines in /var/log/messages with:
> > kernel: XFS: possible memory allocation deadlock in kmem_alloc (mode: 0x250)
> >
> > Does anyone know know if this bug has been fixed in newer versions of Linux
> > kernel? 3.x maybe?
> >
> >
> > 2011/5/11 Christoph Hellwig <>
> >>
> >> And here's the actual patch, sorry:
> >>
> >>
> >> Index: linux-2.6/fs/xfs/linux-2.6/kmem.c
> >> ===================================================================
> >> --- linux-2.6.orig/fs/xfs/linux-2.6/kmem.c	2011-05-11 17:29:51.729191621
> >> +0200
> >>
> >> +++ linux-2.6/fs/xfs/linux-2.6/kmem.c	2011-05-11 17:30:22.915689382 +0200
> >> @@ -56,10 +56,12 @@ kmem_alloc(size_t size, unsigned int __n
> >>  		ptr = kmalloc(size, lflags);
> >>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> >>
> >>  			return ptr;
> >> -		if (!(++retries % 100))
> >> +		if (!(++retries % 100)) {
> >>  			xfs_err(NULL,
> >>  		"possible memory allocation deadlock in %s (mode:0x%x)",
> >>  					__func__, lflags);
> >> +			dump_stack();
> >>
> >> +		}
> >>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
> >>  	} while (1);
> >>  }
> >> @@ -112,10 +114,12 @@ kmem_zone_alloc(kmem_zone_t *zone, unsig
> >>  		ptr = kmem_cache_alloc(zone, lflags);
> >>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> >>
> >>  			return ptr;
> >> -		if (!(++retries % 100))
> >> +		if (!(++retries % 100)) {
> >>  			xfs_err(NULL,
> >>  		"possible memory allocation deadlock in %s (mode:0x%x)",
> >>  					__func__, lflags);
> >> +			dump_stack();
> >>
> >> +		}
> >>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
> >>  	} while (1);
> >>  }
> >>
> >>
> >> 2011/5/11 Christoph Hellwig <>
> >>>
> >>> You're probably running into a different issue.  Any chance you can try
> >>> the attached patch to see where you're stuck exactly?
> >>>
> >>> Also in case you're using slub (CONFIG_SLUB) can you check if it still
> >>>
> >>> happens when using slab (CONFIG_SLAB) instead?
> >>>
> >>>
> >>> 2011/5/10 Felipe Wilhelms Damasio - Taghos <>
> >>>>
> >>>>     Hi Mr. Hellwig,
> >>>>
> >>>>     I saw the XFS deadlock thread regarding 2.6.38:
> >>>>
> >>>> http://www.linux.sgi.com/archives/xfs/2011-03/msg00185.html
> >>>>
> >>>>
> >>>>     I'm seeing too in 2.6.38.4. A lot of
> >>>>
> >>>> XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> >>>>
> >>>>     I checked the changelog for 2.6.38.6 and can't be sure if the fix
> >>>> got
> >>>> in...could you tell me if it did?
> >>>>
> >>>>
> >>>>     Thanks,
> >>>>
> >>>> --
> >>>>
> >>>> Felipe Wilhelms Damasio
> >>>>
> >>>>
> >>>> TAGHOS - Tecnologia
> >>>> Rua Prof. Alvaro Alvim, 211
> >>>> Porto Alegre - RS - (51) 3239-3180
> >>>> www.taghos.com.br <http://www.taghos.com.br/>
> >>>>
> >>>
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
