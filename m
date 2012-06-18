Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IIPeUW221086 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 13:25:40 -0500
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id zwMgKtUD2HnszxnN for
	<xfs@oss.sgi.com>; Mon, 18 Jun 2012 11:25:39 -0700 (PDT)
Subject: Re: XFS status update for May 2012
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20120618120853.GA15480@infradead.org>
Date: Mon, 18 Jun 2012 12:25:37 -0600
Message-Id: <AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
References: <20120618120853.GA15480@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
> May saw the release of Linux 3.4, including a decent sized XFS update.
> Remarkable XFS features in Linux 3.4 include moving over all metadata
> updates to use transactions, the addition of a work queue for the
> low-level allocator code to avoid stack overflows due to extreme stack
> use in the Linux VM/VFS call chain,

This is essentially a workaround for too-small stacks in the kernel,
which we've had to do at times as well, by doing work in a separate
thread (with a new stack) and waiting for the results?  This is a
generic problem that any reasonably-complex filesystem will have when
running under memory pressure on a complex storage stack (e.g. LVM +
iSCSI), but causes unnecessary context switching.

Any thoughts on a better way to handle this, or will there continue
to be a 4kB stack limit and hack around this with repeated kmalloc
on callpaths for any struct over a few tens of bytes, implementing
memory pools all over the place, and "forking" over to other threads
to continue the stack consumption for another 4kB to work around
the small stack limit?

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
