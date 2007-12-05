Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 05:55:30 -0800 (PST)
Received: from poptart.bithose.com (poptart.bithose.com [24.97.26.52])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB5DtPFJ001538
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 05:55:26 -0800
Received: from poptart.bithose.com (localhost [127.0.0.1])
	by poptart.bithose.com (8.12.10/8.12.10) with ESMTP id lB5DiVbO113486
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 08:44:31 -0500 (EST)
Received: from localhost (jakari@localhost)
	by poptart.bithose.com (8.12.10/8.12.10/Submit) with ESMTP id lB5DiVuB113379
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 08:44:31 -0500 (EST)
Date: Wed, 5 Dec 2007 08:44:31 -0500 (EST)
From: Jameel Akari <jakari@bithose.com>
Subject: Which (lib)acl for 2.4.35?
In-Reply-To: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
Message-ID: <Pine.OSF.4.64.0712050837120.108924@poptart.bithose.com>
References: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>


The story: We have some old RH7.3 machines that had been running the old 
2.4.18_SGI_XFS1.1 from back in the day.  Moving these to a new version of 
VMware requires upgrading to something more recent, and 2.4.35.3/SMP was 
built from the mainline.

The situation:

Seems to work, except ACL support is broken.  I'm pretty sure this is due 
to the userland libraries and tools being so out of date (machine has 
2.0.9-0).  Which versions do I need, and where do I get them?  CVS?

I assume that all the other utilities (things in xfsprogs like mkfs, 
and xfsdump) will need similar updates as well.

The immediate need is to get ACLs working, but it'd be nice if I can patch 
up the rest of it one last time until we can rebuild these VMs.

-- 
Jameel Akari
