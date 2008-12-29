Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTLukl5016404 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 15:56:46 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15F6A1BF7467
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:56:45 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8vKtJFPpN3pn69KR for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:56:45 -0800 (PST)
Message-ID: <4959479D.8010801@sandeen.net>
Date: Mon, 29 Dec 2008 15:56:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
References: <200812291920.34123.Martin@Lichtvoll.de>	<4959205E.4000000@thebarn.com>	<20081229192957.GC18092@puku.stupidest.org>
	<49592E7D.4050208@xfs.org>
In-Reply-To: <49592E7D.4050208@xfs.org>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Martin Steigerwald <Martin@Lichtvoll.de>, Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

Russell Cattelan wrote:
> Chris Wedgwood wrote:

>> this will bite xfs more than ext3 w/ ordered mode
>>   
> Delayed allocation is a factor (and this will be true of any fs 
> supporting delayed allocation)
> holding of data flushes helps reduce fragmentation by allowing larger 
> segments to be flushed out,
> but it increases the time data is held in cache and thus create a larger 
> window for data loss.

That's not quite accurate AFAIK; yes, xfs has delayed allocation, but it
pushes data to disk on the same schedule (by default) as any other
filesystem; when pdflush goes off (30s) or under memory pressure.

The only difference is that xfs (or any delalloc fs) allocates at flush
time not at write time.

But this does not imply that xfs is holding off flushes for longer due
to delayed allocation; I don't want it to sound like xfs is putting data
integrity at risk due to delalloc, because it's not ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
