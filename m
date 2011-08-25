Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P71W76171993 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 02:01:32 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2BA219222D1
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:01:31 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id SMaD1SCDyZbhF0h0 for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 00:01:31 -0700 (PDT)
Date: Thu, 25 Aug 2011 03:01:30 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.0.1: xfs hang
In-Reply-To: <20110825051812.GC1869@infradead.org>
Message-ID: <alpine.DEB.2.02.1108250300060.14539@p34.internal.lan>
References: <alpine.DEB.2.02.1108201536510.14176@p34.internal.lan>
	<20110825051812.GC1869@infradead.org>
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
Cc: Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com



On Thu, 25 Aug 2011, Christoph Hellwig wrote:

> On Sat, Aug 20, 2011 at 03:38:21PM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> Forgot to remove 'delaylog' from my fstab on one of my machines,
>> while rm -rf a large directory with many files:
>
> Does it actually hand the machine, or do you get the warning and then
> work continues?
Hi,

Normally the work continues but delaylog's effect varies on different hardware.
For example on server HW it actually kills all network connections (ssh,etc)
if delaylog is set and you remove lots of files.
>
> Unfortunately your backtrace doesn't seem overly reliable
Would compiling with frame pointers help for future XFS/related items?
> , so it's kinda
> hard to figure out what is going on.  There is nothing delaylog related
> in the provided one though.  If it halfway matches what is going on it
> seems to be block I/O related.

Justin.

>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
