Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C8B77FC1
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 08:56:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 661508F8037
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 06:56:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id xWPhSnFRdmqzz6GT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 06:56:02 -0800 (PST)
Date: Thu, 20 Feb 2014 06:56:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: allocate xfs_da_args to reduce stack footprint
Message-ID: <20140220145601.GC8366@infradead.org>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392783402-4726-4-git-send-email-david@fromorbit.com>
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

On Wed, Feb 19, 2014 at 03:16:42PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The struct xfs_da_args used to pass directory/attribute operation
> information to the lower layers is 128 bytes in size and is
> allocated on the stack. Dynamically allocate them to reduce the
> stack footprint of directory operations.

Are we having stack space problems in the directory code as well,
without all the VM code above it?  I'm defintively a bit scared about
adding another memory allocation to every single directory operation.

> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;

KM_SLEEP is the default when KM_NOFS is set.  Also KM_SLEEP will never
return a NULL pointer, either remove the handling or make it an
KM_MAYFAIL allocation.

> +	/*
> +	 * If we don't use KM_NOFS here, lockdep will through false positive
> +	 * deadlock warnings when we come through here of the non-transactional
> +	 * lookup path because the allocation can recurse into inode reclaim.
> +	 * Doing this avoids having to add a bunch of lockdep class
> +	 * annotations into the reclaim patch for the ilock.
> +	 */
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);

I don't understand that comment.  We do use KM_NOFS here unlike what the
comment claims, and the comment seems to explain why we actually need
KM_NOFS as far as I can tell.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
