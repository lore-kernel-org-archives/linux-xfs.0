Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 19:26:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9A2QQaG007054
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 19:26:26 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20F7BD1859A0
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 19:25:45 -0700 (PDT)
Message-ID: <452B04A7.3090400@sandeen.net>
Date: Mon, 09 Oct 2006 21:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs vs. lockdep
References: <452A8DE2.4000608@sandeen.net> <20061010004726.GO11034@melbourne.sgi.com>
In-Reply-To: <20061010004726.GO11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:

> FWIW, we call mrfree() on both the ilock and the iolock, but these are
> #defined to null statements. If there is a destructor for the underlying
> lock type, we probably should call that in mrfree() so the debugging code
> can catch these probelms that only trigger in debug code.

 From a quick look I don't see those destructors, might be good to write some 
though.

It'd also be good to turn our spinlock_destroy(lock) into a 
WARN_ON(spin_is_locked(lock)) or something...

it'd be extra nice if lockdep could grok that the lock it's looking at is full 
of free poison, print a warning, take it off the list and move on... this was a 
bear to figure out which one was causing the problem.

I have a few changes to get more desructors called for some of the newer locks 
that are missing them (think agirotor_lock...) that I'll send when I get a moment.

-Eric

> Cheers,
> 
> Dave.
