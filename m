Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88B087CCC
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 11:59:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1827AC007
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 09:58:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o47amFCyXzc37zDa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 09:58:55 -0700 (PDT)
Date: Wed, 23 Mar 2016 12:58:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160323165853.GE43073@bfoster.bfoster>
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
	<56F2B036.4090306@kyup.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F2B036.4090306@kyup.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nikolay Borisov <kernel@kyup.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 05:03:18PM +0200, Nikolay Borisov wrote:
...
> > I'm not sure where one would draw the line tbh, it's just a matter of
> > having too many extents to the point that it causes problems in terms of
> > performance (i.e., reading/modifying the extent list) or such as the
> > allocation problem you're running into. As it is, XFS maintains the full
> > extent list for an active inode in memory, so that's 800k+ extents that
> > it's looking for memory for.
> 
> I saw in the comments that this problem has already been identified and
> a possible solution would be to add another level of indirection. Also,
> can you confirm that my understanding of the operation of the
> indirection array is correct in that each entry in the indirection array
> xfs_ext_irec is responsible for 256 extents. (the er_extbuf is
> PAGE_SIZE/4kb and an extent is 16 bytes which results in 256 extents)
> 

That looks about right from the XFS_LINEAR_EXTS #define. I see the
comment but I've yet to really dig into the in-core extent list data
structures too deep to have any intuition or insight on a potential
solution (and don't really have time to atm). Dave or others might
already have an understanding of a limitation here.

> > 
> > It looks like that is your problem here. 800k or so extents over 878G
> > looks to be about 1MB per extent. Are you using extent size hints? One
> > option that might prevent this is to use a larger extent size hint
> > value. Another might be to preallocate the entire file up front with
> > fallocate. You'd probably have to experiment with what option or value
> > works best for your workload.
> 
> By preallocating with fallocate you mean using fallocate with
> FALLOC_FL_ZERO_RANGE and not FALLOC_FL_PUNCH_HOLE, right? Because as it
> stands now the file does have holes, which presumably are being filled
> and in order to be filled an extent has to be allocated which caused the
> issue?  Am I right in this reasoning?
> 

You don't need either, but definitely not hole punch. ;) See 'man 2
fallocate' for the default behavior (mode == 0). The idea is that the
allocation will occur with as large extents as possible, rather than
small, fragmented extents as writes occur. This is more reasonable if
you ultimately expect to use the entire file.

> Currently I'm not using extents size hint but will look into that, also
> if the extent size hint is say 4mb, wouldn't that cause a fairly serious
> loss of space, provided that the writes are smaller than 4mb. Would XFS
> try to perform some sort of extent coalescing or something else? I'm not
> an FS developer but my understanding is that with a 4mb extent size,
> whenever a new write occurs even if it's 256kb a new 4mb extent would be
> allocated, no?
> 

Yes, the extent size hint will "widen" allocations due to smaller writes
to the full hint size and alignment. This results in extra space usage
at first but reduces fragmentation over time as more of the file is
used. E.g., subsequent writes within that 4m range of your previous 256k
write will already have blocks allocated (as part of a larger,
contiguous extent).

The best bet is probably to experiment with your workload or look into
your current file layout and try to choose a value that reduces
fragmentation without sacrificing too much space efficiency.

> And a final question - when i printed the contents of the inode with
> xfs_db I get core.nextents = 972564 whereas invoking the xfs_bmap | wc
> -l on the file always gives varying numbers?
> 

I'd assume that the file is being actively modified..? I believe xfs_db
will read values from disk, which might not be coherent with the latest
in memory state, whereas bmap returns the latest layout of the file at
the time (which could also change again by the time bmap returns).

Brian

> Thanks a lot for taking the time to reply.
> 
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
