Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED98B7F53
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:10:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C395C304053
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 06:10:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UsCkIyLqxvMUxrEC for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 06:10:51 -0700 (PDT)
Date: Fri, 11 Apr 2014 09:10:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/6 v2] xfs: delalloc, dio and corruption...
Message-ID: <20140411131044.GA11718@laptop.bfoster>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397106053-7489-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 03:00:47PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is version 2 of the DIO vs delalloc patchset I posted here:
> 
> http://oss.sgi.com/archives/xfs/2014-03/msg00313.html
> 
> The changes to this version are:
> 
> 	- the bug fix to patch 2 that Brain noticed,
> 	- I dropped the delalloc extent splittting patch because
> 	  with the fix to patch 2 I can't trigger that bug anymore,
> 	  and that patch was causing transaction overruns in
> 	  xfs/297. Hence without an existing reproducer, I won't try
> 	  to fix that problem.
> 	- the last patch is new, and is a bug in the collapse range
> 	  code where it fails to shift the last N extents correctly
> 	  if there are N delalloc extents before the shifted range.
> 
> With these 6 patches, all of the xfstests fsx/fsstress tests pass
> on 1k, 2k and 4k block size filesystems, with and without CRCs
> enabled, on 1, 2 and 16p test VMs.
> 
> I'm much happier with these patches now - I don't think that there
> are more problems lurking, but only time will tell. I'd like to get
> these fixes to Linus for 3.15 (probably for -rc2), so eyeballs and
> testing would be appreciated.
> 

The series looks pretty good to me now with the latest fix. I was
previously tripping all over the delalloc asserts. With this set (and
also running with finobt enabled), my tests ran clean on a 4k fs.

I've seen generic/270 still hit an assert once or twice on a 1k block fs
(as noted on irc), but that's proven rather difficult to reproduce. I'll
continue beating on it a bit, but otherwise:

Tested-by: Brian Foster <bfoster@redhat.com>

Brian

> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
