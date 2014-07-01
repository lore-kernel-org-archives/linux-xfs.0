Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE9D87F88
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 07:55:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDC7D304064
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 05:55:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AhNcBhj2OQFGMAA1 for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 05:55:03 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] repair: fixes for 3.2
Date: Tue,  1 Jul 2014 22:54:52 +1000
Message-Id: <1404219296-29302-1-git-send-email-david@fromorbit.com>
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

Hi Arkadiusz,

These are the fixes I have so far from working through the metadumps
you supplied me with. The unobfuscated metadump repairs cleanly with
these patches, but the obfuscated one still has a directory rebuild
issue that I haven't got to the bottom of yet. That results in
an error in phase 6 like:

Metadata corruption detected at block 0x2af84770/0x1000
name create failed in ino 2306912354 (117), filesystem may be out of space

It appears that a read verifier is on a recently created
directory leaf block and that is failing. I'm not yet sure why the
leaf block is corrupt, nor why the verifier is even being run on it
seeing as it was only allocated and initialised during the directory
rebuild. That directory rebuil dfailure is the reason for all the
disconected inode that end up in lost+found, and I think it's the
only remaining issue that I need to solve.

Can you test the patches on you machine and see if you get the same
results?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
