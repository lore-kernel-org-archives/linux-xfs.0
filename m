Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2B6C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F522065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZTHcKna+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGOUNH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:13:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgGOUNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 16:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594843985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j8SnYrZZI/AJTMy1XEftjio3kza6eIiv2uaVGzEceAU=;
        b=ZTHcKna+UvsW+mZegTffE8Q2SWeR7Y+cm4d15/qzQ3gEuHvoajOwVIjeGkIAGXYCSxEkmD
        HV+xyenqFZb/YwPgj+c/usDfJoC8/AGcaPMMZrXk+yyCXo00T348Q/7b/QU9bbtF9LbF8d
        T7YbHdan1eUmVY8mz0qamwTia911ydE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-QLGF1d02PkK41AuEKpmuTA-1; Wed, 15 Jul 2020 16:13:04 -0400
X-MC-Unique: QLGF1d02PkK41AuEKpmuTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F2EA1080;
        Wed, 15 Jul 2020 20:13:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-87.rdu2.redhat.com [10.10.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9201260BF1;
        Wed, 15 Jul 2020 20:13:02 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com
Subject: [PATCH 0/3] xfsprogs: xfs_quota error message and state reporting improvement
Date:   Wed, 15 Jul 2020 15:12:50 -0500
Message-Id: <20200715201253.171356-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


This patchset improves xfs_quota command error message output as well as
adding reporting for grace times and warning limits for state (u,g,p).

Note that patches to xfstests to handle these changes will be forthcoming.
Also, patch 1 was originally submitted separately:
  (xfsprogs: xfs_quota command error message improvement)

patch 1 contains the command error message improvements.
patch 2 contains the warning limit reporting (originally SoB Darrick Wong).
patch 3 contains the additional state reporting of grace times for u,g,p.

Comments appreciated. Thanks-
Bill




