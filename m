Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 886AB7CA2
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 17:07:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01A00AC004
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 15:06:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ohMvE7JNOAMbL3MK for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2016 15:06:57 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2 V2] fix up mount check handling
Message-ID: <bf987720-16ef-164a-2b0f-ba7cbb13b399@sandeen.net>
Date: Mon, 19 Sep 2016 17:06:56 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

A 2 patch series to more cleanly handle the disappearance
of ustat() on some platforms, used in platform_check_ismounted()
on Linux, which caused a switch to getmntent loops in _ismounted()

This series collapses the now-similar check_platform_ismounted()
and platform_check_iswritable() functions into one, with
helpers.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
