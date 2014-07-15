Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BECC17F83
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 00:45:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A997530404E
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 22:45:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vtN6vpTQd1hwGNuL for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 22:45:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6vY5-0001m0-4P
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6vY5-0000oT-3H
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsdump: fix build issues
Date: Tue, 15 Jul 2014 15:45:04 +1000
Message-Id: <1405403106-3084-1-git-send-email-david@fromorbit.com>
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

it's clearly been a while since I built xfsdump, because it didn't
compile in my current dev environment. These patches are needed to
make it compile again. Once there are reviewed and merged, I'll do a
point release for the xfsdump package....

I also noticed that 'make deb' issues a huge number of
set-but-not-used variable warnings, which means that the debian
package is building with different compiler flags to the normal
build. We should fix that at some point.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
