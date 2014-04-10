Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4D2F7FB4
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:35:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8424304043
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 03:35:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YbZfsXr9mUFORn6V (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 03:35:55 -0700 (PDT)
Date: Thu, 10 Apr 2014 03:35:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: xfs_vm_write_end truncates too much on failure
Message-ID: <20140410103555.GF17641@infradead.org>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397106053-7489-4-git-send-email-david@fromorbit.com>
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

On Thu, Apr 10, 2014 at 03:00:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to the write_begin problem, xfs-vm_write_end will truncate
> back to the old EOF, potentially removing page cache from over the
> top of delalloc blocks with valid data in them. Fix this by
> truncating back to just the start of the failed write.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any reason you used max_t in the previous one, and opencode it here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
