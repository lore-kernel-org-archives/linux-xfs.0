Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6I4pQXV119703 for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 23:51:30 -0500
Date: Sun, 18 Jul 2010 00:54:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs:negative_icount.patch
Message-ID: <20100718045423.GA6282@infradead.org>
References: <1279306421.17689.38.camel@superior.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279306421.17689.38.camel@superior.americas.sgi.com>
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
To: Stuart Brodsky <sbrodsky@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 16, 2010 at 01:53:41PM -0500, Stuart Brodsky wrote:
> This patch fixes the stat -f icount field going negative.

In what tool?  Do you means the Inodes: Total output in the stat(1) tool?

Please describe the problem in more detail in the commit log, and also
use a descriptive subject line.


> The use of
> lazy counts means that the super block field sb_icount is not updated
> correctly and will allow over allocation of inodes above maxicount.

The patch replaces the use of m_sb.sb_icount with your new atomic
variable in a few places in the inode allocator.  If it really was the
stat tool mentioned above I would expect xfs_fs_statfs to also be
updated to use it.  Either way I'm a bit confused about which users
are switched to the new variable and which not.  This probably needs
a good comment in the code explaining where to use it and where not.

And the commit message needs a comment explaining how this negative
icount actually happened.

Note that introducing a filesystem-global atomic variable generally
isn't a good thing for scalability.  This one is touched seldomly enough
that it might not a big problem, but depending on where you need to use
it summing up the per-cpu counters on demand might be a better option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
