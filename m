Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C834C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 22:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD84206D9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 22:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FFqdVH0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGNWLk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 18:11:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726361AbgGNWLj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 18:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594764698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DfjinsVKPWUQwGbmNBSEeWBLtzAp/p89ilNObfVr4xE=;
        b=FFqdVH0+ntpEN5eOWVIbOrLT2At1cJHHJbdgokDDa7nMb2CuUdkNYVfbm2tzGYaNJJkdjR
        I6P1YL/DZi9okmEyIbO1ogLG7yVfkST08r/pNQYv8Grl3FR2wAvsskwDTvf7pbELOaAuOS
        C3cnginL+OMJ3tXY8YUWiYinAr/WsQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-1hk7BrQbNACAu8mJAjoOCA-1; Tue, 14 Jul 2020 18:11:36 -0400
X-MC-Unique: 1hk7BrQbNACAu8mJAjoOCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A62171080
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 22:11:35 +0000 (UTC)
Received: from Liberator.localdomain (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D1641992D
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 22:11:35 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: preserve inode versioning across remounts
Message-ID: <e8bfbbec-4cb9-0267-08eb-03580e2aedc6@redhat.com>
Date:   Tue, 14 Jul 2020 15:11:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The MS_I_VERSION mount flag is exposed via the VFS, as documented
in the mount manpages etc; see the iversion and noiversion mount
options in mount(8).

As a result, mount -o remount looks for this option in /proc/mounts
and will only send the I_VERSION flag back in during remount it it
is present.  Since it's not there, a remount will /remove/ the
I_VERSION flag at the vfs level, and iversion functionality is lost.

xfs v5 superblocks intend to always have i_version enabled; it is
set as a default at mount time, but is lost during remount for the
reasons above.

The generic fix would be to expose this documented option in 
/proc/mounts, but since that was rejected, fix it up again in the
xfs remount path instead, so that at least xfs won't suffer from
this misbehavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 379cbff438bc..9239985571af 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1714,6 +1714,10 @@ xfs_fc_reconfigure(
 	int			flags = fc->sb_flags;
 	int			error;
 
+	/* version 5 superblocks always support version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		fc->sb_flags |= SB_I_VERSION;
+
 	error = xfs_fc_validate_params(new_mp);
 	if (error)
 		return error;

