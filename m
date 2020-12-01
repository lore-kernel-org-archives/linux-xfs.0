Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D15CC64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0813820639
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:12:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g0gtsReR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgLATLu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 14:11:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730070AbgLATLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 14:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606849824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hO/an0Zgggpp15df93yQ7816LW8xfvYdCaHurz9R0F4=;
        b=g0gtsReReLu403uUThf+aL5R8Bc2rltuBbWUMV/zI0wNQsNEiGkGY/ALRIMw5NV5TNgqWn
        eYhExShtKFcxNJJhF7iKW7RDm1DDrtNT0kgwJSc7H0qTMktTXoI47U4ujQ0cN0UuX9NsLp
        IXBmCIrNDzCdaXH/CF2z/z8gMAbPSmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-SrRJjL6LOkSJxmlncQRHKQ-1; Tue, 01 Dec 2020 14:10:22 -0500
X-MC-Unique: SrRJjL6LOkSJxmlncQRHKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F2FE817B8C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:10:21 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54FFD5D9CA
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:10:21 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: fix up some reflink+dax interactions
Message-ID: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Date:   Tue, 1 Dec 2020 13:10:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

dax behavior has changed semi-recently, most notably that per-inode dax
flags are back, which opens the possibility of dax-capable files existing on
reflink-capable filesystems.

While we still have a reflink-vs-dax-on-the-same-file incompatibilty, and for
the most part this is handled correctly, there are a couple of known issues:

1) xfs_dinode_verify will trap an inode with reflink+dax flags as corrupted;
   this needs to be removed, because we actually can get into this state today,
   and eventually that state will be supported in future kernels.

2) (more RFC) until we actually support reflink+dax files, perhaps we should
   prevent the flags from co-existing in a kernel that cannot support both
   states.  patch 2 stops us from reflinking files with the dax flag set,
   whether or not the file is actually "in the CPU direct access state"

-Eric

