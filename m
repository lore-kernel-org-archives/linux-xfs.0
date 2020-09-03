Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668ACC433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28489206EB
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZduOFvGC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgICOag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:30:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728878AbgICO2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599143326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K7Y9S7fpx+ab7HZemyoDghcR2mnt0SrOrT0Zbdctn6s=;
        b=ZduOFvGCPwP3P3klAvZ/ChUcnIy7Daua/ZaRICbbRLcV1m8RaJlRx38xa6Wfe+OtQJHkJH
        PS+qEU3TjDxfhNILmWfveT9d0nuNhvy7h2GUfcbIFoF7ivgCs8LSnmgEcvTNL9UaLisbi8
        853/Zc5I3OCu6qXoXfpZmigTYSJyXgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-p9F4pGJDMhWYEm4kIX8Wog-1; Thu, 03 Sep 2020 10:28:44 -0400
X-MC-Unique: p9F4pGJDMhWYEm4kIX8Wog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B805D801AEA
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:43 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F5A010013D9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:42 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] Clean up xfs_attr_sf_entry
Date:   Thu,  3 Sep 2020 16:28:35 +0200
Message-Id: <20200903142839.72710-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

This is the V3 version of this series, containing the changes discussed in the
previous version. Details are on each patch.

Cheers

Carlos Maiolino (4):
  xfs: remove typedef xfs_attr_sf_entry_t
  xfs: Remove typedef xfs_attr_shortform_t
  xfs: Use variable-size array for nameval in xfs_attr_sf_entry
  xfs: Convert xfs_attr_sf macros to inline functions

 fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.c | 46 +++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_sf.h   | 29 ++++++++++++++--------
 fs/xfs/libxfs/xfs_da_format.h |  6 ++---
 fs/xfs/xfs_attr_list.c        |  6 ++---
 fs/xfs/xfs_ondisk.h           | 12 ++++-----
 6 files changed, 64 insertions(+), 49 deletions(-)

-- 
2.26.2

