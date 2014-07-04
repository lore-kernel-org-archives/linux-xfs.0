Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F99B7F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 09:36:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04EBF304039
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 07:36:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8gpphWv1XPZ3mFYv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 07:35:59 -0700 (PDT)
Date: Fri, 4 Jul 2014 07:35:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] repair: fix quota inode handling in secondary
	superblocks
Message-ID: <20140704143559.GA29745@infradead.org>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1404453435-1915-6-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Jul 04, 2014 at 03:57:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Changes to support separate project quota inodes changed the way
> quota inodes got written to the superblock. The current code is
> tailored for the needs to the kernel, where the inodes should only
> be written if certain falgs are set saying a quota type is enabled.
> 
> Unfortunately, when recovering a corrupt secondary superblock, we
> need to unconditionally write the quota inode fields after we
> unconditionally zero the quota flags field. The result of this bug
> is that the bad quota inode fields cannot be cleared and hence
> always are reported by bad by repair in subsequent runs.
> 
> Fix this by directly clearing the quota inodes in the superblock
> buffers so that we do need to set special flags to get
> xfs_sb_to_disk() to do the right thing as setting flags leave bad
> flag values in the superblock instead of bad inode numbers....
> 
> Also, when clearing the inode numbers, write them as NULLFSINO
> rather than 0 as this is what the kernel will write them as if quota
> is turned off.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
