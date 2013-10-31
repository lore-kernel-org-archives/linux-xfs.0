Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F28F7F5F
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:45:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2B25304059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:45:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id By4ICTpypwCBIUp9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 07:45:25 -0700 (PDT)
Date: Thu, 31 Oct 2013 07:45:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/30] xfs: create a shared header file for
	format-related information
Message-ID: <20131031144525.GC22359@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-4-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:30:54PM +1100, Dave Chinner wrote:
> All of the buffer operations structures are needed to be exported
> for xfs_db, so move them all to a common location rather than
> spreading them all over the place. They are verifying the on-disk
> format, so while xfs_format.h might be a good place, it is not part
> of the on disk format.
> 
> Hence we need to create a new header file that we centralise these
> related definitions. Start by moving the bffer operations
> structures, and then also move all the other definitions that have
> crept into xfs_log_format.h and xfs_format.h as there was no other
> shared header file to put them in.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
