Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99EkQsr107606 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 09:46:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FEDB55E0E2
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 07:46:23 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SjE9LNxWziOGd2JJ for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 07:46:23 -0700 (PDT)
Date: Sun, 9 Oct 2011 10:46:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111009144616.GA3605@infradead.org>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de> <20111007231410.GG3159@dastard>
	<4E90422E.3060805@birkenwald.de>
	<20111008131809.GB25855@infradead.org>
	<20111008223404.GM3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111008223404.GM3159@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Bernhard Schmidt <berni@birkenwald.de>, xfs@oss.sgi.com

On Sun, Oct 09, 2011 at 09:34:04AM +1100, Dave Chinner wrote:
> Just bear in mind that this can result in all inodes being allocated
> in the same AG, thereby serialising all future file creation and
> deletion in the filesystem. If you take this route, using a directory
> hashing scheme is, IMO, absolutely necessary.

Only if you preallocate all inodes in the same directory, else you
get them spread around.  But either way the hashing scheme probably
is the much better idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
