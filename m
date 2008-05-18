Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 22:22:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4I5MbYj013022
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 22:22:37 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71CB0B82875
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 22:23:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id k608SHpCV2uTixHC for <xfs@oss.sgi.com>; Sat, 17 May 2008 22:23:25 -0700 (PDT)
Message-ID: <482FBD4C.20608@sandeen.net>
Date: Sun, 18 May 2008 00:23:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net>
In-Reply-To: <482F67D9.70400@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
>> I'll see if I have a little time today to track down the problem.
> 
> 
> Does this patch fix it for you?  Does for me though I can't yet explain
> why ;)
> 
> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
> 
> -Eric

So what's happening is that xfs is trying to read a page-sized IO from
the last sector of the log... which goes off the end of the device.
This looks like another regression introduced by
a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
in the URL above, which should be headed towards -stable.

(aside: it seems that this breaks any external log setup where the log
consists of the entire device... but I'd have expected the xfsqa suite
to catch this...?)

The patch avoids the problem by looking for some extra locking but it
seems to me that the root cause is that the buffer being read at this
point doesn't have it's b_offset, the offset in it's page, set.  Might
be another little buglet but harmless it seems.

-Eric
