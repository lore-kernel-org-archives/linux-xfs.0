Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECC347F37
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 09:16:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3DA8304039
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 07:16:15 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 64lpcfJ80jiJICWk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2015 07:16:14 -0700 (PDT)
Date: Sat, 25 Apr 2015 16:16:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150425141612.GA4153@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150423222942.GK15810@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

Al, what do you think about adding a new

i_link member to the union of i_pipe, i_bdev and i_cdev.  That we
we can cache a link acquired by any way for direct use in the VFS.

This has a few use cases:  inline links can be set up directly
when reading the inode, and we never need to call into ->follow_link.

Formats like the XFS v5 symlinks can be read in once by whatever
way we want, and following accesses can be done RCU safe and
without calling into the filesystem.

Note that caching the symlink in a kmalloc'ed buffer might be
more efficient than the pagecache for most cases anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
