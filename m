Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA43C2741C4
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747952773; cv=none; b=oEuumTrYc/u+DLMZZNWE0uQwcPKUq5vqWIRg2Cz+y4jJtSztGnpWm5CJcRE92Tr83Lza+hXgJFaTbHZqJ9yJ+kyTS/JHVKyIarTE7XRke7y3YDFL2+MmfsBOsyLU67Xxy8zQz5P+OZYUoMd9qBt+wp/lpUtntp+11AEUH9LWWQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747952773; c=relaxed/simple;
	bh=ERIIFgKxrnPwjSVA6jXYtUfeYroUqJBM9v+L48OiIjw=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=n/TYlbqhtAhHnNNN7y4e5fEz+enBoJliVs4c2u/6Df4ZqnrECK9/uZK2iYEwka++6WmswR48HzdRQDYr4KaFLfEK/2+d7CiMkcRVQoJ2ldyF2yRnFn09+P36PvlY6aPqvoJ+V1HdtEuUdwCJJ4AqpK4rFPcm9JGWiQLZtDFhw+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ToVMF8Pc; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ToVMF8Pc"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c542ffec37so948106285a.2
        for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 15:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1747952768; x=1748557568; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yW4BwrWRPMGZw+m/ri6EFRKCjP4k+SeXSk6ZWrWvJiA=;
        b=ToVMF8PcVy37DRcyydOqAzRtU8MIfxnsQYcyTujtaPP+6rNuh10GiSxHl8BpEOL7Vl
         xP549yj/DsBJfMi3qCROE0CjVVteyRyHylhdLw04oGcxRiQntTqkGaj0qxDt91en7Yaf
         k+SmxoaFBB+G/5sErCk+bkQleUrTH6XQJe2p+LIipbvb4fbPmu1wnSD2q+VMoi0xxJsW
         gaMrvrcaiHSnHiky9rJUvXODz2114Xg3/bkQmKiZIEtphocJflv5aC1cQ1XzMR2q+5M1
         e5C3pB8Uc+2bJywG7HLAABdlrHUZ45rP3ykqZkmL5ezlodK/YayNjCLBFI5pn3kcMbPH
         Giow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747952768; x=1748557568;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yW4BwrWRPMGZw+m/ri6EFRKCjP4k+SeXSk6ZWrWvJiA=;
        b=F2PNSXlUcwLYRGnzX9KYG/sGQXIL2uhHqnWYy3/NNVN5K7rRCPkRAqZPiuSpp7MvLx
         bG5WWyFV81iJa8CPiQAWwVrAD6zBe9qmWqCvzS3aeDAX/awV19/YmXJKHGYx+Ot/Mia5
         8M4gZvjM30CkHeOt70+LnKfaDUg4Nmshz9H72JFguD2d8KFmhIm/e91HUWmC33fIyhJS
         6GJAhzlIfke6fRSbUgL0dzLpRIn/HUCxPFV7LsETywLLuyruTjAlprO3exi9hrt1rwZn
         kLQkVplSoqlKCWTOaaqNfjcNVDCmGTMmTE3xyLeL/MLR6L2L+2ECEVg5YUteN8u9jNm5
         WzuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYn5+iUFu0ga3uy1D5o9tnsObpgn39s5SmsX3S7eM1E7aOoain65UlyfBMBNgermb299dGF/TOo2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfK0PsAKZxxY/M/JvFZBOqmvo89+q5ub0pHxh1xUCskvAdc5i7
	V9lG/Ar4RVkYZ27I3vqd1wolIQOFapGC1gUqbL5XP5NGN9LYqIG7xZBTJOhdnLrbLA==
X-Gm-Gg: ASbGncvtjikAGHPvfLftPGrcfguv1I6o+O3FMbrMi1gbRsAN8zAqwDN6d8DZ+4FS49L
	Ei0N1+MHNx0UsuhzBrIFh6P3gBt8hG86tKmxZ4dXJHOkTuaw6VjmMBNVdinpBlk87BQV5Zg+s4N
	bd0/eYfGVon2gvG4xnURZ5nL0cUQlPc+CClM7CvmW0O+XONwvVfCCVVUlRBARwLD5evbHA42mZZ
	W2pU/q9FT9QSuv/CGC44fJiDYaXzTvEUvwJYRoQLX3EB9bZjmWOT751O0RoA98MpKRuy8F0VtyH
	mdw1LtY08ufkRcjX+yt2VFMz+njD3hjlkei/PPpCCU4JtwwVtAIV20dNejREmW9VlRp+7ScWSnH
	NkcJ+NCT586iybZnGDG0d
X-Google-Smtp-Source: AGHT+IHmIlyqjG6e3vdHM+wi0UqPbDaDdVTY/IdBlClNAbyXhci/B2Ul0PB2ozu0sL7+1EWeTaPM2w==
X-Received: by 2002:a05:620a:408e:b0:7ce:d352:668f with SMTP id af79cd13be357-7ced352670emr1334278485a.47.1747952768087;
        Thu, 22 May 2025 15:26:08 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7cd468b69dfsm1089029585a.79.2025.05.22.15.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 15:26:07 -0700 (PDT)
Date: Thu, 22 May 2025 18:26:07 -0400
Message-ID: <8bf36078ef8f3e884a1d3d8415834680@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20250522_1740/pstg-lib:20250522_1730/pstg-pwork:20250522_1740
From: Paul Moore <paul@paul-moore.com>
To: Andrey Albershteyn <aalbersh@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Tyler Hicks <code@tyhicks.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, selinux@vger.kernel.org, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v5 3/7] selinux: implement inode_file_[g|s]etattr hooks
References: <20250513-xattrat-syscall-v5-3-22bb9c6c767f@kernel.org>
In-Reply-To: <20250513-xattrat-syscall-v5-3-22bb9c6c767f@kernel.org>

On May 13, 2025 Andrey Albershteyn <aalbersh@redhat.com> wrote:
> 
> These hooks are called on inode extended attribute retrieval/change.
> 
> Cc: selinux@vger.kernel.org
> Cc: Paul Moore <paul@paul-moore.com>
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  security/selinux/hooks.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Acked-by: Paul Moore <paul@paul-moore.com>

--
paul-moore.com
