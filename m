Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 17:16:51 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m011Gevs024341
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 17:16:46 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36DD34D1FA9
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 17:16:53 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id GVEBcxRyMAyjcZnw for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 17:16:53 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so2937048fga.8
        for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 17:16:52 -0800 (PST)
Date: Tue, 1 Jan 2008 01:15:04 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid 10 su, sw settings
Message-ID: <20080101001504.GA12559@teal.hq.k1024.org>
References: <1199059239.13944.65.camel@up> <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan> <1199126586.3437.10.camel@up> <Pine.LNX.4.64.0712311406190.1239@p34.internal.lan> <20071231201712.GA3679@teal.hq.k1024.org> <1199134501.3437.21.camel@up> <20071231214223.GB3679@teal.hq.k1024.org> <1199141644.3437.24.camel@up>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199141644.3437.24.camel@up>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brad Langhorst <brad@langhorst.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 31, 2007 at 05:54:04PM -0500, Brad Langhorst wrote:
> 
> On Mon, 2007-12-31 at 22:42 +0100, Iustin Pop wrote:
> > On Mon, Dec 31, 2007 at 03:55:01PM -0500, Brad Langhorst wrote:
> > > Any opinions on the partition layout? Did you go to special effort to
> > > layout your partitions on the stripe boundaries (actually i don't really
> > > understand this fully yet).
> > 
> > So instead of the usual 255 heads, 63 cylinders fake geometry that is
> > not a multiple of anything, I setup 16h/16c geometry that gives a nice
> > power-of-two multiplier so all partitions *should* be aligned at a nice
> > multiple of any size you choose; fdisk -l on the drive reports units of
> > 128k.
> Sorry to be thick... i don't understand this.
> Do you configure the raid controller with these settings? or is this an
> fdisk option?

Note: I'm not even sure it matters, or if I did it right :)

It's an fdisk option. For example, "fdisk -H 16 -S 16 /dev/sdX".

Also, happy new year!
iustin
