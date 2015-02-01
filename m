Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7824C7F88
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 17:09:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 583668F8033
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:09:12 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UlAzBZO7S52zov27 for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 15:09:10 -0800 (PST)
Date: Mon, 2 Feb 2015 10:06:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/20] xfs: factor out a xfs_update_prealloc_flags() helper
Message-ID: <20150201230653.GE4251@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-19-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421925006-24231-19-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 12:10:04PM +0100, Christoph Hellwig wrote:
> This logic is duplicated in xfs_file_fallocate and xfs_ioc_space, and
> we'll need another copy of it for pNFS block support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This stands alone, so I'm pulling it into the XFS tree without
waiting for the rest of the patch set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
