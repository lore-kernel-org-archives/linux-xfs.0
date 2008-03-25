Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 05:53:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PCrHCS015387
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:53:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1D7B1262797
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:53:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id xNZpTOIzkHZOraju for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:53:49 -0700 (PDT)
Message-ID: <47E8F5BD.7000601@sandeen.net>
Date: Tue, 25 Mar 2008 07:53:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: Write primary superblock info to ALL secondaries during
 mkfs
References: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> Secondaries should contain redundant information from the primary
> superblock. It does this for the filesystem geometry information,
> but not inode values (rootino, rt inos, quota inos).
> 
> This patch updates all the secondaries from the primary just before
> it marks the filesystem as good to go.
> 
> Unfortunately, this also affects the output of xfs_repair during
> QA 030 and 178 which restores the primary superblock from the
> secondaries.
> 
> Now that the secondaries have valid inode values, xfs_repair
> does not have to restore them to the correct values after copying
> the secondary into the primary.
> 
> Attached is the mkfs.xfs patch and also the updated golden
> outputs for QA 030 and 178.
> 
> The next step after this is to enhance xfs_repair to be more
> thorough in checking the secondaries during Phase 1.

One related thing I'd always wondered about was stamping a secondary at
the very end of the device (and therefore shrinking the fs by just a
bit) - repair could then do a quick check at the end of the device
before resorting to scanning for the 2nd backup... would this make any
sense?

-Eric
