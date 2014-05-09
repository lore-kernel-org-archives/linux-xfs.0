Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EF4E7F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 02:31:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4593A8F8037
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 00:31:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id wALjpiB1YADRM9V1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 May 2014 00:31:28 -0700 (PDT)
Date: Fri, 9 May 2014 00:31:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/18] xfs: add xfs_da_geometry to inode forks
Message-ID: <20140509073127.GC7882@infradead.org>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
	<1399537188-26509-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399537188-26509-19-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, May 08, 2014 at 06:19:48PM +1000, Dave Chinner wrote:
> While this might seem wasteful to burn a pointer in the data fork
> for all files, consider that the geometry information
> for data allocation can be abstracted from the xfs_mount in exactly
> the same way as has been done for the directory geometry.
> Effectively it's a hook to carry allocation policy around in....
> 
> So, add the geometry pointer to the inode fork, and initialise is
> appropriately and use it for all the directory and attribute
> operation setup instead ofthe xfs_mount version.

A definitively NAK to bloating the inode without actually making
use of this.  I can see where you might want to go with this, but
until we actuall support different dir block sizes per inodes or
similar, and it actually proves to be useful this is not something
that should go in.

The rest of the series looks okay as long as we don't touch the inode,
but I'll have to do a slightly more detailed review.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
