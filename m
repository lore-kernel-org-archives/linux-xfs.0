Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K1ixHp065597 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 20:45:00 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gSfht4QxicaG6j2j for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 18:44:57 -0700 (PDT)
Date: Fri, 20 Jul 2012 11:44:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: prevent xfs_bmap_extsize_align() to exceed
	maximum extent size.
Message-ID: <20120720014454.GI23387@dastard>
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
	<50059437.6070705@sgi.com> <20120719033027.GD23387@dastard>
	<5007C33B.5010603@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5007C33B.5010603@sgi.com>
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 19, 2012 at 10:20:11AM +0200, Alain Renaud wrote:
> 
> On 12-07-19 05:30 AM, Dave Chinner wrote:
> >
> >Note the minlen? It's been shortened to reflect the fact I don't
> >have 8GB freespace extents in the filesystem.
> >
> >Firstly, can you reproduce this on your test setup, Alain? What is
> >the size (and number) of the AGs in the filesystem? If you do see
> >this behaviour, then the alignment code is not the problem...
> 
> Note that I did provide an xfstest case in a seperate patch and YES
> you do need to make sure that the AG size is bigger then 8Gig for a
> filesystem with 4K block size you can reduce that by using a
> filesystem with a 512 block size and 1Gig AG. look for this patch
> that I sent to the list.
> 
> [PATCH] xfstest: preallocate file space greater then MAXEXTLEN
> 
> >
> >>+        * Make sure we do not exceed the maximum len of an extent.
> >>+        */
> >>+       align_alen = XFS_FILBLKS_MIN(align_alen,
> >>+                                    MAXEXTLEN - (MAXEXTLEN % extsz));
> >I don't think that is correct. alignment happens at both the start
> >and end of the extent, so you need to take into account two lots of
> >(extsz - 1) blocks of range extension for alignment.
> 
> If you look in the function where I put this code is it AFTER the
> head/len alignment so the HEAD is already align so I do not need to
> account for it.

No need to shout. I did look at the code, and IMO you do need to
account for both head and tail extension and you definitely can't do
it there.....

> And if you look at the rest of the function we can
> only decrease the length and we do return the start and the length
> not the start and the end.

Sure, but that's not the problem.  You're passing in {orig_off,
orig_len}, and the idea is to extend it -outwards- to {align_off,
align_len}. In other words, correct behaviour is this:

	extsize:	|-----|-----|-----|-----|-----|-----|
	orig:		  o---|-----|-----|-----|-----|--o
	aligned:	a-----|-----|-----|-----|-----|-----a

If orig_len > (MAXEXTLEN - extsize), then the existing code
overflows and causes ENOSPC, but your code now results in this:

	extsize:	|-----|-----|-----|-----|-----|-----|
	orig:		  o---|-----|-----|-----|-----|--o
	new:		n-----|-----|-----|-----|-----n

which is incorrect as it does not cover the entire range of the
original request. That's why it fired that assert that you removed -
the newly aligned offset+len does not extend past the original
extent end. Alignment has well defined behavioural semantics, and we
do not want to add a special case here because we use the same
"aligment extends outwards" semantics all throughout the allocation
code. 

Fundamentally, you can't fix the extent length alignment overflow
problem in the alignment function as it knows nothing of the calling
context. It aligns outwards only and hence the caller has to limit
the incoming extent length to prevent the alignment extension length
overflows.

> >>@@ -1999,7 +2004,6 @@ xfs_bmap_extsize_align(
> >>  			return XFS_ERROR(EINVAL);
> >>  	} else {
> >>  		ASSERT(orig_off >= align_off);
> >>-		ASSERT(orig_end <= align_off + align_alen);
> >Why is this removed? What it is checking is that the aligned end
> >covers the entire range of the original space requested.
> 
> This is the logic I am following if the original start was at zero
> and the length we passed in was 9G the orig_end would be at 0+9G
> however the since we will truncate the 8Gig the align_off +
> align_alen will be smaller then 9G

I don't think you can pass a length of greater than MAXEXTLEN to
xfs_bmap_extsize_align() anymore. I've spent a fair bit of time
debugging problems as a result of missing length limiting in the
calling functions. IOWs, anything coming through
xfs_bmapi_allocate() will already be limited to MAXEXTLEN. from
xfs_bmapi_write():

                        /*
                         * There's a 32/64 bit type mismatch between the
                         * allocation length request (which can be 64 bits in
                         * length) and the bma length request, which is
                         * xfs_extlen_t and therefore 32 bits. Hence we have to
                         * check for 32-bit overflows and handle them here.
                         */
                        if (len > (xfs_filblks_t)MAXEXTLEN)
                                bma.length = MAXEXTLEN;
                        else
                                bma.length = len;

                        ASSERT(len > 0);
                        ASSERT(bma.length > 0);
                        error = xfs_bmapi_allocate(&bma, flags);

xfs_bmapi_allocate() has other range limits to MAXEXTLEN as well,
and we know that xfs_bmapi_delalloc_reserve() ensures this as well.
Hence no-one should be asking to allocate more than MAXEXTLEN at at
time through any path to xfs_bmap_extsize_align(). Hence I don't
think your logic is valid as it assumes a condition that shouldn't
exist (i.e. is a bug) occurs.

Alain, I'm really glad you're trying to understand this code well
enough to fix problems in it,  but please understand that it took me
5 years of digging in this code before I had any confidence that I
knew how it worked.  I went through this same "i think I've fixed
it, but it fires this strange ASSERT" process many times, and the
result of an ASSERT firing -always- was that my logic was flawed and
I didn't understand the code correctly, so the fix was wrong. I
expect anyone else trying to fix bugs in this code is going to have
exactly the same learning curve I had. Hence when I see changes to
assert statements along with the fix to this code, it raises a great
big red flag....

Remember, the xfs_bmap.c code is the most complex and most critical
code in XFS, and so my review process reflects that. I need to 1)
reproduce it reliably 2) understand what the problem is, and 3) test
the fix before I can say I've reviewed it. Right now I haven't got
past 1) as all my test machines show it to be a transient
condition and that needs to be understood first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
