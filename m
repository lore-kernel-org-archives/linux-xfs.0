Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CACC7F56
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:54:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 150BCAC001
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:54:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FYniR0VUaG3RLO5Y for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 01:54:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ufnlh-0001Nf-Js
	for xfs@oss.sgi.com; Fri, 24 May 2013 18:54:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UfnlX-0004QJ-Eq
	for xfs@oss.sgi.com; Fri, 24 May 2013 18:54:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfstests: a fix or two
Date: Fri, 24 May 2013 18:54:17 +1000
Message-Id: <1369385659-16970-1-git-send-email-david@fromorbit.com>
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

The first patch fixes generic/193 to ctually test suig/sgid
behaviour on target filesytems, and to test truncate as well.
The second filters a bunch of noise that causes tests to fail when
testing CRC-enabled filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
