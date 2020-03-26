Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58109C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14CA52073E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmWEsz0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgCZNRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:17:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59098 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbgCZNRI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 09:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585228627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b0FMAX0eEGRWuV1ZpxO0xIKXeEP2ZqzyUc/gr3tw+zg=;
        b=CmWEsz0P//Kz8nqVF3UFV8BO3Hv2winQxyXb+4Ihtai+SkR5JXkVB454xrGxVmRSlgfvU7
        B4UywRBKqAATUxiHJXFMrpDZTp0UbXbpUCtWzeO8jwNdyCy9G3xJ4JA2bixpur57NKm9sp
        9Q30HUc1fK4NEy+iP/oA8TKWC8Cfo0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41--yGCwaKuP_yThI5a58gKSA-1; Thu, 26 Mar 2020 09:17:05 -0400
X-MC-Unique: -yGCwaKuP_yThI5a58gKSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C20A107ACC4
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:04 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EAB810002A9
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: a couple AIL pushing trylock fixes
Date:   Thu, 26 Mar 2020 09:17:01 -0400
Message-Id: <20200326131703.23246-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a couple more small fixes that fell out of the auto relog work.
The dquot issue is actually a deadlock vector if we randomly relog dquot
buffers (which is only done for test purposes), but I figure we should
handle dquot buffers similar to how inode buffers are handled. Thoughts,
reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: trylock underlying buffer on dquot flush
  xfs: return locked status of inode buffer on xfsaild push

 fs/xfs/xfs_dquot.c      |  6 +++---
 fs/xfs/xfs_dquot_item.c |  3 ++-
 fs/xfs/xfs_inode_item.c |  3 ++-
 fs/xfs/xfs_qm.c         | 14 +++++++++-----
 4 files changed, 16 insertions(+), 10 deletions(-)

--=20
2.21.1

