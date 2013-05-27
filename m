Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A52F329E05
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 02:15:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 677978F8033
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 00:15:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F5LP7kvNXsQSxGmI for <xfs@oss.sgi.com>;
	Mon, 27 May 2013 00:15:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugrdy-0008LB-IT
	for xfs@oss.sgi.com; Mon, 27 May 2013 17:14:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugrdy-0006To-Dd
	for xfs@oss.sgi.com; Mon, 27 May 2013 17:14:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfsprogs: more CRC patches
Date: Mon, 27 May 2013 17:14:52 +1000
Message-Id: <1369638896-24872-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1369312565-6266-1-git-send-email-david@fromorbit.com>
References: <1369312565-6266-1-git-send-email-david@fromorbit.com>
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

A few more patches. The first enforced the fixed config bits for CRC
enabled filesystems at mkfs time. The second adds "-m crc=?" output
to xfs-info, the last two effectively disable metadump/restore
functionality on CRC enabled filesystems until xfs_db supports CRC
calculations properly.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
