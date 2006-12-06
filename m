Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 17:50:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB61oLaG009568
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 17:50:23 -0800
Message-ID: <457621A2.7000605@melbourne.sgi.com>
Date: Wed, 06 Dec 2006 12:49:22 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: Recent changes in xfsprogs
References: <1165359970.1281.51.camel@edge>
In-Reply-To: <1165359970.1281.51.camel@edge>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: bnaujok@sgi.com, xfs@oss.sgi.com

Nathan,

Nathan Scott wrote:
> Yo Barry,
> 
> xfsprogs/doc/CHANGES
> 
>         - Rename include/list.h to xfs_list.h so that other applications
>           do not accidentally use it.
> 
> What was the problem here?  This doesnt sound like the right fix -
> there should be no applications outside of the XFS userspace that
> use libxfs.h - thats what <xfs/xfs.h> is for (exactly this reason,
> preventing namespace collision, by reducing all the XFS internals
> being exposed).
> 

A classic problem with cpp is that it is possible for someone else to
introduce a header that breaks your build. By introducing a header
called list.h, a very common name, we have exposed products whose build
may not have strictly doing the right thing (adding /usr/include/xfs to
their include path) to pulling in this file rather than the one they
intended.

So strictly speaking XFS was doing nothing wrong, but its a simple
change for us to make to be more friendly. The application that had this
problem has also been fixed to use <xfs/foo.h>.

> Also, there seems to be lots of checkin mail not making it out to
> oss.sgi.com (let alone review mail), making it difficult for people
> to keep up to date with changes (and keep distros, like Debian,
> uptodate) ... could y'all make some effort to keep us "on the
> outside" in the loop?
> 

True, not everything has been escaping of late.

> Oh, noone is updating oss.sgi.com/projects/xfs/{news,index}.html
> with recent changes either - seems like progress has come to a
> halt to those of us no longer in the secret cabal, anyway ;) ...
> just FYI.
> 

Its now on my list of things to do.

David

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
