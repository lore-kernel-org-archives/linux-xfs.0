Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF71ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 03:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiILDPe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILDPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2022 23:15:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4A717E00
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 20:15:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dv25so17040078ejb.12
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 20:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=c7adxJw+p44IAmh4KskrQQ8vtDBGxQjqP39fSBRdd/c=;
        b=Qm9Ey8t/tEE13QD2yrenxx5BZO1R6drDluzl+zXxFOEhpBVWxVKNZk6jvOlHoh6Zq9
         h0qYiot5XZ/wWbcxBggUQNRlSbJRoaVfAIdnqsJGDutP0edWQa+LWfxDqMarDTiMN4/9
         UOUKxB5l8saU7EJ336bTs4PblJj7t96TiHQBuAzVJCoFHur/vQHS7F5j/6BlRVjUEp7v
         fOh9i3O/4juqPoYGUQTw8dH/8hC+CKjz9IwXvBMzVx4MWFw8O3YsdPFKZJ1tgkQkFmkl
         QTC59OQ3K5eEF2EBrISDwmRMqh5RvvLAq3yM7YZ46rhyFLnW0QVO81qwqhPL0zjM17E9
         Dyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=c7adxJw+p44IAmh4KskrQQ8vtDBGxQjqP39fSBRdd/c=;
        b=1TWwVQAevUmXrR5hrnhuNOMIYDUxejrmrOEucnjros6n+4MAW6HXEOnlUQYmQhVW3E
         EgqUF1uSdAb8wq83LTo0r4DEgqX5EEcxEK+1hC0fB67FRybD6EjQYYuUulirU7oktezY
         WEHjxLgOQWjBHD8amZ+xU54YMq6WyCaJDnKorqsPVPfQ6BDPPaA1oA0MonhA9Ckm5LER
         VjocFfw6lcDtWdeRMLMAIepOAoej7D1A2W6fbiXzqK/BL5MWFf/Q7B8IfbPmZgX8yJCR
         MB5vXszRw/yNQhCORD+b6Y/eTjOEPE0KVE5fsF56RvbchrZ0+cV6RMOR4BU2DupQWN2W
         Tkww==
X-Gm-Message-State: ACgBeo3tC7m6I/1yvhV2BsIy62XIQxKSI6l9M6J6J1hKU6imuJi1WwEv
        al8SA5NjNTqBaenLPMGv6wOkKAqX3oYCAaaZvUg=
X-Google-Smtp-Source: AA6agR7wQtLGOfy0lhiK7wLD9FGmuhPXdlvXnZ5d2M7h95MLSxtuKma2oV/GwNVvSKyerJAQV1ELEpOkVuWPVKd/8TQ=
X-Received: by 2002:a17:907:a049:b0:77c:1f27:1b28 with SMTP id
 gz9-20020a170907a04900b0077c1f271b28mr4765082ejc.20.1662952527819; Sun, 11
 Sep 2022 20:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220911033137.4010427-1-zhangshida@kylinos.cn> <20220911222024.GY3600936@dread.disaster.area>
In-Reply-To: <20220911222024.GY3600936@dread.disaster.area>
From:   Stephen Zhang <starzhangzsd@gmail.com>
Date:   Mon, 12 Sep 2022 11:14:51 +0800
Message-ID: <CANubcdUrZQTQnokcb8FUm31sgUToriaS1uNVXNYvNyeZ+ZUHkA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix up the comment in xfs_dir2_isleaf
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        zhangshida@kylinos.cn, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave Chinner <david@fromorbit.com> =E4=BA=8E2022=E5=B9=B49=E6=9C=8812=E6=97=
=A5=E5=91=A8=E4=B8=80 06:20=E5=86=99=E9=81=93=EF=BC=9A
>
> The "*vp" parameter should be a "bool *isleaf", in which case the
> return value is obvious and the comment can be removed. Then the
> logic in the function can be cleaned up to be obvious instead of
> relying on easy to mistake conditional logic in assignemnts...

Thanks for the suggestion.In order to make sure we are at the same page,
so this change will be shown like:
=3D=3D=3D=3D
 xfs_dir2_isblock(
        struct xfs_da_args      *args,
-       int                     *vp)    /* out: 1 is block, 0 is not block =
*/
+       bool                    *isblock)
 {
        xfs_fileoff_t           last;   /* last file offset */
        int                     rval;

        if ((rval =3D xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK))=
)
                return rval;
-       rval =3D XFS_FSB_TO_B(args->dp->i_mount, last) =3D=3D args->geo->bl=
ksize;
+       *isblock =3D XFS_FSB_TO_B(args->dp->i_mount, last) =3D=3D args->geo=
->blksize;
        if (XFS_IS_CORRUPT(args->dp->i_mount,
-                          rval !=3D 0 &&
+                          *isblock &&
                           args->dp->i_disk_size !=3D args->geo->blksize))
                return -EFSCORRUPTED;
-       *vp =3D rval;
        return 0;
 }
=3D=3D=3D=3D

Thanks,

Stephen.
