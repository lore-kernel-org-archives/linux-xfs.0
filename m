Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C45B7F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:43:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50179304039
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:43:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BbpOE0T7wkMOCcOp for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:43:57 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006IY-L2
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002du-Jv
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 00/15] mkfs: sanitise input parameters
Date: Fri, 29 Nov 2013 12:43:35 +1100
Message-Id: <1385689430-10103-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This is still a work in progress, but is compelte enough to get
feedback on the general structure. The problem being solved here is
that mkfs does a terrible job of input validation from the command
line, has huge amounts of repeated code in the sub options
processing loops and has many, many unnecessary variable for
tracking simply things like whether a parameter was specified.

This patchset introduces a parameter table structure that is used to
define the parameters and their constraints. Things like minimum and
maximum valid values, default values, conflicting options, etc are
all contained within the table, so all the "policy" is found in a
single place.

This greatly reduces the complexity of the option parsing loop. It
doesn't remove all the complexity (yet) because many of the options
have special cases or more complex conflicts than I've yet added
support for. The idea is, however, that all of the sub-option
parameter setup will eventually end up being implemented as a
generic loop as the parameter structure will hold all the
information about in the input parameters.

To get there, the parameter table still needs more work - it needs
to hold the value/string for the parameter, and we need to reference
those in the code.

The flow on effect of this is that we can remove the many, many
individual variables and start passing the option structures to
functions rather than avoiding using functions because passing so
many variables is messy and nasty. IOWs, it lays the groundwork for
factoring xfs_mkfs.c into something more than a bunch of spagetti...

Anyway, have a look and see what you think about progress so far.

FWIW, the first patch is following up on the multi-disk discussion
Christoph and I had, and the last patch in the series covers all the
issues that arose with "-d file" and treating files like block
devices....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
