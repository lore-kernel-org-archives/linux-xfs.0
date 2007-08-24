Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:05:07 -0700 (PDT)
Received: from bowl.fysh.org (fysh.org [83.170.75.51])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OB4w4p029138
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:05:05 -0700
Received: from mike by bowl.fysh.org with local (Exim 4.50 #1 (Debian))
	id 1IOWYx-0001aE-1l
	for xfs@oss.sgi.com; Fri, 24 Aug 2007 11:38:47 +0100
Date: Fri, 24 Aug 2007 11:38:47 +0100
Subject: XFS and 4k stacks/newer kernels.
Message-ID: <20070824103846.GC13240@fysh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: Mike Ashton <mike@fysh.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi folks,

Firstly, I must apologise for the tremendously vague nature of this
"report".  I do hope it's of some use, and it's the best I can do at
the moment.

I've been using XFS for several years now on a raid6 partition on a
15-disk array on linux 2.6.19 without 4k stacks, and without incident.
And a very nice filesystem it is too.

I've just set up a new one based on exactly the same hardware but with
a 2.6.22.3 kernel (and thus with compulsory 4k stacks, as I understand
it?).  During a large rsync to populate the filesystem, the write to
local disk blocked in a fast device wait, but without any errors in
dmesg.  After giving it half an hour to wake up again, I hard rebooted
and the XFS superblock was unreadable; bye bye filesystem.

So I've rolled back to 2.6.19, unsurprisingly, but I wanted to let you
know that some issues with 4k stacks or other features of newer
kernels may not have been resolved yet.  Since there were no errors,
I've nothing specific to give you, which I appreciate gives you little
to go on.  It wouldn't be right to leave this anecdote unreported,
however.

Best of luck and thanks,
Mike.
