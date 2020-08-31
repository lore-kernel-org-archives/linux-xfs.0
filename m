Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE63C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA32520866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ERnVuO5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgHaNEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726913AbgHaNEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/dxfhff34vqVH3L4gjPrnuhHQKwppOQxDc20E4J+tbg=;
        b=ERnVuO5xexsv1jhfHvav7XQopd7lc3mMsJm66KNfygdRgcsFRXQerZPtZPxVOdRTy0tcYd
        Qfjy2nk1dtfbpNH8NwXJn20blmW0Aby+rn+DsNp3MlCfNbKTzOx/pEYFBfmb00xYFOVxZb
        0b4Yf5tDATqkKiTgE8LUjhbgi/dJAPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-iItK2rebMiGGpSgSKXGFWg-1; Mon, 31 Aug 2020 09:04:29 -0400
X-MC-Unique: iItK2rebMiGGpSgSKXGFWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00CF98030CD
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:29 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FCD75D9D5
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:28 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] Clean up xfs_attr_sf_entry
Date:   Mon, 31 Aug 2020 15:04:19 +0200
Message-Id: <20200831130423.136509-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

this series has been suggested by Eric, and it's intended as a small clean up
for xfS_attr_sf_entry usage.

First patch changes the nameval array definition from 1 element to a
variable-size array. The array is already being used as a variable size array,
but by now, we need to subtract 1 from every time we use it.

Second patch just convert some macros to inline functions.

The remaining two patches are just 2 typedef cleanups that I think it's
appropriate since I'm already touching this code. I opted to leave the typedef
cleanups by last, since, if by any reason anybody think it's not worth it, both
patches can be simply discarded without needing to change any of the first 2.

All patches survived a few xfstests runs and the reproducer Eric shared on his
previous patch:

#touch file
#setfatt -n user.a file


Comments?

Cheers

Carlos Maiolino (4):
  xfs: Use variable-size array for nameval in xfs_attr_sf_entry
  xfs: Convert xfs_attr_sf macros to inline functions
  xfs: remove typedef xfs_attr_sf_entry_t
  xfs: Remove typedef xfs_attr_shortform_t

 fs/xfs/libxfs/xfs_attr.c      | 15 ++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.c | 42 +++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_sf.h   | 27 +++++++++++++---------
 fs/xfs/libxfs/xfs_da_format.h |  6 ++---
 fs/xfs/xfs_attr_list.c        |  6 ++---
 fs/xfs/xfs_ondisk.h           | 12 +++++-----
 6 files changed, 60 insertions(+), 48 deletions(-)

-- 
2.26.2

