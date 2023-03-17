Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA095C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCQLIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQLI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:28 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F00224BD2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:27 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so4861834wmb.5
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PP8hrBv8Zg8teY5qFhszUF4+5kq7WXrNzkvw8H5L9wU=;
        b=bu5w/YmNuIx1H4ujZw3P1vYHrvRZgL4eLh9PXVQDJTWsn5gV0UgzrT3XecgsHE2Lu2
         an0PTPfwzmfkVe92w9Qht4f9XmtRbdaCzX0euTmxEBDXsBIA89XlU0AjWXHEgR31yNo8
         u6eYZMUXdC8MTUMCYixfeNkUmO4WPmiTuhC9MGw6rbk/Fe5CVma11jlORaVjOkhg+ENo
         l5+rr/yXJg9uyNotgaa4cs1OMHIttEfKNnCLCmU1jg/Z7by+Ufj1LAiBjdpgBphwLZmr
         Is6Zj36awIONThvPU2330rVCWu7E0X/4K8zFUPhHXChr1SmIBabCCgnhfF64IkL8ipii
         K7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PP8hrBv8Zg8teY5qFhszUF4+5kq7WXrNzkvw8H5L9wU=;
        b=M6XJ4COfk3iX+ynCBwGUkPFGNwEWMK3unE8+YdsI1VwyuGgdITzU7oPYjcmawTLmC0
         GjgWbHiwSCo/8hJr45pQDHYbVuyb/9o0kLl8xtrbFWB5jCFlmQ9xYuZr9qn7+cIUQxoV
         0mJFVI0PP2bKEw+cyiq/8egtKArSw1G+DHj9SFYaKWHc/8aWyWSZUdU9/WJnhWnAZW2e
         G+JnuGHYmlePOPfGnSyrKsDe0hJ3AtmSq8bRXI2EjjGriVUmk+j0yg2S7CyObAd3nlWw
         Vchpxt7EmbAppgCDL4WMzx/PBfeD0WloeRHSVVZqUkH3FDTXi6tUfGnLvUI2bqHh3yHe
         wirQ==
X-Gm-Message-State: AO0yUKUER9HhMcfpVYuHd5CoXQeDcfu4Lw6cY51JnPERxJd0Ho8VUZLj
        HmxIgOXwkRhiWscQJnxmf8lSkVuC/L8=
X-Google-Smtp-Source: AK7set/guxZaQEGg6Upy8WBnUpNfPf10OeLP9So6oI0RckSbPeAR3dpyxOJS2jFibZkz7KxgyNzyxQ==
X-Received: by 2002:a1c:7c01:0:b0:3e5:4fb9:ea60 with SMTP id x1-20020a1c7c01000000b003e54fb9ea60mr1992941wmc.9.1679051305388;
        Fri, 17 Mar 2023 04:08:25 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 01/15] xfs: don't assert fail on perag references on teardown
Date:   Fri, 17 Mar 2023 13:08:03 +0200
Message-Id: <20230317110817.1226324-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea upstream.

[backport for 5.10.y, prior to perag refactoring in v5.14]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a2a5a0fd9233..402cf828cc91 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,7 +126,6 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -145,7 +144,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
-- 
2.34.1

