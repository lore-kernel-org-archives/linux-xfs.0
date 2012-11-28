Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS1wrjs121938 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:58:53 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	r4U7wUBepbgSK7Rn for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:01:09 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TdWxV-0003zT-PM
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TdWxV-0000SG-KU
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: patch queue for 3.8
Date: Wed, 28 Nov 2012 13:00:59 +1100
Message-Id: <1354068063-1692-1-git-send-email-david@fromorbit.com>
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

Hi folks,

More bug fixes for 3.8. This series contains:

- the DIO transaction deadlock patch (unmodified),
- addressed Christoph's zero-range review points and fixes the
  ASSERT in the sub-block zeroing case. (updated)
- a dquot locking issue that has been causing me random hangs in
  xfstests 232 for months (new)
- fixes for the log CRC sparse endian warnings. (new)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
