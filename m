Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 18:09:44 -0800 (PST)
Received: from page.mel.office.aconex.com (eth2333.vic.adsl.internode.on.net [150.101.159.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB629aaG012288
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 18:09:37 -0800
Subject: Re: Recent changes in xfsprogs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <457621A2.7000605@melbourne.sgi.com>
References: <1165359970.1281.51.camel@edge>
	 <457621A2.7000605@melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 06 Dec 2006 13:08:22 +1100
Message-Id: <1165370902.1281.72.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: bnaujok@sgi.com, xfs@oss.sgi.com

On Wed, 2006-12-06 at 12:49 +1100, David Chatterton wrote:
> ...
> A classic problem with cpp is that it is possible for someone else to
> introduce a header that breaks your build.

Heh, its a poor tradesman who blames his tools. :)

>  By introducing a header
> called list.h, a very common name, we have exposed products whose build
> may not have strictly doing the right thing (adding /usr/include/xfs to
> their include path) to pulling in this file rather than the one they
> intended.

Well, clearly they're doing the wrong thing.  We've now introduced
a half-baked scheme where one random header is inconsistent with
the rest, because of some other broken application.  That's dopey.

The convention there now is such that its easy to tell what include/
files have kernel counterparts (the xfs_* prefixed ones), and the
rest are generically named (list.h, cache.h, parent.h, paths.h,
linux.h, etc).  This change now makes list.h sit in no-mans-land...
please revert it back, since the app is fixed anyway (you are also,
of course, ignoring the flip side of your own argument, which is that
other equally broken apps could be using <xfs/list.h>, which moved
and hence broke their builds).  You can't win by pandering to broken
3rd party applications... best you can do is keep the XFS stuff sane
and internally consistent.

> > Oh, noone is updating oss.sgi.com/projects/xfs/{news,index}.html
> > with recent changes either - seems like progress has come to a
> > halt to those of us no longer in the secret cabal, anyway ;) ...
> > just FYI.
> > 
> 
> Its now on my list of things to do.
> 

Great - thanks!

cheers.

-- 
Nathan
