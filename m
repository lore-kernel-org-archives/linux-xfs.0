Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1CC267F4E;
	Tue, 11 Feb 2025 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739301867; cv=none; b=hIwEYhyeVLe2XYTVALrhruYWp7tRHIqZvfvw+Sc/hw6KTP8recxu6TobJzk4jauAbd9LocuvxffeC7PnOrfZzmdodXbgugv1bwGhg3w1rZiyQBKct+1TaxnRhg1gx2TgqM2cdi3eVSPOrZOBcLpcjvSwsPCdY4EtTOdgki4vvSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739301867; c=relaxed/simple;
	bh=c3d2vNEaLKWV5MP/R/ATr1E1H0RvMwxHYf1Cp5qlV3I=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Nla1km1WvPDrH5QY9q2OXM8nHmOzVJu5ZJyVLTA+hXjv1amQ8EaF/GRDElg+gzF+lTzPMjXhm8cBg+3eKeRQhjeXl4wk6dPR8IJYG4MQDerGPYJVDkPrRYSHnH4B1m5p0Xwd4V1incQfBvyeB6dniKVZYyWpIeW/8uXZNRFPbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=ymfhP0lW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ommBzpk+; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="ymfhP0lW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ommBzpk+"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2D05911401CB;
	Tue, 11 Feb 2025 14:24:24 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Tue, 11 Feb 2025 14:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1739301864;
	 x=1739388264; bh=c3d2vNEaLKWV5MP/R/ATr1E1H0RvMwxHYf1Cp5qlV3I=; b=
	ymfhP0lWFnruH6o3PlWj4VEX4QrXdMxvUy7kxrWyyD8mMENQyn/vLNmodJRw/3xq
	Omk028RmEf41WjgvyzWOAu/AfMPPsintWTjNI74AkpxwwMvZKmKfcHPIhjKvC3DJ
	97yK0QGLE5VIh48ThNS55BNOAsqK0PwFwASgnamzQ6fw6BsiAuRRbV65Q+CbzH7/
	jusO1PuR1RfNZ2fGcB6FVzh3z6ZEmWLLi2s/tutocUhmy8q/s2Avq+GzKJprHyJS
	/4ftJpOWt0eWs9HRG0XQpRWhabmHL73YqFv3yBMSFIHmbrtOUR7bmIDZ1zNYwz5H
	+N9o8FnJ4P3CsNsjoP7TnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1739301864; x=
	1739388264; bh=c3d2vNEaLKWV5MP/R/ATr1E1H0RvMwxHYf1Cp5qlV3I=; b=o
	mmBzpk+/yYw5E+45xbH1XxyEJJsdrId5cufG2ZsIL7jptyYyQs+SStXqDYbtEro4
	4gRO1kL4bM9PsyxghVCr/HBSoZ+4QQOl1h0DtmR/Pt9vHyNjj6wmVUoawgbBNZCj
	2wCEwZ9RRJxaz3AOcxm9PoVEEdZosAsztxgJWFcL3Ir5bwlSelXvRYxms0HuVlXf
	5wfhYEk2q6J6FzYV8zScDrOAl2aiDPCj9AphSRsdALL2fD0hEZEOHOXPEz48fK6A
	j+GlKy7VWJ82O5+ReyX2gAhuGN8wCoArCorCLmlfSDtau1bYlzvD7qIa81u6CM6L
	MevptyIHLlfWt6D+5sZzw==
X-ME-Sender: <xms:56OrZ35fmlgQspCET-mmihyL-weUnVlPuoCZwasWS1xXMcaxOWKWmw>
    <xme:56OrZ874o_-Fn0a8noveZxvP1odRydiwhJI8EwFuilSFGZEdmKSjdPIm9CsyetRM0
    7hse0vS9ZPSDxKHkg0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegudekfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeeh
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhprghrtghlihhnuhigsehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheptghhrhhishesiigrnhhkvghlrdhnvghtpd
    hrtghpthhtohepvhhirhhoseiivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprhgtphht
    thhopehhphgrseiihihtohhrrdgtohhm
X-ME-Proxy: <xmx:56OrZ-dboiOXOyiwtEA0fs-voQa90FN_SYp_LvAiX52d9RvECiLkGQ>
    <xmx:56OrZ4IXilq7f6fEV9RrulAGNF0Q8Q7FlKvS0fM4MyN9bCAbnu9p-Q>
    <xmx:56OrZ7KSBkLEZBF0vQ2oId6Gbm5JxDsGhW79Z6Z5m0PP-zMLG3suWA>
    <xmx:56OrZxz-lh27awnRcQM6JBgbeuIDaM54vvjMzyGPcZk-05oX4y6KFQ>
    <xmx:6KOrZ4G2STdlXeRTSnIWJhIgK_S9TIyt1tJ2WrQ6YRSXg2Sp_JW_QRcF>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6103B2220072; Tue, 11 Feb 2025 14:24:23 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 11 Feb 2025 20:24:02 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrey Albershteyn" <aalbersh@redhat.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 "Matt Turner" <mattst88@gmail.com>,
 "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Michal Simek" <monstr@monstr.eu>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Helge Deller" <deller@gmx.de>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Naveen N Rao" <naveen@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>,
 "Rich Felker" <dalias@libc.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Andy Lutomirski" <luto@kernel.org>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Chris Zankel" <chris@zankel.net>,
 "Max Filippov" <jcmvbkbc@gmail.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-api@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-xfs@vger.kernel.org
Message-Id: <f4276a02-57cd-4703-be3c-4210e4a033a9@app.fastmail.com>
In-Reply-To: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
References: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
Subject: Re: [PATCH v3] fs: introduce getfsxattrat and setfsxattrat syscalls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Feb 11, 2025, at 18:22, Andrey Albershteyn wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
>
> Introduce getfsxattrat and setfsxattrat syscalls to manipulate inode
> extended attributes/flags. The syscalls take parent directory fd and
> path to the child together with struct fsxattr.
>
> This is an alternative to FS_IOC_FSSETXATTR ioctl with a difference
> that file don't need to be open as we can reference it with a path
> instead of fd. By having this we can manipulated inode extended
> attributes not only on regular files but also on special ones. This
> is not possible with FS_IOC_FSSETXATTR ioctl as with special files
> we can not call ioctl() directly on the filesystem inode using fd.
>
> This patch adds two new syscalls which allows userspace to get/set
> extended inode attributes on special files by using parent directory
> and a path - *at() like syscall.
>
> Also, as vfs_fileattr_set() is now will be called on special files
> too, let's forbid any other attributes except projid and nextents
> (symlink can have an extent).
>
> CC: linux-api@vger.kernel.org
> CC: linux-fsdevel@vger.kernel.org
> CC: linux-xfs@vger.kernel.org
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

I checked the syscall.tbl additions and the ABI to ensure that
it follows the usual guidelines and is portable across
all architectures, this looks good. Thanks for addressing
my v1 comments:

Acked-by: Arnd Bergmann <arnd@arndb.de>

Disclaimer: I have no idea if the new syscalls are a good
idea or if they are fit for the purpose, I trust the
VFS maintainers will take care of reviewing that.
