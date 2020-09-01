Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DB4C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA216206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="opW6oQmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgIAPuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbgIAPuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93927C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3EAi0+GCJdfy4Yuj9A4bm0t2HyIP/Tzn29GaY/tYyJs=; b=opW6oQmOv2Io/MPdwm99bUh7gl
        AwSZOo3WiHbp1jFz/4Iy3vjnL8ETPKCYUM/hId7hUO33dSuQf6jxWfF1hSYjLt35NPSh+HxoVrxg7
        +k0vaaQjTQUwk1gQlh8VSbuE63olrk32Nqb2ns3Dd6IX9pcotGpHWyumTNYBI7adeDFoG43Mqd0Z2
        V7pWeJZpYX9cjUl91f0MINOiZn3yTBAsdymozpxLf+awqP4YD+7v01gkOZrQ/DWCP2RBwE4YjOfK8
        zqioJSthW9TnOFyQ+vs/I3TZN2LdBltZrvRN540/OB9XXq2GMJdUAnb7+7m+FDLHsnpG5tBFZll33
        aEh8iEpw==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8Y7-0003kt-Iw
        for linux-xfs@vger.kernel.org; Tue, 01 Sep 2020 15:50:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: tidy up the buffer cache implementation v3
Date:   Tue,  1 Sep 2020 17:50:03 +0200
Message-Id: <20200901155018.2524-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series ties up some old and new bits in the XFS buffer
cache, and consolidates a fair amount of code.

Changes since v1:
 - don't pass buf ops to _xfs_buf_read
 - add two more cleanup patches

Changes since v1:
 - fix read flag propagation in _xfs_buf_read
 - improve a few commit messages and comments

Diffstat:
 libxfs/xfs_log_recover.h |    1 
 libxfs/xfs_sb.c          |    4 
 libxfs/xfs_trans_inode.c |    6 -
 xfs_buf.c                |  208 +++++++++++++++++++++++++++++++------
 xfs_buf.h                |   17 ---
 xfs_buf_item.c           |  264 +----------------------------------------------
 xfs_buf_item.h           |   12 ++
 xfs_buf_item_recover.c   |    2 
 xfs_dquot.c              |   14 ++
 xfs_inode.c              |    6 -
 xfs_inode_item.c         |   12 +-
 xfs_inode_item.h         |    1 
 xfs_log_recover.c        |   58 ++--------
 xfs_mount.c              |   17 ---
 xfs_mount.h              |    1 
 xfs_quota.h              |    8 -
 xfs_trace.h              |    2 
 xfs_trans.c              |    2 
 xfs_trans.h              |    2 
 xfs_trans_buf.c          |   46 ++------
 20 files changed, 261 insertions(+), 422 deletions(-)
