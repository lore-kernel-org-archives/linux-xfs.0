Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 696577F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E579304039
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:40:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rlDUWkTXzRTn1zRi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:40:34 -0700 (PDT)
Date: Tue, 27 May 2014 03:40:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: xfs_readsb needs to check for magic numbers
Message-ID: <20140527104034.GB1440@infradead.org>
References: <1401143214-9181-1-git-send-email-david@fromorbit.com>
	<1401143214-9181-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401143214-9181-3-git-send-email-david@fromorbit.com>
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

On Tue, May 27, 2014 at 08:26:54AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit daba542 ("xfs: skip verification on initial "guess"
> superblock read") dropped the use of a verifier for the initial
> superblock read so we can probe the sector size of the filesystem
> stored in the superblock. It, however, now fails to validate that
> what was read initially is actually an XFS superblock and hence will
> fail the sector size check and return ENOSYS.
> 
> This causes probe-based mounts to fail because it expects XFS to
> return EINVAL when it doesn't recognise the superblock format.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
