Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE85A7FFD
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:24:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDA678F8037
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:24:25 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lbxRCi3C1l5GZcOq for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:24:23 -0800 (PST)
Date: Tue, 3 Feb 2015 06:24:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150202192404.GI6282@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202073024.GA9399@lst.de>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 08:30:24AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 29, 2015 at 03:52:32PM -0500, J. Bruce Fields wrote:
> > Who can give us ACKs on these last five fs/xfs patches?  (And is it
> > going to cause trouble if they go in through the nfsd tree?)
> 
> 
> We'd need ACKs from Dave.  He already has pulled in two patches so
> we might run into some conflicts.  Maybe the best idea is to add the
> exportfs patch to both the XFS and nfsd trees, so each of them can
> pull in the rest?  Or we could commit the two XFS preparation patches
> to both tree and get something that compiles and works in the nfsd
> tree.

This patch has already been committed to the XFS repo.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
