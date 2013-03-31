Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BD2D7F55
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 20:22:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3AFD08F8049
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 18:22:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mKGAahNV1PghoNjy for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 18:22:35 -0700 (PDT)
Date: Sun, 31 Mar 2013 12:22:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130331012231.GJ6369@dastard>
References: <5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5155F2B2.1010308@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 29, 2013 at 03:59:46PM -0400, Dave Hall wrote:
> Dave, Stan,
> 
> Here is the link for perf top -U:  http://pastebin.com/JYLXYWki.
> The ag report is at http://pastebin.com/VzziSa4L.  Interestingly,
> the backups ran fast a couple times this week.  Once under 9 hours.
> Today it looks like it's running long again.

    12.38%  [xfs]     [k] xfs_btree_get_rec
    11.65%  [xfs]     [k] _xfs_buf_find
    11.29%  [xfs]     [k] xfs_btree_increment
     7.88%  [xfs]     [k] xfs_inobt_get_rec
     5.40%  [kernel]  [k] intel_idle
     4.13%  [xfs]     [k] xfs_btree_get_block
     4.09%  [xfs]     [k] xfs_dialloc
     3.21%  [xfs]     [k] xfs_btree_readahead
     2.00%  [xfs]     [k] xfs_btree_rec_offset
     1.50%  [xfs]     [k] xfs_btree_rec_addr

Inode allocation searches, looking for an inode near to the parent
directory.

Whatthis indicates is that you have lots of sparsely allocated inode
chunks on disk. i.e. each 64 indoe chunk has some free inodes in it,
and some used inodes. This is Likely due to random removal of inodes
as you delete old backups and link counts drop to zero. Because we
only index inodes on "allocated chunks", finding a chunk that has a
free inode can be like finding a needle in a haystack. There are
heuristics used to stop searches from consuming too much CPU, but it
still can be quite slow when you repeatedly hit those paths....

I don't have an answer that will magically speed things up for
you right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
