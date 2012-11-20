Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKBPP01151936 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 05:25:25 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	z5yeJ65o8rGyzkbD for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 03:27:34 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Talyz-000132-N3
	for xfs@oss.sgi.com; Tue, 20 Nov 2012 22:27:13 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Talyz-0005uY-JC
	for xfs@oss.sgi.com; Tue, 20 Nov 2012 22:27:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: regression fixes for 3.8 merge cycle
Date: Tue, 20 Nov 2012 22:27:09 +1100
Message-Id: <1353410831-22653-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Folks,

Here's a couple of fixes for regressions reported in the past couple
of days. They've passed xfstests smoke testing here. I'm not really
certain whether the direct Io deadlock fix is the best way to fix
the problem, but I can't think of any other way of doing it at this
point because we have no way of passing a transaction context to the
direct IO allocation callback path. If anyone has any bright ideas,
I'm all ears....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
