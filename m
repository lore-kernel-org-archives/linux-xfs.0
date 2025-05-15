Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD328151B
	for <linux-xfs@vger.kernel.org>; Thu, 15 May 2025 07:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747295454; cv=none; b=BzCbH8LwE5V7zd+bnzc32oweZHx7nbf5CmkJexAVj/TH4zHDj4DWp5RDHjyiTceDfgHgZQOzQPuWaLJlDj0piBB2XjHKN3LRG+jy5n6s0oz2RL3nDVEAuURHPMApMWybmqfYQeSY7LsfXpd5VEoahshJR/nRbBsunTDT+phcAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747295454; c=relaxed/simple;
	bh=SI+pTvA0hGOAcmdfuFDmY5RUnGs6yiJiGIIQYLSqKL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQqsBKQ4aBQinUdyqRaiOrKBRiVY0Rmttp+/kMYQM4jplK9gg7rrZTDrvI53902SYFmqCNBZE+W4nkmNtDjSKjeHHcnIUleunxdqJRBbPrpsLNQnHL1SrO0vUBNzhnN9puaD2sFmZlmw4kEmuJaXXWRiFFnaoHN2nMguN8wDqI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DldQMFxA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DldQMFxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747295451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIYznBp1zKy3fmdyZZzgeQrbk2pRjSVKo51V0MhaZng=;
	b=DldQMFxAavsg8G6TXoVVzdQa+2B794I131t+XgoYaxCKxDAQYCHlulxQDOnwSl4Kdp6FWG
	Hm336+SU9Dbp4kS8vMUh/okrik/tFSZb8Jw+n+l2Jks824r6QI69jpgaPRq3AQhm9NkDpK
	PQgNhUxK4Q95QzZDFFqJDlBvxSMNwyc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-Khp5u5lVOxCEZXZAiqFQ3Q-1; Thu, 15 May 2025 03:50:49 -0400
X-MC-Unique: Khp5u5lVOxCEZXZAiqFQ3Q-1
X-Mimecast-MFC-AGG-ID: Khp5u5lVOxCEZXZAiqFQ3Q_1747295448
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ad4d7d9e7b4so54546566b.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 May 2025 00:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747295448; x=1747900248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIYznBp1zKy3fmdyZZzgeQrbk2pRjSVKo51V0MhaZng=;
        b=UzPGOWhtoSA4GUa0xUBhliUH1RsFt2ILKj9fMbjCKAc5rWFoh8mw7hWtr8cgcuKJHN
         tGabgLFYOsBbOQj2lYpXfEAmyxv38IUgWDEyg2lX6TT89WDmphcetdgiqkXIcZmL+uFZ
         qFfgQOvJ5liZbChUfcf+RvR2PhOKZ5GbklHUm6SKYOQ1BW6955xVUbo8AM6aVMklGD+/
         aPGnGeaLcjyqYPh+P759ymNjV/R/30CI2pk67CjhJSw8e03yeUWDVsK0JDyEVF8RomS5
         VSTrWDkI2aEE+mHW39Lc4Ecj8IqSttgp+KXHL+Belws04djBRR4B8CZaG7gSvHebaX0d
         vkCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbHt2NtN5EjHa/sXSw9WImyNw9HvqQ5eyKfNqR+5UxynUZvtzgLnsUg07cQscg2rLc9kCMM8L2isA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX0onuiJIyqhbfVSbDXfTDCBfNWv5M9ZsMMEmGa0MrzTVugGye
	1u15hzMWGzzO4V0t0kUj2PgTyiMBsc0mB2pQ1GEnIg3eFxGgIPl6OJ6DOSMAMPtuDeINK9puL/6
	i6lZNg1gNPhSYQw7710Yrz6tzdDkJw8pTNU2BFECS1njbvaoUUInibA58
X-Gm-Gg: ASbGncuXpZ+8Ra4C2FcU26bwe/oUEVI5+BMF3eBW46GDKbKc3hpxKnKb6s6R2GCrayb
	gDsPdy1Dqg3oVmRxzCBaY0J1/sF2fJ+LsiA19zzM1auBhXyfYgqJHOOCbl0FPchnbX8Ite7MpVw
	PSxpBBNVz6gneNZJRlbYWC8X6EQmWVuErW875EJQzVvPEX7oR6dqy3K6k45VEDb3sBoE0X28V7X
	qPJBnEOE6a5Xps3lMzmGA/ZJoEVZuWQl2c4QQMEEpiMXQlsy2dXytaC7Jn7WMOLz+WtioNe0tNB
	EPLeRmFzzPrsld8N9rieGTZ2r5od75U678fesswW
X-Received: by 2002:a17:907:6e8f:b0:ad4:f6d2:431b with SMTP id a640c23a62f3a-ad51601e1edmr114984866b.44.1747295448304;
        Thu, 15 May 2025 00:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWr4fWklZ0eQ07tSCt/uJX+ZC5LZkXrxcbvUbmkmojzea9n6Ige7V0auLmvx+BHm+IbBk77A==
X-Received: by 2002:a17:907:6e8f:b0:ad4:f6d2:431b with SMTP id a640c23a62f3a-ad51601e1edmr114976966b.44.1747295447688;
        Thu, 15 May 2025 00:50:47 -0700 (PDT)
Received: from thinky (109-92-26-237.static.isp.telekom.rs. [109.92.26.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad224531152sm984378866b.38.2025.05.15.00.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 00:50:47 -0700 (PDT)
Date: Thu, 15 May 2025 09:50:44 +0200
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
Message-ID: <5jtjzgfgyjkw5oiofp2npp5zwib4rdp24u6lwmfctvmxo742vz@5wi6latt74lb>
References: <20250512-xattrat-syscall-v5-0-4cd6821e8ff7@kernel.org>
 <20250512-xattrat-syscall-v5-2-4cd6821e8ff7@kernel.org>
 <f700845d-f332-4336-a441-08f98cd7f075@schaufler-ca.com>
 <kgl5h2iruqnhmad65sonlvneu6mdj6jl3sd4aoc3us3lvrgviy@imce27t4nk2e>
 <cb737e58-51ab-4918-b5ba-2c18bf1ad601@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb737e58-51ab-4918-b5ba-2c18bf1ad601@schaufler-ca.com>

On 2025-05-14 11:21:46, Casey Schaufler wrote:
> On 5/14/2025 4:02 AM, Andrey Albershteyn wrote:
> > On 2025-05-12 08:43:32, Casey Schaufler wrote:
> >> On 5/12/2025 6:25 AM, Andrey Albershteyn wrote:
> >>> Introduce new hooks for setting and getting filesystem extended
> >>> attributes on inode (FS_IOC_FSGETXATTR).
> >>>
> >>> Cc: selinux@vger.kernel.org
> >>> Cc: Paul Moore <paul@paul-moore.com>
> >>>
> >>> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> >>> ---
> >>>  fs/file_attr.c                | 19 ++++++++++++++++---
> >>>  include/linux/lsm_hook_defs.h |  2 ++
> >>>  include/linux/security.h      | 16 ++++++++++++++++
> >>>  security/security.c           | 30 ++++++++++++++++++++++++++++++
> >>>  4 files changed, 64 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >>> index 2910b7047721..be62d97cc444 100644
> >>> --- a/fs/file_attr.c
> >>> +++ b/fs/file_attr.c
> >>> @@ -76,10 +76,15 @@ EXPORT_SYMBOL(fileattr_fill_flags);
> >>>  int vfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
> >>>  {
> >>>  	struct inode *inode = d_inode(dentry);
> >>> +	int error;
> >>>  
> >>>  	if (!inode->i_op->fileattr_get)
> >>>  		return -ENOIOCTLCMD;
> >>>  
> >>> +	error = security_inode_file_getattr(dentry, fa);
> >>> +	if (error)
> >>> +		return error;
> >>> +
> >> If you're changing VFS behavior to depend on LSMs supporting the new
> >> hooks I'm concerned about the impact it will have on the LSMs that you
> >> haven't supplied hooks for. Have you tested these changes with anything
> >> besides SELinux?
> > Sorry, this thread is incomplete, I've resent full patchset again.
> > If you have any further comments please comment in that thread [1]
> >
> > I haven't tested with anything except SELinux, but I suppose if
> > module won't register any hooks, then security_inode_file_*() will
> > return 0. Reverting SELinux implementation of the hooks doesn't
> > cause any errors.
> >
> > I'm not that familiar with LSMs/selinux and its codebase, if you can
> > recommend what need to be tested while adding new hooks, I will try
> > to do that for next revision.
> 
> At a minimum the Smack testsuite:
> 	https://github.com/smack-team/smack-testsuite.git
> And the audit suite:
> 	https://github.com/linux-audit/audit-testsuite.git
> 
> AppArmor has a suite as well, but I'm not sure where is resides.

Well, I thought about something more specific, I know about these
testsuites

> 
> My primary concern is that you're making changes that remove existing
> hook calls and add new hook calls without verifying that the protections
> provided by the old calls are always also provided by the new ones.

I'm only adding new hooks, ioctls weren't calling any hooks.

-- 
- Andrey

