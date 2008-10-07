Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:42:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lg5Zc032754
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:42:05 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87F4B1B57AF0
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:43:44 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id kMQzufAf2jfJ2jOz for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:43:44 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKLD-0001js-Uq
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:43:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] XFS: clean up sync code
Date: Wed,  8 Oct 2008 08:43:29 +1100
Message-Id: <1223415819-6599-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_sync and xfs_syncsub are multiplexed interfaces that
shares relatively little code between callers. Because it is
a multiplexed interface, it's hard to tell what is executed
in each context it is called.

Factor out the sync code and explicitly call the sync functions
needed rather than the multiplexed interfaces. Once this is
done, we can remove xfs_syncsub and xfs_sync altogether.
