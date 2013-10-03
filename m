Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C11129DFC
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 09:58:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 150C7304059
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 07:58:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6VCJfULYrDIYwFvB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 07:58:50 -0700 (PDT)
Date: Thu, 3 Oct 2013 07:58:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] xfs: decouple inode and bmap btree header files
Message-ID: <20131003145849.GE10316@infradead.org>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380510433-8353-6-git-send-email-david@fromorbit.com>
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

I like this a lot, but it also seems to move the in-core btree records
and keys to the format header which seems wrong.  Maybe those should be
centralized in xfs_btree.h instead?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
