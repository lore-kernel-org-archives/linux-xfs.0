Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E8C17F5A
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 17:23:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E85A304084
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 15:23:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	q0CgWGFQNCZHAUdM for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 15:23:06 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvaEH-0003vL-89
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvaEH-0005he-7B
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] libxfs: make some dir2 definitions public
Date: Tue,  2 Dec 2014 10:18:01 +1100
Message-Id: <1417475883-21881-1-git-send-email-david@fromorbit.com>
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

These are a couple of patches that make some private dir2 functions
public as they are used externally to libxfs in userspace. e.g. by
xfs_repair to walk and rebuild directories. There will be more
patches like this as I work through the process of synchronising
libxfs in user and kernel space...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
