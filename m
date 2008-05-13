Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:01:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D816w7006481
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:01:09 -0700
Message-Id: <20080513075749.477238845@chook.melbourne.sgi.com>
Date: Tue, 13 May 2008 17:57:49 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 0/4] XFS: Case-insensitive support - ASCII only
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This patch seems to resolve all issues I had with CI support with the
dentry cache. 

My solution for negative dentries was to not call d_add() when the 
inode was not found. I had to fix up the create so it would call
d_rehash if the entry was unhashed.

I've also applied the other previous suggestions and cleanups.

The only outstanding problem is case-preserving rename on a CI
filesystem. I will write a patch for passing flags down to the 
fs-specific lookup once the nameidata patch mentioned by 
Christoph has been removed.

-- 
