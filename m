Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED079C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 02:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjKJCD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 21:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjKJCDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 21:03:55 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C735BB
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 18:03:52 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-d9a4c0d89f7so1675207276.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 18:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699581832; x=1700186632; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ee1gdMiQdem0bKnPzcqX/Iq4cJoSjn4R2vfuYpLkMQk=;
        b=GsYZEODLtCLh3bsUJBqpZuki0Fhg/rcy8o+v8HiKhrS8invoujqvP4RSBe/Tf4HG5F
         s2bXcMNWGL3mTnXjqOs3O+02dTAESdKne1819vWA6gAVPx6l6zpGsA51LyvWufoH6t5y
         uKfHRbHj3E5cFDACSS6oExZ2B4nC1j4hG1ENvmy+bRZCVCkUb4iYEtFp6viCbgvJCKIg
         AqP81jhu7HN7bO+SF5GwKAN2c3NMhPEXv/JnSTmmB9HDW3bBoSQRvmZk0a6Nxm7tFQ4F
         JMkXCwX7f0wy53NJzdxtSUFb91M45FQ/rGT7Dvk8TNhfIiJ/QDRr+JZDRXWrcnAZdd/X
         Jzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699581832; x=1700186632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ee1gdMiQdem0bKnPzcqX/Iq4cJoSjn4R2vfuYpLkMQk=;
        b=ofR0plbrrI18HsNcKFcN3W9zSJl9Rpb6PI1yjgt1iOUWDiCBG3sTqjym9UHJRca55S
         xqff4PO1hXxGRJvMZdW7fCnZZJ9SWfIIBwaT5W1eWJuGKHjIIuA+uta4xLldn6UYnuXR
         TqqDohh2ccfItgwsd3//1QRF4qE/5MysEKyvw3UMyfvkZX7RbpVdTYi5vJM8Mg781+P+
         w9QYfZJt+iZMoeU5y6T43GwrlSyZyXJDX+A8qOONs4KPIVr1mxM3AygJlesuqarC2M26
         2aZ8uzcbrqL8p2fqhS9xI5VxKqPK5iHlkLGapvWcXFYh9wSOFF7VCY5t1vSgEXNoLZZq
         lHPw==
X-Gm-Message-State: AOJu0Yy+stPS9T7KBERrGhO+c0oR8oHjLHF3WY9vjalK7sFqLfm6e4yV
        r3GS4BcJabPEkF2+MryAGnXpDg==
X-Google-Smtp-Source: AGHT+IHu6yMgXM7sNxyLRnxYRHZ8IFTwst2Kh3PZSwrr1XY9jxVCxqCq+0UAEhqbv9K17N/EnBxxWw==
X-Received: by 2002:a05:6902:18c8:b0:d85:abce:3f43 with SMTP id ck8-20020a05690218c800b00d85abce3f43mr8738435ybb.38.1699581832059;
        Thu, 09 Nov 2023 18:03:52 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id r19-20020aa78b93000000b006bf43e5619bsm11318836pfd.195.2023.11.09.18.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 18:03:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r1Gs9-00AYwS-0t;
        Fri, 10 Nov 2023 13:03:49 +1100
Date:   Fri, 10 Nov 2023 13:03:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZU2PhTKqwNEbjK13@dread.disaster.area>
References: <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU1nltE2X6qLJ8EL@dread.disaster.area>
 <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 09:36:51AM +0800, Zorro Lang wrote:
> The g/047 still fails with this 2nd patch. So I did below steps [1],
> and get the trace output as [2], those dump_inodes() messages you
> added have been printed, please check.

And that points me at the bug.

dump_inodes: disk ino 0x83: init nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
dump_inodes: log ino 0x83: init nblocks 0x8 nextents 0x0/0x1 anextents 0x0/0x0 v3_pad 0x1 nrext64_pad 0x0 di_flags2 0x18 big
                                                     ^^^^^^^
The initial log inode is correct.

dump_inodes: disk ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
dump_inodes: log ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18 big
                                                    ^^^^^^^

.... but on the second sample, it's been modified and the extent
count has been zeroed? Huh, that is unexpected - what did that?

Oh.

Can you test the patch below and see if it fixes the issue? Keep
the first verifier patch I sent, then apply the patch below. You can
drop the debug traceprintk patch - the patch below should fix it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: recovery should not clear di_flushiter unconditionally

From: Dave Chinner <dchinner@redhat.com>

Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
zero padding in the inode, except when NREXT64=1 configurations are
in use and the zero padding is no longer padding but holds the 64
bit extent counter.

This manifests obviously on big endian platforms (e.g. s390) because
the log dinode is in host order and the overlap is the LSBs of the
extent count field. It is not noticed on little endian machines
because the overlap is at the MSB end of the extent count field and
we need to get more than 2^^48 extents in the inode before it
manifests. i.e. the heat death of the universe will occur before we
see the problem in little endian machines.

This is a zero-day issue for NREXT64=1 configuraitons on big endian
machines. Fix it by only clearing di_flushiter on v2 inodes during
recovery.

Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
cc: stable@kernel.org # 5.19+
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index f4c31c2b60d5..dbdab4ce7c44 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_has_v3inodes(mp) &&
-	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
-		/*
-		 * Deal with the wrap case, DI_MAX_FLUSH is less
-		 * than smaller numbers
-		 */
-		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
-		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
-			/* do nothing */
-		} else {
-			trace_xfs_log_recover_inode_skip(log, in_f);
-			error = 0;
-			goto out_release;
+	if (!xfs_has_v3inodes(mp)) {
+		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+			/*
+			 * Deal with the wrap case, DI_MAX_FLUSH is less
+			 * than smaller numbers
+			 */
+			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
+			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
+				/* do nothing */
+			} else {
+				trace_xfs_log_recover_inode_skip(log, in_f);
+				error = 0;
+				goto out_release;
+			}
 		}
+
+		/* Take the opportunity to reset the flush iteration count */
+		ldip->di_flushiter = 0;
 	}
 
-	/* Take the opportunity to reset the flush iteration count */
-	ldip->di_flushiter = 0;
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
