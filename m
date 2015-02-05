Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 756707F6A
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 18:51:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 623E6304043
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 16:51:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AB0OpDfL5VShACiL for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 16:51:48 -0800 (PST)
Date: Thu, 5 Feb 2015 11:51:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/20] xfs: recall pNFS layouts on conflicting access
Message-ID: <20150205005105.GP4251@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-21-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421925006-24231-21-git-send-email-hch@lst.de>
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

On Thu, Jan 22, 2015 at 12:10:06PM +0100, Christoph Hellwig wrote:
> Recall all outstanding pNFS layouts and truncates, writes and similar extent
> list modifying operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks fine, assuming break_layout() doesn't require any other
VFS inode locks to be held for serialisation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
