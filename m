Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D06A07F50
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:53:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9BBB304032
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 23:53:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lbCqr93d9xF7IXiJ for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 23:53:12 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeJxz-0006qr-JL
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:07 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeJxz-0006Vg-F2
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfsprogs: more CRC support patches
Date: Mon, 20 May 2013 16:52:57 +1000
Message-Id: <1369032783-24973-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

[ well, really patches 31..36 :) ]

Hi folks,

More work on top of the original series of 30 patches, including
xfs_db support for parsing the v3 directory format.

Note that there are also two patches in here that convert both
xfs_db and xfs_repair to use the libxfs directory block type
definitions. While it may have once been convenient for them to have
a basic definition, it does not lend itself to making the code
support the v3 format quickly and concisely. Reusing the
libxfs/kernel structure definitions and abstraction means that the
code quickly becomes v3 aware and has just works.

Right now this patchset and the current kernel patchset (all the
attr fixes) runs through xfstests quite far on a 4k block size
filesystem - all the generic tests pass, and most of the XFS
specific tests that don't rely on write or attr output support in
xfs_db also pass.

I'll get the attr db support done tomorrow.....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
