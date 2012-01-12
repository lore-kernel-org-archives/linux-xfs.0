Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CF1nuj001034 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:01:49 -0600
Message-ID: <4F0EF5DC.1070207@sgi.com>
Date: Thu, 12 Jan 2012 09:01:48 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com>
	<20120110171855.GX6390@sgi.com>	<4F0D21E5.7010908@oracle.com>
	<4F0DFB20.7030704@sgi.com> <4F0EE5B6.2040408@oracle.com>
In-Reply-To: <4F0EE5B6.2040408@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 01/12/12 07:52, Jeff Liu wrote:
> Hi Mark,
>
> On 01/12/2012 05:12 AM, Mark Tinguely wrote:
>
>> xfs_has_unwritten_buffer() always returns the offset of the first
>> dirty unwritten page. This can cause xfs_seek_data() and xfs_seek_hole()
>> to give the wrong results in certain circumstances.
>
> Sorry, am was well understood your opinions in this point for now.
> IMHO, we can only find and return the data buffer offset at a dirty or
> unwritten page once the first page was probed.
>

 From my tests, xfs_bmapi_read() can only find holes if they cross or 
start on a 64KB boundary. It would be nice if unwritten extents were at 
least that good at finding holes.


In xfs_has_unwritten_buffer(), could you start searching from the seek 
offset? The variable *offset could pass in that seek address and us that 
offset as the starting "index" rather than the beginning of the extent?

You start:

        index = XFS_FSB_TO_B(mp, map->br_startoff) >> PAGE_CACHE_SHIFT;

Could we do?:

	index = XFS_FSB_TO_B(mp, *offset) >> PAGE_CACHE_SHIFT;

And before calling xfs_has_unwritten_buffer():
	offset = seekoff;

Also, my idea to find the next data/hole requires that 
xfs_has_unwritten_buffer() finds the smallest PAGECACHE_TAG_DIRTY or 
PAGECACHE_TAG_WRITEBACK page if any starting at the seek offset.


>>
>> In xfs_seek_data(), every page past first dirty/unwritten page in the
>> unwritten extent will be reported as data.
>
> Hmm, consider the user level utility that make use of SEEK_XXX stuff to
> copy data from an offset in source file:
>
> Generally, it will call xfs_seek_data() firstly,
> if we read an unwritten extent and there is data buffer was probed in
> xfs_seek_data(), it only means we can read file data starting from the
> returned offset of xfs_has_unwritten_buffer().
>
> Then it will call xfs_seek_hole() to calculate this extent length.
> next, a couple of read()/write() will be called in a loop depending on
> the extent length.
>
> [  page 1  ] | [  page 2  ] | [  page 3  ] | .... [  page N  ]
>                   |data offset at page 2|
>
> If we got the data offset from page2, and there is no data at page 3,
> the user utility call read(2) will returns ZERO, and it will break
> immediately.
>

Something like:
	loop
		s = lseek(fd, off, SEEK_DATA);
		if (s == -1)
			if we errno == ENXIO
				return done /* eof */
			else
				return errno
			
		e = lseek(fd, s, SEEK_HOLE);
		if (e == -1)
			return errno

		dest = copy from s to e
		off = e
	end loop (if not eof or other condition)

You will seek for next hole at the found data position. Even if 
xfs_has_unwritten_buffer() does the right thing and returns the 
dirty/unwritten page starting from seekoff, we need go a page past the 
current page (which has data) to look for the next hole.



Something like (again psuedo-code)
	loop
		offset1 = offset2 = seekoff
		xfs_has_unwritten_buffer(seekoff, &offset1, DIRTY)
		xfs_has_unwritten_buffer(seekoff, &offset2, WRITEBACK)
		d = min(offset1, offset2)

		if (d > seekoff OR d == NULL)
			return found a hole at seekoff

		if (d == seekoff) /* standard case assuming how we
				   * use SEEK_DATA/SEEK_HOLE
				   * This is the step your code
				   * does not perform. It jumps
				   * to the next extent
				   */
			seekoff += page size of dirty/writeback **
	end while the seekoff < extent size

** here we could jump to the next 64KB boundary and be as accurate as 
xfs_bmapi_read().

Good job. This is an important feature.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
