Received: from prime.voidband.net (prime.voidband.net [199.247.17.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31130C35B;
	Tue, 14 Oct 2025 11:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.247.17.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760441282; cv=none; b=Bjp7MoBqgONSbYOjK0/DV/blxjPK/X1OR//ue1u6lKCsO7Km/pCdPAkoK3PBqS7Kxddh4qEdYYbcRs/ZSZ4gJ6O7d4IMZI2pbRil/PynhXDANbK74eWMMiTWtzK7CL1mvoxnvlHuFJKj1zw31d1u0ot1FAjdSyk/vdmZLpyWJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760441282; c=relaxed/simple;
	bh=Aqknw9cvz1a5UVydHXHDG8HHJbPwIFs1dlI9sCw4JAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJmlP7584y4usfCAqAOOJSdbyOxODYkVbqO30MnVeCxKQrSiLsFkxjcUgWryNzF6DrHfWKqKIATC28VadCM4qKS3Oyg9Y+C0WkcsrbNfG3cLiVnvbkQmDAgi023R85rIbUMUvBgyiPPoRs/N4gRv8AZM+zVsDKZmjwuLDK/QqFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=natalenko.name; spf=pass smtp.mailfrom=natalenko.name; dkim=pass (1024-bit key) header.d=natalenko.name header.i=@natalenko.name header.b=ECeb8yJL; arc=none smtp.client-ip=199.247.17.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=natalenko.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=natalenko.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=natalenko.name header.i=@natalenko.name header.b="ECeb8yJL"
Received: from spock.localnet (unknown [212.20.115.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by prime.voidband.net (Postfix) with ESMTPSA id E5699635B045;
	Tue, 14 Oct 2025 13:27:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
	s=dkim-20170712; t=1760441276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/EMfT5aBiBHDf6vkd/myeAKoiQKREcvgcSsPCDJBELw=;
	b=ECeb8yJL+ffmqQ81Mob0aT6ZiQKT3W/6LJa/WF/uUfmj+eEVhk1+uQDIac+FqOYY0lWZnk
	9LtFZKc5fbuPj7mImMGPRdoSLFXnj6pFhwPP/f4oS0ZS/RoEX8LyJeIzRHvlxVq6bt30Mw
	OLUs3gTAxOUqT7qpqdXC9cScnERriNk=
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
 Vlastimil Babka <vbabka@suse.cz>, Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 1/2] xfs: quietly ignore deprecated mount options
Date: Tue, 14 Oct 2025 13:27:40 +0200
Message-ID: <2800646.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20251013233229.GR6188@frogsfrogsfrogs>
References: <20251013233229.GR6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12758673.O9o76ZdvQC";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart12758673.O9o76ZdvQC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/2] xfs: quietly ignore deprecated mount options
Date: Tue, 14 Oct 2025 13:27:40 +0200
Message-ID: <2800646.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20251013233229.GR6188@frogsfrogsfrogs>
References: <20251013233229.GR6188@frogsfrogsfrogs>
MIME-Version: 1.0

Hello.

On =C3=BAter=C3=BD 14. =C5=99=C3=ADjna 2025 1:32:29, st=C5=99edoevropsk=C3=
=BD letn=C3=AD =C4=8Das Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> Apparently we can never deprecate mount options in this project, because
> it will invariably turn out that some foolish userspace depends on some
> behavior and break.  From Oleksandr Natalenko:
>=20
> > In v6.18, the attr2 XFS mount option is removed. This may silently
> > break system boot if the attr2 option is still present in /etc/fstab
> > for rootfs.
> >
> > Consider Arch Linux that is being set up from scratch with / being
> > formatted as XFS. The genfstab command that is used to generate
> > /etc/fstab produces something like this by default:
> >
> > /dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=3D8,=
logbsize=3D32k,noquota)
> >
> > Once the system is set up and rebooted, there's no deprecation warning
> > seen in the kernel log:
> >
> > # cat /proc/cmdline
> > root=3DUUID=3D77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=3Ddiscard =
rd.luks.options=3Ddiscard quiet
> >
> > # dmesg | grep -i xfs
> > [    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub,=
 repair, quota, no debug enabled
> > [    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1=
ef-4dfd430e47e9
> > [    2.442546] XFS (sda2): Ending clean mount
> >
> > Although as per the deprecation intention, it should be there.
> >
> > Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated()
> > doesn't produce any warning by design if the XFS FS is set to be
> > rootfs and gets remounted read-write during boot. This imposes two
> > problems:
> >
> > 1) a user doesn't see the deprecation warning; and
> > 2) with v6.18 kernel, the read-write remount fails because of unknown
> >    attr2 option rendering system unusable:
> >
> > systemd[1]: Switching root.
> > systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 3=
2.
> >
> > # mount -o rw /
> > mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.
> >
> > Thorsten (in Cc) suggested reporting this as a user-visible regression.
> >
> > From my PoV, although the deprecation is in place for 5 years already,
> > it may not be visible enough as the warning is not emitted for rootfs.
> > Considering the amount of systems set up with XFS on /, this may
> > impose a mass problem for users.
> >
> > Vlastimil suggested making attr2 option a complete noop instead of
> > removing it.
>=20
> IOWs, the initrd mounts the root fs with (I assume) no mount options,
> and mount -a remounts with whatever options are in fstab.  However,
> XFS doesn't complain about deprecated mount options during a remount, so
> technically speaking we were not warning all users in all combinations
> that they were heading for a cliff.
>=20
> Gotcha!!
>=20
> Now, how did 'attr2' get slurped up on so many systems?  The old code
> would put that in /proc/mounts if the filesystem happened to be in attr2
> mode, even if user hadn't mounted with any such option.  IOWs, this is
> because someone thought it would be a good idea to advertise system
> state via /proc/mounts.
>=20
> The easy way to fix this is to reintroduce the four mount options but
> map them to a no-op option that ignores them, and hope that nobody's
> depending on attr2 to appear in /proc/mounts.  (Hint: use the fsgeometry
> ioctl).
>=20
> Lessons learned:
>=20
>  1. Don't expose system state via /proc/mounts; the only strings that
>     ought to be there are options *explicitly* provided by the user.
>  2. Never tidy, it's not worth the stress and irritation.
>=20
> Reported-by: oleksandr@natalenko.name
> Reported-by: vbabka@suse.cz
> Cc: <stable@vger.kernel.org> # v6.18-rc1
> Fixes: b9a176e54162f8 ("xfs: remove deprecated mount options")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e85a156dc17d16..e1df41991fccc3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -102,7 +102,7 @@ static const struct constant_table dax_param_enums[] =
=3D {
>   * Table driven mount option parser.
>   */
>  enum {
> -	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
> +	Opt_quietlyignore, Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
>  	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32,
> @@ -115,6 +115,14 @@ enum {
>  };
> =20
>  static const struct fs_parameter_spec xfs_fs_parameters[] =3D {
> +	/*
> +	 * These mount options were advertised in /proc/mounts even if the
> +	 * filesystem had not been mounted with that option.  Quietly ignore
> +	 * them to avoid breaking scripts that captured /proc/mounts.
> +	 */
> +	fsparam_flag("attr",		Opt_quietlyignore),

Should have been "attr2" here I suppose.

Thanks.

> +	fsparam_flag("noattr2",		Opt_quietlyignore),
> +
>  	fsparam_u32("logbufs",		Opt_logbufs),
>  	fsparam_string("logbsize",	Opt_logbsize),
>  	fsparam_string("logdev",	Opt_logdev),
> @@ -1408,6 +1416,8 @@ xfs_fs_parse_param(
>  		return opt;
> =20
>  	switch (opt) {
> +	case Opt_quietlyignore:
> +		return 0;
>  	case Opt_logbufs:
>  		parsing_mp->m_logbufs =3D result.uint_32;
>  		return 0;
> @@ -1528,7 +1538,6 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>  		return 0;
>  #endif
> -	/* Following mount options will be removed in September 2025 */
>  	case Opt_max_open_zones:
>  		parsing_mp->m_max_open_zones =3D result.uint_32;
>  		return 0;
>=20

=2D-=20
Oleksandr Natalenko, MSE
--nextPart12758673.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmjuM60ACgkQil/iNcg8
M0vfURAA60mh8W8inA79KQ3Z2IR/dIhqKNQ/I28xR83zU9Xh6cViJa8rekWYSZLR
HkS2Y5F2Gvxf0KFQN5QbUhWbyVyHL0LbAb7l7dPfFAC/pI/A/WTt9v7LKHIC1JnS
60FL6zaGZLgX6REKdu99jFZl0jtTSEsJlo6fcPtudGNNz+kwyHWp1fSeT0vQd7xT
QhmrRGIFQjvrxiYIM2IgoSmTETRDt9tqWMVyuCVH5aK6kY3T+h6VwbNn97bVqLTH
iWQsNBtKs2LLyiE9HGLaXg/zdG7L0E2qllXMR6+Tot2PSH5kOUUy6bDajXD7Eflb
kYnUofJMY4KE9it8ZI1rZqdLoH1a16yao4zLSk1zM+DP9mjkWEsXah0O/dOegT0y
24bjxjLZK/aGwZh5CX9FMgVQjdzURTey/sTIfZmz8Avv5tpzMnum2aF3wA7FviLt
03u4Hz7lUx1z0eGDPbloASbu4IVHOrw6fCOzgR8vqgsTfYiCQWwAHiwJ14mOv+tC
kNHDo2edZaFymQkKsGZkcROp6CmdePcxQCA5haUScUGbi1Z8tNrw8s917FVFxLw1
sA13utFJ9PifS7su7B6UijbLk4ou61RHI81FVz3oEZwMpWR2nf7b8azXzNKLEG0c
sparWTTJgPHgJvQ/62aLQXqquPtom1BKikD5I/T1vgUfjMqL91w=
=rPP4
-----END PGP SIGNATURE-----

--nextPart12758673.O9o76ZdvQC--



