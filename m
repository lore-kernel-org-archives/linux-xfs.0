Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 10:43:06 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVIh0Ge019802
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:43:03 -0800
Received: from pan.gwi.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5F82BD4C5F
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:43:12 -0800 (PST)
Received: from pan.gwi.net (pan.gwi.net [207.5.128.165]) by cuda.sgi.com with ESMTP id cGkteSbyWZ7drKPQ for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:43:12 -0800 (PST)
Subject: Re: raid 10 su, sw settings
From: Brad Langhorst <brad@langhorst.com>
In-Reply-To: <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan>
References: <1199059239.13944.65.camel@up>
	 <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan>
Content-Type: text/plain
Date: Mon, 31 Dec 2007 13:43:06 -0500
Message-Id: <1199126586.3437.10.camel@up>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com


On Mon, 2007-12-31 at 12:04 -0500, Justin Piszcz wrote:

> >
> > Typical blocks/sec from iostat during large file movements is about
> > 100M/s read and 80M/s write.
> >
> 
> #1 What type of performance do you expect with a 4-disk raid10?

Are you saying that i should not expect more?
I expect about 70% better performance, since I think a single disk
should be able to do 100M/s. Maybe this is unreasonable?


> #2 You should be able to umount/mount with the new sizes, although I have 
> not tested it myself b/c I typically use sw raid here (sunit/etc is 
> optimized for sw raid).
I am able to do the remount, but it seems to have had no impact. 
I don't know why but I see 3 possibilities:
 - Perhaps because su/sw settings  don't matter very much.
 - maybe it didn't take effect (rebooting this system is not a preferred
option)
 - maybe it doesn't matter if the partition layout is not optimized.

Brad
