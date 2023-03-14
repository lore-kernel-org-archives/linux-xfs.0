Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E74C6FD1F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 05:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjCNFMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 01:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCNFMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 01:12:09 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3172789F11
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 22:12:08 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id o2so13009681vss.8
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 22:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678770727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7W13c4FBWsgQQVsbZqXvnGuE5NHm+bN0X38u4Mkpy4=;
        b=dJ9dYxjJYRYy2TjwrX/5yx8DOHnXGeLCEYBo8p27ULInqGY8UyRDnoPK417tQznhBb
         ADYh3KQrRLsH0qMRvxl/qj+lJC+oeacB6sdolKpzN9lAPLk8sS1Y/HZoZ3OryDTSBPpr
         ajcXBBbOqc6+9HyLXTZ1Ob4BgFnCtqG+RRk/V35/thCiD7EWeJ5MCsEW9a83R7D5KRrV
         jIEwgI6K8NyL9GfpTBexkjSLzoelhO5t6D/4AIoehQhowIzScgLCqw0yQ404i8X7XB4Q
         Fu28yDMc0aObJxuszB8aED+ew4Am2q1j/b/tIhQJNmMiDv+JIC39dhgQgZoldOGTiD1l
         BGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678770727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7W13c4FBWsgQQVsbZqXvnGuE5NHm+bN0X38u4Mkpy4=;
        b=nEgZep9PoeAVmbN/f5Mxwgy8g5v/zg2V7IOdgAVmx5jepCN9FOt2tpyVvZnAewjxmk
         1xhTWG2WfnV7RcTm0jHRmeEuqu+jma47PpLPfqNh6xRX0CJCshCXkauHupKYFKp5DHPo
         P1MnI+JqjoFaRIMmFbwxtQzpiBHDrxDhkzn/SrJcqpaHBqeloCLNyIrVcUh7qopMLsHf
         48eTvO0TaG6uA1zhFPU28A5YJXKyn8B8qDbikR92GHcW8iDF+KIn2ffX82/07s4zqL50
         cL8r8qM3XeaQ+PbaMU+WPkjC/uCU2urkgQKgqOmuTm19ZFPcb/dSSMVcMY4W1kFWpreJ
         1tjw==
X-Gm-Message-State: AO0yUKVqEkIBG6Lp2DkSzDvYccqk9xKjMNsjtsuD7hVq/yT9wNiJjzLO
        hfA/vtdedGMOFTuLYsFVVC3uYu8Ycmdf22dVtx+IhfQK6R4=
X-Google-Smtp-Source: AK7set8HKyx8pk8Ji0JwTOuS1AMt0bflQfrV6RWwy+0PnwE5rO3G38KyL7SEWaWBP3mxoW8uBtgbJL2RQjAwlvEKFsY=
X-Received: by 2002:a67:f406:0:b0:414:48a5:473f with SMTP id
 p6-20020a67f406000000b0041448a5473fmr24113667vsn.0.1678770727162; Mon, 13 Mar
 2023 22:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230314042109.82161-1-catherine.hoang@oracle.com> <20230314042109.82161-3-catherine.hoang@oracle.com>
In-Reply-To: <20230314042109.82161-3-catherine.hoang@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Mar 2023 07:11:56 +0200
Message-ID: <CAOQ4uxhKEhQ4X+rE4AYq70iEWKfqwQOZu47w_n1dbXd-wOeHTw@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] xfs: implement custom freeze/thaw functions
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 6:25=E2=80=AFAM Catherine Hoang
<catherine.hoang@oracle.com> wrote:
>
> Implement internal freeze/thaw functions and prevent other threads from c=
hanging
> the freeze level by adding a new SB_FREEZE_ECLUSIVE level. This is requir=
ed to

This looks troubling in several ways:
- Layering violation
- Duplication of subtle vfs code

> prevent concurrent transactions while we are updating the uuid.
>

Wouldn't it be easier to hold s_umount while updating the uuid?
Let userspace freeze before XFS_IOC_SETFSUUID and let
XFS_IOC_SETFSUUID take s_umount and verify that fs is frozen.

> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_super.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_super.h |   5 ++
>  2 files changed, 117 insertions(+)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2479b5cbd75e..6a52ae660810 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2279,6 +2279,118 @@ static inline int xfs_cpu_hotplug_init(void) { re=
turn 0; }
>  static inline void xfs_cpu_hotplug_destroy(void) {}
>  #endif
>
> +/*
> + * We need to disable all writer threads, which means taking the first t=
wo
> + * freeze levels to put userspace to sleep, and the third freeze level t=
o
> + * prevent background threads from starting new transactions.  Take one =
level
> + * more to prevent other callers from unfreezing the filesystem while we=
 run.
> + */
> +int
> +xfs_internal_freeze(
> +       struct xfs_mount        *mp)
> +{
> +       struct super_block      *sb =3D mp->m_super;
> +       int                     level;
> +       int                     error =3D 0;
> +
> +       /* Wait until we're ready to freeze. */
> +       down_write(&sb->s_umount);
> +       while (sb->s_writers.frozen !=3D SB_UNFROZEN) {
> +               up_write(&sb->s_umount);
> +               delay(HZ / 10);
> +               down_write(&sb->s_umount);
> +       }

That can easily wait forever, without any task holding any lock.

> +
> +       if (sb_rdonly(sb)) {
> +               sb->s_writers.frozen =3D SB_FREEZE_EXCLUSIVE;
> +               goto done;
> +       }
> +
> +       sb->s_writers.frozen =3D SB_FREEZE_WRITE;
> +       /* Release s_umount to preserve sb_start_write -> s_umount orderi=
ng */
> +       up_write(&sb->s_umount);
> +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
> +       down_write(&sb->s_umount);
> +
> +       /* Now we go and block page faults... */
> +       sb->s_writers.frozen =3D SB_FREEZE_PAGEFAULT;
> +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT - 1)=
;
> +
> +       /*
> +        * All writers are done so after syncing there won't be dirty dat=
a.
> +        * Let xfs_fs_sync_fs flush dirty data so the VFS won't start wri=
teback
> +        * and to disable the background gc workers.
> +        */
> +       error =3D sync_filesystem(sb);
> +       if (error) {
> +               sb->s_writers.frozen =3D SB_UNFROZEN;
> +               for (level =3D SB_FREEZE_PAGEFAULT - 1; level >=3D 0; lev=
el--)
> +                       percpu_up_write(sb->s_writers.rw_sem + level);
> +               wake_up(&sb->s_writers.wait_unfrozen);
> +               up_write(&sb->s_umount);
> +               return error;
> +       }
> +
> +       /* Now wait for internal filesystem counter */
> +       sb->s_writers.frozen =3D SB_FREEZE_FS;
> +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_FS - 1);
> +
> +       xfs_log_clean(mp);
> +
> +       /*
> +        * To prevent anyone else from unfreezing us, set the VFS freeze
> +        * level to one higher than FREEZE_COMPLETE.
> +        */
> +       sb->s_writers.frozen =3D SB_FREEZE_EXCLUSIVE;
> +       for (level =3D SB_FREEZE_LEVELS - 1; level >=3D 0; level--)
> +               percpu_rwsem_release(sb->s_writers.rw_sem + level, 0,
> +                               _THIS_IP_);

If you really must introduce a new freeze level, you should do it in vfs
and not inside xfs, even if xfs is the only current user of the new leve.

Thanks,
Amir.
