Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5172CC4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED5F8221F2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgLCTyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:54:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbgLCTyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607025203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q3lRhkOko/FEA2GUi6179v9+Dbz6Tmjkl/BZAmM1a4E=;
        b=Z9aGf86JMsKF6ISCX4Hm7D6tc8qQoU7Zn+L5QKl8w9hHEgKW27LTddl2ppdt3t9osxQUrL
        crcC3wga1jX2QdiX61THj6bdEc6u3Kw/NltuI3tZctfCloDJH6bphFl2jATFwGsPfp/MZb
        qbxoQZg04Q3kFbI+Dw1LBFqv7He77ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-aVFdJGoGNIKriXylc8nO0Q-1; Thu, 03 Dec 2020 14:53:21 -0500
X-MC-Unique: aVFdJGoGNIKriXylc8nO0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B3EC285
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 19:53:20 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B05B65C1B4
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 19:53:20 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] xfs_quota: man page fixups
Message-ID: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
Date:   Thu, 3 Dec 2020 13:53:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A handful of small updates & fixes for the xfs_quota man page

