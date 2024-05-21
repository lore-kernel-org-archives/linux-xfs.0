Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2BB6A8D2
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716286021; cv=none; b=CEqA+nZzRiNhn9/P+3Yx2vbEXK1OlRSQG+TkcaLI8DrZh/ORpmFSN0wJQuYDPjcDABpjjL19uEZWSOtveSoEmh47H+l37tdeIIIdqIiutqjKh1tNRL9PTx8SxLLYiNosE29/NI0nMEsDi5NGh8R2m7F/gUB2NnxS0aBPgYN05Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716286021; c=relaxed/simple;
	bh=gfS5ij5ynR+dW+7wUskzlakjEoDgLeefZRn5DlBOE/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NOELWVeYMspWuIgrUdVi2XAmm3TqcMVS/t8G99vsWid5cwmh7mOK/h3aRyoZ0pEiWREgYyFYqU/bwT/oO+e1tCwHO3rnPE1wC/chN0MFWypcRkKgYNirkwgdlCbK3fNR1BAMhMsYtEanMegc3GUuZ3Hkt2vGYKi//fKgWwSk+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/DwwWZi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/DwwWZi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716286019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lytEjnB2qVjk/ZWiVMPZLEZDCxYKGYQkDMVZ/hxvk6A=;
	b=Y/DwwWZiphrMmwCwp/f7DzJT5YpfDdwT2gwoqqnFQ7fs45+DXdhDf3PBPS1kFTynhGDxGw
	x5IulBJbdD/Ko8Dry3H3ugQm908vVMngUoUv85EsqQl8cOQ79dPNDU8aMyN54kKFVju7/J
	kXBbzhfdp1Trc6jubEngMLA9AX0ieUo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-W6YIKzcIPd-ZA5zpcQFvtA-1; Tue, 21 May 2024 06:06:57 -0400
X-MC-Unique: W6YIKzcIPd-ZA5zpcQFvtA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a59cbb6f266so823538066b.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 03:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716286015; x=1716890815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lytEjnB2qVjk/ZWiVMPZLEZDCxYKGYQkDMVZ/hxvk6A=;
        b=NUZkDQoO1CeRIoyufEzMasp9DGhwL1WdaPFdnCFFV3ekecYNkwBoZVnwmdneq62EWS
         okSEIyJuvI1dZ3E0oGi6YBIUS39i6abmmq7dJBMmWVUmbxKhIfxn/G6DpR3hbFTlHhx7
         dEcddA1Oi9VUr//kTF5n6CRvf2EdpbxOZLcGOKYcjHSxv0oE/IRdT4VSuat0gIUy5FQA
         QSum4ak6DGs2DRiDfRjE9PXCgv+SodqKWRM/to28IsplBmvn7HqHOU5K6iQXJvDh8CYt
         eWp5eOuUi/q3z22ymex4T7uaoUUxYXN4vU68Uw4iNk23GEQD0EnTSUiVzk4LxUX9iTyx
         rPXw==
X-Forwarded-Encrypted: i=1; AJvYcCVooiKnJ4+SD000gj1hPlmq6lEJryg7sGVHvB7NLtr9edTzDYvpKiRGrD3zJ51MurOzR4+0/4YqKJ+2AYuB5J73ATNcbSAbprSX
X-Gm-Message-State: AOJu0Yx9DRsajgDpFSIY2fW/axIrdyz2yXHLoy4gejcEnfW2mn4k3O/c
	KT2FwEvhL3N2IPNfQMFbOSg6J4TEb+D8+xb2fPKopUzl0vpofYFmN9LYj1FnGuSeQxmTmfw/ydH
	84VYgoreMH/GGD0NNH/jiA7HDP/uOtsY/TcwyCingGHIuLjkQGrVF0ugTqXtYp+uIwVqnyE0sSt
	dEseLW5ISqP05JeS8lkPktFjFBqRvW3sbzfs6kCLEACCsJ9Q==
X-Received: by 2002:a17:907:9446:b0:a59:afdd:590a with SMTP id a640c23a62f3a-a5a2d65d66dmr3737226666b.56.1716286015671;
        Tue, 21 May 2024 03:06:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXAIkc2ncamBbHf63wfdmfYgVtcGm2uHgL1lxuGBQWEjjgbZEHhZRMVVNyYUS+LoP2ZSLxgfWgmgJvguDu3F4=
X-Received: by 2002:a17:907:9446:b0:a59:afdd:590a with SMTP id
 a640c23a62f3a-a5a2d65d66dmr3737224866b.56.1716286015271; Tue, 21 May 2024
 03:06:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
 <ae36c333-29fe-1bfd-9558-894b614e916d@huaweicloud.com>
In-Reply-To: <ae36c333-29fe-1bfd-9558-894b614e916d@huaweicloud.com>
From: Guangwu Zhang <guazhang@redhat.com>
Date: Tue, 21 May 2024 18:06:44 +0800
Message-ID: <CAGS2=YrG7+k7ufEcX5NY2GFy69A7QQwq6BCku2biLHXVEOxWow@mail.gmail.com>
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock) a
 t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
I use the below script reproduce the error.

        mkdir -p /media/xfs
        mkdir -p /media/scratch
        dev0=3D$(losetup --find)
        dd if=3D/dev/zero of=3D1.tar bs=3D1G count=3D1
        dd if=3D/dev/zero of=3D2.tar bs=3D1G count=3D1
        losetup $dev0 1.tar
        dev1=3D$(losetup --find)
        losetup $dev1 2.tar
        mkfs.xfs -f $dev0
        mkfs.xfs -f $dev1
        mount $dev0 /media/xfs
        mount $dev1 /media/scratch
        export TEST_DEV=3D"$(mount | grep '/media/xfs' | awk '{ print $1 }'=
)"
        export TEST_DIR=3D"/media/xfs"
        export SCRATCH_DEV=3D"$(mount | grep '/media/scratch' | awk '{
print $1 }')"
        export SCRATCH_MNT=3D"/media/scratch"

        git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
        cd xfstests-dev
        make
        for i in $(seq 20);do
            ./check generic/461
        done

@YI,  Could you list your 4 patch links here ?  the kernel don't work
well after apply the patch [1]
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5ce5674187c345dc31534d2024c09ad8ef29b7ba


Zhang Yi <yi.zhang@huaweicloud.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=BA=8C 13:05=E5=86=99=E9=81=93=EF=BC=9A

>
> On 2024/5/20 19:48, Guangwu Zhang wrote:
> > Hi,
> > I get a xfs error when run xfstests  generic/461 testing with
> > linux-block for-next branch.
> > looks it easy to reproduce with s390x arch.
> >
> > kernel info :
> > commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
> > 6.9.0+
> > reproducer
> > git clone xfstests
> >  ./check generic/461
> >
> >
>
> I guess this issue should be fixed by 5ce5674187c3 ("xfs: convert delayed
> extents to unwritten when zeroing post eof blocks"), please merge this co=
mmit
> series (include 4 patches) and try again.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D5ce5674187c345dc31534d2024c09ad8ef29b7ba
>
> Yi.
>
> > [ 5322.046654] XFS (loop1): Internal error isnullstartblock(got.br_star=
tblock) a
> > t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_insert_e=
xtents+0x
> > 2ee/0x420 [xfs]
> > [ 5322.046859] CPU: 0 PID: 157526 Comm: fsstress Kdump: loaded Not tain=
ted 6.9.0
> > + #1
> > [ 5322.046863] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
> > [ 5322.046864] Call Trace:
> > [ 5322.046866]  [<0000022f504d8fc4>] dump_stack_lvl+0x8c/0xb0
> > [ 5322.046876]  [<0000022ed00fc308>] xfs_corruption_error+0x70/0xa0 [xf=
s]
> > [ 5322.046955]  [<0000022ed00b7206>] xfs_bmap_insert_extents+0x3fe/0x42=
0 [xfs]
> > [ 5322.047024]  [<0000022ed00f55a6>] xfs_insert_file_space+0x1be/0x248 =
[xfs]
> > [ 5322.047105]  [<0000022ed00ff1dc>] xfs_file_fallocate+0x244/0x400 [xf=
s]
> > [ 5322.047186]  [<0000022f4fe90000>] vfs_fallocate+0x218/0x338
> > [ 5322.047190]  [<0000022f4fe9112e>] ksys_fallocate+0x56/0x98
> > [ 5322.047193]  [<0000022f4fe911aa>] __s390x_sys_fallocate+0x3a/0x48
> > [ 5322.047196]  [<0000022f505019d2>] __do_syscall+0x23a/0x2c0
> > [ 5322.047200]  [<0000022f50511d20>] system_call+0x70/0x98
> > [ 5322.054644] XFS (loop1): Corruption detected. Unmount and run xfs_re=
pair
> > [ 5322.977488] XFS (loop1): User initiated shutdown received.
> > [ 5322.977505] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goin=
gdown+0xb
> > 4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
> > [ 5322.977772] XFS (loop1): Please unmount the filesystem and rectify t=
he proble
> > m(s)
> > [ 5322.977877] loop1: writeback error on inode 755831, offset 32768, se=
ctor 1804
> > 712
> > 00:00:00
> >
> >
> > .
> >
>
>


--
Guangwu Zhang
Thanks

