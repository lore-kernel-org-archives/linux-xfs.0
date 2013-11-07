Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 137B17FE1
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 02:12:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC89A304048
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 00:12:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id nNZPPH8rI6f5oXy0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 00:12:01 -0800 (PST)
Date: Thu, 7 Nov 2013 00:11:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/37 V3] libxfs: fix root inode handling inconsistencies
Message-ID: <20131107081159.GA25157@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-16-git-send-email-david@fromorbit.com>
	<20131106102334.GB614@infradead.org>
	<20131106230257.GJ6188@dastard> <20131107045830.GN6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107045830.GN6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 03:58:30PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When "mounting" a filesystem via libxfs_mount(), callers can tell
> libxfs to read the root and realtime inodes into cache. However,
> when unmounting the filesystem, libxfs_unmount() used to
> unconditionally free root inodes if they were present.
> 
> This leads to interesting issues like in mkfs, when it handles
> creation, reading and freeing of the root and rt inodes itself.
> It, however, passes in the flag to tell libxfs_mount() to read the
> root inodes and so can result in unbalanced freeing of inodes when
> cleaning up during the unmount proceedure.
> 
> As it turns out, nothing ever uses mp->m_rootip and so we don't need
> to read it in or free it, or even have a pointer to it in the struct
> xfs_mount. Similarly, the only user of the realtime inodes is mkfs,
> and it initialises them itself. Hence we can kill the m_rootip and
> the realtime inode mounting code.
> 
> This leaves one user of LIBXFS_MOUNT_ROOTINOS - xfs_db - and that is
> only used to initialise the in-core superblock counter values from
> the ag header for xfs_check. Move this code to the xfs_db init
> functions so we can get rid of the mount parameter previously used
> to trigger all these behavours (LIBXFS_MOUNT_ROOTINOS) completely.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
