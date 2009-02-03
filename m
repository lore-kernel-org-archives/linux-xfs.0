Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n136LHY0040831 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 00:21:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69073DD7B7
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 22:20:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3fiTYPAyz6fj332B for
	<xfs@oss.sgi.com>; Mon, 02 Feb 2009 22:20:38 -0800 (PST)
Date: Tue, 3 Feb 2009 01:20:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: Bug#513821: xfsprogs: xfs_growfs does not work]
Message-ID: <20090203062036.GA23098@infradead.org>
References: <1233641256.5518.83.camel@verge.scott.net.au>
	<1233641336.5518.85.camel@verge.scott.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1233641336.5518.85.camel@verge.scott.net.au>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 03, 2009 at 05:08:56PM +1100, Nathan Scott wrote:
> On Tue, 2009-02-03 at 17:07 +1100, Nathan Scott wrote:
> > Is this issue known (Eric?) in 2.10.2?
> 
> and "Kernel: Linux 2.6.26-1-amd64 (SMP w/1 CPU core)" to save ya looking.

2.6.16 didn't have the compat ioctl handler for growfs yet, and this is
i386 xfsprogs on a 64bit kernel.  He needs to upgrade to a more recent
kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
