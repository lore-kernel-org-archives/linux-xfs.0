Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 22:46:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H5kB0n020442
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 22:46:12 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 361FC50A6EB
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 22:47:54 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id fvO9GqUgJ1DfwZ6B for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 22:47:54 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KqiBb-0007tK-9H
	for xfs@oss.sgi.com; Fri, 17 Oct 2008 16:47:43 +1100
Date: Fri, 17 Oct 2008 16:47:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: git tree updates....
Message-ID: <20081017054742.GH31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Lachlan,

I just noticed you've been updating the git tree. You might want to
change the order that certain patches have been committed - the
changes to the fs/inode.c needed to be committed before the changes
to fs/xfs/xfs_inode.c that use them. They've been committed the
wrong way around and about 20 commits apart, so there's significant
region in the commit history where the kernel will fail to build.
Given the distance between the commits, there's a fair chance that
a git bisect could land in this range of compiliation failures.

Any chance of redoing these commits before you push to Linus so
that they are ordered correctly in the git tree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
