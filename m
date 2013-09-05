Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 997857F52
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 06:53:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25F90AC005
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 04:53:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gMkZpX9VH1pMPJuK for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 04:53:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHY81-0001DA-Ab
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 21:53:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHY81-0004BD-9Q
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 21:53:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: more code movement for userspace
Date: Thu,  5 Sep 2013 21:53:32 +1000
Message-Id: <1378382015-16026-1-git-send-email-david@fromorbit.com>
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

The following three patches move code around to help with userspace
support and maintainance. The first patch is done because xfs_db
requires access to all the verifiers that libxfs uses, so exporting
them with eh disk formats they verify makes sense.

The second patch unifies all the directory and attribute on-disk
format definitions in a single file - xfs_da_format.h - and switches
all the code to include that.

The last patch is required for xfs_db to support reading, verifying
and recalculating CRCs via libxfs, similar to what xfs_inode_buf.c
supplies the userspace tools.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
