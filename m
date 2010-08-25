Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7PFLe22243688 for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 10:21:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C8E01B9B4AB
	for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 08:22:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LDltHtrNGEKbE9xu for
	<xfs@oss.sgi.com>; Wed, 25 Aug 2010 08:22:15 -0700 (PDT)
Date: Wed, 25 Aug 2010 11:22:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issue: try to release page which still has unwritten blocks?
Message-ID: <20100825152214.GA6385@infradead.org>
References: <AANLkTin9BzMOwRy_=6MU-5h-EaEqDWEByxymHUW5jEYS@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTin9BzMOwRy_=6MU-5h-EaEqDWEByxymHUW5jEYS@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 25, 2010 at 09:55:56AM -0500, Mike Gao wrote:
> Hi, there,
> 
> It seems that the block should be flushed out somewhere before we come to
> xfs_aops.c:1295.
> This happens when I run xfstest 013. Can anybody take a look at this?

Which kernel version are you running?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
