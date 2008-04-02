Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:26:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QWtO006081
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:08 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 0/7] XFS: case-insensitive lookup and Unicode support
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

The following sequence of patches (must be applied in order) implements
case-insensitive support in XFS in two ways:
  1. ASCII only case-insensitive
  2. Unicode case-insensitive mount
 
ASCII only case-insensitive support is a mkfs option and is primary
implemented to support existing IRIX filesystems migrating to Linux.
 
Unicode support is also a mkfs option, but the case-insensitive mode
is a mount time option.
 
The user space patches were posted back in January:
http://oss.sgi.com/archives/xfs/2008-01/msg00102.html

-- 
