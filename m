Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742B22571A7;
	Tue, 25 Feb 2025 10:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740480076; cv=none; b=PcHBbI1PtHL4R2LsvS7VPeq1viRGs7JmHK98DYPU/voDh++w+Mm8XgjD0PHTJOUt0934uvwoJxy6u6tX89cJj/S9i6ldDTJX2hTqr8Y4IkLR1dOmAVN6toDrBkaUcqNJbWdivTj99ZNRuyFt8Q7B5oIh6QJRHRFeQpuVtMPbiUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740480076; c=relaxed/simple;
	bh=xfJ/tP0KEVZjgcjFjGNS5v96EkfIzgw/9MuCJaXzLxo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=N+ay1xIM6w7I9QjzqrVupHlzD+ndteWugvZJxZLjxUboINNt6BKFkiXRyq73dJTa29KnHUomDBW1JU/KV81x7jQo5Ms4uSQk8ZrpBj2cygiaMAAULlyZf7cqonjWeptsbLLR1HbpkM9SZkDyrHgobstDVnSvEZxe7UQ5FsmZ8Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=YRAOnS/c; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xYJ+d1Fr; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="YRAOnS/c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xYJ+d1Fr"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 330931140170;
	Tue, 25 Feb 2025 05:41:13 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-11.internal (MEProxy); Tue, 25 Feb 2025 05:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1740480073;
	 x=1740566473; bh=XK5p1hiUrczS04SoL3Bp/F/Lh9UgXsKum/DNMyd+O3I=; b=
	YRAOnS/cOhKHCb+4ca0IAWi3KJFDBREkZ2qcoygOv1HMG1SLa5588O+iusUmmMbi
	n0M/PIFNq4zqpAv02VwgFa2/wubxXbUTw+jxBfwuyT4az2Fd9g1tkjqMA0M0SkW3
	DXQ6zC+8UHazZqpXwede2UrazztdKDjpPZPrWpt3uRhUeqYp7vxvvQvcHYEqdxqr
	dFwX156KF+Hl748+Ocm6D4J7OrHuDqpLVytqIdP/5eIcyKisqYO8oLazic8WrMAA
	mDlK0mlbBWdLzNBWeTzZzeNDmyxIMEU2jrUK3TIZIju7fTmFP9LDBxTzNCa7QDBD
	x2dlr6hrBjs402Cykes1zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740480073; x=
	1740566473; bh=XK5p1hiUrczS04SoL3Bp/F/Lh9UgXsKum/DNMyd+O3I=; b=x
	YJ+d1FrrIBUEILprE50UlwbTW4sKoTbF7BBO6sgYiM/KklC6dZ9ymgwyvu+ni8K8
	dTqXeJ7f7969oNDeFKHygGouF/NMUGFOqDFcB0162y+q24PrB0WgUmCzMlIJ7MF/
	h/bM5PJJps014S9byjVQOkRUVG36A9Rb03J6OsPyshN9WsmzMAAjz1WrgscY5uwB
	YLYjob1v76ntNmOgVglHXQrn4ppLkR8g3X06wkZhIEySQ/nHeyBTiEvxAmFKhb5q
	qlUeYdztQ3SFxAFylM5jIjqUuK9v+nwwOBrdj3WZHzzWOROSyZrf3JihIHOKkOwH
	07MoNaFGH68OU9ju8v04A==
X-ME-Sender: <xms:SJ69Z81GqBcLM4hsetqYTlJgdIQFmGaQxhbcUMQHAX2kX7YPIdFhHw>
    <xme:SJ69Z3FvNJVhQQuPkj52Ilj9Kl4zDw6UcBpJLOVRDLbCwNeq_Zzr_70plAXUMa2fn
    AtFW-fhdxRQIJxcbcU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdekudegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeel
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhprghrihhstgesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhsfeeltdesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhsvggtuhhrihhthi
    dqmhhoughulhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqshhhsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqgi
    hfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsphgrrhgtlhhinhhu
    giesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegthhhrihhsseiirghnkh
    gvlhdrnhgvthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdr
    uhhkpdhrtghpthhtohephhhprgesiiihthhorhdrtghomh
X-ME-Proxy: <xmx:SJ69Z05R_1Q9aAMUWUqHuLikg8BPRcHasxJT8B1OsaCV-gOVwjma1g>
    <xmx:SJ69Z10ejXDYBcYfJO6-cbfwWTjSRF8yos_qtOf6oqvojgI2SWhQ0Q>
    <xmx:SJ69Z_E_XZWB6Q1O3LlPD7izsLXEPWITFarUoirOeEw-5lQinKbNTA>
    <xmx:SJ69Z-9bOdHdq51zhiiFoaT8wNlvXdFBDVlqjceE4KupUSZadE9DbQ>
    <xmx:SZ69Z1YpfeIAURN4DhwLxlH9VgAYEigI9scCHan7avsJu1MBGaQXePLo>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 82A852220072; Tue, 25 Feb 2025 05:41:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 25 Feb 2025 11:40:51 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Amir Goldstein" <amir73il@gmail.com>,
 "Andrey Albershteyn" <aalbersh@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>,
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
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-api@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-xfs@vger.kernel.org, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 "Theodore Ts'o" <tytso@mit.edu>
Message-Id: <3c860dc0-ba8d-4324-b286-c160b7d8d2c4@app.fastmail.com>
In-Reply-To: <20250225-strom-kopflos-32062347cd13@brauner>
References: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
 <20250221181135.GW21808@frogsfrogsfrogs>
 <CAOQ4uxgyYBFqkq6cQsso4LxJsPJ4uECOdskXmz-nmGhhV5BQWg@mail.gmail.com>
 <20250224-klinke-hochdekoriert-3f6be89005a8@brauner>
 <6b51ffa2-9d67-4466-865e-e703c1243352@app.fastmail.com>
 <20250225-strom-kopflos-32062347cd13@brauner>
Subject: Re: [PATCH v3] fs: introduce getfsxattrat and setfsxattrat syscalls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Feb 25, 2025, at 11:22, Christian Brauner wrote:
> On Tue, Feb 25, 2025 at 09:02:04AM +0100, Arnd Bergmann wrote:
>> On Mon, Feb 24, 2025, at 12:32, Christian Brauner wrote:
>> 
>> The ioctl interface relies on the existing behavior, see
>> 0a6eab8bd4e0 ("vfs: support FS_XFLAG_COWEXTSIZE and get/set of
>> CoW extent size hint") for how it was previously extended
>> with an optional flag/word. I think that is fine for the syscall
>> as well, but should be properly documented since it is different
>> from how most syscalls work.
>
> If we're doing a new system call I see no reason to limit us to a
> pre-existing structure or structure layout.

Obviously we could create a new structure, but I also see no
reason to do so. The existing ioctl interface was added in
in 2002 as part of linux-2.5.35 with 16 bytes of padding, half
of which have been used so far.

If this structure works for another 23 years before we run out
of spare bytes, I think that's good enough. Building in an
incompatible way to handle potential future contents would
just make it harder to use for any userspace that wants to
use the new syscalls but still needs a fallback to the
ioctl version.

     Arnd
