Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACA6C7EE22
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 00:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjEIAUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 20:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbjEIAUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 20:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986BE44BD
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 17:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF7C63036
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 00:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0F0C433EF
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 00:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683591598;
        bh=MjkItiypktEo25V6DO99EB7GxcQEs1EfAiVhHUuOnbQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RSSudBY16vz4RroQGxUhku5OYcaCkTjMO58/KDOi1njcr8zgMeihbJkxIfe65FdwA
         WTKRFk6yLOIpAzrnwSc0mgGoLoqHAmwLcw5j+/ZcE4ExvVWFtdQZHfyiT5v2LqPQAL
         CJjAqVGQZKTLiM7Geg+UAZwtw9PLqV72x8dfHDiQPcnMah4gDRlxD0mfA6PQtR1ygY
         tSHHJaV+yO9jZA69YjZYgxwTxbKWNwxGoRQkoKHqh2LcT4jRNC4u7QTtaySrD+bmEI
         Jwb9ej+fJqbGeMH8Q1vK9wkTdfbBAJF3cszo7dZOpRxsmLDp07qqoh+s+uHedZ8+xd
         8LPuzMoSTBDxA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-50bc4ba28cbso9527100a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 May 2023 17:19:58 -0700 (PDT)
X-Gm-Message-State: AC+VfDxSP1OMbpgeq3W1C3kOCywY8HQxy506paxKjwqdtgo1f8tKBBUC
        ZwF7Y/5RTc34c/lKR/DxNYnYn4uBFb8ySlfaZj2g
X-Google-Smtp-Source: ACHHUZ6XguvB359TJD5EVeTjXaiA2ucEsERS2+WbXhgo3pznKhng9msxWTb8gnB50Rzaq/efZNnWYP+FsScnG1YYBIM=
X-Received: by 2002:a17:907:9808:b0:94f:4801:6d08 with SMTP id
 ji8-20020a170907980800b0094f48016d08mr10822326ejc.71.1683591597081; Mon, 08
 May 2023 17:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230503183821.1473305-1-john.g.garry@oracle.com> <20230503183821.1473305-2-john.g.garry@oracle.com>
In-Reply-To: <20230503183821.1473305-2-john.g.garry@oracle.com>
From:   Mike Snitzer <snitzer@kernel.org>
Date:   Mon, 8 May 2023 20:19:46 -0400
X-Gmail-Original-Message-ID: <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
Message-ID: <CAH6w=ay1NNxh=9mQv5PCcDi3OY0mgvRXO_0VrmKBLAd1dcUQqQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/16] block: Add atomic write operations to
 request_queue limits
To:     John Garry <john.g.garry@oracle.com>
Cc:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jejb@linux.ibm.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 3, 2023 at 2:40=E2=80=AFPM John Garry <john.g.garry@oracle.com>=
 wrote:
>
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
>
> Add the following limits:
> - atomic_write_boundary
> - atomic_write_max_bytes
> - atomic_write_unit_max
> - atomic_write_unit_min
>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  Documentation/ABI/stable/sysfs-block | 42 +++++++++++++++++++++
>  block/blk-settings.c                 | 56 ++++++++++++++++++++++++++++
>  block/blk-sysfs.c                    | 33 ++++++++++++++++
>  include/linux/blkdev.h               | 23 ++++++++++++
>  4 files changed, 154 insertions(+)
>

...

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 896b4654ab00..e21731715a12 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -59,6 +59,9 @@ void blk_set_default_limits(struct queue_limits *lim)
>         lim->zoned =3D BLK_ZONED_NONE;
>         lim->zone_write_granularity =3D 0;
>         lim->dma_alignment =3D 511;
> +       lim->atomic_write_unit_min =3D lim->atomic_write_unit_max =3D 1;
> +       lim->atomic_write_max_bytes =3D 512;
> +       lim->atomic_write_boundary =3D 0;
>  }

Not seeing required changes to blk_set_stacking_limits() nor blk_stack_limi=
ts().

Sorry to remind you of DM and MD limits stacking requirements. ;)

Mike
