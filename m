Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 085447F6D
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:11:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B571AC001
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:10:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id k0veApoxRRSJBpgj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:10:55 -0800 (PST)
Date: Thu, 5 Dec 2013 13:10:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: use xfs_ilock_map_shared in xfs_attr_get
Message-ID: <20131205211055.GA3209@infradead.org>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.679310054@bombadil.infradead.org>
	<20131205205910.GD29897@dastard>
	<20131205210159.GA30318@infradead.org>
	<20131205210557.GF29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205210557.GF29897@dastard>
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

On Fri, Dec 06, 2013 at 08:05:57AM +1100, Dave Chinner wrote:
> > Haven't really done an in-depth audit, mostly just looking at
> > where the asserts kick in..
> 
> Right - I just did a scan with cscope on the users of
> XFS_ILOCK_SHARED, and those two were the only ones that stuck out
> that weren't handled correctly....

With MAXPATHLEN at 1024 a symlink is at max 2 extents and thus never in
btree format, so I don't think we'll need it in readlink.  The attr
cases look real, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
