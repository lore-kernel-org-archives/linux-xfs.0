Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q657hB4O042565 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 02:43:17 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tC7FdO8bsG8tjPFD (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 00:43:09 -0700 (PDT)
Date: Thu, 5 Jul 2012 03:43:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3.5.0-rc5: inconsistent lock state
Message-ID: <20120705074307.GA28127@infradead.org>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 04, 2012 at 12:13:32PM -0700, Christian Kujau wrote:
> Hi,
> 
> this powerpc machine is running 3.5.0-rc5 for 2 days now and this happened 
> today:

See my "do not take the iolock in inode reclaim context" series from
yesterday, which should take care of this.

Btw, if you hit this it's a sign you have out of the inode attributes,
so if this isn't just a single inode with them you might be better off
using larger inodes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
