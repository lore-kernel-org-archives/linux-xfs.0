Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OCHHLf207543 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 07:17:17 -0500
Date: Sun, 24 Jul 2011 08:17:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: unable to handle kernel paging request xfs_is_delayed_page
Message-ID: <20110724121714.GA22065@infradead.org>
References: <4E289228.4000208@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E289228.4000208@gmail.com>
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
To: T?r?k Edwin <edwintorok@gmail.com>
Cc: xfs-masters@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jul 21, 2011 at 11:55:04PM +0300, T?r?k Edwin wrote:
> Not sure what the BUG means: did XFS ran out of memory when trying to write the 4GB coredump, as it wanted to allocate an extra 4G temporarely to hold it?
> 

It means we dereferenced an invalid pointer in xfs_is_delayed_page,
which is called from the writeback code, which is pretty odd.  We
haven't really touched that particular piece of code for a long time,
and it really doesn't derefence many pointers, basically just
page->mapping, page->private and the flags and b_this_page fields
in the buffer head.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
