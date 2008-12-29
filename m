Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTKXr65031776 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:33:53 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46BC14FCC1
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:33:52 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	vwd1xu604fLLjHlQ for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 12:33:52 -0800 (PST)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mBTK9XUx078278;
	Mon, 29 Dec 2008 14:09:36 -0600 (CST)
	(envelope-from cattelan@xfs.org)
Message-ID: <49592E7D.4050208@xfs.org>
Date: Mon, 29 Dec 2008 14:09:33 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
References: <200812291920.34123.Martin@Lichtvoll.de>
	<4959205E.4000000@thebarn.com>
	<20081229192957.GC18092@puku.stupidest.org>
In-Reply-To: <20081229192957.GC18092@puku.stupidest.org>
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
To: Chris Wedgwood <cw@f00f.org>
Cc: Martin Steigerwald <Martin@Lichtvoll.de>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Mon, Dec 29, 2008 at 01:09:18PM -0600, Russell Cattelan wrote:
>
>   
>> The question that I have is regards to kde apps.
>>     
>
> i just did a quick strace of something, i see it do:
>
>
> open newfile
> write data
> close file
> rename newfile over oldfile
>
> no fsync before close...
>   
Hmm that is worse than truncate to 0, since now we have a new file vs 
one that has been truncated.
But really same net result.
Still why is the file size making it to disk before the data and more 
importantly the extent transaction to the log?
 that should have been fixed.

>
> this will bite xfs more than ext3 w/ ordered mode
>   
Delayed allocation is a factor (and this will be true of any fs 
supporting delayed allocation)
holding of data flushes helps reduce fragmentation by allowing larger 
segments to be flushed out,
but it increases the time data is held in cache and thus create a larger 
window for data loss.

-Russell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
