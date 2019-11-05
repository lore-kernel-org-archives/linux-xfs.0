Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629C6C00302
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 08:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F742084D
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 08:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FcQ5Pkw6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfKEIyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:54:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729765AbfKEIyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 03:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572944093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUGLSeTRytgNQOJIwB5DIbTvPkVTosdtAc5q+ut5r0M=;
        b=FcQ5Pkw6oSX3Igj5Gb3sXCwejII+HXRDYm3bCCxOX7/kZo8mJG8N9Hz+VV3uxADox1ir2N
        U/IlQ9ta++KyAkV6iMCzSYIkwCPeCdoX0d/0KlhFec+HF6wnX0PYDXd4GsaQNWTrxKQT0R
        vgDZ5iD+iNewSTxyCoGFJr9/YAgzVi8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-gREIVcHQO8GrYlxd6LNY_g-1; Tue, 05 Nov 2019 03:54:51 -0500
Received: by mail-wr1-f72.google.com with SMTP id c2so5345196wrt.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 00:54:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=7Xs/Efjk6SVLtweIzYfyUQMswnrZoD5QgMbuka76OE4=;
        b=iq62hoej7sIQVSRDBDrv2dEFudog7tWL9pQoSolBKdzp0ZUslzTTGnUa4kdPxLadRW
         xx/gmtNpZxXM7TH2bQI2dBaDym3ZAO7b9u2T7CNNKAcpgKwOVI0Vi7GuY+WHx23E2HxT
         cJZZ3qZ7V7ohivFf9UZ1OyPaJZIGZ/InYRMv+l4/UaMLnD+o0IrYX19yw0sDwHYegQA8
         4AuOTgbf8VZKmrfHwjhK55GePxoKAiguWQUikbLKm7K9N731s1lW/RfZoIYZFuw399ge
         JKWa8vD7ACe6JYnn0JKJsg9IzjMmqZaKwnep8eB8Rr2Zd0/qMaWTJVJWv13d4LLdkE9X
         4nCA==
X-Gm-Message-State: APjAAAX+Fs9ZtC2LsBEwmEg+KrhtgL0inKPQylI3IKh1FV/2uQNVdesT
        uKIp2oGrWYk3r3t40xH5THpEd2kQmsY4KLFhomiCO2HDZIMfl8CRca2V2oaN7+KMFhBHcxoQDJW
        Mw9MEy0v71Oe9WIWSJ7H6
X-Received: by 2002:adf:8088:: with SMTP id 8mr26167986wrl.230.1572944089558;
        Tue, 05 Nov 2019 00:54:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnQJewjN4Rz3g/+EcjLCzwDAezTMYdKpNBfCr2i0qPNCMlje1SOUl8UuZZ5OvzUUuH3jCDvg==
X-Received: by 2002:adf:8088:: with SMTP id 8mr26167961wrl.230.1572944089171;
        Tue, 05 Nov 2019 00:54:49 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id w12sm10027915wmi.17.2019.11.05.00.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:54:48 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:54:46 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Sitsofe Wheeler <sitsofe@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Tasks blocking forever with XFS stack traces
Message-ID: <20191105085446.abx27ahchg2k7d2w@orion>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
X-MC-Unique: gREIVcHQO8GrYlxd6LNY_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

On Tue, Nov 05, 2019 at 07:27:16AM +0000, Sitsofe Wheeler wrote:
> Hi,
>=20
> We have a system that has been seeing tasks with XFS calls in their
> stacks. Once these tasks start hanging with uninterruptible sleep any
> write I/O to the directory they were doing I/O to will also hang
> forever. The I/O they doing is being done to a bind mounted directory
> atop an XFS filesystem on top an MD device (the MD device seems to be
> still functional and isn't offline). The kernel is fairly old but I
> thought I'd post a stack in case anyone can describe this or has seen
> it before:
>=20
> kernel: [425684.110424] INFO: task kworker/u162:0:58843 blocked for
> more than 120 seconds.
> kernel: [425684.110800]       Tainted: G           OE
> 4.15.0-64-generic #73-Ubuntu
> kernel: [425684.111164] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: [425684.111568] kworker/u162:0  D    0 58843      2 0x80000080
> kernel: [425684.111581] Workqueue: writeback wb_workfn (flush-9:126)
> kernel: [425684.111585] Call Trace:
> kernel: [425684.111595]  __schedule+0x24e/0x880
> kernel: [425684.111664]  ? xfs_map_blocks+0x82/0x250 [xfs]
> kernel: [425684.111668]  schedule+0x2c/0x80
> kernel: [425684.111671]  rwsem_down_read_failed+0xf0/0x160
> kernel: [425684.111675]  ? bitmap_startwrite+0x9f/0x1f0
> kernel: [425684.111679]  call_rwsem_down_read_failed+0x18/0x30
> kernel: [425684.111682]  ? call_rwsem_down_read_failed+0x18/0x30
> kernel: [425684.111685]  down_read+0x20/0x40
> kernel: [425684.111736]  xfs_ilock+0xd5/0x100 [xfs]
> kernel: [425684.111782]  xfs_map_blocks+0x82/0x250 [xfs]
> kernel: [425684.111823]  xfs_do_writepage+0x167/0x6a0 [xfs]
> kernel: [425684.111830]  ? clear_page_dirty_for_io+0x19f/0x1f0
> kernel: [425684.111834]  write_cache_pages+0x207/0x4e0
> kernel: [425684.111869]  ? xfs_vm_writepages+0xf0/0xf0 [xfs]
> kernel: [425684.111875]  ? submit_bio+0x73/0x140
> kernel: [425684.111878]  ? submit_bio+0x73/0x140
> kernel: [425684.111911]  ? xfs_setfilesize_trans_alloc.isra.13+0x3e/0x90 =
[xfs]
> kernel: [425684.111944]  xfs_vm_writepages+0xbe/0xf0 [xfs]
> kernel: [425684.111949]  do_writepages+0x4b/0xe0
> kernel: [425684.111954]  ? fprop_fraction_percpu+0x2f/0x80
> kernel: [425684.111958]  ? __wb_calc_thresh+0x3e/0x130
> kernel: [425684.111963]  __writeback_single_inode+0x45/0x350
> kernel: [425684.111966]  ? __writeback_single_inode+0x45/0x350
> kernel: [425684.111970]  writeback_sb_inodes+0x1e1/0x510
> kernel: [425684.111975]  __writeback_inodes_wb+0x67/0xb0
> kernel: [425684.111979]  wb_writeback+0x271/0x300
> kernel: [425684.111983]  wb_workfn+0x1bb/0x400
> kernel: [425684.111986]  ? wb_workfn+0x1bb/0x400
> kernel: [425684.111992]  process_one_work+0x1de/0x420
> kernel: [425684.111996]  worker_thread+0x32/0x410
> kernel: [425684.111999]  kthread+0x121/0x140
> kernel: [425684.112003]  ? process_one_work+0x420/0x420
> kernel: [425684.112005]  ? kthread_create_worker_on_cpu+0x70/0x70
> kernel: [425684.112009]  ret_from_fork+0x35/0x40
> kernel: [425684.112024] INFO: task kworker/74:0:9623 blocked for more
> than 120 seconds.
> kernel: [425684.112461]       Tainted: G           OE
> 4.15.0-64-generic #73-Ubuntu
> kernel: [425684.112925] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: [425684.113438] kworker/74:0    D    0  9623      2 0x80000080
> kernel: [425684.113500] Workqueue: xfs-cil/md126 xlog_cil_push_work [xfs]
> kernel: [425684.113502] Call Trace:
> kernel: [425684.113508]  __schedule+0x24e/0x880
> kernel: [425684.113559]  ? xlog_bdstrat+0x2b/0x60 [xfs]
> kernel: [425684.113564]  schedule+0x2c/0x80
> kernel: [425684.113609]  xlog_state_get_iclog_space+0x105/0x2d0 [xfs]
> kernel: [425684.113614]  ? wake_up_q+0x80/0x80
> kernel: [425684.113656]  xlog_write+0x163/0x6e0 [xfs]
> kernel: [425684.113699]  xlog_cil_push+0x2a7/0x410 [xfs]
> kernel: [425684.113740]  xlog_cil_push_work+0x15/0x20 [xfs]
> kernel: [425684.113743]  process_one_work+0x1de/0x420
> kernel: [425684.113747]  worker_thread+0x32/0x410
> kernel: [425684.113750]  kthread+0x121/0x140
> kernel: [425684.113753]  ? process_one_work+0x420/0x420
> kernel: [425684.113756]  ? kthread_create_worker_on_cpu+0x70/0x70
> kernel: [425684.113759]  ret_from_fork+0x35/0x40
>=20
> Other directories on the same filesystem seem fine as do other XFS
> filesystems on the same system.

The fact you mention other directories seems to work, and the first stack t=
race
you posted, it sounds like you've been keeping a singe AG too busy to almos=
t
make it unusable. But, you didn't provide enough information we can really =
make
any progress here, and to be honest I'm more inclined to point the finger t=
o
your MD device.

Can you describe your MD device? RAID array? What kind? How many disks?
What's your filesystem configuration? (xfs_info <mount point>)=20
Do you have anything else on your dmesg other than these two stack traces? =
I'd
suggest posting the whole dmesg, not only what you think is relevant.

Better yet:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

Cheers.

>=20
> --=20
> Sitsofe | http://sucs.org/~sits/

--=20
Carlos


P.S. I'm removing Darrick and linux-fsdevel from CC to avoid spamming too m=
any.

