Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 22:58:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L5woHT007296
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 22:58:50 -0700
Received: from web34508.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 3AA921A1D9F5
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:00:10 -0700 (PDT)
Received: from web34508.mail.mud.yahoo.com (web34508.mail.mud.yahoo.com [66.163.178.174]) by cuda.sgi.com with SMTP id HUo0zO6s2sxZrERW for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:00:10 -0700 (PDT)
Date: Wed, 20 Aug 2008 23:00:07 -0700 (PDT)
From: gus3 <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
In-Reply-To: <20080821051508.GB5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <684252.68814.qm@web34508.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--- On Wed, 8/20/08, Dave Chinner <david@fromorbit.com> wrote:

> Ok, I thought it might be the tiny log, but it didn't
> improve anything
> here when increased the log size, or the log buffer size.
> 
> Looking at the block trace, I think elevator merging is
> somewhat busted. I'm
> seeing adjacent I/Os being dispatched without having been
> merged.  e.g:

[snip]

> Also, CFQ appears to not be merging WRITE_SYNC bios or
> issuing them
> with any urgency.  The result of this is that it stalls the
> XFS
> transaction subsystem by capturing all the log buffers in
> the
> elevator and not issuing them. e.g.:

[snip]

> The I/Os are merged, but there's still that 700ms delay
> before dispatch.
> i was looking at this a while back but didn't get to
> finishing it off.
> i.e.:
> 
> http://oss.sgi.com/archives/xfs/2008-01/msg00151.html
> http://oss.sgi.com/archives/xfs/2008-01/msg00152.html
> 
> I'll have a bit more of a look at this w.r.t to
> compilebench performance,
> because it seems like a similar set of problems that I was
> seeing back
> then...

I concur your observation, esp. w.r.t. XFS and CFQ clashing:

http://gus3.typepad.com/i_am_therefore_i_think/2008/07/finding-the-fas.html

CFQ is the default on most Linux systems AFAIK; for decent XFS performance one needs to switch to "noop" or "deadline". I wasn't sure if it was broken code, or simply base assumptions in conflict (XFS vs. CFQ). Your log output sheds light on the matter for me, thanks.
