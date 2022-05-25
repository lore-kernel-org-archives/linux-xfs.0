Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB9AC43219
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 11:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiEYLRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 07:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiEYLRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 07:17:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD9A6FA1D;
        Wed, 25 May 2022 04:17:36 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bg25so12265096wmb.4;
        Wed, 25 May 2022 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qWgwOMIZoZnoqcx4izZwNBl2nOWFWpcJl0NLoI3n8I=;
        b=AxzS0DUqbBsKXgkc1qHfc14RnK86er5uXvG+I1R3AvGenFiuZ49NYv3W1I6FN3+qQY
         3uh4io3EIncMnmbl8vs0whGNz8UMKtVhIQ7f9hyxIDtJF+1A7Yb0QObjL1YNwd+D7CsM
         fjbSyYIFSer4oXEq3J2sU8ECI+d2tt7bbDp5wAMv7c1R22kFTCjNLxWKfDK7iMfjs3XC
         eaqxqkyl0TZHfM09rOs5c8fcZYVrGsaSZDa+Uh087apJp3/2f3qm5//Q/gXuzcfJgK4q
         ew/LdMVRNlhZy7rPSvwUsjDQ+sRjttOnGDU7Z8O744F3nlf27rxmSk/fgMioT4UoBbRD
         uDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qWgwOMIZoZnoqcx4izZwNBl2nOWFWpcJl0NLoI3n8I=;
        b=S9p0uAhuY7EQfzQA/CHBci3lLuxHGHr1rTocsls6rpoIDeQe8CBrPpPq+E2ruEgW30
         CLHCyno4EXDM7TFBXtWO1q4CBi5a3NTiPH0R7L8IXZNwXSZcrGfG21vqlhcLoEcNXxhy
         BFYGFRQe3pyLhFfUIzPqN8jpNqj6y71eoI7aPqG3XJEVmNdv0JQcqR6O8Ib/I+1nLgeW
         4evIphYsR3+hiXbzUQW0HsPYIYr1HrVRH904hjq45cUAjoQ0QW3h/wBCNAy7GjjCrnyB
         us7fQq88YjeVP68GP7PY+0bstu/clfyHE6VJQmzUoYYJpZVOmRPzl7Xd0RWPCYK5Q6w0
         EEDw==
X-Gm-Message-State: AOAM530/HtFE/hJqPmoFcbfcFSDDUxmJGZdfoG+bL1OducqmasFxhTdn
        i/9ELMJO71YXkrZvdHiaYxI=
X-Google-Smtp-Source: ABdhPJz7dE2sbVIYT7ZPTv9s7MHnpNRFZj1WPPTH+YG5h59Xfv0QYhIKOErQkH97nOCbUipWwQl7ng==
X-Received: by 2002:a7b:c928:0:b0:397:65f3:67b6 with SMTP id h8-20020a7bc928000000b0039765f367b6mr4224736wml.45.1653477454574;
        Wed, 25 May 2022 04:17:34 -0700 (PDT)
Received: from localhost.localdomain ([5.29.19.200])
        by smtp.gmail.com with ESMTPSA id e12-20020a056000178c00b0020c5253d8besm2059904wrg.10.2022.05.25.04.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:17:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATH 5.10 1/4] xfs: detect overflows in bmbt records
Date:   Wed, 25 May 2022 14:17:12 +0300
Message-Id: <20220525111715.2769700-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525111715.2769700-1-amir73il@gmail.com>
References: <20220525111715.2769700-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit acf104c2331c1ba2a667e65dd36139d1555b1432 upstream.

Detect file block mappings with a blockcount that's either so large that
integer overflows occur or are zero, because neither are valid in the
filesystem.  Worse yet, attempting directory modifications causes the
iext code to trip over the bmbt key handling and takes the filesystem
down.  We can fix most of this by preventing the bad metadata from
entering the incore structures in the first place.

Found by setting blockcount=0 in a directory data fork mapping and
watching the fireworks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d9a692484eae..de9c27ef68d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6229,6 +6229,11 @@ xfs_bmap_validate_extent(
 	xfs_fsblock_t		endfsb;
 	bool			isrt;
 
+	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
+		return __this_address;
+	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
+		return __this_address;
+
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt && whichfork == XFS_DATA_FORK) {
-- 
2.25.1

