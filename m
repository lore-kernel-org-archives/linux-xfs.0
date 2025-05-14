Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04A8272E79
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220558; cv=none; b=c0z/hX3RURCkth9XoLs7mX2eMZ4GfepngjEmlW7bHVyvEbUViYiHCjTnX5J3N/zZNFuLQYzN3Ffe6hucLk+5IAedgIovmkSCDT/948onF6wkDloarX3HSI14eqpFJa0Ne3GiHYAtXZR/IGdUyQVX6yrirngPiKie6jFeIlMAPls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220558; c=relaxed/simple;
	bh=g6FsWqajrTcVSIHknD3zeLY9flfbWnzSw3aQFZLECpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=misX1YmGskmQS4shiBI1NYHhOkIiNcmSIhhk0eTG2L8DBHtelYJ6nlBdffFb5H6NTQq+Id/ZTbgaQEoLXUQzeq07cpBWtTmhQu0IACV4eqqnu0AWKlKBlHJxoSEbo1eDwTZO+7YAB7qwTkL74tHy2n9qOLdRFmBZqILKjPfgq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmDo9w0y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmDo9w0y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747220553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cav3Z4NY5VTBc23C/qTtaVoA8kEGEB5wAcjksldNIvE=;
	b=MmDo9w0yz1Kn3sjpYTSSjD4KrGMy642rX6NeyGw0BXVGUAJtLpNr/jiSCs78/k6kPmZONb
	1RW8FgVKyn4Xti1ZjFxpWYaJxj2Tcu+wyggyg2xIC+GcF3d775HpKZpGvBXNYkmv52waPk
	mrns9bc03aeESHAE3VEXBSgaL59QP5U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-krhJMw-FPvidGEHn9ve1oQ-1; Wed, 14 May 2025 07:02:32 -0400
X-MC-Unique: krhJMw-FPvidGEHn9ve1oQ-1
X-Mimecast-MFC-AGG-ID: krhJMw-FPvidGEHn9ve1oQ_1747220551
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5fbeee46e51so6846704a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 04:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747220551; x=1747825351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cav3Z4NY5VTBc23C/qTtaVoA8kEGEB5wAcjksldNIvE=;
        b=fm290CKHjRJ4JcEPCmooafjqRmPl+XsMbU01rlaDrM5hROLfQdIC2kdMjV+1uCyiQB
         BWxTSRry61lG68HtudxT8oVgaKl7wrMQt0LIArK+DSd4Q6acaIj7BA0VVkOkfnC8mBdu
         w+diO6d13dn+r/ypzngn5lhCmgw1ad1XljDYh091Ob5I0Rds/fpgS5vKf4OFP2gAb0Sl
         hiaveQij9ob0q67Q2Rog5uT9ijWr+tIwV6FZIJMMH0jXTvG9xArUQxl/AQa/7IBH71LT
         VSGouuMeYO9roCHQ0clLjYfcqFUF68uQHvSn8EPUP1OUxsCN25bYQnFW+nRE80mWCExA
         +W7g==
X-Forwarded-Encrypted: i=1; AJvYcCUrUYFxP9QkrIIlbYoDU9Y1DD82bjSPO57QL0MyPcfVZnq1zaom8iFuDgCKYsK+mR+RoAR0VJuIr78=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1NKjbZbUufw2CarXUgvgI1ATzVxhd2ZvJQwzr37F49gtye50k
	WqipFdNUsLiGnxtv/FQeBRkuZDNRFb7ou3pqWH2Z91Ll2LKr3jmuUDk49xPr+hswsRM8/uFcDMV
	6DBypTT1mU7KqCi7FHjStI+ljdFxl2cB39sXJzXoR32C6HqvJQNoUclnA
X-Gm-Gg: ASbGncvoqD/z84xiQVEX/HhHCEQKW0uXJKFWf8qrrpT4MP/Ww2qg7jA1ARMxdg/xen/
	FdcdjUw9ZdIGwH5TGfYi7PiXwqFRdNLr3N+hnOkul6xShXfmWc63oE+xJB7Rcvi1agjWc5gJIbQ
	ShbRkZwQMIwJJPzDsLuw/ZWGRG5ULKBv0pgUqWvqCtHubVJIodlqjf2/Bd/Ck2LtR6ZpaeKZOg2
	NXVMiWpLzxHZnm+WM8qgdrIWr7Nlgrj7HEpZsloUhobnWFf0OS1lCyDwmSm0/znhutipZThgZ7y
	UQ==
X-Received: by 2002:a05:6402:234d:b0:5f4:ade4:88c5 with SMTP id 4fb4d7f45d1cf-5ff988dd135mr2082919a12.34.1747220550914;
        Wed, 14 May 2025 04:02:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEs3ORoNcv9GW9V4gupozuqWmYmwSxEEUINo5zQzLXzCm36ngPWceLYKaaZhwPfqmrqY5iYdA==
X-Received: by 2002:a05:6402:234d:b0:5f4:ade4:88c5 with SMTP id 4fb4d7f45d1cf-5ff988dd135mr2082854a12.34.1747220550339;
        Wed, 14 May 2025 04:02:30 -0700 (PDT)
Received: from thinky ([2a0e:fd87:a051:1:e664:4a86:4c01:c774])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fe43357d45sm4879817a12.54.2025.05.14.04.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 04:02:29 -0700 (PDT)
Date: Wed, 14 May 2025 13:02:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Tyler Hicks <code@tyhicks.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	selinux@vger.kernel.org, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v5 2/7] lsm: introduce new hooks for setting/getting
 inode fsxattr
Message-ID: <kgl5h2iruqnhmad65sonlvneu6mdj6jl3sd4aoc3us3lvrgviy@imce27t4nk2e>
References: <20250512-xattrat-syscall-v5-0-4cd6821e8ff7@kernel.org>
 <20250512-xattrat-syscall-v5-2-4cd6821e8ff7@kernel.org>
 <f700845d-f332-4336-a441-08f98cd7f075@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f700845d-f332-4336-a441-08f98cd7f075@schaufler-ca.com>

On 2025-05-12 08:43:32, Casey Schaufler wrote:
> On 5/12/2025 6:25 AM, Andrey Albershteyn wrote:
> > Introduce new hooks for setting and getting filesystem extended
> > attributes on inode (FS_IOC_FSGETXATTR).
> >
> > Cc: selinux@vger.kernel.org
> > Cc: Paul Moore <paul@paul-moore.com>
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/file_attr.c                | 19 ++++++++++++++++---
> >  include/linux/lsm_hook_defs.h |  2 ++
> >  include/linux/security.h      | 16 ++++++++++++++++
> >  security/security.c           | 30 ++++++++++++++++++++++++++++++
> >  4 files changed, 64 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/file_attr.c b/fs/file_attr.c
> > index 2910b7047721..be62d97cc444 100644
> > --- a/fs/file_attr.c
> > +++ b/fs/file_attr.c
> > @@ -76,10 +76,15 @@ EXPORT_SYMBOL(fileattr_fill_flags);
> >  int vfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
> >  {
> >  	struct inode *inode = d_inode(dentry);
> > +	int error;
> >  
> >  	if (!inode->i_op->fileattr_get)
> >  		return -ENOIOCTLCMD;
> >  
> > +	error = security_inode_file_getattr(dentry, fa);
> > +	if (error)
> > +		return error;
> > +
> 
> If you're changing VFS behavior to depend on LSMs supporting the new
> hooks I'm concerned about the impact it will have on the LSMs that you
> haven't supplied hooks for. Have you tested these changes with anything
> besides SELinux?

Sorry, this thread is incomplete, I've resent full patchset again.
If you have any further comments please comment in that thread [1]

I haven't tested with anything except SELinux, but I suppose if
module won't register any hooks, then security_inode_file_*() will
return 0. Reverting SELinux implementation of the hooks doesn't
cause any errors.

I'm not that familiar with LSMs/selinux and its codebase, if you can
recommend what need to be tested while adding new hooks, I will try
to do that for next revision.

[1]: https://lore.kernel.org/linux-fsdevel/CAOQ4uxgOAxg7N1OUJfb1KMp7oWOfN=KV9Lzz6ZrX0=XRGOQrEQ@mail.gmail.com/T/#t

-- 
- Andrey

