Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9181C7F37
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 16:05:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 825318F8035
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 14:05:24 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id OAiaZIMOIGBqm0Z2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2015 14:05:23 -0700 (PDT)
Date: Sat, 25 Apr 2015 22:05:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150425210520.GG889@ZenIV.linux.org.uk>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard> <20150425141612.GA4153@lst.de>
	<20150425145728.GE889@ZenIV.linux.org.uk>
	<20150425183247.GA30562@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150425183247.GA30562@lst.de>
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

On Sat, Apr 25, 2015 at 08:32:47PM +0200, Christoph Hellwig wrote:
> On Sat, Apr 25, 2015 at 03:57:28PM +0100, Al Viro wrote:
> > > Note that caching the symlink in a kmalloc'ed buffer might be
> > > more efficient than the pagecache for most cases anyway.
> > 
> > Hmm...  When would you free the sucker?
> 
> final iput.  Similar design to the generic ACL cache.

Except that in this case you have to deal with the cases when it should
_not_ be freed in ->evict_inode() (and doing that in generic code is
right out).  I'm not sure it will be simpler that way, actually...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
