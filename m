Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67CF57F55
	for <xfs@oss.sgi.com>; Sat,  8 Nov 2014 17:43:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7595AC002
	for <xfs@oss.sgi.com>; Sat,  8 Nov 2014 15:43:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	m35F2FyRt75xlDLI for <xfs@oss.sgi.com>;
	Sat, 08 Nov 2014 15:43:20 -0800 (PST)
Date: Sun, 9 Nov 2014 10:42:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: beginners project: RENAME_WHITEOUT
Message-ID: <20141108234232.GJ28565@dastard>
References: <20141107190959.GB21021@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141107190959.GB21021@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com

On Fri, Nov 07, 2014 at 11:09:59AM -0800, Christoph Hellwig wrote:
> The overlayfs merge introduces a new rename flag to create to whiteouts.
> Should be a fairly easy to implement.
> 
> Miklos, do you have any good documentation and/or test cases for this?

So overlayfs uses some weird char dev hack to implement whiteout
inodes in directories?  Why do we need a whiteout inode on disk?
what information is actually stored in the whiteout inode that
overlayfs actually needs?  Only readdir and lookup care about
whiteouts, and AFAICT nothing of the inode is ever used except
checking the chrdev/whiteoutdev hack via ovl_is_whiteout(dentry).

Indeed, whatever happened to just storing the whiteout in the dirent
via DT_WHT and using that information on lookup in the lower
filesystem to mark the dentry returned appropriately without needing
to lookup a real inode?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
