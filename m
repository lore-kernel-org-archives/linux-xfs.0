Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4F6wvlN164287 for <xfs@oss.sgi.com>; Tue, 15 May 2012 01:58:57 -0500
Date: Tue, 15 May 2012 02:58:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: hole-punch retaining cache beyond
Message-ID: <20120515065854.GB7373@infradead.org>
References: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
	<alpine.LSU.2.00.1205131350150.1547@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205131350150.1547@eggly.anvils>
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
To: Hugh Dickins <hughd@google.com>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org

On Sun, May 13, 2012 at 01:51:18PM -0700, Hugh Dickins wrote:
> xfs has a very inefficient hole-punch implementation, invalidating all
> the cache beyond the hole (after flushing dirty back to disk, from which
> all must be read back if wanted again).  So if you punch a hole in a
> file mlock()ed into userspace, pages beyond the hole are inadvertently
> munlock()ed until they are touched again.
> 
> Is there a strong internal reason why that has to be so on xfs?
> Or is it just a relic from xfs supporting XFS_IOC_UNRESVSP long
> before Linux 2.6.16 provided truncate_inode_pages_range()?
> 
> If the latter, then this patch mostly fixes it, by passing the proper
> range to xfs_flushinval_pages().  But a little more should be done to
> get it just right: a partial page on either side of the hole is still
> written back to disk, invalidated and munlocked.

I think the original reason is that no range version of the macros
existed.  Giving the somewhat odd calling convention I'd prefer to
simplify deprecate the old wrappers and convert the callers to direct
calls of the VM functions on a 1 by 1 basis.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
