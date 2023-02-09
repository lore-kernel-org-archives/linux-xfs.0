Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED41CC636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjBIWSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjBIWSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F396B374
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:34 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id u75so2516947pgc.10
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9Gs6riQ3obPLvyxnBn3rMMU0xfSBozgIRCcTTg3nmo=;
        b=6ZiFFanz1hHfzzFwo809iUyxSbGz6GjLgiC5BUrJRMPzeSajCMvWq+KaCxrhuru+4G
         tW/PqHAjKWNi6PdYRd+05LpJ/3NMsEmoDxL9qg1R3eOAB+3gS8wEZD+tI2muIYEeC1YI
         uMfK9lp8WcTmWZKEiymXgAkTu+CjryiJiwdu53aQnOgrJdizGsz+D42huiivtnOuoA5n
         +AU59Mr5bdWWExfw04HKi+wq658YHhs6dBZfvPpgpecWTkC2qfbBmX3HMRe1u7oJ3kxp
         5+6rWzVFA+GGVKRzBUeX0v7XQzOMdPSy+UkyMf1Fdxedu+v+GQntm8XN025mYYlsm3az
         dIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P9Gs6riQ3obPLvyxnBn3rMMU0xfSBozgIRCcTTg3nmo=;
        b=4Sdc6OASmm1K0tETWEK5xqHLV1rWLv7kzW4J1ehxix4k7EXpJA9vUWhtCWVgBLX50q
         E24yDwf/zNPkS0qnTAWVub3vJr+ZDEN8jwdbg06LJbQVqHILTUdoabtmGr8Jmf9PWZpb
         EppU/WHKWiU9JjNHEzvSgQVpMsXV8htYJWjYwYMLcAwuW7xjC8MiAPxb3PEqGrb2p4+D
         7drnZK7XKams51dCr6uY2ryDXIyhnnsSm8P8xSx3AYqaB6+6ixylLbjkxfoXbq2xd/j6
         zu4jP4iYRzZqXKB+Kbc01K6bKyPBBZgXMsEkSp2ZE/ppIcKQrLXflgnYAYOQh5YihKwg
         qeUQ==
X-Gm-Message-State: AO0yUKXlxi4T+cjXskeq2Rv4lEV6+MmtSf+WfdCjWKVvAwi3FikoMPHd
        lD3Bq/dWT1NKB50NcYmXRN0+cIf5hV2Fn/n9
X-Google-Smtp-Source: AK7set8JGDNnPdOdwHigDhJPzDVkdK17AykQfbdsq6OYd0pBq8eBlxONY/ZwPSMkbFeyXP7flQ1PjQ==
X-Received: by 2002:a62:1ec7:0:b0:592:5e1d:c7d2 with SMTP id e190-20020a621ec7000000b005925e1dc7d2mr8954738pfe.23.1675981114065;
        Thu, 09 Feb 2023 14:18:34 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id x20-20020aa793b4000000b0058a313f4e4esm1988760pff.149.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:32 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFL-00DOUp-Sr
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:27 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFL-00FcM3-2r
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/42] xfs: prefer free inodes at ENOSPC over chunk allocation
Date:   Fri, 10 Feb 2023 09:17:45 +1100
Message-Id: <20230209221825.3722244-3-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When an XFS filesystem has free inodes in chunks already allocated
on disk, it will still allocate new inode chunks if the target AG
has no free inodes in it. Normally, this is a good idea as it
preserves locality of all the inodes in a given directory.

However, at ENOSPC this can lead to using the last few remaining
free filesystem blocks to allocate a new chunk when there are many,
many free inodes that could be allocated without consuming free
space. This results in speeding up the consumption of the last few
blocks and inode create operations then returning ENOSPC when there
free inodes available because we don't have enough block left in the
filesystem for directory creation reservations to proceed.

Hence when we are near ENOSPC, we should be attempting to preserve
the remaining blocks for directory block allocation rather than
using them for unnecessary inode chunk creation.

This particular behaviour is exposed by xfs/294, when it drives to
ENOSPC on empty file creation whilst there are still thousands of
free inodes available for allocation in other AGs in the filesystem.

Hence, when we are within 1% of ENOSPC, change the inode allocation
behaviour to prefer to use existing free inodes over allocating new
inode chunks, even though it results is poorer locality of the data
set. It is more important for the allocations to be space efficient
near ENOSPC than to have optimal locality for performance, so lets
modify the inode AG selection code to reflect that fact.

This allows generic/294 to not only pass with this allocator rework
patchset, but to increase the number of post-ENOSPC empty inode
allocations to from ~600 to ~9080 before we hit ENOSPC on the
directory create transaction reservation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5118dedf9267..e8068422aa21 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1737,6 +1737,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
+	bool			low_space = false;
 	int			flags;
 	xfs_ino_t		ino;
 
@@ -1767,6 +1768,20 @@ xfs_dialloc(
 		ok_alloc = false;
 	}
 
+	/*
+	 * If we are near to ENOSPC, we want to prefer allocation from AGs that
+	 * have free inodes in them rather than use up free space allocating new
+	 * inode chunks. Hence we turn off allocation for the first non-blocking
+	 * pass through the AGs if we are near ENOSPC to consume free inodes
+	 * that we can immediately allocate, but then we allow allocation on the
+	 * second pass if we fail to find an AG with free inodes in it.
+	 */
+	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
+		ok_alloc = false;
+		low_space = true;
+	}
+
 	/*
 	 * Loop until we find an allocation group that either has free inodes
 	 * or in which we can allocate some inodes.  Iterate through the
@@ -1795,6 +1810,8 @@ xfs_dialloc(
 				break;
 			}
 			flags = 0;
+			if (low_space)
+				ok_alloc = true;
 		}
 		xfs_perag_put(pag);
 	}
-- 
2.39.0

