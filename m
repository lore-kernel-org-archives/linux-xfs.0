Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8E357FFE
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:28:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 710B6AC001
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 05:28:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BCLk1AVwgErOSTqF for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 05:28:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTk7-0001ZH-Sq
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:15 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTk7-0005qG-Or
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/25] xfstests: xfstests: move tests out of top level
Date: Fri, 15 Mar 2013 23:27:44 +1100
Message-Id: <1363350489-22257-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Folks,

Here's the current version of the xfstests rework that I've been
using for the past few months. It was last posted here:

http://oss.sgi.com/archives/xfs/2012-07/msg00373.html

and the description remains the same so I won't repeat it all here.
It is still based on the --large-fs patchset.

>From the previous version, this series reintroduces expunged files,
moves all the common files to a common/ directory and moves all
output files to $RESULTS_BASE and allows that environment variable
to override the default results location. There's also a bunch of
bug fixes to fix random test failures that have been folded back
into the relevant patches.

This version is updated to be current with the TOT xfstests tree.
and all the tests up to 313 have been converted to the new
structure.

There are a couple issues i've noticed with a full run - tests
083/169/184 seem to be misplaced (xfs/169 - no such test?) and
there's an issue with the file path output of diff in 063, but
otherwise there aren't any test failures I didn't expect.  Tests
075, 112 and 230 need some more output file path massaging so they
don't leave files in $here.

In comparison to Phil's rework of my original patch set, this series
does not leave a "common" file around and split check specific
functionality across two files. instead, like the original seriesm
it moves check specific code into check and the remaining common
code into common.rc. It also is current with all the tests added
since the last posting of the patch set, and works just fine with
the --large-fs patch set as well.

So, flame away...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
