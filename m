Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBNGLw3W008668 for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 10:21:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DF8942EE7
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 08:21:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VfINGfNPrVzQ8BLo for
	<xfs@oss.sgi.com>; Tue, 23 Dec 2008 08:21:57 -0800 (PST)
Date: Tue, 23 Dec 2008 11:21:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
	reboot
Message-ID: <20081223162154.GA30287@infradead.org>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan>
	<20081223134247.GA17750@infradead.org>
	<alpine.DEB.1.10.0812230950120.7572@p34.internal.lan>
	<20081223145431.GA31057@infradead.org>
	<alpine.DEB.1.10.0812231043540.9812@p34.internal.lan>
	<49510BEF.2090209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49510BEF.2090209@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: bug-parted@gnu.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Tue, Dec 23, 2008 at 10:03:59AM -0600, Eric Sandeen wrote:
> Justin Piszcz wrote:
> 
> 
> > Better question as well, need to find out if KNOPPIX or distro-CDs support 
> > this option, if one to boot into recovery and this option was not 
> > enabled.. that would not be fun.
> 
> I'd think most do... Fedora does, at least.

It might be time to have gpt partition support in the x86 defconfig, and
without CONFIG_PARTITION_ADVANCED.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
