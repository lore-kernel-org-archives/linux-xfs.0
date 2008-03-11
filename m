Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 17:44:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B0iExN028589
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 17:44:15 -0700
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D63B125114A
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 17:44:45 -0700 (PDT)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id G6Aqgywa8bFvjw4u for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 17:44:45 -0700 (PDT)
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <47D20F78.7000103@sandeen.net>
References: <47D20F78.7000103@sandeen.net>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 11:44:12 +1100
Message-Id: <1205196252.15982.69.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, 2008-03-07 at 22:00 -0600, Eric Sandeen wrote:
> It looks like all of the below is unused... and according
> to Nathan,
> 
> "dont think it even got used/implemented anywhere, but i think it 
> was meant to be an auto-mount kinda thing... such that when you look 
> up at that point, it knows to mount the device with that uuid there, 
> if its not already it was never really written anywhere ... just an 
> idea in doug doucettes brain i think."
> 
> Think it'll ever go anywhere, or should it get pruned?
> 
> The below builds; not at all tested, until I get an idea if it's worth
> doing.  Need to double check that some structures might not need padding
> out to keep things compatible/consistent...

Since effectively all versions of XFS support this feature ondisk,
including complete support in recovery, it would be better IMO to
leave it in for someone to implement/experiment with the syscall
and auto-mounting userspace support.  That would then require no
new feature bits, mkfs/repair changes, etc.  There is effectively
zero cost to leaving it there - and non-zero cost in removing it,
if our seriously bad regression-via-cleanup history is anything
to go by ... :|

It would be really unfortunate to remove this, and then find that
it was useful to someone (who didn't know about it at this time).
OTOH, if there is definately never ever any chance this can ever
be useful, then it should indeed be removed. :)

cheers.

-- 
Nathan
