Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132278678
	for <linux-xfs@vger.kernel.org>; Thu,  8 Feb 2024 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405419; cv=none; b=itHNLL7pX8nNd79xfitLH1UPQRhnGSGxOHasfjds2NBw1spDZBQFQbPNXUYbou5Mm+13vLYThxPFHfX9Lb1j7kbK5oKHhpA5j+xzb1dLR0weGfwjT3NmmfJPhGoA53zZ3Hy77W/H9NL2Qfdwggq/JpHOHnTezIF+KMjuzt4BlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405419; c=relaxed/simple;
	bh=7wYIHHx7hKNwa22X3z9NAYYclt0dMZBa+cAuvCX/4o4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=XPpKPF1UzRmqDIR4o2M/8dQTP6qFpVTiHnU+ntf7vCRxUDMHqXIj18ZO/6rZeInbpyeAdoLP0D4gSMId98ZIfUFOrPLomXudu8BT06CTRi84inonb1F1IrEn7LRJZARHcqTUEgg2Jmv6Yqx9Hk1FOBXTCXQvycx+mm1LKmqIeeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/1CrMKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/1CrMKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1CBC433F1;
	Thu,  8 Feb 2024 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707405418;
	bh=7wYIHHx7hKNwa22X3z9NAYYclt0dMZBa+cAuvCX/4o4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=m/1CrMKER2/OZcPJPGUimLTAiLiTwKbc7xR0bNoXRzKyl5ElWIF5v7OOI1+5ixDQW
	 EAZubA95JQiPxt1jrXpR6PNSwPG7ymgegRwrp8lqzwX1j6TiiSoR2wCVgNN7k0V1+3
	 mw9v6wjDd+51j7GX0kcRe14zpy/YIBvsOSlBqKTK0GXhmtyvx6Z/6Wz1oM4vjv3isO
	 IqGoCzMsbgEyPaLKr0BMDA4s3fQgIbi0UZWjgLEEWFd4eQJxqSkVfDHa0+6kimCm3a
	 kCcmrtSwOKbJSeAtJIuqC121HMYY9CuJgUGn/paiKti+Y8LJO4ALcP2wMonb8wcFyw
	 kD4NU3Z2/crrg==
References: <20240208084616.6l3cfdelev7trv3w@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [BUG][xfstests generic/133] deadlock and crach on xfs, BUG:
 KASAN: slab-out-of-bounds in xfs_read_iomap_begin+0x5f2/0x750 [xfs]
Date: Thu, 08 Feb 2024 19:10:48 +0530
In-reply-to: <20240208084616.6l3cfdelev7trv3w@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Message-ID: <87r0hn3s0p.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Feb 08, 2024 at 04:46:16 PM +0800, Zorro Lang wrote:
> Hi,
>
> Recently I hit a deadlock then panic at the end [1] by running
> xfstests generic/133 on x86_64 xfs with linux v6.8-rc3+. And
> it's reproducible by loop running g/133 many times.
>
> But I found that each time I hit this deadlock, the testing
> machine uses a *multi-stripes* disk/fs, likes:
>
> TEST_DEV:
> meta-data=/dev/sda2              isize=512    agcount=16, agsize=245744 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=3931904, imaxpct=25
>          =                       sunit=16     swidth=32 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> SCRATCH_DEV:
> meta-data=/dev/sda3              isize=512    agcount=16, agsize=245744 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=3931904, imaxpct=25
>          =                       sunit=16     swidth=32 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>

"Multiple stripes" is one of the configurations on which I execute
fstests. However, I noticed that my kernel build configuration did not have
KASAN enabled.

Even with KASAN enabled, I am unable to recreate the bug. I have executed
generic/133 test for 100 iterations on a kernel built from torvalds/master
branch.

How easy/difficult is it to recreate this bug on your test machine?

> I haven't reproduced this issue on a xfs with sunit=0 and swidth=0.
>
> The newest linux commit id (HEAD) which I used to hit this issue is
> (mainline linux):
>
> commit 547ab8fc4cb04a1a6b34377dd8fad34cd2c8a8e3
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Feb 7 18:06:16 2024 +0000
>
>     Merge tag 'loongarch-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson
>

-- 
Chandan
