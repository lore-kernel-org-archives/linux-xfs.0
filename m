Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1AA729DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 19:22:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F4B130405F
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:22:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jEem72DSR6FCCCu7 for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 17:22:34 -0700 (PDT)
Message-ID: <51AE84C9.5030903@sandeen.net>
Date: Tue, 04 Jun 2013 19:22:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: garbage block(s) after powercycle/reboot + sparse writes
References: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
In-Reply-To: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sage Weil <sage@inktank.com>
Cc: xfs@oss.sgi.com

On 6/4/13 2:24 PM, Sage Weil wrote:
> I'm observing an interesting data corruption pattern:
> 
> - write a bunch of files
> - power cycle the box

I guess this part is important?  But I'm wondering why...

> - remount
> - immediately (within 1-2 seconds) write create a file and

a new file, right?

>  - write to a lower offset, say offset 430423 len 527614
>  - write to a higher offset, say offset 1360810 len 269613
>  (there is other random io going to other files too)
> 
> - about 5 seconds later, read the whole file and verify content
> 
> And what I see:
> 
> - the first region is correct, and intact

the lower offset you wrote?

> - the bytes that follow, up until the block boundary, are 0

that's good ;)

> - the next few blocks are *not* zero! (i've observed 1 and 6 4k blocks)

that's bad!

> - then lots of zeros, up until the second region, which appears intact.

the lot-of-zeros are probably holes?

What does xfs_bmap -vvp <filename> say about the file in question?

> I'm pretty reliably hitting this, and have reproduced it twice now and 
> found the above consistent pattern (but different filenames, different 
> offsets).  What I haven't yet confirmed is whether the file was written at 
> all prior to the powercycle, since that tends to blow away the last 
> bit of the ceph logs, too.  I'm adding some additional checks to see 
> whether the file is in fact new when the first extent is written.
> 
> The other possibly interesting thing is the offsets.  The garbage regions 
> I saw were
> 
>  0xea000 - 0xf0000

234-240 4k blocks

>  0xff000 - 0x100000

255-256 4k blocks  *shrug*

Is this what you saw w/ the write offsets & sizes you specified above?

I'm wondering if this could possibly have to do w/ speculative preallocation
on the file somehow exposing these blocks?  But that's just handwaving.

-Eric

> 
> Does this failure pattern look familiar to anyone? I'm pretty sure it is 
> new in 3.9, which we switched over to right around the time when this 
> started happening.  I'm confirming that as well, but just wanted to see if 
> this is ringing any bells...
> 
> Thanks!
> sage
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
