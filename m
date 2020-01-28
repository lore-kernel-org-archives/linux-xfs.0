Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2BDC33CB3
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 04:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A45512467E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 04:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctqBsg5j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA1ETG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 23:19:06 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44011 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgA1ETF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 23:19:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so13201782ljm.10
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2020 20:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ocbdBSQBCTF8Ab51JIKelhwakPE1aZPRV/X6QZE4N1Q=;
        b=ctqBsg5jnAG4YXybJRKBi91/b5K4h/KCTM1bhECw/tSQFfpBLjxR3lfGqpp/oQK6Tn
         4WE1X6M4Q4OFTZykM57kYB/EmuNOZGmDFqiZApO1tSQaaVa5+Qk15q16OxBEb64Z5CzZ
         iwuKg4wSPIL2DCMay9JelckBEPk+83qyv3EyoMU2FOSVPEtwgOXBmHluYesnJAa24ToQ
         JvZA6MT9ifTCVRGxipV3rc2Iq/YRO5tZsfVgQb1ZoYZJYJ/Zfw9yVWO0rbcfwLQNFDzf
         oeMxX7nDmV7lqB2AtEeVzICzhpvzWcFJkcb4YWH5UPjje/cTdvx947YQoX7rhM10bR/X
         nmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ocbdBSQBCTF8Ab51JIKelhwakPE1aZPRV/X6QZE4N1Q=;
        b=HW9RTBMcnUMlYa1tDUSXNZrB/+ORqJ14bGq3Va9m7ynzk4VLr0wnpQeiZlQ/Qg0xLs
         2Xeb5r6oZQIgIWRdXRzIc9KtJ2V5G9NVPdLdSSfLmhQDoS2lxIFozmz7nrbIrFWLCz8O
         NXmENnnmTfFdFtXx7zjs1FPQGVkPx6Y+zZZsAljmAaWNGflRrYEc4oAH3YmOE2/DuSba
         K/YU1yvq0LN6scTwbhE9qkGnAmR4Raen2RbowVp7WyR2Y8jywt+850K0xvdt9NVx17Vg
         +7JZrh+d0KcR+tsQl9fTaeIUSVCCPX3wOvLDPFJUlbPLOyHC97BBonE1hN4RvNbWExcH
         408g==
X-Gm-Message-State: APjAAAVTSAr4b7cPP4ogGlCzzBcCujJzOKVesm1z/2weSqeQNA5fdaez
        C/zpFJdvfq+adXeZYCYseupQ5jyOAzYCdfTcm7J0mQ==
X-Google-Smtp-Source: APXvYqzyGbnVzeuLvGQLOT9KlisGy/B0t9Gip+1Cc+LBWro0ES4b1hl7AFGYoAImpmuPGJpH4W/PFqzRsnwe/jXSUrk=
X-Received: by 2002:a2e:461a:: with SMTP id t26mr12091210lja.204.1580185143299;
 Mon, 27 Jan 2020 20:19:03 -0800 (PST)
MIME-Version: 1.0
References: <CAMym5wu+ypVDQbyFRrjpqCRKyovpT=nitF4O8VNuspDv5rsd-g@mail.gmail.com>
 <20200128035127.GC18610@dread.disaster.area>
In-Reply-To: <20200128035127.GC18610@dread.disaster.area>
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Tue, 28 Jan 2020 13:18:52 +0900
Message-ID: <CAMym5wvrYPhLK+5FB2+M_JosyjD4suShAL5V8BV-z-HAxJzx7g@mail.gmail.com>
Subject: Re: Some tasks got to hang_task in XFS
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

2020=E5=B9=B41=E6=9C=8828=E6=97=A5(=E7=81=AB) 12:51 Dave Chinner <david@fro=
morbit.com>:
>
> On Mon, Jan 27, 2020 at 12:37:55PM +0900, Satoru Takeuchi wrote:
> > In Rook(*1)/Ceph community, some users encountered hang_task in XFS.
> > Although we've not reproduced this problem in the newest kernel, could =
anyone
> > give us any hint about this problem, if possible?
> >
> > *1) An Ceph orchestration in Kubernetes
> >
> > Here is the detail.
> >
> > Under some workload in Ceph, many processes got to hang_task. We found
> > that there
> > are two kinds of processes.
> >
> > a) In very high CPU load
> > b) Encountered hang_task in the XFS
> >
> > In addition,a user got the following two kernel traces.
> >
> > A (b) process's backtrace with `hung_task_panic=3D1`.
> >
> > ```
> > [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 se=
conds.
> > [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
>
> Kinda old, and not an upstream LTS kernel, right?
>
> > [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> > [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
>
> Filesystem is on a Ceph RBD device.
>
> > [51717.039472] Call Trace:
> > [51717.039478]  __schedule+0x24e/0x880
> > [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> > [51717.039506]  schedule+0x2c/0x80
> > [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > [51717.039533]  ? wake_up_q+0x80/0x80
> > [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> > [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> > [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> > [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> > [51717.039626]  process_one_work+0x1de/0x420
> > [51717.039627]  worker_thread+0x32/0x410
> > [51717.039628]  kthread+0x121/0x140
> > [51717.039630]  ? process_one_work+0x420/0x420
> > [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> > [51717.039633]  ret_from_fork+0x35/0x40
>
> That's waiting for log IO completion.
>
> > ```
> >
> > A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
> > process>/stack`
> >
> > ```
> > [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> > [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> > [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> > [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> > [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> > [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> > [<0>] generic_shutdown_super+0x72/0x120
> > [<0>] kill_block_super+0x2c/0x80
> > [<0>] deactivate_locked_super+0x48/0x80
> > [<0>] deactivate_super+0x40/0x60
> > [<0>] cleanup_mnt+0x3f/0x80
> > [<0>] __cleanup_mnt+0x12/0x20
> > [<0>] task_work_run+0x9d/0xc0
> > [<0>] exit_to_usermode_loop+0xc0/0xd0
> > [<0>] do_syscall_64+0x121/0x130
> > [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [<0>] 0xffffffffffffffff
>
> ANd this is the last reference to the filesystem being dropped and
> it waiting for log IO completion.
>
> So, the filesytem has been unmounted, and it's waiting for journal
> IO on the device to complete.  I wonder if a wakeup was missed
> somewhere?
>
> Did the system stop/tear down /dev/rbd0 prematurely?
>
> > Related discussions:
> > - Issue of Rook:
> >   https://github.com/rook/rook/issues/3132
> > - Issue of Ceph
> >   https://tracker.ceph.com/issues/40068
>
> These point to Ceph RBDs failing to respond under high load and
> tasks hanging because they are waiting on IO. That's exactly the
> symptoms you are reporting here. That points to it being a Ceph RBD
> issue to me, especially the reports where rbd devices report no IO
> load but the ceph back end is at 100% disk utilisation doing
> -something-.

Thank you very much for your comment! I'll ask Ceph RBD guys.

Regards,
Satoru

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
