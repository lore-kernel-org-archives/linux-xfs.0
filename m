Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F1FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E50923975
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhAHTLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 14:11:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbhAHTLh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 14:11:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610133011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zXQkiOchNww26NhKsPu4PghNCneNnV48n8O5SpGAHe4=;
        b=GCMc5aZ3SifNqlCBT0+p2lRzuLOaVJqxDNx3SyOQgULQjCS51YDs1cX7rVE64Zx8TaKYZs
        S5q/6/DcjTUF8h1yry61KU/xvgyqikFS4BOT56ETJp5YhOuS0u/pzvR6QaqMqT4MLDGbnX
        TpNZi4fT0YolFzzfUCvoYTR7lXUknYc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-AP110SVIP3uAdG7IzIaLBA-1; Fri, 08 Jan 2021 14:10:09 -0500
X-MC-Unique: AP110SVIP3uAdG7IzIaLBA-1
Received: by mail-pl1-f198.google.com with SMTP id bg11so6908221plb.16
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 11:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXQkiOchNww26NhKsPu4PghNCneNnV48n8O5SpGAHe4=;
        b=NF+Aru7et5cpfwB9ApNgBBHSqhsls1gzMC9J10L9TcQdETX4QdqwMVsqbBjlTvY6q5
         E7iN3V/IJfZJn0WC1MicmmPv2xh0ZcAzZCYXeRdIi2tMYzd34Lg7YFRqKQuIKqJ4KXnk
         D04lM55XdXTYyM/LGnco158L5X72KreH6R+UVthGDBBTIRHkRyYKVFv1WiJ1pDq1MqgR
         77QK/ka6NxE2fxGGhUf5YCFYI3ZqvjVwu9sTsH0He2PJCwUXQh0raU2wc7jZpMEfOcvs
         P0CRhkmGWzPfDc9Cs8dT7gl8NODjZRmPPNehWB263RAzMDGLdxry+aDQgDssa3oCtMZg
         yDMw==
X-Gm-Message-State: AOAM532mWn2yxofMcNJDNn1+XbXdc1krvtMeiyJiMolCR/UTtdPYrciI
        jabCJ4BNldDaJSRbocgUw/vVem96cE1NodZ5CP8PrlsFE9UwgriRs5Qkg+UsUyEJGeyozjgyvsf
        hYK/EOg8dx4IPHYCyzP3nMyJvBvqZAo+2+3dnKKDy9lh+Cz6R+ph6oxXKI6RgX9tDfM5MacwJFA
        ==
X-Received: by 2002:a17:90a:d801:: with SMTP id a1mr5312269pjv.90.1610133008433;
        Fri, 08 Jan 2021 11:10:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkRB9N+dzGmUs5bfIT0XjjybWgJ5mcxOwOvBQYYU1hCzET3/pJRYQeeSFonaq9e425g+ewvA==
X-Received: by 2002:a17:90a:d801:: with SMTP id a1mr5312241pjv.90.1610133008126;
        Fri, 08 Jan 2021 11:10:08 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h15sm9761824pfo.71.2021.01.08.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 11:10:07 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 0/4] xfs: support shrinking free space in the last AG
Date:   Sat,  9 Jan 2021 03:09:15 +0800
Message-Id: <20210108190919.623672-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is version 3 of
https://lore.kernel.org/r/20201028231353.640969-1-hsiangkao@redhat.com

I resend to make sure if the shrinking upstreaming development can be
done in an incremental progress.

Days ago I also made a shrinking the entire AGs prototype at,
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/shrink2
which is still WIP / rather incomplete, yet any directions/suggestions
about that would be greatly helpful to me as well.

This mainly focuses on the previous review from Brian. Mainly to seperate
the previous patch into a patchset. I'm not sure if it looks good this
time (yet I think [PATCH 4/4] is simple enough to address the shrinking
functionality) so post it again to reconfirm that.... and also to confirm
if we need to use #ifdef DEBUG to wrap up the entrance (Although my
humble opinion is that most end users don't build with DEBUG enabled....)

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Changes since v2:
 - [PATCH 4/4] fix a bug about "if (extend && ...)" (Brian);
 - split out the original patch (Brian, Eric, Darrick).

Thanks,
Gao Xiang

Gao Xiang (4):
  xfs: rename `new' to `delta' in xfs_growfs_data_private()
  xfs: get rid of xfs_growfs_{data,log}_t
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: support shrinking unused space in the last AG

 fs/xfs/libxfs/xfs_ag.c |  72 ++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   2 +
 fs/xfs/libxfs/xfs_fs.h |   4 +-
 fs/xfs/xfs_fsops.c     | 161 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_fsops.h     |   4 +-
 fs/xfs/xfs_ioctl.c     |   4 +-
 fs/xfs/xfs_trans.c     |   1 -
 7 files changed, 185 insertions(+), 63 deletions(-)

-- 
2.27.0

