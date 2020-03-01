Return-Path: <SRS0=l9EO=4S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C59DC3F2CD
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 16:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9F5222C4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 16:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUb78Yz9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgCAQBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 11:01:22 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46724 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCAQBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 11:01:22 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so3172357pll.13;
        Sun, 01 Mar 2020 08:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X1Qf2OCqIm6CkhKHMaHnxcWDcAuNMKj3Zf+gtr/sOM4=;
        b=XUb78Yz99k6H5C8iutAZ78+L9AZctNjA04pJWPsRFo2y1FLtEHjPfK9A7ETbegqoL5
         QjAeFIJq8rA/1llRtEe5SsQ4J6MtakObPwEDhBQJbF58XbW8BZVHSlFGPFzqDszQkJB2
         0PomUrTiMVJszztWDeJIIgBqkTAoDvNs7nWKxYM6Gq3bfWXBePVOXgXbQaCeBpQQyE7z
         X5u2qxtF8jK+WBrq653OkURmizACmZHqo/xAXDvpSFeEhUy1CZo6D3tx8cRNt5//FbPO
         s9LtduW9OYbpKmnffkwGcNgYG4zFCDHoTUsAUvGqvF2j331Q7RQva0Qs09rRG1jevk19
         uZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X1Qf2OCqIm6CkhKHMaHnxcWDcAuNMKj3Zf+gtr/sOM4=;
        b=KbcoaI8bPGISfne6NJgLdjgMMPAkyMOpafxolKZnZmLtDuE2QezbzXoP3vB5VmcO1P
         uhBIvNQLv26evRgjYKYHQb76cJ61LA8wGMCAIjEuWrT5036gIR43tWFrjJ36FFQw1FRq
         1C+eoyRkEdmvXWtbxSNb4aeQjLcg3410KkO9vmQvEry4wu/9rfzkmv9F/hbeO1JRvi3N
         zpNrPzbO8lb0pXWm6SBYnL9ZGX7PH/QwQL6UBhRW0SgDvQFZUXGxqZNIVNjCEnU/63fj
         vicG/DhaveCX3+9iH+lsmbOib7C+9WInpiy3smgLVi6bUoyt8Qz9Q5VyTvzpXeU/f6zT
         YCog==
X-Gm-Message-State: APjAAAXtxzOgnBPpwhUYlM7p+nos9BmnHSq/KizTWuRDjw5thsmaLEsA
        MmP8M+7wITvwQDCYe0Rh6EE=
X-Google-Smtp-Source: APXvYqxyy9szxcyDDhWONZvcGl0amPVM6i9Jiovv1quOLFTEITLGzgP9nvqb1WAhEFZvZ9CKdBW9AA==
X-Received: by 2002:a17:90a:db0f:: with SMTP id g15mr15518125pjv.40.1583078481036;
        Sun, 01 Mar 2020 08:01:21 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id u4sm17142956pgu.75.2020.03.01.08.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:01:20 -0800 (PST)
Date:   Mon, 2 Mar 2020 00:00:52 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20200301150857.GM3840@desktop>
References: <158086093704.1990427.12233429264118879844.stgit@magnolia>
 <158086094326.1990427.7286270181411420127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086094326.1990427.7286270181411420127.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:02:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add new helpers to dmerror to provide for marking selected ranges
> totally bad -- both reads and writes will fail.  Create a new test for
> xfs_scrub to check that it reports media errors correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

So is this expected to fail with latest xfsprogs for-next branch? I got
failures like:

 QA output created by 515
  Scrub for injected media error
 -Corruption: disk offset NNN: media error in inodes. (!)
 -SCRATCH_MNT: Unmount and run xfs_repair.
  Scrub after removing injected media error

Thanks,
Eryu
