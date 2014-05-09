Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2677B7F60
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 20:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDFAFAC013
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 18:17:20 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hs6NZasx4zqY1mkt for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 18:17:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiZQu-0004KE-Qt
	for xfs@oss.sgi.com; Fri, 09 May 2014 11:17:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiZQu-000197-Pj
	for xfs@oss.sgi.com; Fri, 09 May 2014 11:17:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] repair: fixes for 3.2.0-rc2
Date: Fri,  9 May 2014 11:17:00 +1000
Message-Id: <1399598222-4349-1-git-send-email-david@fromorbit.com>
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

A couple of fixes identified for xfs_repair follow. The first is a
regression introduced by the discontiguous buffer support in the
prefetch code, which Eric Sandeen found. I've written a slightly
different fix for it than Eric did, but the concept for the fix is
all Eric's work.

The second patch is not actually a regression, but the filesystem
that triggered the above regression can't actually be repaired in a
sane amount of time because of an array insertion algorithm with
exponential cost. It's trivial to fix, and it means xfs_repair can
actually run to completion quickly rather than burn CPU for hours
getting nothing done.

These fixes mean I'll probably release a 3.2.0-rc3 once they've been
reviewed and go into the tree....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
