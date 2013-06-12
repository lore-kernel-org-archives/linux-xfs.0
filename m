Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 122757F53
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 09:05:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E65F98F8049
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:05:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id mcA5nvhkjfHYg6e1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 07:05:20 -0700 (PDT)
Date: Wed, 12 Jun 2013 07:05:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into separate
	file
Message-ID: <20130612140519.GB28988@infradead.org>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371032567-21772-19-git-send-email-david@fromorbit.com>
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

On Wed, Jun 12, 2013 at 08:22:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The core xfs inode operations such as locking, allocation, reading
> and writing are not shared with userspace. However, much of the
> remaining internal inode code such as the incore extent tracking and
> formatting is. Split the XFS inode operations out into a new
> xfs_inode_iops.c file to minimise the differences between the files
> shred with userspace.

Having struct xfs_inode in an xfs_inode_ops.h file while xfs_inode.h
is still around strikes me as extremely odd.  It seems like icdinode
should be in xfs_inode_item.h as is part of the log format primarily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
