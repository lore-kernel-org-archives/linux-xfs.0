Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9ODbUmW039924 for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 08:37:30 -0500
Date: Sat, 24 Oct 2009 09:39:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2]  add lpath_to_handle to libhandle
Message-ID: <20091024133904.GB23125@infradead.org>
References: <4AE08DC7.7000200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AE08DC7.7000200@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 22, 2009 at 11:52:23AM -0500, Bill Kendall wrote:
> path_to_handle() is not reliable when called on a path which
> is a symlink. If the symlink is dangling, or if its points
> to a non-XFS filesystem then path_to_handle() will fail. The
> reason is that path_to_handle() must open the path in order
> to obtain an fd for the xfsctl call.
>
> It's common during xfsrestore to have dangling symlinks since
> the target of the link may not be restored before the symlink.
>
> This patch adds a new function to libhandle, lpath_to_handle.
> It is just like path_to_handle, except it takes a filesystem
> path in addition to the path which you want convert to a
> handle.

I'm not sure this is a good API.  We can derive a useful path for
the ioctl by using basename on the filename if it is a link without
needing to expose the details to the caller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
