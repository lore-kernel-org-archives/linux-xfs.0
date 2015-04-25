Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D73D07F37
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 13:32:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FA23AC002
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 11:32:51 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id FswO6ULHfD7CPQEK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2015 11:32:49 -0700 (PDT)
Date: Sat, 25 Apr 2015 20:32:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150425183247.GA30562@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard> <20150425141612.GA4153@lst.de>
	<20150425145728.GE889@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150425145728.GE889@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Apr 25, 2015 at 03:57:28PM +0100, Al Viro wrote:
> > Note that caching the symlink in a kmalloc'ed buffer might be
> > more efficient than the pagecache for most cases anyway.
> 
> Hmm...  When would you free the sucker?

final iput.  Similar design to the generic ACL cache.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
