Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89CciR9040040 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 07:38:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B18F71E889A1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 05:38:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gE4v5KtuiYkXlrvJ for <xfs@oss.sgi.com>;
	Fri, 09 Sep 2011 05:38:43 -0700 (PDT)
Date: Fri, 9 Sep 2011 08:38:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair segfaut in stage 6
Message-ID: <20110909123842.GA28343@infradead.org>
References: <4E69D1B9.8070201@nasza-klasa.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E69D1B9.8070201@nasza-klasa.pl>
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
To: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
Cc: xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 10:43:37AM +0200, Bartosz Cisek wrote:
> Hi,
> 
> Recently we had some problems with 2TB partition using xfs.
> 
> I/O error in filesystem ("cciss/c0d5p1") meta-data dev cciss/c0d5p1
> block 0x120a0       ("xfs_trans_read_buf") error 5 buf count 4096
> 
> At first I suspected failed hardware, but disk array wasn't reporting
> anything.

But that error really means that we got an error from the device.

> Distro (Debian 5.0) version of xfs_repair finished with segfault. Same
> with compiled from git. I filled bug report [1]. Can someone possibly
> look into it? As it's hadoop heavy replicated partition I keep it only
> to provide additional information to resolve this segfault. I would be
> happy to provide as much detailed info as required, but I need to know
> what :)

The above pretty much guarantees a hardware (or maybe driver) issue,
as XFS only gets the EIO from the lower layers.

Of course that does not mean that xfs_repair should crash.  I'll look
into it.  As already mentioned a metadump image would be very helpful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
