Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A8B2D7F52
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 23:27:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C93C304059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 21:27:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TOXbJNfgHyyOoSyK for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 21:27:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vc6KR-0008Go-2b
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vc6KR-0005lM-1C
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: more patches for 3.13
Date: Fri,  1 Nov 2013 15:27:15 +1100
Message-Id: <1383280040-21979-1-git-send-email-david@fromorbit.com>
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

The following series follows up the recently committed series of
patches for 3.13. The first two patches are the remaining
uncommitted patches from the previous series.

The next two patches are tracing patches, one for AIL manipulations
and the other for AGF and AGI read operations. Both of these were
written during recent debugging sessions, and both proved useful so
should be added to the menagerie of tracepoints we already have
avaialble.

The final patch is the increasing of the inode cluster size for v5
filesystems. I'd like to get this into v5 filesystems for 3.13 so we
get wider exposure of it ASAP so we have more data available to be
able to make informed decisions about how to bring this back to v4
filesystems in a safe and controlled manner.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
