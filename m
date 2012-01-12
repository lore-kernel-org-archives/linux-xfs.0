Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CDrBR5259222 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 07:53:11 -0600
Message-ID: <4F0EE5B6.2040408@oracle.com>
Date: Thu, 12 Jan 2012 21:52:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com>
	<20120110171855.GX6390@sgi.com>	<4F0D21E5.7010908@oracle.com>
	<4F0DFB20.7030704@sgi.com>
In-Reply-To: <4F0DFB20.7030704@sgi.com>
Reply-To: jeff.liu@oracle.com
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Mark,

On 01/12/2012 05:12 AM, Mark Tinguely wrote:

> xfs_has_unwritten_buffer() always returns the offset of the first
> dirty unwritten page. This can cause xfs_seek_data() and xfs_seek_hole()
> to give the wrong results in certain circumstances.

Sorry, am was well understood your opinions in this point for now.
IMHO, we can only find and return the data buffer offset at a dirty or
unwritten page once the first page was probed.

> 
> 
> In xfs_seek_data(), every page past first dirty/unwritten page in the
> unwritten extent will be reported as data.

Hmm, consider the user level utility that make use of SEEK_XXX stuff to
copy data from an offset in source file:

Generally, it will call xfs_seek_data() firstly,
if we read an unwritten extent and there is data buffer was probed in
xfs_seek_data(), it only means we can read file data starting from the
returned offset of xfs_has_unwritten_buffer().

Then it will call xfs_seek_hole() to calculate this extent length.
next, a couple of read()/write() will be called in a loop depending on
the extent length.

[  page 1  ] | [  page 2  ] | [  page 3  ] | .... [  page N  ]
                 |data offset at page 2|

If we got the data offset from page2, and there is no data at page 3,
the user utility call read(2) will returns ZERO, and it will break
immediately.


> 
> 
> in xfs_seek_data():
> +        /*
> +         * Landed in an unwritten extent, try to find out the data
> +         * buffer offset from page cache firstly. If nothing was
> +         * found, treat it as a hole, and skip to check the next
> +         * extent, something just like above.
> +         */
> +        if (map[0].br_state == XFS_EXT_UNWRITTEN) {
> +            if (xfs_has_unwritten_buffer(inode, &map[0],
> +                             PAGECACHE_TAG_DIRTY,
> +                             &offset) ||
> +                xfs_has_unwritten_buffer(inode, &map[0],
> +                             PAGECACHE_TAG_WRITEBACK,
> +                             &offset)) {
> +                offset = max_t(loff_t, seekoff, offset);
> +                break;
> +            }
> 
> Since the xfs_has_unwritten_buffer() returns the offset of the first
> dirty/unwritten page (the first page in this example), the max_t()
> comparison will say that every page after the first dirty page has
> data.
> 
>         -----
> 
> xfs_seek_hole() can only find a hole if it precedes the first dirty
> page.

Yes, for my current implementation, it is the case.
Anyway, I need a careful consideration for probing unwritten extent. :-)


Thanks,
-Jeff

> 
> in xfs_seek_hole():
> +        /*
> +         * Landed in an unwritten extent, try to lookup the page
> +         * cache to find out if there is dirty data or not. If
> +         * nothing was found, treate it as a hole. If there has
> +         * dirty data and its offset starts past both the start
> +         * block of the map and the current seek offset, it should
> +         * be treated as hole too. Otherwise, go through the next
> +         * extent to fetch holes.
> +         */
> +        if (map[0].br_state == XFS_EXT_UNWRITTEN) {
> +            if (xfs_has_unwritten_buffer(inode, &map[0],
> +                             PAGECACHE_TAG_DIRTY,
> +                             &offset) ||
> +                xfs_has_unwritten_buffer(inode, &map[0],
> +                             PAGECACHE_TAG_WRITEBACK,
> +                             &offset)) {
> +                if (offset > max_t(loff_t, seekoff,
> +                           XFS_FSB_TO_B(mp,
> +                           map[0].br_startoff))) {
> +                    offset = max_t(loff_t, seekoff,
> +                               XFS_FSB_TO_B(mp,
> +                               map[0].br_startoff));
> +                    break;
> +                }
> +            } else {
> +                offset = max_t(loff_t, seekoff,
> +                    XFS_FSB_TO_B(mp, map[0].br_startoff));
> +                break;
> +            }
> 
> --Mark Tinguely.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
