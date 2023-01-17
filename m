Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62617C63797
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Jan 2023 10:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbjAQK4a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 05:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbjAQK4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 05:56:24 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B645021A35
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 02:56:16 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d2so10025539wrp.8
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 02:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ZoLTzsNMnqfxZHCWczPZ8j5OvqRTO93Lt1uSPLxwBs=;
        b=ZGCU0toe2A2/SMVvHCvTDcnijgnjLx/lvzFluCBjb1aIFJbTnYIt1qAq9LmFNtU0+F
         vAdxPoe1yXyHen8ZfMy30Z8eExtcia+aoXxEDdo5hrGpcgCDRUZ36IBidiwU/+Q6Ehuw
         GyQBke0QiwHdHIyQ9WED/acKgSXW5ffBBzq7Bzww4s0Kr3z5Nktznc6bk+OUYwzmyFXY
         cAHh3ILAw/iMTUKopp8tF29Dj2fdLJtGZxku8LWlyHFionP3VGvXMVqR9lHOI2Y3tbjF
         sn5Og66uGYewMPiRd/rKGs1Lj3edN4jj5B9hbhMop12NHmbVVTyMLAqszChtiHoo+uiW
         Dr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZoLTzsNMnqfxZHCWczPZ8j5OvqRTO93Lt1uSPLxwBs=;
        b=GYegOK34r1TjKEupZdNr0pvOqXmVAFuqGAobyjDHuSu5HF/Od5qOQefOiElV8QLJXY
         iFZwNoK/6g4pMu8YRPTSNADJjwHlwxv/XCjBqX0p8l36roXZdgJYQ5jspZuk8A429rJ7
         4929sDoH8rTYIJFwX0238VyXPb4DVPuFCZNvL5ZXkFyfPqpwpiDCR3LQ7hX6ls7j8uuw
         w2wODYXc/VpM/fgxmkBKAjwSNo7UzBew8jhnsXblcLfrZR2/doV49C3F1ZJvup7m2De+
         gc3seox5g8QgS0kiG5mOeioAR9FjDS1J8ysCzdtsX4nHbnN/3k14iXKZfn3I89io7QpM
         9rWA==
X-Gm-Message-State: AFqh2kowdIwaOkQScMplQ2aLfrBXcMtUn0TD9G60Qd/9xfLnECn+486V
        nGQWKRvnjOcJozgGyo9kcbg=
X-Google-Smtp-Source: AMrXdXuoRNZUS8FuCApaGzNSufRRowFRTToQAa4x+ezBDSi3c6qRo2Qe2Q4oTemUvlZu8hie5q9Shg==
X-Received: by 2002:adf:cd81:0:b0:2bd:e0e8:694f with SMTP id q1-20020adfcd81000000b002bde0e8694fmr2425428wrj.32.1673952975297;
        Tue, 17 Jan 2023 02:56:15 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e7-20020a056000120700b00241dd5de644sm28509989wrx.97.2023.01.17.02.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:56:14 -0800 (PST)
Date:   Tue, 17 Jan 2023 13:56:11 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: allow setting and clearing of log incompat feature
 flags
Message-ID: <Y8Z+y9j2nT6bQ0Hz@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch 908ce71e54f8: "xfs: allow setting and clearing of log
incompat feature flags" from Aug 8, 2021, leads to the following
Smatch static checker warning:

	fs/xfs/xfs_mount.c:1315 xfs_add_incompat_log_feature()
	warn: missing error code 'error'

fs/xfs/xfs_mount.c
    1280 int
    1281 xfs_add_incompat_log_feature(
    1282         struct xfs_mount        *mp,
    1283         uint32_t                feature)
    1284 {
    1285         struct xfs_dsb                *dsb;
    1286         int                        error;
    1287 
    1288         ASSERT(hweight32(feature) == 1);
    1289         ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
    1290 
    1291         /*
    1292          * Force the log to disk and kick the background AIL thread to reduce
    1293          * the chances that the bwrite will stall waiting for the AIL to unpin
    1294          * the primary superblock buffer.  This isn't a data integrity
    1295          * operation, so we don't need a synchronous push.
    1296          */
    1297         error = xfs_log_force(mp, XFS_LOG_SYNC);
    1298         if (error)
    1299                 return error;
    1300         xfs_ail_push_all(mp->m_ail);
    1301 
    1302         /*
    1303          * Lock the primary superblock buffer to serialize all callers that
    1304          * are trying to set feature bits.
    1305          */
    1306         xfs_buf_lock(mp->m_sb_bp);
    1307         xfs_buf_hold(mp->m_sb_bp);
    1308 
    1309         if (xfs_is_shutdown(mp)) {
    1310                 error = -EIO;
    1311                 goto rele;
    1312         }
    1313 
    1314         if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
--> 1315                 goto rele;
                         ^^^^^^^^^
It's not clear to me, why this old code is suddenly showing up as a new
warning...  But it does feel like it should be an error path.

    1316 
    1317         /*
    1318          * Write the primary superblock to disk immediately, because we need
    1319          * the log_incompat bit to be set in the primary super now to protect
    1320          * the log items that we're going to commit later.
    1321          */
    1322         dsb = mp->m_sb_bp->b_addr;
    1323         xfs_sb_to_disk(dsb, &mp->m_sb);
    1324         dsb->sb_features_log_incompat |= cpu_to_be32(feature);
    1325         error = xfs_bwrite(mp->m_sb_bp);
    1326         if (error)
    1327                 goto shutdown;
    1328 
    1329         /*
    1330          * Add the feature bits to the incore superblock before we unlock the
    1331          * buffer.
    1332          */
    1333         xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
    1334         xfs_buf_relse(mp->m_sb_bp);
    1335 
    1336         /* Log the superblock to disk. */
    1337         return xfs_sync_sb(mp, false);
    1338 shutdown:
    1339         xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
    1340 rele:
    1341         xfs_buf_relse(mp->m_sb_bp);
    1342         return error;
    1343 }

regards,
dan carpenter
