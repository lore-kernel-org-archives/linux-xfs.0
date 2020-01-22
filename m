Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,PDS_TONAME_EQ_TOLOCAL_VSHORT,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C39C33CB6
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385E421835
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="arNl9qjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgAVQjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:39:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgAVQjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 11:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579711139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+0UlfL+qIWiNOwYfY9rvkVy3gE5J5EJtoz1xY+UrwSw=;
        b=arNl9qjC/u850O3V3kxibxRBimZSqaHmkGjGb1w+ODxONuPACIZ3SfZIJUiQb1OQIghS5V
        PupBssENMOVymH5o4+5iFgyBuLWcgRnwE3SDpm2wj+VZMLiCt0+Mtx4K2Tu8bh5Mw/8lxj
        Jt5ALM6+3u48EhhlG4NDidTPGg58Adw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-eQZF6AmZOP-_s5puGgCZSQ-1; Wed, 22 Jan 2020 11:38:57 -0500
X-MC-Unique: eQZF6AmZOP-_s5puGgCZSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 681E818C8C00
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:38:56 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E5D75C28C
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:38:56 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfsprogs: libxfs cosmetic tidyups
Message-ID: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
Date:   Wed, 22 Jan 2020 10:38:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These should be no-op, almost purely cosmetic patches to ease
future libxfs porting work.

