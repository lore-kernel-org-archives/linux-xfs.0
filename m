Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F45C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C52C20702
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKvvbWDF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHUAAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:00:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHUAAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 20:00:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597968002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QDsAMG8hbGhNZYYdhC7Pkma+xhI3WousCXn/FC1J+MM=;
        b=cKvvbWDFXJ5WVnYTOD3FCEn8WtCscZY/jVGtsEYM9UYcv5XI672eyv3iodIMheTJgU/D6E
        RiIJiHDr0+2zSHAVeeW5Vg4zvESnZEuH7qR22XF+izpwINlT9CiBDoRnu3ELHEMoqBOQoA
        pBFN/Z8eoy6vMSEbmRrJm125I1wFeak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-YLtSK3YrMyWqijpsvhPA7g-1; Thu, 20 Aug 2020 19:44:42 -0400
X-MC-Unique: YLtSK3YrMyWqijpsvhPA7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 218D3100CFC0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 23:44:42 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7E8510098A7
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 23:44:41 +0000 (UTC)
To:     linux-xfs@vger.kernel.org
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs_db: more type_f cleanups
Message-ID: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
Date:   Thu, 20 Aug 2020 18:44:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These go on top of Zorro's

"xfs_db: use correct inode to set inode type"

-Eric

