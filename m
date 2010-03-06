Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o261oGKe041820 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 19:50:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71DF81D1A7EA
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 17:51:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ZaDFu17vnRE4MmvE for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 17:51:44 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	4462093-1927428
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 12:21:43 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnjB3-0007Rq-Fg
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnjAu-0001EI-Qv
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] Log and transaction cleanups, factoring and bug fixes
Date: Sat,  6 Mar 2010 12:51:15 +1100
Message-Id: <1267840284-4652-1-git-send-email-david@fromorbit.com>
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

The following series is preparation for delayed logging patches. The cleanups
and factoring patches are mainly to make it simple to introduce the delayed
logging patches, especially as these changes really have nothing to do with
delayed logging. The cleanups and factoring patches should be no-ops from a
functionality point of view.

A couple of the patches are fixes for bugs that I've found as I've been working
through delayed logging prototypes.

The final two patches introduce a new log vector structure and factor
xlog_write(). This is probably the most complex of the changes - it should be a
no-op - so needs the most scrutiny. It's also one of the first changes I made -
it's been running through QA for the past month and a half so I think it is
all OK. I certainly found the factored code far easier to work with when it
came to debugging problems...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
