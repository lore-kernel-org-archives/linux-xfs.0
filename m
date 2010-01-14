Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACYXx250398 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 156CF151462A
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	mSBGgzbAMpAulbzH for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:29 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11391290-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMhj-0007rN-HM
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:27 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LB-1q
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfsprogs: fix build warnings V2
Date: Thu, 14 Jan 2010 21:09:03 +1100
Message-Id: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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

This is the complete set of patches that make xfsprogs build cleanly with gcc
4.3.4 on my debian system. The majority of the warnings are dir2 name string
sign warnings, most of the rest are array subscript bounds warnings which gcc
has got wrong. The only real bug in whole the lot is the missing error check in
xfs_rtfree_range().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
