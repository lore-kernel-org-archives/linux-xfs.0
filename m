Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 377F87FE5
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:15:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 153558F8039
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 14:15:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1n4Hz5DcLiTEYWz4 for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 14:15:22 -0800 (PST)
Date: Fri, 21 Feb 2014 09:15:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140220221518.GR4916@dastard>
References: <20140220220000.GA17541@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220220000.GA17541@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 02:00:00PM -0800, Christoph Hellwig wrote:
> Add a new -T argument to the open command that supports using the
> O_TMPFILE flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can you also push this into the main CLI interface similar to how
all the other open flags can be specified? i.e.

$ xfs_io -d -c "pwrite 0 4k" foo

will open "foo" with O_DIRECT. Be nice just to be able to do

$ xfs_io -dT -c "pwrite 0 4k" foo/

to be able to test O_TMPFILE functionality

FWIW, any plans to add a "link" command to be able to link the
tmpfile into the namespace once it is created?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
