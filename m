Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BE0C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2EB1206CC
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hnTS0gdf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUVox (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:44:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbfKUVox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 16:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574372692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LSuP/o79GihgjEwbHgr2Zgmsm896ue11TtiGPnFCvN0=;
        b=hnTS0gdfJyuTjYsKgZTAa7i9TRTHmyFH7IN+qF4FK5TBt7P0iwj5oPAjXMWKuC5LUtt5SM
        T+xMfo5yRYN7D2FIQr/v8SJWMbvoFiGLoMSFy8vVNgD3o4FHbnl6YRLZ/G1B9kkxnDGz8G
        774sALy3ULyWfbgt/PBvhTjAm2Y3GCM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-Ta2fx1ssPoS-3ZQS0XraUw-1; Thu, 21 Nov 2019 16:44:51 -0500
Received: by mail-wm1-f72.google.com with SMTP id x16so2478248wmk.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2019 13:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v3So6ie+qQARWASZdX2fug2FzNOxdIwY3M610tEblDk=;
        b=R1+J7sAkuRuHuYXNAM3otIwhWBCPyq/sGRXXRrQyAgEAHPiF+6CU3KaB+HO070WN3x
         /wvEWOjV4WU61V0sTCrirWdbB9D4BNbAJaxoVa084Gx1MpEw6Inavsf/d9yAZ1KNZLBq
         TgIttL5v5ORdCDlQ2u7AxE5FhzgWNCH0KuOqKgbUNV2nrHankJSVekCqJl9RNN0j5vcc
         Ii6m46QBvHlLAgBlEvt5pwkxgDTSqJkveSgk3DA1ZDniSlw7N8FhHr7qYwhBkGgtKsir
         mDz+l98wkMqxVkgojuiyVDeGkZBSXKEJiHYw3jtYNv/xhhr+3e+bT/LwPeShkm82deEg
         AHWQ==
X-Gm-Message-State: APjAAAWniFfVrBqTzoNL1lpvcIxQOZw7NisJsg5z5Iq4OvWm19pM+cQ1
        aE4uJzWOYU2ETBXeA3zYMmkN53NTLaMUG+buILQ52J5fY7f+C54YpfbcRKOWnM2y5TR1h80tPI7
        3iNeHjfdpUvNqBz9qfH0s
X-Received: by 2002:a5d:6746:: with SMTP id l6mr9314662wrw.349.1574372689846;
        Thu, 21 Nov 2019 13:44:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqyilatXB9XmBK/9KkzMwM7lBJpJ081HHo28ukJrrHP9QNryN9arY3uwgx+Sqo8r9xnX74WMEw==
X-Received: by 2002:a5d:6746:: with SMTP id l6mr9314638wrw.349.1574372689575;
        Thu, 21 Nov 2019 13:44:49 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id d18sm5093617wrm.85.2019.11.21.13.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:44:49 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 0/2] mkfs: inform during block discarding
Date:   Thu, 21 Nov 2019 22:44:43 +0100
Message-Id: <20191121214445.282160-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: Ta2fx1ssPoS-3ZQS0XraUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

1st patch breaks discarding into smaller chunks and thus make interruption =
and
logging possible.

2nd patch writes messages about discarding process into stderr. Sample outp=
ut
looks like this:
Discarding:  0% done
Discarding: 20% done
Discarding: 40% done
Discarding: 60% done
Discarding: 80% done
Discarding is done.

Pavel Reichl (2):
  mkfs: Break block discard into chunks of 2 GB
  mkfs: Show progress during block discard

 mkfs/xfs_mkfs.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--=20
2.23.0

