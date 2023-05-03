Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C8DC7EE29
	for <linux-xfs@archiver.kernel.org>; Wed,  3 May 2023 08:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjECIKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjECIKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2023 04:10:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC9D4ED5
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 01:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683101261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gAItFTPlViLA5pqMw1tfLrN9/2fArVuO7Mw/NYUVWFo=;
        b=AM58T2GW1NkzejK+xOAnv+cAQIh6MBOmu+vfc2eNg0Rq1oOtWsHV2KjQp/SOYrF/lEJAAa
        yXphOm01JoLUM+6j6AdL8yYHttbhr+wl1ZFlhNr3l0zfLD4StA6Nv9QIfw7ShjWMAjIMMU
        dJYTrwqH9xFQ0M2U8yS6b6g8jP1ZHaw=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-IbzpCVdgOn2GbhBnUoRQxA-1; Wed, 03 May 2023 04:07:40 -0400
X-MC-Unique: IbzpCVdgOn2GbhBnUoRQxA-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-42f8d8ff18eso50302137.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 May 2023 01:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683101259; x=1685693259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gAItFTPlViLA5pqMw1tfLrN9/2fArVuO7Mw/NYUVWFo=;
        b=kS3b0mohr6r22lecP4Q/qIaXXH0uARNa56j5HIItXe/KCSNRXm/sLrCs/LkxfinScy
         K+DUw5kz9fly0WFDBwXV7KMLp7nvNieArgoK0q0K293Tg78E4255zcA0fjJBeomREVob
         i6iaYfZi0xocTUBB3MPsNCj8gFahF9olFOfLyQxgCLgc7euGuSM/MEFxcKQzfgrrwwi/
         XKzBsOkTCTH144o/aNaLavPhOqpZMx+Jzq5xAKGch+80flqJCCTTiuFAPGpLyWcIl27K
         95VdyJSSCJU0W/i2FbUekElQkhZr1jm3Jilowt6fF56jsgIL0uWqZN/be8M8L2Vbl0Kt
         WnTA==
X-Gm-Message-State: AC+VfDwAkKSlgedjLNQFWEVwwq8JPY1YBYdQW1+yQDtEnxOnFgFRSCdR
        08GLbOHuL0tILuK1+73gYFaw/mDN4m0SCIRVqdE7jPtfwT0N3/lESkWTnmg7K/elfLv3cNkTPAz
        HfcYOy65alZOErFdwgN62+vBT1fSPLXpdS659MQYm30B+Emsgiw==
X-Received: by 2002:a05:6102:4423:b0:425:cf4e:f58 with SMTP id df35-20020a056102442300b00425cf4e0f58mr5826612vsb.2.1683101259595;
        Wed, 03 May 2023 01:07:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4gxwahabBGCrNHNF6s+lz4ioJ9i0off0x3X7IY8Rl43m4GKL65v9RDPFIN5Ni52UaiJ5vDPD2ER12791dZuv8=
X-Received: by 2002:a05:6102:4423:b0:425:cf4e:f58 with SMTP id
 df35-20020a056102442300b00425cf4e0f58mr5826607vsb.2.1683101259381; Wed, 03
 May 2023 01:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230503060450.GC3223426@dread.disaster.area>
In-Reply-To: <20230503060450.GC3223426@dread.disaster.area>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Wed, 3 May 2023 16:07:28 +0800
Message-ID: <CAFj5m9+xC7ojwz-gA5T+PEiN9NEyUi+bp4D3XuEPD7hoPrZe-g@mail.gmail.com>
Subject: Re: [6.4-current oops] null ptr deref in blk_mq_sched_bio_merge()
 from blkdev readahead
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 3, 2023 at 2:06=E2=80=AFPM Dave Chinner <david@fromorbit.com> w=
rote:
>
> Hi folks,
>
> fstests running shared/032 on XFS with a default mkfs and mount
> config causes a panic in the block layer when userspace is operating
> directly on the block device like this:
>
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test3 6.3.0-dgc+ #1792 SMP PREEMPT_DYNAMIC =
Wed May  3 15:20:20 AEST 2023
> MKFS_OPTIONS  -- -f -m rmapbt=3D1 /dev/pmem1
> MOUNT_OPTIONS -- -o dax=3Dnever -o context=3Dsystem_u:object_r:root_t:s0 =
/dev/pmem1 /mnt/scratch
>
> ....
>
> [   56.070695] run fstests shared/032 at 2023-05-03 15:21:55
> [   56.768890] BTRFS: device fsid 355df15c-7bc5-49b0-9b5d-dc25ce855a9d de=
vid 1 transid 6 /dev/pmem1 scanned by mkfs.btrfs (5836)
> [   57.285879]  pmem1: p1
> [   57.301845] BUG: kernel NULL pointer dereference, address: 00000000000=
000a8
> [   57.304562] #PF: supervisor read access in kernel mode
> [   57.306499] #PF: error_code(0x0000) - not-present page
> [   57.308414] PGD 0 P4D 0
> [   57.309401] Oops: 0000 [#1] PREEMPT SMP
> [   57.310876] CPU: 3 PID: 4478 Comm: (udev-worker) Not tainted 6.3.0-dgc=
+ #1792
> [   57.313517] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.16.2-debian-1.16.2-1 04/01/2014
> [   57.317089] RIP: 0010:blk_mq_sched_bio_merge+0x7b/0x100

Hi Dave,

It is fixed by:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?h=3Dfor-6.4/block&id=3D38c8e3dfb2a1be863b7f5aad7755d5e9727da8a5

Thanks,
Ming

