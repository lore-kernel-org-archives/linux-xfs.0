Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 542457F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 18:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43B1C8F8049
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 16:56:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GEGqUwCS62kFneU6 for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 16:56:47 -0700 (PDT)
Date: Tue, 24 Sep 2013 09:56:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
Message-ID: <20130923235642.GY9901@dastard>
References: <523EA96B.3040904@oracle.com> <20130923005657.GN12541@dastard>
	<523FC7DB.20204@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523FC7DB.20204@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 23, 2013 at 12:47:23PM +0800, Jeff Liu wrote:
> Hi Dave,
> 
> On 09/23/2013 08:56 AM, Dave Chinner wrote:
> 
> > On Sun, Sep 22, 2013 at 04:25:15PM +0800, Jeff Liu wrote:
> >> From: Jie Liu <jeff.liu@oracle.com>
> >>
> >> At xfs_iext_realloc_direct(), the new_size is changed by adding
> >> if_bytes if originally the extent records are stored at the inline
> >> extent buffer, and we have to switch from it to a direct extent
> >> list for those new allocated extents, this is wrong. e.g,
> >>
> >> Create a file with three extents which was showing as following,
> >>
> >> xfs_io -f -c "truncate 100m" /xfs/testme
> >>
> >> for i in $(seq 0 5 10); do
> >> 	offset=$(($i * $((1 << 20))))
> >> 	xfs_io -c "pwrite $offset 1m" /xfs/testme
> >> done
> >>
> >> Inline
> >> ------
> >> irec:	if_bytes	bytes_diff	new_size
> >> 1st	0		16		16
> >> 2nd	16		16		32
> >>
> >> Switching
> >> ---------						rnew_size
> >> 3rd	32		16		48 + 32 = 80	roundup=128
> >>
> >> In this case, the desired value of new_size should be 48, and then
> >> it will be roundup to 64 and be assigned to rnew_size.
> > 
> > Ok, so it allocates 128 bytes instead of 64 bytes. It tracks that
> > allocation size correctly ifp->if_real_bytes, and all it means is
> > that there are 4 empty extra slots in the extent array. The code
> > already handles having empty slots in the direct extent array, so
> > what impact is there as a result of the oversized initial allocation
> > that is currently happening?
> > 
> > i.e. if fixing the oversized results in more memory allocations due
> > to resizing more regularly, then is there a benefit to changing this
> > code given that the rewrite of the ifp->if_bytes value in the case
> > where we do inline->direct conversion prevents this over-allocation
> > from being a problem...
> 
> I guess my current patch subject/description mislead you.  The result
> of the oversized can be ignored since this can be handled in the direct
> extent array as empty slots.

That's what I thought ;)

> Actually, what I want to say is that we don't need to perform
> "new_size += ifp->if_bytes;" again at xfs_iext_realloc_direct()
> because the new_size at xfs_iext_add() already be the size of
> extents after adding, just as the variable comments is mentioned.

Yes, I understand.

What I'm really asking is that whether there is any specific impact
you can measure as a result of changing the initial allocation size?
i.e. are there workloads where there is a measurable difference in
memory footprint or noticable performance impact of having to
reallocate the direct array more frequently as files grow and/or
shrink?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
