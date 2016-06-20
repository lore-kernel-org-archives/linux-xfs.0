Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D60E97CA0
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 21:29:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D258AC001
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 19:29:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4nkl4TqlsZWSJG6c for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2016 19:29:54 -0700 (PDT)
Date: Mon, 20 Jun 2016 12:29:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] fs: introduce iomap infrastructure
Message-ID: <20160620022952.GJ26977@dastard>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<1464792297-13185-3-git-send-email-hch@lst.de>
	<20160616161242.GB2106@quack2.suse.cz>
	<20160617120144.GA333@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617120144.GA333@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri, Jun 17, 2016 at 02:01:44PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 16, 2016 at 06:12:42PM +0200, Jan Kara wrote:
> > This is actually in 512-byte units, not in fs blocks as the comment
> > suggests, right?
> 
> Indeed, thanks for spotting this!

I'll update the patches I've already tested, Christoph, so you don't
have to post an update just for this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
