Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0NC8hR6184826 for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 06:08:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B12212F5D47
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 04:09:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	xUOClYqzjucIZlxp for <xfs@oss.sgi.com>;
	Sat, 23 Jan 2010 04:09:44 -0800 (PST)
Date: Sat, 23 Jan 2010 23:09:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.23 kdb in xfs_bmbt_get_block with unwritten extents
Message-ID: <20100123120941.GE25842@discord.disaster>
References: <212AA327A3557741A058E787E06188731FA4AA@xmb-sjc-219.amer.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <212AA327A3557741A058E787E06188731FA4AA@xmb-sjc-219.amer.cisco.com>
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
To: "Richard Troxell (rtroxell)" <rtroxell@cisco.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 21, 2010 at 05:41:48PM -0800, Richard Troxell (rtroxell) wrote:
> Hello All,
> 
> I am getting random kdbs when creating preallocated files that are
> excessively 'holey' (ex: 500MB+ file with alternating 4K written
> 4K unwritten extents). Creating such files is not my intention,
> and is being addressing in the userspace writer. That said, I am
> still concerned with running into kdb.
> 
> I am currently running 2.6.23.9, and have done some digging
> through the changelogs, but cant seem to find a match. Also,
> 2.6.24 seems to have a massive rewrite in this area, which
> significantly limits the scope that I can search.
> 
> The cause of the crash is a straigtforward NULL derference in
> xfs_bmap_btree.c:xfs_bmbt_get_block(), but I suspect the root
> cause is going to be some complex condition that corrupts the
> cursor...

There were lots of bugs found and fixed in the btree code between
2.6.23 and 2.6.26 that caused filesystem corruption or crashes like
this one. If you are hitting such problems, I'd suggest your easiest
solution is to upgrade to >= 2.6.27 and you should see the problems go
away.

> Given the trace, I assume that if I avoid all B+tree managed
> unwritten extents, I can avoid the crash. However avoiding such
> files completely seems a bit unrealistic, as I have the need to
> store files with a reasonable amount of holes...

The problems really had nothing to do with unwritten extents;
writing into holes or unwritten extents were simply one way to
trigger the corner cases containing the bugs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
