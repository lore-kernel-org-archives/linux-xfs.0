Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 16:57:35 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SNvStL022705
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 16:57:29 -0700
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Jun 2007 02:52:57 +0200
In-Reply-To: <46841C60.5030207@sandeen.net>
Message-ID: <p73ved74m52.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Just Marc <marc@corky.net>, xfs@oss.sgi.com

Eric Sandeen <sandeen@sandeen.net> writes:

> Just Marc wrote:
> 
> > 2. Files for which 'No improvement will be made' should also be marked 
> > as no-defrag, this will avoid a ton of extra work in the future.   
> 
> But... that file could drastically change in the future, no?  Just
> because it can't be improved now doesn't necessarily mean that it should
> never be revisited on subsequent runs, does it?

I guess one could define an additional dont-defrag (or perhaps
rather already-defrag) flag that is always
cleared when the file changes. That could be safely set here.

But then I'm not sure it would be worth the effort. Why would you
run fsr that often that it matters?

Also I would expect that one can easily detect in many cases an defragmented
file by looking at the number of extents in the inode only and that would 
make it equivalent to the flag. The cases where this is not the case
are probably rare too.

-Andi
