Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EDPLQ3001614
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 08:25:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A03AF16BFA2C
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 06:32:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xmy88bYwSrIDCoDh for <linux-xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 06:32:53 -0700 (PDT)
Date: Fri, 14 Oct 2011 09:20:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Advanced Format drive - sectsz question
Message-ID: <20111014132019.GA4711@infradead.org>
References: <j783rh$gn7$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <j783rh$gn7$1@dough.gmane.org>
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
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Oct 14, 2011 at 03:38:14AM +0200, Zdenek Kaspar wrote:
> Hello list, I have hard drive which reports:
> 
> logical_block_size  ->  512
> physical_block_size -> 4096
> 
> Default mkfs.xfs sets sectsz to 512.
> 
> kernel-2.6.32-131.17.1.el6.x86_64
> xfsprogs-3.1.1-4.el6.x86_64
> 
> Is mkfs.xfs -s size=4096 the right way?

Yes, we probably should default to 4096 bytes sector size for these
drivers, but still allow 512 byte sector sized filesystems if explicitly
requested.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
