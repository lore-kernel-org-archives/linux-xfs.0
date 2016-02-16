Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FD9C7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 18:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8B2BAC002
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 16:20:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	e192OClf7NWg9gdX for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 16:20:26 -0800 (PST)
Date: Tue, 16 Feb 2016 11:20:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fiemap issue with Linux 3.10.0-327.el7.x86_64 (CentOS 7)
Message-ID: <20160216002012.GK14668@dastard>
References: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
	<56C219F0.3050002@sandeen.net>
	<CAJkH1p5ZP-Wg=UgwBZKz6rZS=_5-o625HZPAosW7tt-zpaNDOg@mail.gmail.com>
	<20160215204009.GJ14668@dastard> <56C25574.2060307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C25574.2060307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 04:47:16PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/15/16 2:40 PM, Dave Chinner wrote:
> > On Mon, Feb 15, 2016 at 02:28:36PM -0500, Jim Wilcoxson wrote:
> >> Thanks Eric.
> >>
> >> I ran xfs_bmap -v and it returned extents 0-19999, alternating data
> >> with holes.  The holes and data were various sizes, I suppose for xfs
> >> alignment reasons, but everything was there.
> >>
> >> Running fiemap again after xfs_bmap still returned 1364 extents.
> > 
> > Yes, fiemap in XFS uses a buffer size of:
> > 
> >         bm.bmv_count = min_t(__s32, bm.bmv_count,
> >                              (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
> > 
> > i.e. limits a single fiemap fetch to a maximum of 64k of extent
> > data.
> > 
> > I think you have an incorrect assumption about fiemap behaviour.
> > fiemap is not designed to return or even count all the extents in a
> > file in a single call; 
> 
> I think it is; as was quoted earlier,
> 
> "If fm_extent_count is zero, then the
> fm_extents[] array is ignored (no extents will be returned), and the
> fm_mapped_extents count will hold the number of extents needed in
> fm_extents[] to hold the file's current mapping."
> 
> and that's in there:
> 
>         /* only count the extents */
>         if (fieinfo->fi_extents_max == 0) {
>                 fieinfo->fi_extents_mapped++;
>                 return (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
>         }

Right, but I think we only pass one /internal/ buffer's extents to
the fill function. When we run out of extents to process (i.e we hit
the limit in the above extent count passed to xfs_getbmapx), it
returns to userspace.

This isn't a problem when iterating extent lists, because of the
FIEMAP_EXTENT_LAST is exported to userspace. The problem appears to
be that counting has different semantics, and I bet nobody wrote a
regression test that covered this case....

> > on XFS it returns how many extents it can
> > return in a single call. When you then map the file, if the
> > FIEMAP_EXTENT_LAST is not set on the last extent returned, then the
> > application needs to make another FIEMAP call from the end offset of
> > last extent mapping returned in the last call, and it will then
> > return the next N extents in the file.
> > 
> > IOWs, you have to keep calling FIEMAP to map the entire file, not
> > assume a single call will return an arbitrary amount of data to you
> > in a single call.
> 
> He's not trying to get all data in one call, just a count.

I was under the impression that counting was a ranged operation,
too. i.e. you can ask for the number of extents within a certain
file offset. Maybe we have got counting wrong as FIEMAP_EXTENT_LAST
is never exposed to userspace, nor does the fiemap code record the
offset we counted up to, so it would be hard to iterate.

Patches to fix the kernel, to support extent counting in xfs_io
and a regression test, please!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
