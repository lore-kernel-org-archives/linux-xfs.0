Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbeKCOC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 10:02:59 -0400
Date: Fri, 2 Nov 2018 21:52:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfsprogs-4.16; scrubbing and files w/o /usr dependencies...
Message-ID: <20181103045253.GT4135@magnolia>
References: <5BDD1D19.7030208@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5BDD1D19.7030208@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: Linux-Xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 02, 2018 at 08:59:21PM -0700, L.A. Walsh wrote:
> I was noticing in a newer version of xfsprogs that it puts some non-/usr-lib
> dependent files in /sbin, specifically fsck.mfs(shell), mkfs.xfs, xfs_repair
> xfs_scrub, and xfs_scrub_all.
> 
> What was the decider for putting these files in /sbin?  The reason I ask is
> that the last one 'xfs_scrub_all' has a heavy dependency on /usr as it needs
> #!/usr/bin/python3 to run.  So wouldn't it be happier in /usr/sbin?

Hmm, good point, scrub should move to /usr/sbin.

(Granted with many of the distros moving towards /sbin -> /usr/sbin
these days it might not make that much difference... :/ )

> I also note that it has dependencies on systemd.  Will it work for
> systems not running systemd or will systemd be required for newer-versioned
> xfs maintenance?

/usr/lib/xfsprogs/xfs_scrub_all.cron is a sample cronjob that will get
installed automatically some years from now when scrub is stable and
ready to be autoconfigured as a background job.  The goal is to be able
to handle both systemd and cron environments, and I'm not picking sides.
:)

(Note that xfs_scrub is still experimental...)

--D

> Thnx...
> 
> 
> 
