Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DE8C35242
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA6021775
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEWgEMj3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgBHVJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 16:09:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727478AbgBHVJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 16:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581196162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yn2V6Sm3LlBqbLVmuxTKLZTGqmw5nMVmegmTzYhtlWU=;
        b=gEWgEMj3Y67iGJimSK5gyicsygifFiBTt/NZYjNjQ0H93ZT+EqbcJrUAWHnCsc7O007gC7
        Wn5r8OKDbb7Y1CZf67vbCtUXCRhLnVD9kBes1mLYiJdweoU/u7Y+K6ZyjLKrbHsxRxLeut
        sHmYvlmM3zendpNQ8OHyhhjEzuAXbdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-1Nv0cO8vPUO4yWtz6hwq2g-1; Sat, 08 Feb 2020 16:09:20 -0500
X-MC-Unique: 1Nv0cO8vPUO4yWtz6hwq2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D62BA8010E7
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:09:19 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AEE9F867E2
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:09:19 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] xfs: enable per-type quota timers and warn limits
Message-ID: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
Date:   Sat, 8 Feb 2020 15:09:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Quota timers are currently a mess.  Right now, at mount time,
we pick up the first enabled type and use that for the single
timer in mp->m_quotainfo.

Interestingly, if we set a timer on a different type, /that/
gets set into mp->m_quotainfo where it stays in effect until
the next mount, when we pick the first enabled type again.

We actually write the timer values to each type of quota inode,
but only one is ever in force, according to the interesting behavior
described above.

This series allows quota timers & warn limits to be independently
set and enforced for each quota type.

All the action is in the last patch, the first 3 are cleanups to
help.

-Eric

