Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BTC_ID,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6329C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DCEB21835
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDmU7upn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfLERuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:50:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729396AbfLERuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 12:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575568239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HLNM7FhxFeR3AAR16zURlPkn52LfIqXBEqugNI9aYeg=;
        b=dDmU7upnqIUCGEaPrRntmCTwNqUm5s9s0brAgfW8g+7FyAjj+OUoixJLAqFc/SKayOR+qi
        SXgYUnCdPkIuXC9gna4QEwPwlFP/DzulncEe7Ufdl92iVaXIWt0PzPLlgKTDTYvBIkiLGV
        A1um165fTMQxbycJjG7GraQZGYxaclM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-XD3TUMdKNWyjuJkW-VSPLQ-1; Thu, 05 Dec 2019 12:50:37 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DBAA107ACE8
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D07410013D9
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v4 0/2] xfs: automatic relogging experiment
Date:   Thu,  5 Dec 2019 12:50:35 -0500
Message-Id: <20191205175037.52529-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: XD3TUMdKNWyjuJkW-VSPLQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v4 RFC for automatic relogging and probably the closest one IMO
to a non-RFC worthy implementation. There's still a few kinks, but this
might be the right combination of simplicity, effectiveness and
flexibility for future enhancement. Patch 1 adds the mechanism and patch
2 uses it for the quotaoff start intent. See the commit logs for further
details.=20

Thoughts, reviews, flames appreciated.

Brian

rfcv4:
- AIL based approach.
rfcv3: https://lore.kernel.org/linux-xfs/20191125185523.47556-1-bfoster@red=
hat.com/
- CIL based approach.
rfcv2: https://lore.kernel.org/linux-xfs/20191122181927.32870-1-bfoster@red=
hat.com/
- Different approach based on workqueue and transaction rolling.
rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat=
.com/

Brian Foster (2):
  xfs: automatic log item relog mechanism
  xfs: automatically relog the quotaoff start intent

 fs/xfs/xfs_dquot_item.c  |  7 +++++
 fs/xfs/xfs_qm_syscalls.c |  9 +++++++
 fs/xfs/xfs_trace.h       |  1 +
 fs/xfs/xfs_trans.c       | 30 +++++++++++++++++++++
 fs/xfs/xfs_trans.h       |  7 ++++-
 fs/xfs/xfs_trans_ail.c   | 56 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trans_priv.h  |  5 ++++
 7 files changed, 112 insertions(+), 3 deletions(-)

--=20
2.20.1

