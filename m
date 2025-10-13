Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0E52EACF9;
	Mon, 13 Oct 2025 21:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760390994; cv=none; b=ghQz+9mbEuY3j4I7B50HDWpQmmctCKcEXPzpc/I5ig6pkgUiEqjsL0Mv1hdKG+WkjMXwZpqvYOT8AOxVVI5PFFKbVmkcxwflPKnOFNUNa/otpbBci4LIvdtmUkoCQko8/WNZmKB9oHjVxZGoNIORvF0RE+xfUgX6R+Akygem48c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760390994; c=relaxed/simple;
	bh=++BeBe3zqpGAMmuedQ8DfBM4v2kByC3QC54r77doVzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXod5OzYfyQICZEMfGiactVKEa24O20EOHAwSqqNf26KfqOYkIMQMaBJ/o0XLv740ofRR9YFqSiyZe1JakXLX9soJvJP2ZXzDXEbuzJYTBMNv8ABerAMM39DJVbycon8SXfAvu4zxI0EIrJiHccXOyEIPF+xidNIU5Qq8Vdk//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts8emS7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts8emS7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9BAC4CEE7;
	Mon, 13 Oct 2025 21:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760390994;
	bh=++BeBe3zqpGAMmuedQ8DfBM4v2kByC3QC54r77doVzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ts8emS7G0Llfd62Ab5RP/yy7iqQwT6dEOGM6QvKU7V3KiM8tRXhvm45m2Av845XFd
	 hCLPotuQRbY/0bHwfW11QIqJtfGQrhBTlLFGRijHyWty8m7/b/N+SW4rtn5GriGfX2
	 J9rQWUfWsoXx3r7KWLzv0VTozq4ojFb+EGloiZuwDhktuDPGgIADOTqLbHyxdtW5Aw
	 ykvZky6vomBEgZqiWgoKZYqTCJAGuVlOE7je8HWqFLlkxsWrDiW++eJvt4Qu3r+T0j
	 otFGinC+bDd9t/6glcXHOoI4J/iMYsCzDU67lKLz+HflVz/K8hit90GRbHQn7o7cpd
	 CIQYWE8Cr5xMQ==
Date: Mon, 13 Oct 2025 14:29:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: XFS attr2 mount option removal may break system boot
Message-ID: <20251013212953.GP6188@frogsfrogsfrogs>
References: <3654080.iIbC2pHGDl@natalenko.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3654080.iIbC2pHGDl@natalenko.name>

On Mon, Oct 13, 2025 at 09:08:38PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> In v6.18, the attr2 XFS mount option is removed. This may silently break system boot if the attr2 option is still present in /etc/fstab for rootfs.
> 
> Consider Arch Linux that is being set up from scratch with / being
> formatted as XFS. The genfstab command that is used to generate
> /etc/fstab produces something like this by default:
> 
> /dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota)

As in, /etc/fstab captures ALL the output of /proc/mounts, including the
strings that reflect filesystem state even if not explicitly provided by
whoever mounted the fs?  Is your actual fstab contents:

/dev/sda2	/	relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota	0	0

(aka logbufs/inode64/logbsize/sunit/swidth and the ones the vfs puts in
there on its own)

That's pretty messed up, but open-parsing stringly typed data structures
with unclear RMW semantics is always going to be a trash fire.

> Once the system is set up and rebooted, there's no deprecation warning seen in the kernel log:
> 
> # cat /proc/cmdline
> root=UUID=77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=discard rd.luks.options=discard quiet
> 
> # dmesg | grep -i xfs
> [    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
> [    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1ef-4dfd430e47e9
> [    2.442546] XFS (sda2): Ending clean mount
> 
> Although as per the deprecation intention, it should be there.
> 
> Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated() doesn't produce any warning by design if the XFS FS is set to be rootfs and gets remounted read-write during boot. This imposes two problems:
> 
> 1) a user doesn't see the deprecation warning; and
> 2) with v6.18 kernel, the read-write remount fails because of unknown attr2 option rendering system unusable:

...aaand that's the second failed deprecation in the kernel in the past
month because someone missed a detail somewhere for years and nobody
noticed.

> systemd[1]: Switching root.
> systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 32.
> 
> # mount -o rw /
> mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.
> 
> Thorsten (in Cc) suggested reporting this as a user-visible regression.
> 
> From my PoV, although the deprecation is in place for 5 years already,
> it may not be visible enough as the warning is not emitted for rootfs.
> Considering the amount of systems set up with XFS on /, this may
> impose a mass problem for users.
> 
> Vlastimil suggested making attr2 option a complete noop instead of removing it.
> 
> Please check.

Heh.  Yep, that's a bug.

--D

> Thank you.
> 
> -- 
> Oleksandr Natalenko, MSE


