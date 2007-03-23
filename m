Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 18:38:08 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2N1c16p028009
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2007 18:38:04 -0700
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 5FEBB21BA5
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 02:26:35 +0100 (CET)
From: Neil Brown <neilb@suse.de>
Date: Fri, 23 Mar 2007 12:26:31 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17923.11463.459927.628762@notabene.brown>
Subject: XFS and write barriers.
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,
 I have two concerns related to XFS and write barrier support that I'm
 hoping can be resolved.

Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
If it is, then barriers are disabled.

I think this is a layering violation - xfs really has no business
looking that deeply into the device.
For dm and md devices, ->ordered is never used and so never set, so
xfs will never use barriers on those devices (as the default value is
0 or NONE).  It is true that md and dm could set ->ordered to some
non-zero value just to please XFS, but that would be telling a lie and
there is no possible value that is relevant to a layered devices.

I think this test should just be removed and the xfs_barrier_test
should be the main mechanism for seeing if barriers work.

Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
retried without the barrier (after possibly waiting for dependant
requests to complete).  This is what other filesystems do, but I
cannot find the code in xfs which does this.
The approach taken by xfs_barrier_test seems to suggest that xfs does
do this... could someone please point me to the code ?

This is particularly important for md/raid1 as it is quite possible
that barriers will be supported at first, but after a failure and
different device on a different controller could be swapped in that
does not support barriers.

Thanks for your time,
NeilBrown
