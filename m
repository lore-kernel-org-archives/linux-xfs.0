Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88EFC7F6D
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:22:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73C91304062
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:22:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yBJsNFre1cKQlYbA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:22:19 -0800 (PST)
Date: Thu, 5 Dec 2013 13:22:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: assert that we hold the ilock for extent map
	access
Message-ID: <20131205212219.GA12602@infradead.org>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.874279041@bombadil.infradead.org>
	<20131205211047.GG29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205211047.GG29897@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 08:10:47AM +1100, Dave Chinner wrote:
> Looks good, but can we add an assert to xfs_bunmapi() at the same
> time just to cover all the public bmapi interfaces with locking
> requirements?

Sure, will do.

Btw, I got another idea to sort this mess out a bit better:

 - add a new XFS_ILOCK_BMAP flag, and fold the bmap locking magic
   into xfs_ilock.
 - because the flag is now passed down we can assert that it is
   passed in xfs_bmapi_read and friends even if the extent list
   is already read in and thus improve coverage.

The downside is another two branches in the common ilock code path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
