Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 086227F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 16:58:41 -0500 (CDT)
Date: Mon, 21 Oct 2013 16:58:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/5] refactor the preallocation and hole punching code
Message-ID: <20131021215825.GL1935@sgi.com>
References: <20131012075503.370510641@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075503.370510641@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

Hi Christoph,

On Sat, Oct 12, 2013 at 12:55:03AM -0700, Christoph Hellwig wrote:
> This series massages the preallocation and hole punching code into something
> sane.  The big catchall xfs_change_file_space function is gone, fallocate
> and the ioctl entry point now directly call the low-level functions, and
> fallocate can avoid packing its arguments into the xfs_flock form and
> duplicating error checking already done in the VFS.  In addition we also
> use a common locking patter now, that is preallocations using the ioctl
> path now also take iolock, just like fallocate and all other ioctl cases
> already did beforehand.
> 
> 
> Changes since version 1:
>  - remove the unused setprealloc variable in xfs_file_fallocate
>  - rebased

Applied this series.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
