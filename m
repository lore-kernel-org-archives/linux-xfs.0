Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 00:54:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E7sTYo029053
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 00:54:35 -0700
Message-Id: <20080514075244.738514733@chook.melbourne.sgi.com>
Date: Wed, 14 May 2008 17:52:44 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 0/4] XFS: ASCII case-insensitivity support
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

I've addressed Christoph's comments in these patches.

I've also changed the behaviour of the "ci_match" parameter
being passed to the lookup functions, and kept the use of it
separate from the "name" parameter.

The other change is the xfs_sb_version_hasasciici() name
from "oldci". This is inline with the user-space patch posted
a few days ago.

-- 
