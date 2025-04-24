Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3254728E61D
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 17:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516715; cv=none; b=eeaI+SpEMA7IgwCf1r+Wy46Cea3u3Rb2exrkRBBp5ltWmppwrrWgGd8AobxE9+aaubbbliBis2Yz1chX+AM2TUE25h10H6p9GMv9qgXtb0J33raJulanj05cR59+VR5Sel9HL7idmrI/1v2Vn7WkDwxKEtzvVUtDkF+Rkkjgdg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516715; c=relaxed/simple;
	bh=nuhY4mNQtbqLil9CN9WkICD/oYDC6db0CLuLTFGNXWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmT4ZOD/NMz85PhIh94r58yDbyCs+VLVgiCT8ilfyrrXD+Im8cVBkUUDwl7nFYtr43kOMC51ZuNAcFOshsVnuZk16dzu76lP118Uu7zfbTzJRHWk77DA2Gc6LaMeWRrFeZxQKelG3P+Z/ygTqtqKVlBqobZ3uoVHWJbEY4ANeQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=an/xVS7j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="an/xVS7j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745516711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSMzO6fx79vdlfqdO8dlMyzHm6+/LG9Oml+3X61fg04=;
	b=an/xVS7j6EwyHG3LmIL6j2+DtJAsAThNylH1GGZj6KjbGaII7K38BOBooxJjXnXZzAGMGU
	dPXg1uYZ7HZFAwmRaV9SruWMQlv2mniP2hwHwjTJaUPYtfEOu2QFRoVD4LCjLQw4b6l9br
	8+uRDxoAuUQIJ79T7ajAWIaaxhl8Xy0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-yHfDOeIgNpC0eXvJXa6a_Q-1; Thu, 24 Apr 2025 13:45:10 -0400
X-MC-Unique: yHfDOeIgNpC0eXvJXa6a_Q-1
X-Mimecast-MFC-AGG-ID: yHfDOeIgNpC0eXvJXa6a_Q_1745516709
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac6ef2d1b7dso123606166b.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 10:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516709; x=1746121509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSMzO6fx79vdlfqdO8dlMyzHm6+/LG9Oml+3X61fg04=;
        b=FLjPIBNc+Km8svVptwOBiFXW2BTLpWQ/RrUPQTf2vs8YCIuEPQxDHSHTdXKGaeXcT7
         rXBipkQUNH5HmIoLbjhOoRHFS5xoks+zXwB+v3AwwWaAtb2X7sM9PYG2OUQSetCkXtNF
         ioS/2KY40vcg6+WMDBlSiq8NRz9qtBzd20Y4B/bDhlWizMy6v2I1sDCaMIKM8MEFz4n4
         fT9reP5BNOPxzg9JdPukU1KqK1u6vh/bbeAhYN/4NHwacFrgQFYH8Oa1Dcokbvz3QMJP
         /6+HTDx0oQuM3QQDHHGoC+vTbJRiVeW5TZrQz7lnPyAAoXeYu7c5Y5An21Q1XCcM76U9
         zbAA==
X-Forwarded-Encrypted: i=1; AJvYcCWaB+OORazbzgwG/culVbG2jU0+zait72sZA7NbkeSHXAKLtwAGc2n54rvRJcA+yCDHKA92F0QGu3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX6eUoarGVA8vwab/aYt8XxA4paTkuS4bt+Ln7zFkgQ7Fqw6Os
	Y04nrx5xREtQksylkJuKAqcCdINX70903Qvz5U1nKB/5v3LdW9DW1Vuz7fWpiwsGXP/crT5F/2m
	dtjIBl57iaXmeKaYAzRz6FTrb7LvQyuK/FBa4eZaKz8kJUUuSFpVDJTSn
X-Gm-Gg: ASbGncun/i8YvmRJPxmLoN/wXW10V0O3UZqTfAHnP7+z9nliLanavKWgSRuGSjNK+Jz
	Pc6KtaxyDtwWqiIRS4NQoYsmXQsRvSX7XtKGJJoeuzsMAQi8nCCcI+MMHw8U1i5579puy/mYWE/
	ItIrRuR1KXrKnTAteqYhpSgtkIUdTWlQH2SxavkvQRUfVvMDzPiZqtEDLZ0WRWL5cEODvOLe0zu
	zEXFRXDopsoJO5boHwqlzaPmPr+CrLR0kJQrHgXPb75fCv7jxBd342xmcHFxOmojxNxDJzQuZMN
	eLXcF2HUgjjkCuH7qNvaZlO2zMlojF4=
X-Received: by 2002:a17:907:9412:b0:acb:3a0d:8a82 with SMTP id a640c23a62f3a-ace6b450a49mr51592366b.32.1745516708714;
        Thu, 24 Apr 2025 10:45:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTh+3uHoEBQ4GmOFk2Iro9cQNDST88N03Da5siOmOBhQ6S/NryZGUQ9nV3zdizG2WhZyWkCg==
X-Received: by 2002:a17:907:9412:b0:acb:3a0d:8a82 with SMTP id a640c23a62f3a-ace6b450a49mr51586866b.32.1745516708167;
        Thu, 24 Apr 2025 10:45:08 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace5989b173sm140418466b.59.2025.04.24.10.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:45:07 -0700 (PDT)
Date: Thu, 24 Apr 2025 19:45:06 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, 
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
	Alexander Viro <viro@zeniv.linux.org.uk>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] fs: introduce getfsxattrat and setfsxattrat
 syscalls
Message-ID: <oprhbm2vcqpveaf6smetfl2zacntntzqlakysys73zx3gnougi@zy7bo43bh5ef>
References: <20250321-xattrat-syscall-v4-0-3e82e6fb3264@kernel.org>
 <20250321-xattrat-syscall-v4-3-3e82e6fb3264@kernel.org>
 <20250422-abbekommen-begierde-bcf48dd74a2e@brauner>
 <rbzlwvecvrp4xawwp5nywdq6wp5hgjhrtrabpszv74xmfqbj4f@x7v6eqfc5gcd>
 <20250424-zuspielen-luxus-3d49b600c3bf@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-zuspielen-luxus-3d49b600c3bf@brauner>

On 2025-04-24 11:06:07, Christian Brauner wrote:
> On Wed, Apr 23, 2025 at 11:53:25AM +0200, Jan Kara wrote:
> > On Tue 22-04-25 16:59:02, Christian Brauner wrote:
> > > On Fri, Mar 21, 2025 at 08:48:42PM +0100, Andrey Albershteyn wrote:
> > > > From: Andrey Albershteyn <aalbersh@redhat.com>
> > > > 
> > > > Introduce getfsxattrat and setfsxattrat syscalls to manipulate inode
> > > > extended attributes/flags. The syscalls take parent directory fd and
> > > > path to the child together with struct fsxattr.
> > > > 
> > > > This is an alternative to FS_IOC_FSSETXATTR ioctl with a difference
> > > > that file don't need to be open as we can reference it with a path
> > > > instead of fd. By having this we can manipulated inode extended
> > > > attributes not only on regular files but also on special ones. This
> > > > is not possible with FS_IOC_FSSETXATTR ioctl as with special files
> > > > we can not call ioctl() directly on the filesystem inode using fd.
> > > > 
> > > > This patch adds two new syscalls which allows userspace to get/set
> > > > extended inode attributes on special files by using parent directory
> > > > and a path - *at() like syscall.
> > > > 
> > > > CC: linux-api@vger.kernel.org
> > > > CC: linux-fsdevel@vger.kernel.org
> > > > CC: linux-xfs@vger.kernel.org
> > > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ...
> > > > +		struct fsxattr __user *, ufsx, size_t, usize,
> > > > +		unsigned int, at_flags)
> > > > +{
> > > > +	struct fileattr fa = {};
> > > > +	struct path filepath;
> > > > +	int error;
> > > > +	unsigned int lookup_flags = 0;
> > > > +	struct filename *name;
> > > > +	struct fsxattr fsx = {};
> > > > +
> > > > +	BUILD_BUG_ON(sizeof(struct fsxattr) < FSXATTR_SIZE_VER0);
> > > > +	BUILD_BUG_ON(sizeof(struct fsxattr) != FSXATTR_SIZE_LATEST);
> > > > +
> > > > +	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!(at_flags & AT_SYMLINK_NOFOLLOW))
> > > > +		lookup_flags |= LOOKUP_FOLLOW;
> > > > +
> > > > +	if (at_flags & AT_EMPTY_PATH)
> > > > +		lookup_flags |= LOOKUP_EMPTY;
> > > > +
> > > > +	if (usize > PAGE_SIZE)
> > > > +		return -E2BIG;
> > > > +
> > > > +	if (usize < FSXATTR_SIZE_VER0)
> > > > +		return -EINVAL;
> > > > +
> > > > +	name = getname_maybe_null(filename, at_flags);
> > > > +	if (!name) {
> > > 
> > > This is broken as it doesn't handle AT_FDCWD correctly. You need:
> > > 
> > >         name = getname_maybe_null(filename, at_flags);
> > >         if (IS_ERR(name))
> > >                 return PTR_ERR(name);
> > > 
> > >         if (!name && dfd >= 0) {
> > > 		CLASS(fd, f)(dfd);
> > 
> > Ah, you're indeed right that if dfd == AT_FDCWD and filename == NULL, the
> > we should operate on cwd but we'd bail with error here. I've missed that
> > during my review. But as far as I've checked the same bug is there in
> > path_setxattrat() and path_getxattrat() so we should fix this there as
> > well?
> 
> Yes, please!
> 

Thanks for the review, Christian. I will fix issues you noticed as
suggested. I see that Jan already sent fix for path_[s|g]etxattrat()
so won't do anything here.

-- 
- Andrey

