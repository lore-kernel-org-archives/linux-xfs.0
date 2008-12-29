Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTLPMr0010073 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 15:25:22 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB5AB5033D
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:25:21 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	VHOafrKF4waVE40N for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 13:25:21 -0800 (PST)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mBTLPBhF080053;
	Mon, 29 Dec 2008 15:25:12 -0600 (CST)
	(envelope-from cattelan@xfs.org)
Message-ID: <49594037.9070201@xfs.org>
Date: Mon, 29 Dec 2008 15:25:11 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
References: <200812291920.34123.Martin@Lichtvoll.de>
	<4959205E.4000000@thebarn.com>
	<20081229192957.GC18092@puku.stupidest.org>
	<49592E7D.4050208@xfs.org>
	<20081229201741.GA20024@puku.stupidest.org>
In-Reply-To: <20081229201741.GA20024@puku.stupidest.org>
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
> On Mon, Dec 29, 2008 at 02:09:33PM -0600, Russell Cattelan wrote:
>
>   
>> Still why is the file size making it to disk before the data and
>> more importantly the extent transaction to the log?
>>     
>
> well, as you know, it's logged, the data isn't
>   
yes but the whole deal with null files is no extents for a file size 
that should have extents.

So if the extent creation transaction is logged then it should be safe 
to update the file size on disk,
if not then the file "last flushed" size should be on disk. In this case 
I would assume 0, since that would
be the last valid flush size.


>   
>> that should have been fixed.
>>     
>
> the window was shrunk to write out begins on close for existing files
> the are opened with truncate (i think nathans did that some time
> ago?)
>   
correct but that change/hack has apparently been removed at some point? 
maybe along with the "last flush size" changes?


> new files won't be affected by that change
>   
Correct even if the sync on close if truncate code was there it would 
not help kde apps apparently.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
