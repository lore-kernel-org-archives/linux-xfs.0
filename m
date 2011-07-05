Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65Ao2Me251981 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 05:50:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A70E1E6CC04
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 03:50:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NE09gjZtrc5PsdxS for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 03:50:00 -0700 (PDT)
Date: Tue, 5 Jul 2011 06:49:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_bmap Cannot allocate memory
Message-ID: <20110705104959.GA20919@infradead.org>
References: <4E129B00.4020709@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E129B00.4020709@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 07:02:56AM +0200, Michael Weissenbacher wrote:
> Hi List!
> I've got a file here on which i cannot use xfs_bmap to determine it's
> fragments. All that i know is that it must have a really great number of
> them. It was the result of running a smbd without strict allocate. The
> machine itself has 8GiB of RAM and 10GiB of swap available, so that
> shouldn't be the problem. I guess this is some bug in xfs_bmap. Or is it
> a known limitation?
> 
> # xfs_bmap /backup/tmp/cannot_allocate_memory.vhd
> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0
> ["/backup/tmp/cannot_allocate_memory.vhd"]: Cannot allocate memory

What version of xfsprogs do you use?  xfsprogs 3.0.1 fixes a problem
in the bmap command that looked pretty similar to what you see.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
