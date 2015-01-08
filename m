Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 716C07F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 06:44:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C9BDAC005
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 04:44:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fEV9m3JzAHaY4BFp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 04:44:47 -0800 (PST)
Date: Thu, 8 Jan 2015 04:44:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: move xfs_fs.h to libxfs
Message-ID: <20150108124446.GA3424@infradead.org>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
	<1420666983-7275-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420666983-7275-2-git-send-email-david@fromorbit.com>
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

On Thu, Jan 08, 2015 at 08:43:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ioctl API definitions are shared with userspace, so move the header
> file that defines them all to libxfs along with all the other code
> shared with userspace.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

This might also be a good time to get rid of the ifdefs in there
for IRIX compatibility.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
