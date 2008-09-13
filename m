Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:56:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDtjwU012304
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:45 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C2B5126BED4
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:15 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id iJWkY6dOt8oDTGn7 for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:15 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcc-0007Tu-S4
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] XFS: clean up sync code
Date: Sat, 13 Sep 2008 23:57:00 +1000
Message-Id: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_sync and xfs_syncsub are multiplexed interfaces that
shares relatively little code between callers. because it is
a multiplexed interface, it's hard to tell what is executed
in each context it is called.

Factor out the sync code and explicitly call the sync functions
needed rather than the multiplexed interfaces. Once this is
done, we can remove xfs_syncsub and xfs_sync altogether.
