Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 15:38:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBHNbwKR027030
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 15:38:01 -0800
Date: Tue, 18 Dec 2007 10:37:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
Message-ID: <20071217233759.GB4396912@sgi.com>
References: <20071217143655.chiehahh@trusted.lncsa.com> <20071217220354.GU4396912@sgi.com> <4766F58C.8040000@lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766F58C.8040000@lncsa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Laurent CARON <lcaron@lncsa.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Dec 17, 2007 at 11:17:48PM +0100, Laurent CARON wrote:
> David Chinner wrote:
> > The symptoms you see are the machine running out of memory and the OOM
> > killer being invoked. There's nothing XFS here - you'd do better to post
> > to lkml about this.
> 
> So, I was wrong .... :$
> 
> > Hmmm - you appear to have a highmem based box and have run out of
> > low memory for the kernel. So while having ~9.5GB of free high
> > memory (that the kernel can't directly use), you're out of low
> > memory that the kernel can use and hence it is going OOM.  The
> > output of /proc/slabinfo or watching slabtop will tell you where
> > most of this memory is going.
> 
> Please find attached the output from /proc/slabinfo from both servers,
> as well as output from slabtop from server 1.
> 
> > 
> > FWIW, I suggest upgrading to a 64 bit machine ;)
> 
> I'm currently migrating those 2 servers to 2 64 Bit setups ;)
> 
> Thanks for your advice.
> 
> Laurent

> slabinfo - version: 2.1 (statistics)
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
> xfs_inode         227129 245574    408    9    1 : tunables   32   16    8 : slabdata  27286  27286
> xfs_vnode         227106 243130    392   10    1 : tunables   32   16    8 : slabdata  24313  24313
> radix_tree_node    88310  88356    312   12    1 : tunables   32   16    8 : slabdata   7363   7363
> dentry            170738 215280    160   24    1 : tunables   32   16    8 : slabdata   8970   8970
> buffer_head       150095 460752     80   48    1 : tunables   32   16    8 : slabdata   9599   9599

> slabinfo - version: 2.1 (statistics)
> xfs_inode         386493 386505    408    9    1 : tunables   32   16    8 : slabdata  42945  42945
> xfs_vnode         386491 386510    392   10    1 : tunables   32   16    8 : slabdata  38651  38651
> radix_tree_node    56266  56292    312   12    1 : tunables   32   16    8 : slabdata   4691   4691
> dentry            425976 425976    160   24    1 : tunables   32   16    8 : slabdata  17749  17749
> buffer_head       794845 794976     80   48    1 : tunables   32   16    8 : slabdata  16562  16562

>  Active / Total Objects (% used)    : 1031308 / 1501486 (68.7%)
>  Active / Total Slabs (% used)      : 87577 / 87659 (99.9%)
>  Active / Total Caches (% used)     : 116 / 179 (64.8%)
>  Active / Total Size (% used)       : 275759.16K / 331390.36K (83.2%)
>  Minimum / Average / Maximum Object : 0.04K / 0.22K / 4096.00K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> 460752 150236  32%    0.08K   9599       48     38396K buffer_head
> 244413 225674  92%    0.40K  27157        9    108628K xfs_inode
> 242010 225657  93%    0.38K  24201       10     96804K xfs_vnode
> 215280 171465  79%    0.16K   8970       24     35880K dentry
>  88368  88272  99%    0.30K   7364       12     29456K radix_tree_node

Hmmm - no real surprises there, but the numbers are well lower than the
~960MB low memory limit. I suspect that there's something at around
2.55am that does a filesystem traversal and that blows out the memory
usage of these slab caches and you run out of lowmem...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
