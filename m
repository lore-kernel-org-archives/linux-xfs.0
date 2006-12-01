Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 12:29:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB1KTUaG015432
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 12:29:31 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kB1KSfrX028519
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 15:28:41 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kB1KSfKk002215
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 15:28:41 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kB1KSdqn024592
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 15:28:40 -0500
Message-ID: <45709075.7080906@sandeen.net>
Date: Fri, 01 Dec 2006 14:28:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: on stack space....
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On the issue of stack space & where it goes in xfs...

<arjan> checkstack does not count function call arguments
<arjan> if you pass big-ish structures to functions things get skewed
quickly
<arjan> the caller pushes the arguments
<arjan> just before the 'call'

and also:

<arjan> btw one thing that helps modern gcc is to move variable
declarations into the inner most {} scope possible
<sandeen> does it really help?
<arjan> it'll allow it to share stack slots
<sandeen> older gccs that was actually -worse-
<arjan> yes
<sandeen> xfs was originally largely written that way
<sandeen> how recent?
<arjan> 4.1 and later have this fixed

lots of irix xfs was written this way IIRC, but I think things got moved
out.  Maybe it'd help to move them back in, for things like xfs_bmapi...

although it's a -penalty- for older gcc's still I think.

Anyway, just found that interesting, might help us get some of this
under control without a huge amount of refactoring...

-Eric
