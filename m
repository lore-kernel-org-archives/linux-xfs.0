Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANEUlpo218739
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 08:30:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07D1E571B56
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 06:30:46 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DZqfopvX0OTtdBO9 for <linux-xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 06:30:46 -0800 (PST)
Date: Wed, 23 Nov 2011 09:30:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly
Message-ID: <20111123143045.GA20892@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20111123T134243-580@post.gmane.org>
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
To: Guoquan Yang <ygq51@hotmail.com>
Cc: linux-xfs@oss.sgi.com, hank peng <pengxihan@gmail.com>

On Wed, Nov 23, 2011 at 01:04:58PM +0000, Guoquan Yang wrote:
> I meet with a problem when using 64bit XFS and NFS,
> 
> When I access a directory from the NFS client,I get Stale NFS file Handle 
> error.But it is ok when accessing on the server without NFS.
> 
> And I have checked that the inode num in the NFS file handle is the same as 
> inode num on the server, Using ls -il.
> 
> I found that XFS_IGET_UNTRUSTED in xfs_imap() filtered the function 
> xfs_imap_lookup(),It fails in xfs_imap_lookup() when access from NFS 
> client.local access does not go into xfs_imap_lookup().
> 
> My kernel is Linux2.6.35.6 from kernel.org. please help me to find out this 
> problem!

It seems like you hit the same issue hank peng reported recently, and
in facr your are on the same kernel for the serve as he is.

>From a closer look it seems like the changes you mentioned above indeed
had a bug in Linux 2.6.35, which was later fixed with the following
commit

mmit 4536f2ad8b330453d7ebec0746c4374eadd649b1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 24 11:42:30 2010 +1000

    xfs: fix untrusted inode number lookup

which should be included in Linux 2.6.35.6.  Can you make sure you
really have the commit?  Can you also verify that a recent kernel
like Linux 3.0-stable shows the same behaviour?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
