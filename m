Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B753C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjKVXHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjKVXHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCAB1AE
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3857C433C8;
        Wed, 22 Nov 2023 23:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694425;
        bh=2yl6rq9YSI9sJXut4EB7KV7Qi6eRm6WvUSm1IemLCgI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X+d1sqVeohlybLKoSEIXu4gzlWOhsazxmtF0OpU9WjGhr67lUAANvuCIid8In+NkF
         J3TXapzpXmbqzPgPPSs4GkAYqFacGUJa5RU8QP8KL7xfdDRmnBhZD7f58xPy0uptNZ
         5duanht5Nj7cZmskIcEblk2WhS0xm1+gY6qlVeM5s9RaLmBSBNDqOtgtWqJWgugBIL
         JeeVMzTOXzaELoJYqtoql9+w9ROplrueIRK34u8woeL+DR+hIbOxzehPwRM3f9I6Hl
         YRogZeI2f426RCHab6Glt52BV+sStW2obF14Ayp6ptMarqyAWLJ7+bzlJUTEex3btI
         sItq0o9/sry9A==
Subject: [PATCH 3/9] xfs_copy: actually do directio writes to block devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:05 -0800
Message-ID: <170069442535.1865809.15981356020247666131.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Not sure why block device targets don't get O_DIRECT in !buffered mode,
but it's misleading when the copy completes instantly only to stall
forever due to fsync-on-close.  Adjust the "write last sector" code to
allocate a properly aligned buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 79f65946709..26de6b2ee1c 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -854,6 +854,8 @@ main(int argc, char **argv)
 					progname, target[i].name, progname);
 				exit(1);
 			}
+			if (!buffered_output)
+				open_flags |= O_DIRECT;
 		}
 
 		target[i].fd = open(target[i].name, open_flags, 0644);
@@ -887,20 +889,22 @@ main(int argc, char **argv)
 				}
 			}
 		} else  {
-			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
+			char	*lb = memalign(wbuf_align, XFS_MAX_SECTORSIZE);
 			off64_t	off;
 
 			/* ensure device files are sufficiently large */
+			memset(lb, 0, XFS_MAX_SECTORSIZE);
 
 			off = mp->m_sb.sb_dblocks * source_blocksize;
-			off -= sizeof(lb);
-			if (pwrite(target[i].fd, lb, sizeof(lb), off) < 0)  {
+			off -= XFS_MAX_SECTORSIZE;
+			if (pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off) < 0)  {
 				do_log(_("%s:  failed to write last block\n"),
 					progname);
 				do_log(_("\tIs target \"%s\" too small?\n"),
 					target[i].name);
 				die_perror();
 			}
+			free(lb);
 		}
 	}
 

