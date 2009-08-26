Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QDoZFn014961 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 08:50:45 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F7513FDB02
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 06:51:01 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id SxYFpWyGpO76cL6C for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 06:51:01 -0700 (PDT)
Date: Wed, 26 Aug 2009 09:50:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
References: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
	<20090816022331.GA2309@infradead.org>
	<alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
	<alpine.DEB.2.00.0908220624440.30321@p34.internal.lan>
	<20090822142550.GA10003@infradead.org>
	<alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
	<alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
	<20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
	<20090823224504.GA19942@infradead.org>
	<alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Mon, 24 Aug 2009, Justin Piszcz wrote:

>
>
> On Sun, 23 Aug 2009, Christoph Hellwig wrote:
>
>> Ok, let's see where errors could happen then.
>> 
>> There are four theoretical possibilities:
>> 
>> (a) XFS
>> (b) loop driver
>> (c) crypto loop code
>> (d) block layer
>> 
>> Or combinations thereof.
>> 
>> I would take (a) and (d) as more unlikely as they tend to get used much
>> more and I would have heard more bug reports already.
>> 
>> The cryptoloop code hasn't changed at all since 2.6.29.
>> 
>> The loop code howver has a very interesting commit just after 2.6.39:
>> 
>> commit 68db1961bbf4e16c220ccec4a780e966bc1fece3
>> Author: Nikanth Karthikesan <knikanth@suse.de>
>> Date:   Tue Mar 24 12:29:54 2009 +0100
>>
>>    loop: support barrier writes
>> 
>> Can you try reverting this one (it cleanly reverse-applies against
>> 2.6.30 and current mainline) and see if that makes a difference?
>> 
>
> Hello Christoph,
>
> # patch -p1 -R < ../unpatch.patch
> patching file drivers/block/loop.c
> Hunk #1 succeeded at 473 (offset -1 lines).
> Hunk #2 succeeded at 804 (offset -22 lines).
> #
>
> Patched, we'll see if the problem recurs.. thanks!
>
> Justin.
>

Hi Christoph,

So far the uptime is 2 days, if it does not recur in the next 24-48 hours, 
do you recommend I follow up with the linux-crypto folks about this?  It 
appears this could be the cause (no issues, as of yet).

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
