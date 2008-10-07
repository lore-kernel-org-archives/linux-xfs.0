Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M834q008999
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA0721B0C572
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:41 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id GloURPl6k2KazQvK for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:41 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002VY-Bw
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/7] XFS: dynamic busy extent tracking
Date: Wed,  8 Oct 2008 09:09:30 +1100
Message-Id: <1223417377-8679-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The busy extent tracking in XFS is currently very static and has
some performance issues. We can only track 128 busy extents per AG,
and when we overflow this we fall back to synchronous transactions.
Also, every time we re-use a busy extent we cause a synchronous log
force, which stops all allocation and freeing in that AG while the
log force is in progress.

This limits the amount of transaction aggregation we can potentially
do because of the fact that we do log forces when a busy extent is
found which would effectively close off an aggregating transaction
group. It is relatively easy to trigger overflows or reuse of busy
extents and cause thіs to occur.

Further, when it comes to issuing block discard messages to tell the
lower layer that we're finished with a block, we need to track all
freed extents, not just those we can fit in a static array.  Hence
adding block discard functionality to XFS also requires us to rework
the way we track busy extents.

This patch series is a work in progress. It's probably better to
look at the finished product rather than the inividual patches
because the later patches undo a lot of the earlier factoring and
shuffling. I'll need to completely redo the series before final
subbbmission. However, I'm posting this now because it passes XFSQA
and it seems to be a good time to post it for comments before I
start cleaning it up....
