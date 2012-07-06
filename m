Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q661tgEj123442 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 20:55:42 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id ZCDFILmNdVLD3XmI for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 18:55:41 -0700 (PDT)
Date: Thu, 5 Jul 2012 18:55:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.5.0-rc5: inconsistent lock state
In-Reply-To: <20120706010126.GT19223@dastard>
Message-ID: <alpine.DEB.2.01.1207051824190.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
	<20120705074307.GA28127@infradead.org>
	<alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
	<20120705215940.GP19223@dastard>
	<alpine.DEB.2.01.1207051615421.5568@trent.utfs.org>
	<20120706010126.GT19223@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 6 Jul 2012 at 11:01, Dave Chinner wrote:
> Applications can use attributes without you being aware of them.
> e.g. Samba, desktop search/indexing, etc might be using attributes
> even though you aren't explicitly using them....

Hm, it's some kind of server, samba is serving those mounts, but only as 
readonly shares. When running "getfattr -R" or "getfacl -R" on these xfs 
filesystems, only very few (<100) file have attribtues / ACLs set.

> > 50 bytes sounds more than enought for holding only unix permissions.
> Unix permissions are held in the inode core, not in the attribute
> space.

Even better, so I'm really at a loss what could use up this attribute 
space.


> And i did say "typically". if you have a file that has 6-7 extents,
> then there won't be any space for attributes and it will put new
> attributes out of line immediately....

$ xfs_bmap foo | wc -l
933

And there are lots of files held by lots of extents, so this might be it.

Thanks for this guide through this attribute business. There's currently 
no problem with any of the filesystems but I was tipped off by Christoph's 
remark about "running out of inode attributes" which got me scared a 
little. I understand that it might be a performance issue having to do 
an extra lookup for attributes, but I still fail to see how (and where) 
they sneaked into the fs.

Christian.
-- 
BOFH excuse #284:

Electrons on a bender

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
