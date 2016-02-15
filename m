Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B9997CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E360C304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mOlAZjUtSAzDt8N9 for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:58 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000M8-Fs
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005G5-Bz
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/14] xfsprogs: kernel libxfs sync up to 4.5-rc2
Date: Mon, 15 Feb 2016 17:18:11 +1100
Message-Id: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

This patchset pulls xfsprogs lixfs up to the same base code as the
v4.5-rc2 kernel. I've simply pulled the commits across and in each
patch made the external xfsprogs changes necessary to make them
compile and work correctly. This applies on top of the xfs_io dax
patchset I posted a short while ago. I've left all the kernel
sign-offs on the commits - it's really only the patches that change
stuff outside libxfs that need any sort of review...

This is pretty much all of the remaining changes needed before I can
cut a 4.5.0-rc1 release of xfsprogs - it's really only bug fixes and
minor changes from here, as I really need this base tree mostly
stable from here on.

The reason for that I'm now going to be build a for-next branch off
this that has all the changes in the current kernel for-next branch.
This will enable Darrick to have a sane code base that he can rebase
all his xfsprogs changes for rmap/reflink on top of. That will make
review, testing and eventual merge much easier for everyone.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
