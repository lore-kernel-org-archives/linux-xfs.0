Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24372C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 09:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8A0620823
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 09:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoZp8/Mt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfKYJ2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 04:28:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50032 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727192AbfKYJ2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 04:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574674108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SY4XM57ZeEt9dqHrsCWVlZF/eNuAepqGfPRvF8eHyn0=;
        b=BoZp8/MtUTT57494wcS4sQl1QJcZ9LqUTYzcri0YvY9dTAZCVL3Eu1t6ftF3Ml3n2z+7Yb
        +iDSz7qxPP44roBqJ4obezO5s/noGgc/UJZdx9y9L17i50S7aDlSJgn1zjLVjuyQDAF2n2
        wWYkAtHI6w1JNIn65vFol6i4IjghQNw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-BwKmmwvtN7-u4fTn9-eRPA-1; Mon, 25 Nov 2019 04:28:23 -0500
Received: by mail-wm1-f70.google.com with SMTP id p5so2336911wmc.4
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2019 01:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=mi5kBY7uJcp5d5Qz+yBfD5d7To+60vpCy0Q6DtEBzz8=;
        b=EtC2YRJS9TYcrzhqln1YLnIp+adqQLM/e0Ct3rrHRxB1kzfv5eLRzgVnIoUUBaaiZY
         Ghb+bLwawUBx3ddiWMIAwMQx24v+sz3Y25yXpqB4x5LTtTCZEIhOI+yZQ9ey1yI00NIm
         7G/DJRA6DmLun34pmsYRRS2HriJcXiqFNjEUkxvnwwOZ5IPzuzwBm5M+NGVRTts9tYku
         4A8uxW0/KzI7KlgjbMrw4VwqBeYdxVT8gkKeJpVY0f94We7tzgMpEiYnn0oFa8f8n0/K
         wEAS7Ywq6HQI6PFfNjqOFZBfAEC1CVUE45iaYmgT9L5EpRQji+Hb5HcWjvMlpsxMJ1Vh
         qtTw==
X-Gm-Message-State: APjAAAWfz73BEEy81qzRJokFzy0JML0SEjZbPIQOKaTOQ6q/nkWXbcEG
        FHKK4aEj7zIXZ0E6yircLl4LYDB4OnnmYUJFWViR8sM58ch8X7MwvvhdAdAFidVZEljMXJOH3I+
        6Y1X1HB8RMKza4l6hxn1S
X-Received: by 2002:a05:600c:290e:: with SMTP id i14mr9988460wmd.126.1574674101588;
        Mon, 25 Nov 2019 01:28:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHKLr0A7aj/S+TnP4ggij9qnbJH6D+1vj/RyjVtpRlMSoQFr+HclojBJSJd21fFmPSDs4vPA==
X-Received: by 2002:a05:600c:290e:: with SMTP id i14mr9988435wmd.126.1574674101242;
        Mon, 25 Nov 2019 01:28:21 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id j17sm9887834wrr.75.2019.11.25.01.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 01:28:20 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:28:18 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Convert kmem_alloc() users
Message-ID: <20191125092818.puakokhcunwoorbb@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-6-cmaiolino@redhat.com>
 <20191122155756.GE6219@magnolia>
 <20191122223048.GK6219@magnolia>
 <20191124220256.GM6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191124220256.GM6219@magnolia>
X-MC-Unique: BwKmmwvtN7-u4fTn9-eRPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 24, 2019 at 02:02:56PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 22, 2019 at 02:30:48PM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 22, 2019 at 07:57:56AM -0800, Darrick J. Wong wrote:
> > > On Wed, Nov 20, 2019 at 11:44:25AM +0100, Carlos Maiolino wrote:
> > > > Use kmalloc() directly.
> >=20
> > <snip all this>
> >=20
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index 5423171e0b7d..7bb53fbf32f6 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -1962,7 +1962,7 @@ xlog_recover_buffer_pass1(
> > > >  =09=09}
> > > >  =09}
> > > > =20
> > > > -=09bcp =3D kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> > > > +=09bcp =3D kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __G=
FP_NOFAIL);
> > > >  =09bcp->bc_blkno =3D buf_f->blf_blkno;
> > > >  =09bcp->bc_len =3D buf_f->blf_len;
> > > >  =09bcp->bc_refcount =3D 1;
> > > > @@ -2932,7 +2932,8 @@ xlog_recover_inode_pass2(
> > > >  =09if (item->ri_buf[0].i_len =3D=3D sizeof(struct xfs_inode_log_fo=
rmat)) {
> > > >  =09=09in_f =3D item->ri_buf[0].i_addr;
> > > >  =09} else {
> > > > -=09=09in_f =3D kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
> > > > +=09=09in_f =3D kmalloc(sizeof(struct xfs_inode_log_format),
> > > > +=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
> > > >  =09=09need_free =3D 1;
> > > >  =09=09error =3D xfs_inode_item_format_convert(&item->ri_buf[0], in=
_f);
> > > >  =09=09if (error)
> > > > @@ -4271,7 +4272,7 @@ xlog_recover_add_to_trans(
> > > >  =09=09return 0;
> > > >  =09}
> > > > =20
> > > > -=09ptr =3D kmem_alloc(len, 0);
> > > > +=09ptr =3D kmalloc(len, GFP_KERNEL | __GFP_NOFAIL);
> > > >  =09memcpy(ptr, dp, len);
> > > >  =09in_f =3D (struct xfs_inode_log_format *)ptr;
> > >=20
> > > I noticed that kmalloc is generating warnings with generic/049 when 1=
6k
> > > directories (-n size=3D16k) are enabled.  I /think/ this is because i=
t's
> > > quite possible to write out an xlog_op_header with a length of more t=
han
> > > a single page; log recovery will then try to allocate a huge memory
> > > buffer to recover the transaction; and so we try to do a huge NOFAIL
> > > allocation, which makes the mm unhappy.
> > >=20
> > > The one thing I've noticed with this conversion series is that the fl=
ags
> > > translation isn't 100% 1-to-1.  Before, kmem_flags_convert didn't
> > > explicitly set __GFP_NOFAIL anywhere; we simply took the default
> > > behavior.  IIRC that means that small allocations actually /are/
> > > guaranteed to succeed, but multipage allocations certainly aren't.
> > > This seems to be one place where we could have asked for a lot of
> > > memory, failed to get it, and crashed.
> > >=20
> > > Now that we explicitly set NOFAIL in all the places where we don't al=
so
> > > check for a null return, I think we're just uncovering latent bugs
> > > lurking in the code base.  The kernel does actually fulfill the
> > > allocation request, but it's clearly not happy.
> >=20
> > FWIW I ran with various dirsizes and options and it looks like this is
> > the only place where we screw this up... patches soon.
>=20
> I rescind that statement -- there's enough places in this series where I
> can't 100% tell that a k{mzre}alloc call asks for a small enough amount
> of memory to qualify for __GFP_NOFAIL.
>=20
> I really want this cleanup to start with a straightforward removal of
> the kmem.c wrappers without any behavior changes.  Only after that's
> done should we move on to things like adding __GFP_NOFAIL to allocations
> or deciding if/where we can substitute kfree for kvfree.
>=20
> Munging them together means I can't easily tell if something is
> seriously broken here (but the WARN_ONs suggest this) and I'd forgotten
> that the merge window is opening the week of a major US holiday, so I
> choose to defer this series to 5.6.

Thanks, this is the best option IMO too. I'll think a bit about it and chec=
k
what should we do about it.

>=20
> --D
>=20
> > --D
> >=20
> > > --D
> > >=20
> > > Relevant snippet of dmesg; everything else was normal:
> > >=20
> > >  XFS (sdd): Mounting V5 Filesystem
> > >  XFS (sdd): Starting recovery (logdev: internal)
> > >  ------------[ cut here ]------------
> > >  WARNING: CPU: 1 PID: 459342 at mm/page_alloc.c:3275 get_page_from_fr=
eelist+0x434/0x1660
> > >  Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_=
snapshot dm_bufio dm_flakey xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_RE=
JECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_=
hash_mac bfq ip_set nfnetlink ip6table_filter ip6_tables iptable_filter sch=
_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
> > >  CPU: 1 PID: 459342 Comm: mount Not tainted 5.4.0-rc3-djw #rc3
> > >  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubu=
ntu1 04/01/2014
> > >  RIP: 0010:get_page_from_freelist+0x434/0x1660
> > >  Code: e6 00 00 00 00 48 89 84 24 a0 00 00 00 0f 84 08 fd ff ff f7 84=
 24 c0 00 00 00 00 80 00 00 74 0c 83 bc 24 84 00 00 00 01 76 02 <0f> 0b 49 =
8d 87 10 05 00 00 48 89 c7 48 89 84 24 88 00 00 00 e8 03
> > >  RSP: 0018:ffffc900035d3918 EFLAGS: 00010202
> > >  RAX: ffff88803fffb680 RBX: 0000000000002968 RCX: ffffea0000c8e108
> > >  RDX: ffff88803fffbba8 RSI: ffff88803fffb870 RDI: 0000000000000000
> > >  RBP: 0000000000000002 R08: 0000000000000201 R09: 000000000002ff81
> > >  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> > >  R13: 0000000000048cc0 R14: 0000000000000001 R15: ffff88803fffb680
> > >  FS:  00007fcfdf89a080(0000) GS:ffff88803ea00000(0000) knlGS:00000000=
00000000
> > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >  CR2: 000055b202ec48c8 CR3: 000000003bfdc005 CR4: 00000000001606a0
> > >  Call Trace:
> > >   ? kvm_clock_read+0x14/0x30
> > >   __alloc_pages_nodemask+0x172/0x3a0
> > >   kmalloc_order+0x18/0x80
> > >   kmalloc_order_trace+0x1d/0x130
> > >   xlog_recover_add_to_trans+0x4b/0x340 [xfs]
> > >   xlog_recovery_process_trans+0xe9/0xf0 [xfs]
> > >   xlog_recover_process_data+0x9e/0x1f0 [xfs]
> > >   xlog_do_recovery_pass+0x3a9/0x7c0 [xfs]
> > >   xlog_do_log_recovery+0x72/0x150 [xfs]
> > >   xlog_do_recover+0x43/0x2a0 [xfs]
> > >   xlog_recover+0xdf/0x170 [xfs]
> > >   xfs_log_mount+0x2e3/0x300 [xfs]
> > >   xfs_mountfs+0x4e7/0x9f0 [xfs]
> > >   xfs_fc_fill_super+0x2f8/0x520 [xfs]
> > >   ? xfs_fs_destroy_inode+0x4f0/0x4f0 [xfs]
> > >   get_tree_bdev+0x198/0x270
> > >   vfs_get_tree+0x23/0xb0
> > >   do_mount+0x87e/0xa20
> > >   ksys_mount+0xb6/0xd0
> > >   __x64_sys_mount+0x21/0x30
> > >   do_syscall_64+0x50/0x180
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >  RIP: 0033:0x7fcfdf15d3ca
> > >  Code: 48 8b 0d c1 8a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 8b 0d 8e 8a 2c 00 f7 d8 64 89 01 48
> > >  RSP: 002b:00007fff0af10a58 EFLAGS: 00000202 ORIG_RAX: 00000000000000=
a5
> > >  RAX: ffffffffffffffda RBX: 000055b202ec1970 RCX: 00007fcfdf15d3ca
> > >  RDX: 000055b202ec1be0 RSI: 000055b202ec1c20 RDI: 000055b202ec1c00
> > >  RBP: 0000000000000000 R08: 000055b202ec1b80 R09: 0000000000000000
> > >  R10: 00000000c0ed0000 R11: 0000000000000202 R12: 000055b202ec1c00
> > >  R13: 000055b202ec1be0 R14: 0000000000000000 R15: 00007fcfdf67e8a4
> > >  irq event stamp: 18398
> > >  hardirqs last  enabled at (18397): [<ffffffff8123738f>] __slab_alloc=
.isra.83+0x6f/0x80
> > >  hardirqs last disabled at (18398): [<ffffffff81001d8a>] trace_hardir=
qs_off_thunk+0x1a/0x20
> > >  softirqs last  enabled at (18158): [<ffffffff81a003af>] __do_softirq=
+0x3af/0x4a4
> > >  softirqs last disabled at (18149): [<ffffffff8106528c>] irq_exit+0xb=
c/0xe0
> > >  ---[ end trace 3669c914fa8ccac6 ]---
> > >=20
> > > AFAICT this is because inode buffers are 32K on this system
> > >=20
> > > > =20
> > > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > > index a2664afa10c3..2993af4a9935 100644
> > > > --- a/fs/xfs/xfs_qm.c
> > > > +++ b/fs/xfs/xfs_qm.c
> > > > @@ -988,7 +988,8 @@ xfs_qm_reset_dqcounts_buf(
> > > >  =09if (qip->i_d.di_nblocks =3D=3D 0)
> > > >  =09=09return 0;
> > > > =20
> > > > -=09map =3D kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> > > > +=09map =3D kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> > > > +=09=09      GFP_KERNEL | __GFP_NOFAIL);
> > > > =20
> > > >  =09lblkno =3D 0;
> > > >  =09maxlblkcnt =3D XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > > index 7f03b4ab3452..dfd419d402ea 100644
> > > > --- a/fs/xfs/xfs_rtalloc.c
> > > > +++ b/fs/xfs/xfs_rtalloc.c
> > > > @@ -962,7 +962,7 @@ xfs_growfs_rt(
> > > >  =09/*
> > > >  =09 * Allocate a new (fake) mount/sb.
> > > >  =09 */
> > > > -=09nmp =3D kmem_alloc(sizeof(*nmp), 0);
> > > > +=09nmp =3D kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
> > > >  =09/*
> > > >  =09 * Loop over the bitmap blocks.
> > > >  =09 * We will do everything one bitmap block at a time.
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index cc1933dc652f..eee831681e9c 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1739,7 +1739,7 @@ static int xfs_init_fs_context(
> > > >  {
> > > >  =09struct xfs_mount=09*mp;
> > > > =20
> > > > -=09mp =3D kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> > > > +=09mp =3D kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOF=
AIL);
> > > >  =09if (!mp)
> > > >  =09=09return -ENOMEM;
> > > > =20
> > > > --=20
> > > > 2.23.0
> > > >=20
>=20

--=20
Carlos

