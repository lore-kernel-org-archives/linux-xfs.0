Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 19:03:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E23Wlm007909
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:03:32 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2550B4EFF4C
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:05:12 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id pH3J8phAhCD8x1TW for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:05:12 -0700 (PDT)
Date: Tue, 14 Oct 2008 13:04:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fw: [PATCH] fix instant oops with tracing enabled
Message-ID: <20081014020457.GG10716@disturbed>
References: <20081013223932.GE10716@disturbed> <48F3EA6F.9000209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F3EA6F.9000209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs@oss.sgi.com, hch@lst.de

On Tue, Oct 14, 2008 at 10:40:15AM +1000, Mark Goodwin wrote:
>
>
> Dave Chinner wrote:
>> SGI folks,
>>
>> Looks like Christoph is having problems posting to the list;
>> the spam filter is dropping all his mail. In the mean time,
>> here's a fix for an oops in the tracing code as a result of
>> the last check ins. I didn't see this because the "combine
>> inodes" patches removes xfs_icount altogether.
>
> Lachlan also saw some regressions after merging these patchsets :
> . replace the mount inode list with radix tree traversals
> . clean up sync code

Can you share with us all what those problems are? I can't help
find and fix the problems if I don't get told about them. perhaps
you should be opening bugzilla bugs rather than internal bugworks
PVs for regressions as a result of merges of community patch
sets....

>> If that
>> series is going to be included in the current round of checkins
>> then this patch probably isn't needed.
>
> The agreed plan for 2.6.28 still has the following patchsets to go in:
>
> . Combine the XFS and Linux inode structures V2
> . Track reclaimable inodes in inode cache
> . AIL cleanup and bug fixes
> . Account for allocated blocks when expanding directories
> . Check for valid transaction headers in recovery
> . fix remount rw with unrecognized options
>
> It's starting to look like a pretty aggressive merge and QA schedule.

We've got all of the -rc series to address regressions.

> Dave, is it worth doing any testing until these are *all* merged?

IMO, no, but that's up to you guys. I'd just merge them, run some
basic QA then push them to linus.  We've still got the whole -rc
series to address regressions.  And if you tell us about
regressions, we can help track them down and get them fixed quickly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
