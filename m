Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 959617F94
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 12:14:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22745AC004
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 10:14:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wi0s2H3jGdaSNG8D (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 10:14:26 -0700 (PDT)
Date: Thu, 31 Jul 2014 10:14:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: kill xfs_vnode.h
Message-ID: <20140731171425.GD22173@infradead.org>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406791995-14723-7-git-send-email-david@fromorbit.com>
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

On Thu, Jul 31, 2014 at 05:33:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move the IO flag definitions to xfs_inode.h and kill the header file
> as it is now empty.
> 
> Removing the xfs_vnode.h file showed up an implicit header include
> path:
> 	xfs_linux.h -> xfs_vnode.h -> xfs_fs.h
> 
> And so every xfs header file has been inplicitly been including
> xfs_fs.h where it is needed or not. Hence the removal of xfs_vnode.h
> causes all sorts of build issues because BBTOB() and friends are no
> longer automatically included in the build. This also gets fixed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
