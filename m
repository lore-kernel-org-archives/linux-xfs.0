Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CB5C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 10:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B649F6144C
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 10:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFYKv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 06:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhFYKv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jun 2021 06:51:56 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCD3C061574
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jun 2021 03:49:35 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id u10so5168339vsu.12
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jun 2021 03:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GUFPsp6TuVNNZBrGSd+7nbPcX+A4B8pXMkopu535keM=;
        b=APy5yILSOkBDO/1Is89WdHK4l4U/Gw7zHmPfF4q9Y/HsWKIQ8Ml8yfBZ02EdfSvxD9
         RMosbXxPJoKhcdb02M/PJ4EbycnlvWtnX9i7ENKPl+0wWQ996Lei6Ux05U12i3q2rjXO
         FmqIARDOAK8ghS0O72vYWInNMc2XdrjqwWX4PNx6zr1rUb4kMduUSkPY6IeavpeJhXNc
         Fysr2YvgRe+IsIzKS8SncbjarboAR/aqBdrhn8wwE/OK90kb7hYQbXC18fCDS70ixe0+
         x3iBOyO8G4yxJ4006RPt8q7fsShJu7UmeZfW011CwmypJzs/RWGo8Mo9ECSiKBl0xiX5
         Oy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GUFPsp6TuVNNZBrGSd+7nbPcX+A4B8pXMkopu535keM=;
        b=fm3SpwbQAnuipIVBb4Q3Oymbixnv45WJKecEEwqM9DntR1IQbRMFYIRcEYE6+EgpRh
         8PoKr9JlUc5W7PVFmJ57M390UXZCDSx35hfrvx1K1Se019tz3SrGNZIMrlTPk4Q50JSJ
         B1L0/b6uX4sj5iSOjol2VhRyklRcAGvPaNaOmWvEswwVStIreNd6w3NEuWtSI7p3htrq
         qm7laFtvWUgp1HSRh/VUHFWyFydVDe/QddMn2X6xC2TDK2X/zY3FCLcy1tj3aRkE1ITS
         7kZA+xi0Y6aH6RvKLTI4piNuDry2pxaAOu5VFWb4yS1zpVAWy768Noiz63+9MQqCDee3
         5xxw==
X-Gm-Message-State: AOAM533i1qiCJ1Lz+3mYJLQSWst09rVIpTlUk/tRPCmj9h0P0Ql2xSiL
        262+CodOjbNoMZRiYFKTcvzV5xVjkDwQ/UgKZRKvz4NkRo8cZw==
X-Google-Smtp-Source: ABdhPJzcSlCr06AfbR8nPSkiCMkZNaH5GMSSkqK9N3Zd9QCtkF7/PqCmh8GQ86kUOcbJxIjzvohkebhw6btSpUMcHoc=
X-Received: by 2002:a67:79d1:: with SMTP id u200mr7688977vsc.19.1624618174214;
 Fri, 25 Jun 2021 03:49:34 -0700 (PDT)
MIME-Version: 1.0
From:   Ml Ml <mliebherr99@googlemail.com>
Date:   Fri, 25 Jun 2021 12:49:23 +0200
Message-ID: <CANFxOjCAYYs7ck0wrnM1AD0pBKE74=4PcDj_k+gHGjDmmvZBzg@mail.gmail.com>
Subject: XFS Mount need ages
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello List,

i have a rbd block device with xfs on it. After resizing it (from 6TB
to 8TB i think) the mount need hours to complete:

I started the mount 15mins ago.:
  mount -nv /dev/rbd6 /mnt/backup-cluster5

ps:
root      1143  0.2  0.0   8904  3088 pts/0    D+   12:17   0:03  |
   \_ mount -nv /dev/rbd6 /mnt/backup-cluster5


There is no timeout or ANY msg in dmesg until now.

strace -p 1143  :  seems to do nothing.
iotop --pid=3D1143: uses about 50KB/sec

dd bs=3D1M count=3D2048 if=3D/dev/rbd6 of=3D/dev/null =3D> gives me 50MB/se=
c


Any idea what=C2=B4s the problem here?

Cheers,
Michael
