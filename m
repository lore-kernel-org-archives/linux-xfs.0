Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LHM6ZC200216 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:22:06 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id WHHEQM9BirstVMQP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 09:22:05 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RztPh-0008U4-Av
	for xfs@oss.sgi.com; Tue, 21 Feb 2012 09:22:05 -0800
Message-ID: <33365485.post@talk.nabble.com>
Date: Tue, 21 Feb 2012 09:22:05 -0800 (PST)
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: Re: [PATCH 4/4] xfs: fix deadlock in xfs_rtfree_extent with kernel
	v2.6.37
In-Reply-To: <20120219224118.GA31535@infradead.org>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
	<33346051.post@talk.nabble.com>
	<20120219224118.GA31535@infradead.org>
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
To: xfs@oss.sgi.com




Christoph Hellwig wrote:
> 
> I think you're better off fixing this problem like I did for the
> allocation side, that is:
> 
>  - remove the xfs_ilock and xfs_trans_ijoin (or probably still
>    xfs_trans_iget in your version) from xfs_rtfree_extent, and
>    instead add asserts that the inode is locked and has an inode_item
>    attach to it.
>  - in xfs_bunmapi if we are dealing with an inode with the rt flag
>    bump the reference count on the inode there and attach it to the
>    transaction before calling into xfs_bmap_del_extent, similar to
>    what we do in xfs_bmap_rtalloc.
> 

I will make the change and test and send the new version of the patch.
BTW when you say reference counting the inode do you mean I should call 
xfs_trans_ijoin_ref().


-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--RFC-xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33365485.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
