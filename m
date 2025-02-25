Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFA0175AB;
	Tue, 25 Feb 2025 08:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740470549; cv=none; b=Rcn35Vi3VY1+31SnyR03mehixi1ZIpJKLWQhqyFnjGQYPWVks/qAM4PqXHsD0KpY8PXbKj8PqPqVhzlYXF/elRf+NDrE3nRnp77Z8QIDyzSOwvXJBaLFyfaimWYuiccO64NUS/AziMkgCOTM+8LbsPDsdhytaGHIhoxPLElK1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740470549; c=relaxed/simple;
	bh=k1leRad2ojzsetmQP/1iyqy9qsl2R22cOQijt9+MijA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DOa6TMYbP80Q3wOIzdfyumBQbYG+Zvm10PbYdxhCqvBbLNl3TBZiD7muCnmvieuSSJrHjOZ0SonUn0iOkvKCfY+dSKFquvdB49n3V0sbBHEIPPU3a8V2So8GmY4bbvPr9NFIuq6lP92qM8GkUrw9agePxToRUTFs6SXxz+BDsJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Tf4Iq+/9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=0oq0By6m; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Tf4Iq+/9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0oq0By6m"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7807F25400DE;
	Tue, 25 Feb 2025 03:02:25 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-11.internal (MEProxy); Tue, 25 Feb 2025 03:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1740470545;
	 x=1740556945; bh=QLBFywS7XyTxwPOejQif6z/28yCPC+NOlxqp7jJivgU=; b=
	Tf4Iq+/9FoptMoOc1nTy4f6BZj5gOhOcHoeGz30LIjaqvtSeOkmVD7cvZMxvxaA2
	C9FBCps0jhTV8mON4YGxKlQQ/DY4j4gq9DUn1hR2wvSW5+19TSRIcaMVQnxs7z+Q
	Q1HcJJh3jNBnqM2g+zF8oI3aFNpbxiOH8NGYi0hG/Tsx4Vo2LnTecLS9dUkLnCzJ
	74Yb04cjHm0WnoPvdKmEs8JDZAl6Twpc1+JcHw49CuY9i8rfJPipD/KnX2GeHqmh
	6zMbMYf1tfnXdqi5OEQYJO0JZX7GElIIEjGwSJXzbRLOOUSlGuA+8Z0oUg6et+Gj
	Ng4DzlsI+jxT8GyIZSf33g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740470545; x=
	1740556945; bh=QLBFywS7XyTxwPOejQif6z/28yCPC+NOlxqp7jJivgU=; b=0
	oq0By6mJ5NU9t94eHHbBWd1S57H/FNY4h6Bf/tNIyl/sv61I5hgg19F78zcR1V43
	M3R9Xa+Mivuoj2un/03HKLXJzxOIou5DdoZVSSxmeIoeGOnqxBI7Ki5IyrBIXr5e
	MvY4WS7T0N63bm+7VZyHgSKpsH2hX4B10irHEd53mymzHZHRBmOA4aEaY0CsZBQO
	1JVeT1A4iBzZDn4ZwkdfhyTfGrCrzwWNURnZbh1+Xv7XvgnD1DoI8FplhzohR/Hg
	+g1nV5ROjbWwent0yDSTo3+n+fi4dxXI3HdHcSRzo1x0uH3oRDx6huW/Gly+ojgo
	RNJvSsSWSvKicaOGni8lw==
X-ME-Sender: <xms:EHm9Z6Ueeld-J-y38pUdxlQFN0u69PD-iN4M0VScKLvURxXHU0szCA>
    <xme:EHm9Z2lmmZRxLlBIenGCUfci6FMToiUmNH_Pt9giaE6zq60W0nd1PYGM_iBoxQ3XP
    ZTmklTn1jqxZbYrbW8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdekuddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredt
    jeenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpedvhfdvkeeuudevfffftefgvdevfedvleehvddv
    geejvdefhedtgeegveehfeeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
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
X-ME-Proxy: <xmx:EHm9Z-ZIf4WE2-wNzseYDm9x7hprbFHz10DKe2GRvVPNKzaBgy6XkQ>
    <xmx:EHm9ZxUanB_hQqMJMNKW0Rx6zN0XeG9puC5chAlei8xDXkzxYsHbIw>
    <xmx:EHm9Z0m9hTJLXfvsJGXAaWD8aWcG2olfL0b-oNEspC0aaov9fHWzvg>
    <xmx:EHm9Z2fKM_n1XKLlyAXepTqs4plqGLdUy7mS8ymNvqdebJWeG23a-A>
    <xmx:EXm9Z-42ymM6iFFD8VvAMpU1O7tYc_kThzG4uPM3IrOXX9V4F4Lmp5EP>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A3F4B2220072; Tue, 25 Feb 2025 03:02:24 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 25 Feb 2025 09:02:04 +0100
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
Message-Id: <6b51ffa2-9d67-4466-865e-e703c1243352@app.fastmail.com>
In-Reply-To: <20250224-klinke-hochdekoriert-3f6be89005a8@brauner>
References: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
 <20250221181135.GW21808@frogsfrogsfrogs>
 <CAOQ4uxgyYBFqkq6cQsso4LxJsPJ4uECOdskXmz-nmGhhV5BQWg@mail.gmail.com>
 <20250224-klinke-hochdekoriert-3f6be89005a8@brauner>
Subject: Re: [PATCH v3] fs: introduce getfsxattrat and setfsxattrat syscalls
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025, at 12:32, Christian Brauner wrote:
> On Fri, Feb 21, 2025 at 08:15:24PM +0100, Amir Goldstein wrote:
>> On Fri, Feb 21, 2025 at 7:13=E2=80=AFPM Darrick J. Wong <djwong@kerne=
l.org> wrote:

>> > > @@ -23,6 +23,9 @@
>> > >  #include <linux/rw_hint.h>
>> > >  #include <linux/seq_file.h>
>> > >  #include <linux/debugfs.h>
>> > > +#include <linux/syscalls.h>
>> > > +#include <linux/fileattr.h>
>> > > +#include <linux/namei.h>
>> > >  #include <trace/events/writeback.h>
>> > >  #define CREATE_TRACE_POINTS
>> > >  #include <trace/events/timestamp.h>
>> > > @@ -2953,3 +2956,75 @@ umode_t mode_strip_sgid(struct mnt_idmap *=
idmap,
>> > >       return mode & ~S_ISGID;
>> > >  }
>> > >  EXPORT_SYMBOL(mode_strip_sgid);
>> > > +
>> > > +SYSCALL_DEFINE4(getfsxattrat, int, dfd, const char __user *, fil=
ename,
>> > > +             struct fsxattr __user *, fsx, unsigned int, at_flag=
s)
>> >
>> > Should the kernel require userspace to pass the size of the fsx buf=
fer?
>> > That way we avoid needing to rev the interface when we decide to gr=
ow
>> > the structure.
>
> Please version the struct by size as we do for clone3(),
> mount_setattr(), listmount()'s struct mnt_id_req, sched_setattr(), all
> the new xattrat*() system calls and a host of others. So laying out the
> struct 64bit and passing a size alongside it.
>
> This is all handled by copy_struct_from_user() and copy_struct_to_user=
()
> so nothing to reinvent. And it's easy to copy from existing system
> calls.

I don't think that works in this case, because 'struct fsxattr'
is an existing structure that is defined with a fixed size of
28 bytes. If we ever need more than 8 extra bytes, then the
existing ioctl commands are also broken.

Replacing fsxattr with an extensible structure of the same contents
would work, but I feel that just adds more complication for little
gain.

On the other hand, there is an open question about how unknown
flags and fields in this structure. FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
treats them as optional and just ignores anything it doesn't
understand, while copy_struct_from_user() would treat any unknown
but set bytes as -E2BIG.

The ioctl interface relies on the existing behavior, see
0a6eab8bd4e0 ("vfs: support FS_XFLAG_COWEXTSIZE and get/set of
CoW extent size hint") for how it was previously extended
with an optional flag/word. I think that is fine for the syscall
as well, but should be properly documented since it is different
from how most syscalls work.

    Arnd
