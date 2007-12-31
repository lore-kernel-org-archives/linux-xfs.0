Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 14:54:03 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVMrtXB010740
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 14:53:58 -0800
Received: from pan.gwi.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88BB0BD5B5A
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 14:54:10 -0800 (PST)
Received: from pan.gwi.net (pan.gwi.net [207.5.128.165]) by cuda.sgi.com with ESMTP id Ib3kUI3Kfs5n4tN5 for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 14:54:10 -0800 (PST)
Subject: Re: raid 10 su, sw settings
From: Brad Langhorst <brad@langhorst.com>
In-Reply-To: <20071231214223.GB3679@teal.hq.k1024.org>
References: <1199059239.13944.65.camel@up>
	 <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan>
	 <1199126586.3437.10.camel@up>
	 <Pine.LNX.4.64.0712311406190.1239@p34.internal.lan>
	 <20071231201712.GA3679@teal.hq.k1024.org> <1199134501.3437.21.camel@up>
	 <20071231214223.GB3679@teal.hq.k1024.org>
Content-Type: text/plain
Date: Mon, 31 Dec 2007 17:54:04 -0500
Message-Id: <1199141644.3437.24.camel@up>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Iustin Pop <iusty@k1024.org>, xfs@oss.sgi.com


On Mon, 2007-12-31 at 22:42 +0100, Iustin Pop wrote:
> On Mon, Dec 31, 2007 at 03:55:01PM -0500, Brad Langhorst wrote:
> > Any opinions on the partition layout? Did you go to special effort to
> > layout your partitions on the stripe boundaries (actually i don't really
> > understand this fully yet).
> 
> So instead of the usual 255 heads, 63 cylinders fake geometry that is
> not a multiple of anything, I setup 16h/16c geometry that gives a nice
> power-of-two multiplier so all partitions *should* be aligned at a nice
> multiple of any size you choose; fdisk -l on the drive reports units of
> 128k.
Sorry to be thick... i don't understand this.
Do you configure the raid controller with these settings? or is this an
fdisk option?

thanks!

brad
