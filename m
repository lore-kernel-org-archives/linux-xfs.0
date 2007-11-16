Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 21:39:21 -0800 (PST)
Received: from ipmail02.adl2.internode.on.net (ipmail02.adl2.internode.on.net [203.16.214.141])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAG5dFJS011510
	for <Linux-xfs@oss.sgi.com>; Thu, 15 Nov 2007 21:39:17 -0800
Date: Fri, 16 Nov 2007 16:21:29 +1100
From: Jason White <jason@jasonjgw.net>
Subject: SeLinux "fixfiles relabel" shuts down XFS
Message-ID: <20071116052129.GA4401@jdc.jasonjgw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux-xfs <Linux-xfs@oss.sgi.com>

This isn't intended as a bug report, more an FYI, as I don't have time just
now to reproduce the problem, and unfortuantely I wasn't able to obtain any
error log.

I ran fixfiles relabel on an XFS partition, kernel 2.6.22 (Debian). The
fixfiles script terminated with an i/o error and I couldn't access the file
system thereafter - I assume there was an XFS shutdown.

After the inevitable reboot, xfs_check showed no file system errors, and there
have been no subsequent i/o errors indicating possible hardware problems.

This is on a 146gb SAS volume in my home workstation, comprising two 73gb
drives connected to an LSI SAS controller. Everything has been otherwise
stable and the hardware is almost new.

This was the beginning of an attempt to set up SELinux on the machine, which I
won't have time to try again for a while.

This isn't good enough as a bug report, so I'll leave it for now, with the
promise that at some point (not soon, regrettably) I'll try the operation
again and take more care to capture any console messages.

If anyone else happens to reproduce this before I get around to trying it,
I'll be interested in following the progress of the bug.
