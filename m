Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jul 2008 08:00:24 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6PF0KM6000496
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 08:00:21 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E7D91BBBE1C
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 08:01:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id iDqWBxCQpvYyQdpJ for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 08:01:31 -0700 (PDT)
Message-ID: <4889EAC9.5070304@sandeen.net>
Date: Fri, 25 Jul 2008 10:01:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 981498 - remove mounpoint UUID code
References: <20080725033841.D689558C4C3F@chook.melbourne.sgi.com> <48894C66.5060204@sandeen.net> <20080725050149.GL5947@disturbed>
In-Reply-To: <20080725050149.GL5947@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Niv Sardi-Altivanik <xaiki@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Jul 24, 2008 at 10:45:42PM -0500, Eric Sandeen wrote:
>> Niv Sardi-Altivanik wrote:
>>> remove mounpoint UUID code
>> Are you sure this didn't change any disk structures?  The patch I sent
>> was RFC and completely untested...  (and disclosed as such...) :)
> 
> Looking at the original patch, it definitely does change the format
> of log structures on disk. it removes the union of the uuid and rdev
> in the xfs_inode_log_format[32|64] which takes that entry from 16
> bytes down to 4 bytes. So I'd suggest that thisss should be removed
> immediately before it hits public and people start corrupting their
> filesystems....

Yep.  Well crud, I even knew that when I sent it, hence the
RFC/untested/blah/blah but I suppose I shouldn't send a patch that I
know to be busted even if it's just as a whaddya-think.  I'll pad out
the union, check all the log structs, run qa & resend.

And despite all the talk about community & contributors running qa and
helping with test coverage - as a general rule do sgi devels run qa too
before committing?

-Eric

> Cheers,
> 
> Dave.
