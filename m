Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B767B37A4AB;
	Sat, 17 Oct 2026 04:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792212884; cv=none; b=N4baPRWLamsbdAAHCe3uYHz9AZKYN0PODJF4bjOFJMnrMCgxlwyo5LXntXUI2fQYnt0jmNykinkzncQZpzWwI0d0iuT+NWf6SK+Fde2H7dPwyjIF9TeBoGk4BGETfT7bswzMyCTcxGKdnujNTblXApRW25InxEWvvWNnqoObXbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792212884; c=relaxed/simple;
	bh=+Xg+N/UfJF7ToQEdvEHZCS6mDzKCrIBaK3YE046Fkig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qi4caYxcDYXsJf49VOcrXAcUZXExHXggqZmdIOVzLVrI6WJ5bi8pgkObVEdyLiuoWRFChAbB+SSk+2q4ytROg3qYaWBbZYx9i0KsD5QugDppUSSnaQdelqcjjx29qX90WvxGcdputfMHGBG1gnJkO0CE484bkoAh+RNUfHFboJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED/ZAJPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED/ZAJPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87BD1F000C4;
	Sat, 17 Oct 2026 04:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792212883;
	bh=REIwKNtZjgcRHZFlrYddknh/HGx1GtJh0YexpuhA65o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ED/ZAJPUcKBqfsLTk37x4RBOoaVQomeAM699M/k/6dlvc5y+owbvdspZ75bzJ8sKB
	 seiIJBz2k6+jR3ya0n62/jU6m0EUV35PGLsPmd/WUR7Ic63smOKOTefNWXqMfcpL7U
	 mOWd/S8e7ZITNW/VlsrQsb6AIstTeaHJCu9bsRLu3LDsKKgLQS+Oz28js90ZE2XMIV
	 fjlySf+m37rBaTd+MxyX7JmZ7fFCNht7DERNKYohNC0J3rLLQBsBRxW217g+VcDCUV
	 tkSnot0mlgA7fxpjcpjJoJ2QaAoxbuY2Q4u59M84v0Shm8/Tj73de8BwdGCEkXYJ+H
	 D/PGDKMxJEo5w==
Date: Sat, 17 Oct 2026 06:54:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zheng Shuhao <viennaoffh@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Message-ID: <atL8bTDPVGlpZ0LB@nidhogg.toxiclabs.cc>
References: <20261016085536.591-1-viennaoffh@gmail.com>
 <atIj2DeA3TOMJQ2-@cronus.toxiclabs.cc>
 <6ad231b5.6655ddc8.1e37bf.a74a@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ad231b5.6655ddc8.1e37bf.a74a@mx.google.com>

On Fri, Oct 16, 2026 at 10:16:18PM +0800, Zheng Shuhao wrote:
> Hi Carlos,
> 
> Thank you for the pointer, and my apologies for the confusion. This is
> my first patch submission to the Linux kernel, and I was not aware of the

Please keep the context when replying and respond to messages "inline".
Giving this is your first patch, I'd suggest skimming through the guidelines
in the kernel documentation.

> known-identity requirement for patch authorship and Signed-off-by.
> Understood now; I will use my real name for all future submissions:
> 
>     Zheng Shuhao <viennaoffh@gmail.com>
> 
> (vienna-0FFH was my GitHub handle only.)
> 
> For reference, this is the testing I did on the patch before posting:
> 
>  * Built the patched tree with KASAN + XFS_DEBUG enabled; checkpatch.pl
>    --strict reports 0 errors and 0 warnings.

Good.

>  * Reproduced the use-after-free deterministically in QEMU on an
>    unpatched kernel; the KASAN splat matches the syzbot report exactly
>    (xfs_defer_item_unpause <- xrep_newbt_free <- xrep_bmap_build_new_fork,
>    and the xfs_defer_pending object is freed by xfs_defer_finish_noroll).
>  * With the patch applied, the same trigger produces no KASAN report: the
>    scrub ioctl just returns -EIO and the shutdown path unwinds cleanly.
>  * Regression runs on the patched kernel: all metadata scrub types,
>    invalid scrub inputs (bad flags/generation/agno/type), and forced bmap
>    btree rebuilds from 5 up to 1500 extents (covering both extents- and
>    btree-format forks), with read-back verification of the files. No
>    regressions; normal scrub/repair paths still succeed.
> 
> I can share the reproducer and test scripts if that is useful.

Yes, sharing the reproducer (and potentially hooking it up into
xfstests) is a good thing, specially giving the syzbot doesn't seem
to have a reproducer for it yet.

I'm also interested if you actually passed your patch through xfstests
before submitting it. There is no good fixing a bug if you create a
handful of others. Specialy agains scrub, online_repair (and maybe
fsstress_scrub) groups.

> 
> Would you prefer that I resend this as v2 with the correct
> From:/Signed-off-by: lines, or can you fix up the authorship when
> applying? Either way works for me.

You'll need to send a V2. But wait until your patch gets reviewed, you
don't need to send it right now.


> 
> Thanks,
> Zheng Shuhao
> 
