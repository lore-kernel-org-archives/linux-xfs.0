Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3801F7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 22:52:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 249F88F8050
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 20:52:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GZv8mpwTyBJjvzhH for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 20:52:40 -0700 (PDT)
Date: Thu, 4 Apr 2013 14:52:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump having problems dumping attributes again (cannot
	allocate memory)
Message-ID: <20130404035237.GA12011@dastard>
References: <515CB2C1.1050109@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515CB2C1.1050109@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 03, 2013 at 03:52:49PM -0700, Linda Walsh wrote:
> 
> Note -- I might have more attributes than some as the disks are shared via samba
> w/windows
> and samba stores ACL and xattr info from windows in xfs's attrs...
> 
> 
> xfsdump: WARNING: could not get list of root attributes for nondir ino
> 3412893285: Cannot allocate memory (12)

....
> [1007383.689492] xfsdump: page allocation failure: order:4, mode:0x10c0d0
....
> [1007383.689531]  [<ffffffff81143a54>] kmalloc_order_trace+0x34/0xe0
> [1007383.689534]  [<ffffffff81146546>] __kmalloc+0x186/0x190
> [1007383.689541]  [<ffffffff8124263c>] xfs_attrlist_by_handle+0x8c/0x110
> [1007383.689544]  [<ffffffff81243487>] xfs_file_ioctl+0x437/0xb60

So it's the attribute handle interfaces that need the vmalloc
treatment here, just like has been done for all the other attribute
interfaces....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
