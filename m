Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B36C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 06:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjKIGO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 01:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjKIGO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 01:14:57 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0022587
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 22:14:55 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cc938f9612so3785625ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2023 22:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699510495; x=1700115295; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKR0dJg1x5C8vmSRq/4juWRLHn7Fh5ZJAZMUTfWN+Vk=;
        b=dpMQC+kzNWW9slxGUf7JV0zbfyjPYyuqw285HA3OYsdWgMIQejX4KHG+VKPHxKlQaZ
         ihxA//hwX5kPvOZmBnhiJAWagw/oeOoMuYPzKgfRSpPcxCiYzdlZNqIqlDdHoRRAZOHy
         21IkWKPi/SOAul8t+oGbiJikDW91cDMoilRd6wPCTo/DV1yZgB+78shnU2+h4K95f9fz
         PXpZDsKCD6tF5rSxMWRCP48MSjwD9Zpp38MSos8oZ+2FVnuEciuKi72A8m2gUdNoEWKV
         jQNhIjvalgmbdhMvXdCPFsFbZ7EnKMAwbpkZ+SAxL4UiPWCDEkVdLTX4RtFVbq0x/8Mz
         ONOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699510495; x=1700115295;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKR0dJg1x5C8vmSRq/4juWRLHn7Fh5ZJAZMUTfWN+Vk=;
        b=P050xAbsyhod1ZvcGTRyApAmK8dloPfrUv7Op6Dwcw7OClwNJUfIa86HyreEqq5OhC
         4RxmuMx0dW5129k5CWnzG9EZWyRi2qyo2WUMWKVpvhqcpKT/dtHDdZ3cU3KszrqNub99
         pBvuFnDVg8xP/kmavsnqxZfn34OWAfuAtpHkIZul353j+FkltMjzwI6HdlNuQ9vmwcC9
         a3BB6XaZq7VU5gaECfmsHTSG+GT2nDKDD7HpXXnV9RvsbKQ0kzbXjMSfIAjBjQ9mp+Ss
         jMCcicbz/8XdrABaY6/xmmeRWPYQTuNNLbV4IoV+Wi6c8VCUbfm+eOBliNfyQgowuPEq
         t1XA==
X-Gm-Message-State: AOJu0YybYv1UWRK9x/0Gw7pawla50j17i/U9mpE7pcCE0YXrnFRL8uJz
        gYlOrKHtjUBq4FEkiYkxm6WJCg==
X-Google-Smtp-Source: AGHT+IF2YBPrA+TxtUhJZck5p3y+HBHnCqrT+9+9tiGmlO2fuNVpVmkXJ83THm7eb09L0mRw4dj17w==
X-Received: by 2002:a17:902:eb8f:b0:1cc:6906:c016 with SMTP id q15-20020a170902eb8f00b001cc6906c016mr4366753plg.9.1699510494965;
        Wed, 08 Nov 2023 22:14:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b001cc47c1c29csm2691069plh.84.2023.11.08.22.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 22:14:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r0yJX-00ACB6-03;
        Thu, 09 Nov 2023 17:14:51 +1100
Date:   Thu, 9 Nov 2023 17:14:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zirong Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZUx429/S9H07xLrA@dread.disaster.area>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 10:43:58AM +0800, Zirong Lang wrote:
> By changing the generic/047 as below, I got 2 dump files and 2 log files.
> Please check the attachment,
> and feel free to tell me if you need more.

Well, we've narrowed down to some weird recovery issue - the journal
is intact, recovery recovers the inode from the correct log item in
the journal, but the inode written to disk by recovery is corrupt.

What this points out is that we don't actually verify the inode we
recover is valid before writeback is queued, nor do we detect the
specific corruption being encountered in the verifier (i.e. non-zero
nblocks count when extent count is zero).

Can you add the patch below and see if/when the verifier fires on
the reproducer? I'm particularly interested to know where it fires -
in recovery before writeback, or when the root inode is re-read from
disk. It doesn't fire on x64-64....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: inode recovery does not validate the recovered inode

From: Dave Chinner <dchinner@redhat.com>

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 6b09e2bf2d74..f4c31c2b60d5 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -529,8 +530,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
