Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC922D0C90
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765219987; cv=none; b=G6nEzGAOLFLxqTsgIqTFBcMC2c/ckVJzYZ26hVaWWusE9PHBco8n+8uTlU9dpfqeZ3wZd+CwLaAur2BZ4oTbrwSIHHWxHY/gRm93z1uRLQXKyFI+ces75xvjpebvtaIOTnoAKT6+VlTEI7CfFg7fR8I8CIMpjrspdD8F281EBJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765219987; c=relaxed/simple;
	bh=DzD4jA53/GFe9kr8ORxA68kn5w3yZllbIx2WmePzfS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3YqmameS5atqLBggPFyxwFL5kxqG8w9uzzelPr2mtuRkQSNvvWcexK80BCAlvqZtw5DL6CpRCufgCMtfJVDXBRDaVQnrGsfr2E1EiznK4VaHX0ATIZZsYhfKmijpngn59w5fifLooMTQHBgPAm1tIVrIUGjXpOuZ85XBqmiIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjDlrkvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjDlrkvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B127C4CEF1;
	Mon,  8 Dec 2025 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765219987;
	bh=DzD4jA53/GFe9kr8ORxA68kn5w3yZllbIx2WmePzfS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjDlrkvoHiaD/w1arWvqyqllDDehb7IO3PmOfAasfKbddsanz4cxKo4x74nkVnY+b
	 oyoIlsSf3zMlp3iw4lIV1oYqTVjU8JZ1iW6unQcwd9OjPUYrYN9o8maE8yWrFKHmKC
	 a8p3rEsSoKvqBbqyw2I1oxub7BqSPX+O1YL4ljdynOkcv98+KiU4qBVmNDjp7CG19w
	 zaE+w26l0FpWTXmoxqjJKmAUGPVt1KjLkePx0UqjZ7wOXEi09rNsB5ROI/vGX+z2rl
	 pD0pc7pZtdFh5cGqRQCsdAvKwK9j3lbdDAha6qD9yqri6WVJozsJlGqX5+G2ae3jd9
	 zGrYgSCXXUJPg==
Date: Mon, 8 Dec 2025 10:53:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Janne Raatikainen <janne@raatikainen.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: Problem mounting xfs on newer kernels, "found unrecovered
 unlinked inode AG 0x3"
Message-ID: <20251208185306.GI89492@frogsfrogsfrogs>
References: <CAOPeA1ze0C7n+Uk=gUi4FyDaj3Ap_SzBf62dnT6j-pzR94gwkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOPeA1ze0C7n+Uk=gUi4FyDaj3Ap_SzBf62dnT6j-pzR94gwkQ@mail.gmail.com>

[cc linux-xfs]

On Mon, Dec 08, 2025 at 02:39:39PM +0200, Janne Raatikainen wrote:
> Hello,
> 
> I send this email, because I found your address from relating bug,
> https://git.sceen.net/linux/linux-stable.git/commit/fs/xfs/xfs_inode.c?h=linux-2.6.11.y&id=4790c167cc662250114dc4ecdc5d9cedbae1fe01
> 
> My error is:
> "found unrecovered unlinked inode AG 0x3"
> 
> I recently updated my Debian 11 os to Debian 12. Update went fine,
> with the exception that after rebooting with Debian 12 kernel, xfs
> root filesystem caused Linux to hang.
> 
> I have not ran any xfs_repair yet.
> 
> Currently installed kernels
> ii  linux-image-5.10.0-36-amd64           5.10.244-1
>            amd64        Linux 5.10 for 64-bit PCs (signed)
> ii  linux-image-6.1.0-40-amd64            6.1.153-1
>            amd64        Linux 6.1 for 64-bit PCs (signed)
> ii  linux-image-6.12.57+deb12-amd64       6.12.57-1~bpo12+1
>            amd64        Linux 6.12 for 64-bit PCs (signed)
> 
> 5.10 (from Debian 11) works without problems, according to dmesg
> filesystem is clean.

ISTR a bug some time ago wherein the kernel would mark a filesystem log
clean even though it had open unlinked inodes.  I /think/ that was
happening on fs freeze, but I don't remember that well.  Prior to 6.1 or
so we simply leaked the space and you wouldn't find out until an
xfs_repair, but now we try to clean up after ourselves when we notice
this...

> 6.1.0 (from Debian 12) stalls immediately, systemd can't log anything
> because its journal is on root filesystem.
> 6.12.57 lets system be mounted rw for about 10-30 seconds, before it stalls.

...but the difficulty here is that this is done at runtime, which is why
you can run for a half a minute before the stalls come back.

> This bug is reproducible by rebooting to different kernels. 5.10 don't
> detect the problem.

Interesting.  Can you capture a metadump of the rootfs and send it to us
(xfs_metadump -ag /dev/rootdisk /some/path && gzip -9 /some/path)?
Also, if possible, the dmesg / sysrq-t output somewhere?  I'm curious if
it's the xfs_iget() that's stalling.

(I know, capturing anything from the initramfs is annoying...)

> Please let me know, if you have some suggestions how to fix
> (xfs_repair?) or do you need some additional information to fix
> similar bugs in future?
> According to man page of xfs_repair, filesystem should be mounted and
> unmounted cleanly, before fixing with xfs_repair. Which kernel
> version, and xfsprogs version should I use to fix this unlinked inode
> problem? I will definitely backup my data with dd before I try to fix
> it.

The xfs_repair in bookworm (and probably even bullseye) should be ok for
cleaning up after this, though obviously if you have the ability to make
an lvm snapshot for a test-run, it would be safer to try it there first.

--D

> Best regards,
> Janne Raatikainen
