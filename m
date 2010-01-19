Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0Tbjw141344 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1C0611F8B45
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	55Ww7r7EsoXXIF8w for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11561538-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:34 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003DJ-AI
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003Vw-KY
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: clean up pointer sign differences
Date: Tue, 19 Jan 2010 11:30:18 +1100
Message-Id: <1263861026-13448-1-git-send-email-david@fromorbit.com>
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

This patch series cleans up all the pointer sign warnings when they
are turned back on in the XFS build. These are the kernel
equivalents of the libxfs changes I posted a last week. On
Christoph's suggestion, I've made the changes for the kernel code so
that we can fix the libxfs warnings simply by resyncing the userspce
code with the kernel code.

Hence this makes all of the directory and attribute names and values
unsigned chars and uses that consistently within XFS. The on disk
formats are all unsigned, but the VFS is a mix of signed and
unsigned interfaces. 

The series converts all the names and values at the highest
level to unsigned so the rest of the code doesn't need to juggle
different signedness. It cleans up all the places where we have
cast pointers, makes all functions take unsigned strings and so on.

Finally, it turns on the pointer sign warnings again (which are
actually turned off globally in the build) so that we don't
reintroduce new problems due to a lack of warnings being produced by
the compiler.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
