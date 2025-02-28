Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554F1F3FDC
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740731447; cv=none; b=JLzfrXELp7cqSts/CW+rNd3Gin/FhLL7CJ7YcrP3dWmN5RtFAUwvADYv4AqiqZpVVflqRshXxx+70tJtlac9yCQo7lThTFfg3Tm2d95zSgfeDDXlxHSy0ZC9Xws1ePoon6WDxvn845mQmfy4Yh4VIDJViAB6F0u34xbxOtnidfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740731447; c=relaxed/simple;
	bh=9JRh0vQu00gcGDgHvqANg3ZiBZ1ZNLJx8nUj+BWm9B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qORW3uxUQRM0OuDZnK2tbROo2Nmw6KOF7P1tA7R/qJ9jJwSxLaSYT83vBDaEEO3+dg4OLa4w3p/DBmSJJhLzEMlK1kEkyJHs4B9gX2cZtR7pbIvJ6Ij2KrFD9zD1jr+ZwY4UUSJofzF7K2ql1wrVlaLJk1u4SSXYNKiw4PyGZBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dui1sz6N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dui1sz6N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740731445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IAk7T/agbjQFnKEBQSUNnzMrHpjZ/FADtSxLOMcXTqc=;
	b=Dui1sz6NBA52u2gWpD/Jv+g8u440V4PvsD6EoEGuq/Ll7p0AYhpNTwHGVZ96KDS+MCI+BG
	nmnAyQoBXTSDiRxAIUUEvXikd9FOA3L2GXJvbWFiKg9SGqjwySmg1KmYFUCquaqftV+Poi
	qhHzNfOdmnFIGCJUrXcO88GNm+YxEdg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-MUXZ2Zt6Moq_96i2Td60ZA-1; Fri, 28 Feb 2025 03:30:43 -0500
X-MC-Unique: MUXZ2Zt6Moq_96i2Td60ZA-1
X-Mimecast-MFC-AGG-ID: MUXZ2Zt6Moq_96i2Td60ZA_1740731442
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-abbae81829fso205035966b.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 00:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740731442; x=1741336242;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IAk7T/agbjQFnKEBQSUNnzMrHpjZ/FADtSxLOMcXTqc=;
        b=MF+2QwCvhDfNyDQLOMaKAUrt/PD2TYkNWtPcGfpljfbfliO8mDgQ+ZO3UXUC5kwjMe
         RY1B9JJQ0syh0jK1G3cfFgpHZLhbuYVRQ3fdP3YP0qs5KIcZt0YRl3g96QR74L073L2g
         jAxq+4t/aZasENbyyeShpnRMlD/lFd1mjDIYp03AkVpn7/nglaACI+VhQpRnVOLCcEgw
         /6unBt3Yc8xjZXBjBoUY0q+HhVEv8c3Zhp5fl7t5zGlAtZ5mCg3pZMCDjz7zX2SjwpBQ
         A7MOyUqBro468v5zwxrHXo+dzk/0ieqPVA3t21fufhu+fJ74HBDTXB3QJNa9EVU03EHX
         7AvA==
X-Forwarded-Encrypted: i=1; AJvYcCU6CKR15j0OvLFgwvKBKDhFGjaAb1LsSUg9+NL/HNDpuv206+ogO22AchVA9YrkkN1hk1TALGyc5Vk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBd/rsHoMi2WDsKYbD0/Oqm3odbVfYOby/RMlrO46qU9qZ8oa0
	p1U5i6r+JAMrFcGQSIMRLe5/0RppdW8KSMSc80uu7ozdTXq7UC3n9eWoXwGG0nIMy3gptS4A0Ze
	7NeYAu7/7CwsTbQZ5BBZ3jf7Y4RuQ/5f35Hx80lz9kJ3nm6QoQe5md1vD
X-Gm-Gg: ASbGncs5Xow0PqomP15Z2nS+PdHTPOFbMQnHT7lIqK+HzfYGICwq1a2g7PtJyZJ+qiU
	L1Ppm5y1Bkb6S0TOlaQukQWLvIaKCI1G0bYLC4gMYHVNm+HQi6KJgGmNOkuFKNhavCQWoylUx2T
	cPOzWjElMHOysYmjvt+COBqxIuOjm1y9dSJcozjqbbKLbBWhdwkWB4Zl4pVxrnVJ/Ed841aHi6P
	ylVbxnABb5kxAyvq2FIkDrmwa1ISqQu8XZog+K1a6XsIGTPSEUquRR0oKJilqbyvUlvWSd/sJlP
	ovMqaNXx/tdhv27901icI7uXxv23EPL5A8A=
X-Received: by 2002:a17:907:2d08:b0:abf:22cd:9a7e with SMTP id a640c23a62f3a-abf261f5471mr234888066b.30.1740731441857;
        Fri, 28 Feb 2025 00:30:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZIWf4Mi/ez8uccBE3ejxNf0ox83n9Aynget7e7VbyIxs4sY20lz/2ANqi9H9OCRURVdUpFw==
X-Received: by 2002:a17:907:2d08:b0:abf:22cd:9a7e with SMTP id a640c23a62f3a-abf261f5471mr234884766b.30.1740731441289;
        Fri, 28 Feb 2025 00:30:41 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c74c714sm254400566b.124.2025.02.28.00.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 00:30:40 -0800 (PST)
Date: Fri, 28 Feb 2025 09:30:38 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Michal Simek <monstr@monstr.eu>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3] fs: introduce getfsxattrat and setfsxattrat syscalls
Message-ID: <ihkez5xfcuocis7cmipvts2vxnfan2ub5kcpvsrnzm37glwnax@nxp72byvetye>
References: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
 <20250221181135.GW21808@frogsfrogsfrogs>
 <CAOQ4uxgyYBFqkq6cQsso4LxJsPJ4uECOdskXmz-nmGhhV5BQWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgyYBFqkq6cQsso4LxJsPJ4uECOdskXmz-nmGhhV5BQWg@mail.gmail.com>

On 2025-02-21 20:15:24, Amir Goldstein wrote:
> On Fri, Feb 21, 2025 at 7:13 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Feb 11, 2025 at 06:22:47PM +0100, Andrey Albershteyn wrote:
> > > From: Andrey Albershteyn <aalbersh@redhat.com>
> > >
> > > Introduce getfsxattrat and setfsxattrat syscalls to manipulate inode
> > > extended attributes/flags. The syscalls take parent directory fd and
> > > path to the child together with struct fsxattr.
> > >
> > > This is an alternative to FS_IOC_FSSETXATTR ioctl with a difference
> > > that file don't need to be open as we can reference it with a path
> > > instead of fd. By having this we can manipulated inode extended
> > > attributes not only on regular files but also on special ones. This
> > > is not possible with FS_IOC_FSSETXATTR ioctl as with special files
> > > we can not call ioctl() directly on the filesystem inode using fd.
> > >
> > > This patch adds two new syscalls which allows userspace to get/set
> > > extended inode attributes on special files by using parent directory
> > > and a path - *at() like syscall.
> > >
> > > Also, as vfs_fileattr_set() is now will be called on special files
> > > too, let's forbid any other attributes except projid and nextents
> > > (symlink can have an extent).
> > >
> > > CC: linux-api@vger.kernel.org
> > > CC: linux-fsdevel@vger.kernel.org
> > > CC: linux-xfs@vger.kernel.org
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > > v1:
> > > https://lore.kernel.org/linuxppc-dev/20250109174540.893098-1-aalbersh@kernel.org/
> > >
> > > Previous discussion:
> > > https://lore.kernel.org/linux-xfs/20240520164624.665269-2-aalbersh@redhat.com/
> > >
> > > XFS has project quotas which could be attached to a directory. All
> > > new inodes in these directories inherit project ID set on parent
> > > directory.
> > >
> > > The project is created from userspace by opening and calling
> > > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > > files such as FIFO, SOCK, BLK etc. Therefore, some inodes are left
> > > with empty project ID. Those inodes then are not shown in the quota
> > > accounting but still exist in the directory. Moreover, in the case
> > > when special files are created in the directory with already
> > > existing project quota, these inode inherit extended attributes.
> > > This than leaves them with these attributes without the possibility
> > > to clear them out. This, in turn, prevents userspace from
> > > re-creating quota project on these existing files.
> > > ---
> > > Changes in v3:
> > > - Remove unnecessary "dfd is dir" check as it checked in user_path_at()
> > > - Remove unnecessary "same filesystem" check
> > > - Use CLASS() instead of directly calling fdget/fdput
> > > - Link to v2: https://lore.kernel.org/r/20250122-xattrat-syscall-v2-1-5b360d4fbcb2@kernel.org
> > > ---
> > >  arch/alpha/kernel/syscalls/syscall.tbl      |  2 +
> > >  arch/arm/tools/syscall.tbl                  |  2 +
> > >  arch/arm64/tools/syscall_32.tbl             |  2 +
> > >  arch/m68k/kernel/syscalls/syscall.tbl       |  2 +
> > >  arch/microblaze/kernel/syscalls/syscall.tbl |  2 +
> > >  arch/mips/kernel/syscalls/syscall_n32.tbl   |  2 +
> > >  arch/mips/kernel/syscalls/syscall_n64.tbl   |  2 +
> > >  arch/mips/kernel/syscalls/syscall_o32.tbl   |  2 +
> > >  arch/parisc/kernel/syscalls/syscall.tbl     |  2 +
> > >  arch/powerpc/kernel/syscalls/syscall.tbl    |  2 +
> > >  arch/s390/kernel/syscalls/syscall.tbl       |  2 +
> > >  arch/sh/kernel/syscalls/syscall.tbl         |  2 +
> > >  arch/sparc/kernel/syscalls/syscall.tbl      |  2 +
> > >  arch/x86/entry/syscalls/syscall_32.tbl      |  2 +
> > >  arch/x86/entry/syscalls/syscall_64.tbl      |  2 +
> > >  arch/xtensa/kernel/syscalls/syscall.tbl     |  2 +
> > >  fs/inode.c                                  | 75 +++++++++++++++++++++++++++++
> > >  fs/ioctl.c                                  | 16 +++++-
> > >  include/linux/fileattr.h                    |  1 +
> > >  include/linux/syscalls.h                    |  4 ++
> > >  include/uapi/asm-generic/unistd.h           |  8 ++-
> > >  21 files changed, 133 insertions(+), 3 deletions(-)
> > >
> >
> > <cut to the syscall definitions>
> >
> > > diff --git a/fs/inode.c b/fs/inode.c
> > > index 6b4c77268fc0ecace4ac78a9ca777fbffc277f4a..b2dddd9db4fabaf67a6cbf541a86978b290411ec 100644
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -23,6 +23,9 @@
> > >  #include <linux/rw_hint.h>
> > >  #include <linux/seq_file.h>
> > >  #include <linux/debugfs.h>
> > > +#include <linux/syscalls.h>
> > > +#include <linux/fileattr.h>
> > > +#include <linux/namei.h>
> > >  #include <trace/events/writeback.h>
> > >  #define CREATE_TRACE_POINTS
> > >  #include <trace/events/timestamp.h>
> > > @@ -2953,3 +2956,75 @@ umode_t mode_strip_sgid(struct mnt_idmap *idmap,
> > >       return mode & ~S_ISGID;
> > >  }
> > >  EXPORT_SYMBOL(mode_strip_sgid);
> > > +
> > > +SYSCALL_DEFINE4(getfsxattrat, int, dfd, const char __user *, filename,
> > > +             struct fsxattr __user *, fsx, unsigned int, at_flags)
> >
> > Should the kernel require userspace to pass the size of the fsx buffer?
> > That way we avoid needing to rev the interface when we decide to grow
> > the structure.
> >
> 
> This makes sense to me, but I see that Andreas proposed other ways,
> as long as we have a plan on how to extend the struct if we need more space.
> 
> Andrey, I am sorry to bring this up in v3, but I would like to request
> two small changes before merging this API.
> 
> This patch by Pali [1] adds fsx_xflags_mask for the filesystem to
> report the supported set of xflags.
> 
> It was argued that we can make this change with the existing ioctl,
> because it is not going to break xfs_io -c lsattr/chattr, which is fine,
> but I think that we should merge the fsx_xflags_mask change along
> with getfsxattrat() which is a new UAPI.
> 
> The second request is related to setfsxattrat().
> With current FS_IOC_FSSETXATTR, IIUC, xfs ignores unsupported
> fsx_xflags. I think this needs to be fixed before merging setfsxattrat().
> It's ok that a program calling FS_IOC_FSSETXATTR will not know
> if unsupported flags will be ignored, because that's the way it is,
> but I think that setfsxattrat() must return -EINVAL for trying to
> set unsupported xflags.
> 
> As I explained in [2] I think it is fine if FS_IOC_FSSETXATTR
> will also start returning -EINVAL for unsupported flags, but I would
> like setfsxattrat() to make that a guarantee.
> 
> There was an open question, what does fsx_xflags_mask mean
> for setfsxattrat() - it is a mask like in inode_set_flags() as Andreas
> suggested? I think that would be a good idea.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kernel.org/
> [2] https://lore.kernel.org/linux-fsdevel/CAOQ4uxjwQJiKAqyjEmKUnq-VihyeSsxyEy2F+J38NXwrAXurFQ@mail.gmail.com/
> 

I'm fine with making Pali's patchset a dependency for this syscall,
as if vfs_fileattr_set() will start returning EINVAL on unsupported
flags this syscall will pass it through (ioctls will need to ignore
it). And as these syscalls use fsxattr anyway the fsx_xflags_mask
field will be here.

-- 
- Andrey

