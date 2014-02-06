Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC2AF7F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 23:53:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B85DC8F8033
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 21:53:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GghPxxwNR0Cs3c6g for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 21:53:51 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WBHuD-0007Eg-9c
	for xfs@oss.sgi.com; Thu, 06 Feb 2014 16:53:45 +1100
Date: Thu, 6 Feb 2014 16:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdump: master branch updated to a88c490
Message-ID: <20140206055345.GL13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

The xfsdump repository at git://oss.sgi.com/xfs/cmds/xfsdump has
just been updated.

The new head of the master branch is commit:

a88c490 restore: don't trash file capabilities

New Commits:

Dave Chinner (1):
      [a88c490] restore: don't trash file capabilities


Code Diffstat:

 restore/content.c | 116 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 39 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
