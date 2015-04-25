Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AECD57F37
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 09:57:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39CC1AC002
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 07:57:31 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id db1WPd7xPF45yGo0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2015 07:57:30 -0700 (PDT)
Date: Sat, 25 Apr 2015 15:57:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150425145728.GE889@ZenIV.linux.org.uk>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard> <20150425141612.GA4153@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150425141612.GA4153@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 25, 2015 at 04:16:12PM +0200, Christoph Hellwig wrote:
> Al, what do you think about adding a new
> 
> i_link member to the union of i_pipe, i_bdev and i_cdev.  That we
> we can cache a link acquired by any way for direct use in the VFS.
> 
> This has a few use cases:  inline links can be set up directly
> when reading the inode, and we never need to call into ->follow_link.
> 
> Formats like the XFS v5 symlinks can be read in once by whatever
> way we want, and following accesses can be done RCU safe and
> without calling into the filesystem.
> 
> Note that caching the symlink in a kmalloc'ed buffer might be
> more efficient than the pagecache for most cases anyway.

Hmm...  When would you free the sucker?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
