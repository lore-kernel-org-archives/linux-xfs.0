Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 18:19:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B1JI3a002192
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:19:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89283F5C71C
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:19:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id mHZLCqrOgX4zbbgq for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:19:48 -0700 (PDT)
Message-ID: <47D5DE13.8030902@sandeen.net>
Date: Mon, 10 Mar 2008 20:19:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net> <1205196252.15982.69.camel@edge.scott.net.au>
In-Reply-To: <1205196252.15982.69.camel@edge.scott.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs-oss <xfs@oss.sgi.com>

Nathan Scott wrote:


(hope you didn't too much mind my quoting you in this thread) ;)

> Since effectively all versions of XFS support this feature ondisk,
> including complete support in recovery, it would be better IMO to
> leave it in for someone to implement/experiment with the syscall
> and auto-mounting userspace support.  That would then require no
> new feature bits, mkfs/repair changes, etc.  There is effectively
> zero cost to leaving it there - and non-zero cost in removing it,
> if our seriously bad regression-via-cleanup history is anything
> to go by ... :|

the only cost to leaving it is having another instance of "ok now what
the heck is THIS?!" ... death by a thousand cuts of xfs complexity.  But
yeah, removing it has some risk too.

> It would be really unfortunate to remove this, and then find that
> it was useful to someone (who didn't know about it at this time).
> OTOH, if there is definately never ever any chance this can ever
> be useful, then it should indeed be removed. :)

Well I'm not hung up about it.  If anyone thinks it'll be useful, I'm
not bothered by leaving it as is.  So, Nathan, what are your plans for
this code? *grin*

-Eric
