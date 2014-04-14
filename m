Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0148A7F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 21:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FD72AC002
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 19:23:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XpkdgsEHtFk8DsDn for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 19:23:49 -0700 (PDT)
Date: Mon, 14 Apr 2014 12:23:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filestream allocator rewrite
Message-ID: <20140414022347.GI27694@dastard>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
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
Cc: xfs@oss.sgi.com

On Sat, Apr 12, 2014 at 10:01:54AM +0200, Christoph Hellwig wrote:
> This series is a major overhaul of the filestream allocator.  The main point
> is to use the dcache to get the parent and avoiding to maintain a fstrm_item
> for each inode that the filestream is applied to in favor of just tracking
> the parent, but there's various more or less related fallout from this as well.

OVerall it looks good. I'll need to do some testing on it and 
have a deeper look at the main use-the-dentry-cache patch, but it
removes a heap of complexity and code and gets rid of the use of
inode IO locks, so there's a loot to like here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
