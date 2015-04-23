Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79DE97F47
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 17:29:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11080AC001
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 15:29:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UFMcqkUYkagFbPTv for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 15:29:44 -0700 (PDT)
Date: Fri, 24 Apr 2015 08:29:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150423222942.GK15810@dastard>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429816064-10033-6-git-send-email-hch@lst.de>
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
Cc: viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Thu, Apr 23, 2015 at 09:07:43PM +0200, Christoph Hellwig wrote:
> We can use the generic symlink in pagecache code for XFS non-inline
> symlinks.  Because links are always shorter than a page we will
> get the zero termination for the link for free.

Doesn't work for v5 filesystems where headers and CRCs are embedded
into the same blocks as the symlink data. i.e. this now falls down
to ->readpage to read the link data into the page cache, and that
just reads the entire blocks into the page cache. So what we can end
up within the page cache is this:

   4k block/page
+---|--------------+
 hdr  symlink data

And for a 1k block size v5 filesystem it could be this within a 4k
page:

    1k block            1k block
+---|--------------+----|---------------+
 hdr  symlink data   hdr   symlink data

Either way, it will be completely misinterpretted by the generic
symlink code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
