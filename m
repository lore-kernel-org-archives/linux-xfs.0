Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 00:08:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4578CPJ030674
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 00:08:15 -0700
Date: Mon, 5 May 2008 17:08:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080505070847.GH155679365@sgi.com>
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481B7FD1.3030107@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, May 02, 2008 at 03:55:45PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Eric Sandeen wrote:
> >> This should fix the longstanding issues with xfs and old ABI
> >> arm boxes, which lead to various asserts and xfs shutdowns,
> >> and for which an (incorrect) patch has been floating around
> >> for years.  (Said patch made ARM internally consistent, but
> >> altered the normal xfs on-disk format such that it looked
> >> corrupted on other architectures):
> >> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
> > 
> > ping again...
> 
> ping #3...

<sigh>

Looks like if I don't pick it up then nobody is going to answer.
I'll run it through my ia64 and x86_64 test boxes and if it's ok
then I'll commit it.

Did you ever send an equivalent userspace patch?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
