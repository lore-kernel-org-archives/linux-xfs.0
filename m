Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E188273D64;
	Mon, 16 Jun 2025 08:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750064395; cv=none; b=DoOBg6kiuT/JllF6hC52oCfeLsH7y0REv/hL1UxrohLn3y439Ekr4XG8NCw7GMOLueOSDh/cDYbjuCxz7tAaP/wLNByOFen8rfgfGY7vxeS8g4FWP6MimbukQK/6FjyM674CN22jULWxkzkWC66ANRsTMy6myY0mkAtmnxww9gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750064395; c=relaxed/simple;
	bh=TRDI+1LI77i41Lpbd2URKLy/orUrVbjKB17ATEDujTE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=De70SsJwJWbxdMryEVUB/ci8vFVkoFDdaVC6P3wWVOA9Er0DaVWxVfTE2QwywDm9btGdYGUIftC9lfTzK7+liwmnz6RKBoCA5meUFrS+5qbsg4UX27mNOK9hZuraVCUP/CF0HYWEvmDLTkste26y2d0bquNnYuBPIjuV2Xjp148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=T4981MuA; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="T4981MuA"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1750064384;
	bh=TRDI+1LI77i41Lpbd2URKLy/orUrVbjKB17ATEDujTE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=T4981MuAA/1FClS2do81A8YiMvgLw6Bq9BblssGPs4YqpHGLlJxvYyXMzCYk8c0yP
	 /ulix4xnaciFgr5yISW4vA3KQ1ln2T69RsXdsjUDkQccUFBhsGRN4QrbLgJpeblWQl
	 vB5STFsHBvtGwg9JwQTgsdXDcmEsSjQgvDwdpWg0=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
Date: Mon, 16 Jun 2025 10:59:34 +0200
Cc: stable@vger.kernel.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
To: Carlos Maiolino <cem@kernel.org>



> On 16. Jun 2025, at 10:50, Carlos Maiolino <cem@kernel.org> wrote:
>=20
> On Thu, Jun 12, 2025 at 03:37:10PM +0200, Christian Theune wrote:
>> Hi,
>>=20
>> in the last week, after updating to 6.6.92, we=E2=80=99ve encountered =
a number of VMs reporting temporarily hung tasks blocking the whole =
system for a few minutes. They unblock by themselves and have similar =
tracebacks.
>>=20
>> The IO PSIs show 100% pressure for that time, but the underlying =
devices are still processing read and write IO (well within their =
capacity). I=E2=80=99ve eliminated the underlying storage (Ceph) as the =
source of problems as I couldn=E2=80=99t find any latency outliers or =
significant queuing during that time.
>>=20
>> I=E2=80=99ve seen somewhat similar reports on 6.6.88 and 6.6.77, but =
those might have been different outliers.
>>=20
>> I=E2=80=99m attaching 3 logs - my intuition and the data so far leads =
me to consider this might be a kernel bug. I haven=E2=80=99t found a way =
to reproduce this, yet.
>=20
> =46rom a first glance, these machines are struggling because IO =
contention as you
> mentioned, more often than not they seem to be stalling waiting for =
log space to
> be freed, so any operation in the FS gets throttled while the journal =
isn't
> written back. If you have a small enough journal it will need to issue =
IO often
> enough to cause IO contention. So, I'd point it to a slow storage or =
small
> enough log area (or both).

Yeah, my current analysis didn=E2=80=99t show any storage performance =
issues. I=E2=80=99ll revisit this once more to make sure I=E2=80=99m not =
missing anything. We=E2=80=99ve previously had issues in this area that =
turned out to be kernel bugs. We didn=E2=80=99t change anything =
regarding journal sizes and only a recent kernel upgrade seemed to be =
relevant.

> There has been a few improvements though during Linux 6.9 on the log =
performance,
> but I can't tell if you have any of those improvements around.
> I'd suggest you trying to run a newer upstream kernel, otherwise =
you'll get very
> limited support from the upstream community. If you can't, I'd suggest =
you
> reporting this issue to your vendor, so they can track what you =
are/are not
> using in your current kernel.

Yeah, we=E2=80=99ve started upgrading selected/affected projects to =
6.12, to see whether this improves things.

> FWIW, I'm not sure if NixOS uses linux-stable kernels or not. If =
that's the
> case, running a newer kernel suggestion is still valid.

We=E2=80=99re running the NixOS mainline versions which are very =
vanilla. There are very very 4 small patches that only fix up things =
around building and binary paths for helpers to call to adapt them to =
the nix environment.

Christian


--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

