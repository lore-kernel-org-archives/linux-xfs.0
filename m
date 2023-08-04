Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01FEC04FE2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 16:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjHDQZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 12:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjHDQZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 12:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E024749CB;
        Fri,  4 Aug 2023 09:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E414620A3;
        Fri,  4 Aug 2023 16:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE123C433C7;
        Fri,  4 Aug 2023 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691166315;
        bh=6HyVwGgg0hQ242V38jdl3lmrTJewR5sqxSV03aSXNhc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fyuO7nqJ5hZY7rxrVI9zOn1iMGi5KG7nOhmgYjM10ZFd5s/6tkNzzdFdcefYp7W1r
         d/zKiV+FA0J8nhLZPD4Mhki5v5CdHYvxlAmk9vo4B3oktiNt+Fh0UjPByd9e7V9SYF
         YWoVIeT3P704cSuoWh+aZhZW/Zy9bORv8QLNTmHc0MY5lzxga41tw1dl0VpQJtOjNH
         7j84woyrctUxuGNSdqkW2TQXVwhFAem6lPV/2dzsi060pIBDgdA+xOHMK0dYCDer4I
         cFrrVm7I2Ehg17sAbAo17MsDAbO7iq/PIDkfoM5/jmj6i8/OMrjx+2MLBMVUzU8XBU
         veo5qdlj9Qnuw==
Subject: [PATCH 3/3] MAINTAINERS: add Chandan Babu as XFS release manager
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, cem@kernel.org, sandeen@sandeen.net,
        chandan.babu@oracle.com, amir73il@gmail.com,
        leah.rumancik@gmail.com, zlang@kernel.org, fstests@vger.kernel.org,
        willy@infradead.org, shirley.ma@oracle.com, konrad.wilk@oracle.com
Date:   Fri, 04 Aug 2023 09:25:15 -0700
Message-ID: <169116631533.3243794.12031505140377581673.stgit@frogsfrogsfrogs>
In-Reply-To: <169116629797.3243794.7024231508559123519.stgit@frogsfrogsfrogs>
References: <169116629797.3243794.7024231508559123519.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I nominate Chandan Babu to take over release management for the upstream
kernel's XFS code.  He has had sufficient experience merging backports
to the 5.4 LTS tree, testing them, and sending them on to the LTS leads.

NOTE: I am /not/ nominating Chandan to take on any of the other roles I
have just dropped.  Bug triager, testing lead, and community manager are
open positions that need to be filled.  There's also maintainer for
supported LTS releases (4.14, 4.19, 5.10...).

Cc: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Chandan Babu R <chandan.babu@oracle.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)


diff --git a/MAINTAINERS b/MAINTAINERS
index d6b82aac42a4..f059e7c30f90 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23324,6 +23324,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
+M:	Chandan Babu R <chandan.babu@oracle.com>
 R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported

