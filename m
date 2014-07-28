Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C8A27F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 11:04:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D5208F8037
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 09:03:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w35Dko5LCjxrYCS4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 09:03:56 -0700 (PDT)
Date: Mon, 28 Jul 2014 12:03:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/18] xfs: refactor xfs_inobt_insert() to eliminate loop
	and support variable count
Message-ID: <20140728160351.GB59542@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-2-git-send-email-bfoster@redhat.com>
	<20140724221038.GN20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140724221038.GN20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 25, 2014 at 08:10:38AM +1000, Dave Chinner wrote:
> On Thu, Jul 24, 2014 at 10:22:51AM -0400, Brian Foster wrote:
> > Inodes are always allocated in chunks of 64 and thus the loop in
> > xfs_inobt_insert() is unnecessary.
> 
> I don't believe this is true. The number of inodes allocated at once
> is:
> 
>         mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
> 	                                        sbp->sb_inopblock);
> 

So I'm going on that effectively that the number of inodes per block
will never be larger than 8 (v5) due to a max block size of 4k.

> So when the block size is, say, 64k, the number of 512 byte inodes
> allocated at once is 128. i.e. 2 chunks. Hence xfs_inobt_insert()
> can be called with a inode could of > 64 and therefore the loop is
> still necessary...
> 

Playing with mkfs I see that we actually can format >4k bsize
filesystems and the min and max are set at 512b and 64k. I can't
actually mount such filesystems due to the page size limitation. FWIW,
the default log size params appear to be broken for bsize >= 32k as
well, so I wonder if/how often that format tends to occur.

What's the situation with regard to >PAGE_SIZE block size support? Is
this something we actually could support today? Do we know about any
large page sized arches that could push us into this territory with the
actual page size limitation?

> And, indeed, we might want to increase the allocation size in future
> to do entire stripe units or stripe widths of inodes at once:
> 
> http://xfs.org/index.php/Improving_inode_Caching#Contiguous_Inode_Allocation
> 
> This also means a loop would be required -somewhere-...
> 

Indeed, though I'm less inclined to keep this around for the purposes of
this unimplemented feature. It should be easy enough to add the loop in
the appropriate place according to the code at the time this is
implemented.

I suppose if we have >4k page sized arches that utilize block sizes
outside of the 256b-4k range, that's enough to justify the existence of
the range in the general sense. I just might have to factor this area of
code a bit differently. It would also be nice if there was a means to
test.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
