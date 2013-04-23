Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 496C929DFA
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 13:35:14 -0500 (CDT)
Message-ID: <5176D46B.2030003@sgi.com>
Date: Tue, 23 Apr 2013 13:35:23 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfsprogs: Fix manpages for missing or incorrect
	options
References: <5175BB8F.5090604@sandeen.net> <5175BC67.1000902@sandeen.net>
In-Reply-To: <5175BC67.1000902@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Eric,

Couple of comments.

1. The OPTIONS are listed in several ways, (alphabetical order, same 
order as they appear in the SYNOPSIS, ...).  I don't really have a 
preference, but as long as we are cleaning up the manpages, I suggest we 
be consistent. (case insensitive alpha order maybe???)

2. How about making the -V option wording the same also?
	xfs_db and xfs_repair are:
    		Prints out the current version number and exits.
			       ^^^^^^^^
	The others:
	man/man8/mkfs.xfs.8:Prints the version number and exits.
	man/man8/xfs_admin.8:Prints the version number and exits.
	man/man8/xfs_bmap.8:Prints the version number and exits.
	man/man8/xfs_check.8:Prints the version number and exits.
	man/man8/xfs_copy.8:Prints the version number and exits.
	man/man8/xfs_growfs.8:Prints the version number and exits. The
	man/man8/xfs_io.8:Prints the version number and exits.
	man/man8/xfs_logprint.8:Prints the version number and exits.
	man/man8/xfs_mkfile.8:Prints the version number and exits.
	man/man8/xfs_ncheck.8:Prints the version number and exits.
	man/man8/xfs_rtcp.8:Prints the version number and exits.

3. The following are missing the -V option in both the SYNOPSIS and 
OPTIONS sections.
(I did verify the -V option works for all commands)
man/man8/xfs_estimate.8
man/man8/xfs_freeze.8
man/man8/xfs_fsr.8
man/man8/xfs_mdrestore.8
man/man8/xfs_metadump.8
man/man8/xfs_quota.8
man/man8/xfs_repair.8


4. The -V prints the version and exits, shouldn't all the SYNOPSIS look 
like this for the -V option?

SYNOPSIS
        xfs_db [ -c cmd ] ... [ -i|r|x|F ] [ -f ] [ -l logdev ] ...
        xfs_db -V

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
