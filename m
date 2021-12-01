Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC83FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 05:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhLAFVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 00:21:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231666AbhLAFVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 00:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638335880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3p4Np10bdHOt9AWFihrcmkJPB43qjNBTDaMtU3l9OlM=;
        b=YOUC7s2bE7J3yALaKtMlS24m32CBEECH/QCN86I0qTDAM7hc+HFPMlZVDuwiGspxCCvLct
        5HcoTthZtbAKBm+nogkWGXU6wR6ofyBGep3zHJoo33WHJW52wsIW4eZ9T9Pi8SN2iE+E+8
        EMJ9FAK/EBxqpHHp5ONSDc310N9k7Es=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-E0SnLGdaP1KALlkIjTsQzQ-1; Wed, 01 Dec 2021 00:17:59 -0500
X-MC-Unique: E0SnLGdaP1KALlkIjTsQzQ-1
Received: by mail-il1-f199.google.com with SMTP id e1-20020a056e020b2100b00299addac2a4so31310324ilu.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Nov 2021 21:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:subject:cc:content-transfer-encoding;
        bh=3p4Np10bdHOt9AWFihrcmkJPB43qjNBTDaMtU3l9OlM=;
        b=pfWmO9YOxFWsQgodJgNZJ9xzOnaQjqj7fkVBdZ0+OKHZ33fOyHT2yjf//SCaktaAix
         MreU5V5zsgWa5UShQgs98qpKvayi1gpM0G0JXhwtDOOQXCGouotXw7OetxelQVAFulbF
         d699qG7i0DZNE6xDXBcwEioyrazly+2D3Qc0gHHlObXrFjIjyyl4KdMAepcCwjlzMm7m
         nPZJQjHev9iCyGr6IsBziEg4vaf/s0FWtndk0O7c4wbAK083NQ1dbLS9nHswgdYbofyr
         xrlyOw2PQXWarVKRtzlPXTmPtwxCqdlEK1pA5CVfEWY7sblSLsFuQv9aUegY5FtFDrwj
         MLTA==
X-Gm-Message-State: AOAM532sW64YTgUgc5wzkzhYeQDPzrrmrb9iwq7uALHyTUwL4OHogHgp
        Rqi5erxb9zp0/2W7SkBmMGRoeybqk3Da7VSu/e/7qyKGxHcEU0UHyMbptDGwl4+u+r6dqJ53um6
        oD13zH1ts0EPTH2yDh4gqbFs9+1qaGIlE5zd5ZfFReB+yNH+QdSrz9Ynhnfz6xF3JGYggjDos
X-Received: by 2002:a05:6e02:160d:: with SMTP id t13mr4944354ilu.306.1638335878202;
        Tue, 30 Nov 2021 21:17:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8CfTkdCDOLWD/tFVJDVhLZ7IW44TE3SI2idQUlglrW5g6ubvosM2BP82kiYMiWJI0OMoFTA==
X-Received: by 2002:a05:6e02:160d:: with SMTP id t13mr4944344ilu.306.1638335877981;
        Tue, 30 Nov 2021 21:17:57 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id m6sm13288820ilh.32.2021.11.30.21.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 21:17:57 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bbb4b6d5-744c-11c8-fcda-62777e8d7b19@redhat.com>
Date:   Tue, 30 Nov 2021 23:17:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: remove incorrect ASSERT in xfs_rename
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This ASSERT in xfs_rename is a) incorrect, because
(RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
b) unnecessary, because actual invalid flag combinations are already
handled at the vfs level in do_renameat2() before we get called.
So, remove it.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64b9bf3..6771f35 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3122,7 +3122,6 @@ struct xfs_iunlink {
  	 * appropriately.
  	 */
  	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
  		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
  		if (error)
  			return error;

