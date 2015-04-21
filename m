Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FB467F3F
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2015 20:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E039304048
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2015 18:06:51 -0700 (PDT)
Received: from shells.gnugeneration.com (shells.gnugeneration.com
	[66.240.222.126]) by cuda.sgi.com with SMTP id jgTC9RsIMM5IDAbr
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2015 18:06:46 -0700 (PDT)
Date: Mon, 20 Apr 2015 20:06:46 -0500
From: xfs@pengaru.com
Subject: question re: xfs inode to inode copy implementation
Message-ID: <20150421010646.GX8110@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: vito.caputo@coreos.com

Hello list,

I'm prototyping something like reflinks in xfs and was wondering if
anyone could give me some pointers on the best way to duplicate the
blocks of the shared inode at the reflink inode, the copy which must
occur when breaking the link.

It would be nice to do the transfer via the page cache after allocating
the space at the desintation inode, but it doesn't seem like I can use
any of the kernel helpers for copying the data via the address_space
structs since I don't have a struct file on hand for the copy source.
I'm doing this in xfs_file_open() so the only struct file I have is the
file being opened for writing - the destination of the copy.

What I do have on hand is the shared inode and the destination inode
opened and ready to go, and the struct file for the destination.

My prototype already mostly works just using xfs_alloc_file_space() to
allocate the appropriate space in the destination inode, but I need to
get that allocated space populated from the shared inode's extents.

Any pointers appreciated, thanks!

Regards,
Vito Caputo


P.S. I've seen Dave Chinner's mention of reflink prototypes in XFS on
lwn but haven't been able to find any code, what's the status of that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
