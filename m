Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1427C77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 06:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbjEaGmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 02:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjEaGmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 02:42:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ACD99
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685515326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJL/w4UwwgjzVijVeDcfFBV89FGjEVBP8YLSDjcGqBM=;
        b=QQeAWZzvcWvPII1CqU5L1gngTqDrd2zdAAiaUd218QysKZMeBRBjKjPsJUDI2Arhe3U2Sn
        2QQO/l6CTx2wm7ErMTLf1zkWSt5Vyq6pZ9DxzEeyhJQyjCOpIU2dnFb2kYLusIu8RjgDUB
        haQwK5ykpUiQbxA7q0uJVXqXxq+3GQg=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-hUnGILiKP8We-3-laOZtZw-1; Wed, 31 May 2023 02:42:04 -0400
X-MC-Unique: hUnGILiKP8We-3-laOZtZw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-528ab7097afso4715435a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685515323; x=1688107323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJL/w4UwwgjzVijVeDcfFBV89FGjEVBP8YLSDjcGqBM=;
        b=iRkp5fsNllAgMur0SM5ib0xIsKMcqU3wdyp+nNv0bZRr2vHBq2iQsk1MZ4gd3bKP8I
         LW2dlkEy5FGyn2zUpVn0XUysYJbquDRqip1nStahBEcIx+NXYGupXOmKGkL59diPfdJu
         dLZ4Hv/Wxb5HQOKF8lBlvMKGozysHQ2XibxvKMmT8JU+eb6hNuqGbbd5kJNz30i40Y9Z
         Ji0An6VPdZNEbghJOK/kKYWVWwcri8/D5gCLnZOgWdLrXHvJzJNUxfhrsvGa28X9yulM
         UT5QqvGCJ0IUhuc2Q2uU2b5wq+/n/ge74kCIb7KPjrwV68Pg+o3yEXb0FE+2D+9k+kxF
         1u1w==
X-Gm-Message-State: AC+VfDycyCS4/g6DZ3rKj+lxmwF1QWEA3ONk1Zzikl6d6fm4kQ1qT1GO
        KymQ4FY22D/Fdb0B+qN9l0McP4rluReApmWzDTs25Uc1Wk2QXIyR/0GvAwMU2S5xpNApfTqi+yh
        FnsdQW3tOQZlpB+sC0ocj6gvoXhFB2nIcrCnZOo6XmnbHiqhW7HPZrdrVBOoS2BElti5udjI58H
        vvf63H
X-Received: by 2002:a05:6a20:158b:b0:10b:6e18:b698 with SMTP id h11-20020a056a20158b00b0010b6e18b698mr5028950pzj.49.1685515323222;
        Tue, 30 May 2023 23:42:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/Xdc7oDXolRxxQl1VRyPgacYRY9yBDoaDrh2ERo6+eygSL1fHMIsvaDYhgST2eJ3/YAy2pg==
X-Received: by 2002:a05:6a20:158b:b0:10b:6e18:b698 with SMTP id h11-20020a056a20158b00b0010b6e18b698mr5028931pzj.49.1685515322725;
        Tue, 30 May 2023 23:42:02 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id x11-20020a63cc0b000000b0053f2037d639sm494171pgf.81.2023.05.30.23.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:42:02 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfs_repair: always print an estimate when reporting progress
Date:   Wed, 31 May 2023 16:41:43 +1000
Message-Id: <20230531064143.1737591-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230531064024.1737213-1-ddouwsma@redhat.com>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If xfs_repair completes the work for a given phase while allocation
groups are still being processed the estimated time may be zero, when
this occures xfs_repair prints an incomplete string.

 # xfs_repair -o ag_stride=4 -t 1 /dev/sdc
 Phase 1 - find and verify superblock...
         - reporting progress in intervals of 1 second
 Phase 2 - using internal log
         - zero log...
         - 20:52:11: zeroing log - 0 of 2560 blocks done
         - 20:52:12: zeroing log - 2560 of 2560 blocks done
         - scan filesystem freespace and inode maps...
         - 20:52:12: scanning filesystem freespace - 3 of 4 allocation groups done
         - 20:52:13: scanning filesystem freespace - 4 of 4 allocation groups done
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - 20:52:13: scanning agi unlinked lists - 4 of 4 allocation groups done
         - process known inodes and perform inode discovery...
         - agno = 0
         - 20:52:13: process known inodes and inode discovery - 3456 of 40448 inodes done
         - 20:52:14: process known inodes and inode discovery - 3456 of 40448 inodes done
         - 20:52:14: Phase 3: elapsed time 1 second - processed 207360 inodes per minute
         - 20:52:14: Phase 3: 8% done - estimated remaining time 10 seconds
         - 20:52:15: process known inodes and inode discovery - 3456 of 40448 inodes done
         - 20:52:15: Phase 3: elapsed time 2 seconds - processed 103680 inodes per minute
         - 20:52:15: Phase 3: 8% done - estimated remaining time 21 seconds
         - 20:52:16: process known inodes and inode discovery - 33088 of 40448 inodes done
         - 20:52:16: Phase 3: elapsed time 3 seconds - processed 661760 inodes per minute
         - 20:52:16: Phase 3: 81% done - estimated remaining time
         - agno = 1
 	...

Make this more consistent by printing 'estimated remaining time 0
seconds' if there is a 0 estimate.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 repair/progress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/repair/progress.c b/repair/progress.c
index f6c4d988..9fb6e3eb 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -501,6 +501,8 @@ duration(int length, char *buf)
 			strcat(buf, _(", "));
 		strcat(buf, temp);
 	}
+	if (!(weeks|days|hours|minutes|seconds))
+		sprintf(buf, _("0 seconds"));
 
 	return(buf);
 }
-- 
2.39.3

