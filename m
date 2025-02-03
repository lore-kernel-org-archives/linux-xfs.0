Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BEF20F09D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738618906; cv=none; b=M/IIzmCzfexvqjeYadkfQMKxLAbcpVhU6Od2nNxhNy7S9T5uSk9sV/bULbibD/A32XLKq9zbUdiQPFou1Z97KpUOlGgihT1G4osbBqK5HFrcgHR+OI+JD6aI69TYtxZN+ZpzeTA/05KnuvI47IOg/7LjcHIwqO+oOno0p0lygKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738618906; c=relaxed/simple;
	bh=C/fAeZ5TjmlI2KBA/ql0cvqz3EukqX062ySDXg862Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mlzrq5ne/SZ/y4ht61Yf3e+y0ac7mEIh/8u0fmiw+0HDvq7fRFWtM4tRZoK7+FpRqJXoOVM1gvx+pOuXZx+vLjiUwi00059RK+cJqU5IQiU9q043HMb+0Srq+v1E53wCcHvEayWczu99K95VSD+nxnhuSleJezMJHV+s1LdG6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFheXVUu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFheXVUu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738618903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fedZlQnodJAwktFWZrs8j+jy0xji0943zmwbFDXd7UQ=;
	b=AFheXVUucl48oFIrB3sfTzXBUp/jxos/mpxmb9xE6O2mE2/BvFQTKHG/t2dH/rkuvMkyHo
	c7vAl1M8zV9AYy5Y3ELp9ndNu6P61L9qkkLgfoguzrneDFSS7TODZnc4da4CsLckfmT465
	awuV52mUklOMnbFpD5CbL4Ayjlv8lww=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-F-BmywQPPhm2MWL2kjFANg-1; Mon, 03 Feb 2025 16:41:40 -0500
X-MC-Unique: F-BmywQPPhm2MWL2kjFANg-1
X-Mimecast-MFC-AGG-ID: F-BmywQPPhm2MWL2kjFANg
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844e255c111so27731539f.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 13:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738618899; x=1739223699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fedZlQnodJAwktFWZrs8j+jy0xji0943zmwbFDXd7UQ=;
        b=cSsu76ZWQYp6RPPWRxbBc0NixHqEeK/p6geD5u5GKEHv9o2vsWcQZqbqylH/5v9LDI
         gX/dTptxrlr4TY87FOdWleYElVQLneIV2bFqj3DvP8TW9y+PoOcjmme+VbYE7riDCPFf
         bmxle4Lyli5j2Fepk3FNVCiGmDJH/1kDCridKqmqhhMHNte2xEGXj/3KAj0NAAQaWCAM
         eDZU6yiTt00+xC7BbjYCR+V5cGKz0Ie1kYWFd7wwcnm9bYGm5VnpNC0vwz7PoF3rwo2H
         r2Btv7xrwQQyfC3VXIs/86t6qg+qfEnfrfKPXvgPd+tjZRiEueLK+r1D8NwuHS6pD5QE
         ZH1w==
X-Forwarded-Encrypted: i=1; AJvYcCUxVkJiFpZezXEYCsxwn12jtPwhWYMZ0XdW/YULjWZUYu/zAJugbQ1IRlcb7HQrwBgEvBhhJwjA9H8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu84LTQrlkXhR7el2zdB6r2K1/oU8hgVWeTd6zLZmQZMwFk3UJ
	M1xcP3uTNcEkeGHetRo/qTxa7W7MllqHNrlbvdo0C1nL0dVM6SpArfw6RlBgqtE7Z2+J/J3c6fE
	TNsnwEKRh3/CAYFMEimNJ5XLKLTq5kz8RZ2o22VNdsnQ/xrjeMje9PhDK/Q==
X-Gm-Gg: ASbGncv94pb9ENwvWrCHbF8JTkGisz3F22QRtmHeRSo9D4BeUgwv9wG+1EgG/Cpxyil
	8tJJce+Bqkj1Apwd+XoDYIN1sRME/Y2aLuly8dkgr2ecmzBrX/YyuYM+LzsoGXC8RlBlHbul0bp
	hksvR8I8ANpL3JycxZPKvt3VP0F29UmXdjFbLIu6pk/N2aIPBOQXGScj7PVIVLPShIcslUPLxwN
	jJ6N5b4B+FfN0F4IC/YtHD5OqQoGWklAxgwptPEuRCD1q98hnHbLMk8YEz0qJWs8QDjTBH7ctA+
	M9kOwA74
X-Received: by 2002:a05:6602:6082:b0:84a:51e2:9f79 with SMTP id ca18e2360f4ac-854dd94f875mr40832239f.2.1738618899336;
        Mon, 03 Feb 2025 13:41:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYIf7YEdjPvXGZacVgVVZyr+JMryxDDsVGKfxamFm+EdtMLtHIq0nEP3iBHBmyVlkBf0g9sw==
X-Received: by 2002:a05:6602:6082:b0:84a:51e2:9f79 with SMTP id ca18e2360f4ac-854dd94f875mr40831539f.2.1738618898981;
        Mon, 03 Feb 2025 13:41:38 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7469ef2dsm2425558173.97.2025.02.03.13.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 13:41:38 -0800 (PST)
Date: Mon, 3 Feb 2025 14:41:35 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, Linus
 Torvalds <torvalds@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
 linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults
 for files with pre content watches
Message-ID: <20250203144135.1caef6c3.alex.williamson@redhat.com>
In-Reply-To: <CAOQ4uxg63JR2jsy_xA63Zkh_6wzsy_2c30Z_05kZ=cHsRC_UzQ@mail.gmail.com>
References: <cover.1731684329.git.josef@toxicpanda.com>
	<9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
	<20250131121703.1e4d00a7.alex.williamson@redhat.com>
	<CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
	<Z512mt1hmX5Jg7iH@x1.local>
	<20250201-legehennen-klopfen-2ab140dc0422@brauner>
	<CAHk-=wi2pThSVY=zhO=ZKxViBj5QCRX-=AS2+rVknQgJnHXDFg@mail.gmail.com>
	<CAOQ4uxjVTir-mmx05zh231BpEN1XbXpooscZyfNUYmVj32-d3w@mail.gmail.com>
	<20250202-abbauen-meerrettich-912513202ce4@brauner>
	<l5apiabdjosyy4gfuenr4oqdfio3zdiajzxoekdgtsohzpn3mj@dcmvayncbye4>
	<CAOQ4uxg63JR2jsy_xA63Zkh_6wzsy_2c30Z_05kZ=cHsRC_UzQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Feb 2025 21:39:27 +0100
Amir Goldstein <amir73il@gmail.com> wrote:

> On Mon, Feb 3, 2025 at 1:41=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> >
> > On Sun 02-02-25 11:04:02, Christian Brauner wrote: =20
> > > On Sun, Feb 02, 2025 at 08:46:21AM +0100, Amir Goldstein wrote: =20
> > > > On Sun, Feb 2, 2025 at 1:58=E2=80=AFAM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote: =20
> > > > >
> > > > > On Sat, 1 Feb 2025 at 06:38, Christian Brauner <brauner@kernel.or=
g> wrote: =20
> > > > > >
> > > > > > Ok, but those "device fds" aren't really device fds in the sens=
e that
> > > > > > they are character fds. They are regular files afaict from:
> > > > > >
> > > > > > vfio_device_open_file(struct vfio_device *device)
> > > > > >
> > > > > > (Well, it's actually worse as anon_inode_getfile() files don't =
have any
> > > > > > mode at all but that's beside the point.)?
> > > > > >
> > > > > > In any case, I think you're right that such files would (accide=
ntly?)
> > > > > > qualify for content watches afaict. So at least that should pro=
bably get
> > > > > > FMODE_NONOTIFY. =20
> > > > >
> > > > > Hmm. Can we just make all anon_inodes do that? I don't think you =
can
> > > > > sanely have pre-content watches on anon-inodes, since you can't r=
eally
> > > > > have access to them to _set_ the content watch from outside anywa=
y..
> > > > >
> > > > > In fact, maybe do it in alloc_file_pseudo()?
> > > > > =20
> > > >
> > > > The problem is that we cannot set FMODE_NONOTIFY -
> > > > we tried that once but it regressed some workloads watching
> > > > write on pipe fd or something. =20
> > >
> > > Ok, that might be true. But I would assume that most users of
> > > alloc_file_pseudo() or the anonymous inode infrastructure will not ca=
re
> > > about fanotify events. I would not go for a separate helper. It'd be
> > > nice to keep the number of file allocation functions low.
> > >
> > > I'd rather have the subsystems that want it explicitly opt-in to
> > > fanotify watches, i.e., remove FMODE_NONOTIFY. Because right now we h=
ave
> > > broken fanotify support for e.g., nsfs already. So make the subsystems
> > > think about whether they actually want to support it. =20
> >
> > Agreed, that would be a saner default.
> > =20
> > > I would disqualify all anonymous inodes and see what actually does
> > > break. I naively suspect that almost no one uses anonymous inodes +
> > > fanotify. I'd be very surprised.
> > >
> > > I'm currently traveling (see you later btw) but from a very cursory
> > > reading I would naively suspect the following:
> > >
> > > // Suspects for FMODE_NONOTIFY
> > > drivers/dma-buf/dma-buf.c:      file =3D alloc_file_pseudo(inode, dma=
_buf_mnt, "dmabuf",
> > > drivers/misc/cxl/api.c: file =3D alloc_file_pseudo(inode, cxl_vfs_mou=
nt, name,
> > > drivers/scsi/cxlflash/ocxl_hw.c:        file =3D alloc_file_pseudo(in=
ode, ocxlflash_vfs_mount, name,
> > > fs/anon_inodes.c:       file =3D alloc_file_pseudo(inode, anon_inode_=
mnt, name,
> > > fs/hugetlbfs/inode.c:           file =3D alloc_file_pseudo(inode, mnt=
, name, O_RDWR,
> > > kernel/bpf/token.c:     file =3D alloc_file_pseudo(inode, path.mnt, B=
PF_TOKEN_INODE_NAME, O_RDWR, &bpf_token_fops);
> > > mm/secretmem.c: file =3D alloc_file_pseudo(inode, secretmem_mnt, "sec=
retmem",
> > > block/bdev.c:   bdev_file =3D alloc_file_pseudo_noaccount(BD_INODE(bd=
ev),
> > > drivers/tty/pty.c: static int ptmx_open(struct inode *inode, struct f=
ile *filp)
> > >
> > > // Suspects for ~FMODE_NONOTIFY
> > > fs/aio.c:       file =3D alloc_file_pseudo(inode, aio_mnt, "[aio]", =
=20
> >
> > This is just a helper file for managing aio context so I don't think any
> > notification makes sense there (events are not well defined). So I'd say
> > FMODE_NONOTIFY here as well.
> > =20
> > > fs/pipe.c:      f =3D alloc_file_pseudo(inode, pipe_mnt, "",
> > > mm/shmem.c:             res =3D alloc_file_pseudo(inode, mnt, name, O=
_RDWR, =20
> >
> > This is actually used for stuff like IPC SEM where notification doesn't
> > make sense. It's also used when mmapping /dev/zero but that struct file
> > isn't easily accessible to userspace so overall I'd say this should be
> > FMODE_NONOTIFY as well. =20
>=20
> I think there is another code path that the audit missed for getting these
> pseudo files not via alloc_file_pseudo():
> ipc/shm.c:      file =3D alloc_file_clone(base, f_flags,
>=20
> which does not copy f_mode as far as I can tell.
>=20
> > =20
> > > // Unsure:
> > > fs/nfs/nfs4file.c:      filep =3D alloc_file_pseudo(r_ino, ss_mnt, re=
ad_name, O_RDONLY, =20
> >
> > AFAICS this struct file is for copy offload and doesn't leave the kerne=
l.
> > Hence FMODE_NONOTIFY should be fine.
> > =20
> > > net/socket.c:   file =3D alloc_file_pseudo(SOCK_INODE(sock), sock_mnt=
, dname, =20
> >
> > In this case I think we need to be careful. It's a similar case as pipe=
s so
> > probably we should use ~FMODE_NONOTIFY here from pure caution.
> > =20
>=20
> I tried this approach with patch:
> "fsnotify: disable notification by default for all pseudo files"
>=20
> But I also added another patch:
> "fsnotify: disable pre-content and permission events by default"
>=20
> So that code paths that we missed such as alloc_file_clone()
> will not have pre-content events enabled.
>=20
> Alex,
>=20
> Can you please try this branch:
>=20
> https://github.com/amir73il/linux/commits/fsnotify-fixes/
>=20
> and verify that it fixes your issue.
>=20
> The branch contains one prep patch:
> "fsnotify: use accessor to set FMODE_NONOTIFY_*"
> and two independent Fixes patches.
>=20
> Assuming that it fixes your issue, can you please test each of the
> Fixes patches individually, because every one of them should be fixing
> the issue independently and every one of them could break something,
> so we may end up reverting it later on.

Test #1:

fsnotify: disable pre-content and permission events by default
fsnotify: disable notification by default for all pseudo files
fsnotify: use accessor to set FMODE_NONOTIFY_*

Result: Pass, vfio-pci huge_fault observed

Test #2:

fsnotify: disable notification by default for all pseudo files
fsnotify: use accessor to set FMODE_NONOTIFY_*

Result: Pass, vfio-pci huge_fault observed

Test #3:

fsnotify: disable pre-content and permission events by default
fsnotify: use accessor to set FMODE_NONOTIFY_*

Result: Pass, vfio-pci huge_fault observed

Test #4 (control):

fsnotify: use accessor to set FMODE_NONOTIFY_*

Result: Fail, no vfio-pci huge_fault observed

For any combination of the Fixes patches:

Tested-by: Alex Williamson <alex.williamson@redhat.com>

Thanks!
Alex

