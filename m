Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3375A17F3
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 00:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716338796; cv=none; b=czRts5AiIz/879ys/MeHCYZK+mrQEd6edaY8OAdkuCuSSF0VC7tpA6ljj1TXONZCfzuCXbBm6tzgtgiGmUCCL34CJ4gyIT2+uHj2c9USn8HUry0wzzzNT8tBHmdtywKuAmG7jrU9h5xYuoTlxEXiE16JG4jD6QR3SiE0Zq+FHiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716338796; c=relaxed/simple;
	bh=7BY9RRmh2VxZZEuSvcnwCMC9/YP698MeCwYo///rW6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UAU4RWJRWYJL2G/kVPe8kGlLWV34SsbDszeMwfjnJBJO+bqQVFcqlwYpkeaoUKpnzR8vWcLtYBCYPtOfss4HYMr3pu3B3xM94MEQ4/XUuipcslIZzJCRlhNsT7IFXYkQi1sOwga11q906jm/kPCD+x96tsLRBQU3VkuJTq72WSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpYmZNQz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpYmZNQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716338793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qzEDAxoabsUEZMbG3hl5HQi6iHnRf8Nl1CTVdR+bflc=;
	b=fpYmZNQz346FtrIhVDrGiOW4+Qrn0gqv2TAAfCNJyrqEeBTtHK6WaQpJKSMwWJEAe1Pnk0
	t8Z040hB6J3a8DUxqzPfQqnOz7x02Gc3pmuUPqW3CO8c0RDspIS3k8NcdpcqgI8gVn0D0j
	Da0O2xY+DWnDg0UZhnbBJb+5cK/YwOY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-sdZdpgBFO2qTr9m6ldTQDA-1; Tue, 21 May 2024 20:46:30 -0400
X-MC-Unique: sdZdpgBFO2qTr9m6ldTQDA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34d7e948a41so7135662f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 17:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716338789; x=1716943589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzEDAxoabsUEZMbG3hl5HQi6iHnRf8Nl1CTVdR+bflc=;
        b=JeSXEzAnvcJ4USaeWtVEJ5NHIwJXVddsCGAdpKBLP3J6OyA2XYRXSGPuKK38HhSxCW
         F1P+eyjArmsFyrWZGQvYjDcODLgIWmeQyX7VYVf0vPFncsAkmn8z1f7aiiRmOkyRp9G/
         BJJZ0aigZZHbM2aw1b96SuqISY938JE7I739tudfwrL2K/XZQPeuzH9kqccEBc1DDykE
         q8dGRo8JJCSGSzv0sYUA+vTX23x4RZRn1NablbpWkHLXJ6s4x3TCNK7l9Mbmoq8L1h5D
         GtiMvEdAa//ykYu3lVK6jcMXDs3oPgNZooGrbbacwlQjuQpw2Lk2fbeayAOt2rxHIoac
         Kw5A==
X-Forwarded-Encrypted: i=1; AJvYcCWmZEpHsdFR3zvpcVuzlIRIc9356AlWndfe2YYr+gEWKcBIAyxEEY4gGYoAF09L0jsSbnv/f6zfml2DkACt1fbH4KUdligzU1zE
X-Gm-Message-State: AOJu0YwOCNWrRPAv4TAwQygwg3x7/znOibotwNReE5GTCzevfZaEmYpU
	2xIEoAb/BlV9SjOJIAB3T9pGFj7dWIwBPguRe6V9Wd3AxsVB/o2RfEjP5r8rO81DQk4/kbz7009
	qg0KX3Um+BBg+EHwrbCEcdtPAWhPzbTtclBpN6Fh09pZBE0H66k0Y+yQ1RzuL3HyC1EeLDZFCnH
	FbkQDIDf5Kg2iHP9pFz+4+odsLIr0mk033
X-Received: by 2002:a5d:5551:0:b0:351:d3e2:c091 with SMTP id ffacd0b85a97d-354d8ccc817mr280082f8f.14.1716338789156;
        Tue, 21 May 2024 17:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH803zTZAlHW8RmQX2UUect5Ovp9GTkq/vRtljmi6erFRzzLrXu2m8K40SYmpvYmNO/bD7pTlC1tCAROotS5FE=
X-Received: by 2002:a5d:5551:0:b0:351:d3e2:c091 with SMTP id
 ffacd0b85a97d-354d8ccc817mr280077f8f.14.1716338788669; Tue, 21 May 2024
 17:46:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
 <ae36c333-29fe-1bfd-9558-894b614e916d@huaweicloud.com> <CAGS2=YrG7+k7ufEcX5NY2GFy69A7QQwq6BCku2biLHXVEOxWow@mail.gmail.com>
 <a053e948-791c-3233-3791-83bf9ea90bde@huaweicloud.com>
In-Reply-To: <a053e948-791c-3233-3791-83bf9ea90bde@huaweicloud.com>
From: Guangwu Zhang <guazhang@redhat.com>
Date: Wed, 22 May 2024 08:46:17 +0800
Message-ID: <CAGS2=YrkFxiQxWCPyuLgdb_DJHkfXm=nCG9egRHpQ9MG8tEXWA@mail.gmail.com>
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock) a
 t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Could not reproduce the error after applying your four patches
thanks.

Zhang Yi <yi.zhang@huaweicloud.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=BA=8C 19:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2024/5/21 18:06, Guangwu Zhang wrote:
> > Hi,
> > I use the below script reproduce the error.
> >
> >         mkdir -p /media/xfs
> >         mkdir -p /media/scratch
> >         dev0=3D$(losetup --find)
> >         dd if=3D/dev/zero of=3D1.tar bs=3D1G count=3D1
> >         dd if=3D/dev/zero of=3D2.tar bs=3D1G count=3D1
> >         losetup $dev0 1.tar
> >         dev1=3D$(losetup --find)
> >         losetup $dev1 2.tar
> >         mkfs.xfs -f $dev0
> >         mkfs.xfs -f $dev1
> >         mount $dev0 /media/xfs
> >         mount $dev1 /media/scratch
> >         export TEST_DEV=3D"$(mount | grep '/media/xfs' | awk '{ print $=
1 }')"
> >         export TEST_DIR=3D"/media/xfs"
> >         export SCRATCH_DEV=3D"$(mount | grep '/media/scratch' | awk '{
> > print $1 }')"
> >         export SCRATCH_MNT=3D"/media/scratch"
> >
> >         git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> >         cd xfstests-dev
> >         make
> >         for i in $(seq 20);do
> >             ./check generic/461
> >         done
> >
> > @YI,  Could you list your 4 patch links here ?  the kernel don't work
> > well after apply the patch [1]
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D5ce5674187c345dc31534d2024c09ad8ef29b7ba
> >
>
> Please try:
>
> 5ce5674187c3 ("xfs: convert delayed extents to unwritten when zeroing pos=
t eof blocks")
> 2e08371a83f1 ("xfs: make xfs_bmapi_convert_delalloc() to allocate the tar=
get offset")
> fc8d0ba0ff5f ("xfs: make the seq argument to xfs_bmapi_convert_delalloc()=
 optional")
> bb712842a85d ("xfs: match lock mode in xfs_buffered_write_iomap_begin()")
>
> Yi.
>
> >
> > Zhang Yi <yi.zhang@huaweicloud.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8821=
=E6=97=A5=E5=91=A8=E4=BA=8C 13:05=E5=86=99=E9=81=93=EF=BC=9A
> >
> >>
> >> On 2024/5/20 19:48, Guangwu Zhang wrote:
> >>> Hi,
> >>> I get a xfs error when run xfstests  generic/461 testing with
> >>> linux-block for-next branch.
> >>> looks it easy to reproduce with s390x arch.
> >>>
> >>> kernel info :
> >>> commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
> >>> 6.9.0+
> >>> reproducer
> >>> git clone xfstests
> >>>  ./check generic/461
> >>>
> >>>
> >>
> >> I guess this issue should be fixed by 5ce5674187c3 ("xfs: convert dela=
yed
> >> extents to unwritten when zeroing post eof blocks"), please merge this=
 commit
> >> series (include 4 patches) and try again.
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D5ce5674187c345dc31534d2024c09ad8ef29b7ba
> >>
> >> Yi.
> >>
> >>> [ 5322.046654] XFS (loop1): Internal error isnullstartblock(got.br_st=
artblock) a
> >>> t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_insert=
_extents+0x
> >>> 2ee/0x420 [xfs]
> >>> [ 5322.046859] CPU: 0 PID: 157526 Comm: fsstress Kdump: loaded Not ta=
inted 6.9.0
> >>> + #1
> >>> [ 5322.046863] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
> >>> [ 5322.046864] Call Trace:
> >>> [ 5322.046866]  [<0000022f504d8fc4>] dump_stack_lvl+0x8c/0xb0
> >>> [ 5322.046876]  [<0000022ed00fc308>] xfs_corruption_error+0x70/0xa0 [=
xfs]
> >>> [ 5322.046955]  [<0000022ed00b7206>] xfs_bmap_insert_extents+0x3fe/0x=
420 [xfs]
> >>> [ 5322.047024]  [<0000022ed00f55a6>] xfs_insert_file_space+0x1be/0x24=
8 [xfs]
> >>> [ 5322.047105]  [<0000022ed00ff1dc>] xfs_file_fallocate+0x244/0x400 [=
xfs]
> >>> [ 5322.047186]  [<0000022f4fe90000>] vfs_fallocate+0x218/0x338
> >>> [ 5322.047190]  [<0000022f4fe9112e>] ksys_fallocate+0x56/0x98
> >>> [ 5322.047193]  [<0000022f4fe911aa>] __s390x_sys_fallocate+0x3a/0x48
> >>> [ 5322.047196]  [<0000022f505019d2>] __do_syscall+0x23a/0x2c0
> >>> [ 5322.047200]  [<0000022f50511d20>] system_call+0x70/0x98
> >>> [ 5322.054644] XFS (loop1): Corruption detected. Unmount and run xfs_=
repair
> >>> [ 5322.977488] XFS (loop1): User initiated shutdown received.
> >>> [ 5322.977505] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_go=
ingdown+0xb
> >>> 4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
> >>> [ 5322.977772] XFS (loop1): Please unmount the filesystem and rectify=
 the proble
> >>> m(s)
> >>> [ 5322.977877] loop1: writeback error on inode 755831, offset 32768, =
sector 1804
> >>> 712
> >>> 00:00:00
> >>>
> >>>
> >>> .
> >>>
> >>
> >>
> >
> >
> > --
> > Guangwu Zhang
> > Thanks
> >
>


--=20
Guangwu Zhang
Thanks

