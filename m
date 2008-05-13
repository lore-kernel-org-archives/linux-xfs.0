Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 02:21:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D9LBr8015619
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 02:21:13 -0700
Date: Tue, 13 May 2008 05:21:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Jfs-discussion] Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513092156.GA26736@infradead.org>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org> <20080513090311.GZ155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513090311.GZ155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net, Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com

On Tue, May 13, 2008 at 07:03:11PM +1000, David Chinner wrote:
> Sure - XFS will start another three kernel threads per filesystem
> that gets mounted. And for good measure, it cleans them up again
> on unmount. :)
> 
> The other threads are per-cpu workqueue threads that are shared
> across all XFS filesystems in the system and hence are started
> when XFS is initialised rather than when a mount occurs.

Well, we could refcount the number of active xfs instances and
start/stop the global threads based on that.  Not really worth my
time IHMO, but if someone comes up with a clean enough patch it should
go in.
