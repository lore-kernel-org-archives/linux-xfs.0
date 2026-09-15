Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62A47DF87
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 10:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789469870; cv=none; b=rMTzzUFD36mT4ww7H8mY9QveF0kZsfHsCt2PU3ghLt50L+ZXnfjwoeuwC0B+gKXK8mB/qJdTAgJZ2bXdLvIcVwRn6jR6oC+ttFfJGMfyLbzIG4vJhoh1c290ebRjZNRYahAQbTGQdSPTbMVh4xSEOavBfTPVDYlD7Ws0gTAbjJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789469870; c=relaxed/simple;
	bh=eXNwa3O81Oem6JDWzMC2mKcemjhdEru3FFfSTXt9qms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtqLwQpYBFtw+UYRjztavVonepKhc0FljHJdvIjJ4vtjMH/hkiqFh4ljHvU2Z9NZBvPaumiTcbptfWhDBdTA1I63UhlGc4naLWyHQT658rfxlU5qZAIbtLdj92NSaJyJei68IHn2NUARAa5WIBpcTNvGipP/lxlB4Uw3ftbpd/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIvFrWz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIvFrWz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0FE1F000FF;
	Tue, 15 Sep 2026 10:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789469868;
	bh=qpTIq1p/bZMokF5BpXqvzkpyJ43vSTKCMirQnvzprcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JIvFrWz6UpLqvk4JFImrsBfzyUuwuPX7nS/gMkGIXXMz44QoiwkapilPEj74Df2Va
	 whLz5VnaXEMyfDQWZ+GuLxfzOXlIijzJsMyikRVEt95ZfZV8obUc8c6plrNaAbj9rN
	 KTDppjAyzCVGEzmUQz0gfxZwpX15sV09gjY5CQielebUCFSbZC5W4NfnnEtXXJo9bp
	 aMz/JLLRAgDrBK4oh+JIg5bMszAO5LtGZ8mO8PYv8sS0O5HD3+ed7DZ71sHuVTB3zH
	 fXL0Pg8IFP27GncVfUu60Ztl3Q7wJF0jkDf8FjmExJyAi3vmInAW9iflVlqasPnz5U
	 wLt0od3ewfMHw==
Date: Tue, 15 Sep 2026 12:57:45 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqkkmM2EPcMgfYJ9@devuan>
References: <20260915103919.2595641-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2x6ubsbugwdbfylu"
Content-Disposition: inline
In-Reply-To: <20260915103919.2595641-1-aalbersh@kernel.org>


--2x6ubsbugwdbfylu
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqkkmM2EPcMgfYJ9@devuan>
References: <20260915103919.2595641-1-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260915103919.2595641-1-aalbersh@kernel.org>

> Date: 2026-09-15 12:39:18+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add a CAVEATS section with an note that these ioctls can not be used on
> special files and leave a reference to an alternative pathname based
> syscall interface.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: Alejandro Colomar <alx@kernel.org>

LGTM.  Thanks!


Cheers,
Alex

>=20
> ---
> Changes from v2:
> - FIFO on a new line
> Changes from v1:
> - Use semantic newlines
> - pathname-based
> - RvB
> ---
>  man/man2/ioctl_xfs_fsgetxattr.2 | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>=20
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxa=
ttr.2
> index 25a9ba7965d1..9a1983ca1756 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -238,6 +238,28 @@ Caller did not have permission to change the attribu=
tes.
>  This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on=
 the
>  Linux kernel.
>  Not all fields may be understood by filesystems other than xfs.
> +.SH CAVEATS
> +The
> +.B XFS_IOC_FSGETXATTR
> +and
> +.B XFS_IOC_FSSETXATTR
> +.BR ioctl (2)
> +operations require the user to open the file,
> +but this may not be possible or
> +lead to side effects on special files such as
> +FIFOs,
> +sockets,
> +block devices,
> +character devices,
> +and symlinks.
> +.P
> +For a pathname-based interface see the
> +.BR file_getattr (2)
> +and
> +.BR file_setattr (2)
> +syscalls.
>  .SH SEE ALSO
>  .BR ioctl (2),
> -.BR ioctl_iflags (2)
> +.BR ioctl_iflags (2),
> +.BR file_getattr (2),
> +.BR file_setattr (2)
> --=20
> 2.55.0
>=20

--=20
<https://www.alejandro-colomar.es>

--2x6ubsbugwdbfylu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqpJKkACgkQ64mZXMKQ
wqko4A//RlAX6f3CDYGBPhG5RtfPxp1HRTZnorsX5XcdYSGvNi4tmuqBKR2V/HOS
osyC1ep0BAgxXrzDW/MTFZg3yr4niSAA0YAgzcCKwCwag/OFXDksfck4yWqn7/e2
8G8ORZnPI7np+Y9E7GLBOjN76W9/XlA0/PbMixeyEe6CWQDGI41OEVnWnNPBILdE
M0z0AFJbM+neAGSdDFviTjGhIJmqj8pk+WGCIWHT+GbcAsi1cr3NUFClwWrNd9uU
GreaZbLlMMr1Ly9Pez8VBFTGFy7Y3bTmrfZKGrqRaH4W2ZM+n5saN0L7VS51xkCB
zlgbRROQKMGPpcnPzp7TgN9EzBO5KuqduAsCGRJlGMGAyoYn6vwxMmRNuYP5Br4d
4hZXvplWrMNWYYRbxH+dOsl06yFCDVKZVc0L0IGuRK2pAOOoLGJZRK1oO55w7Tj9
YKpdT+R+Rj+RPOMUQ7uAWOeeQH+zP5IybVUdvczqCelrNmdE3YK8rVk3B08nxKEw
BjDTxpecz0U436Ap5mFIFeFsmRG59oDHHmaVf2h7JckVUDU+hpoYZWrnhyhz/AAF
1CS2Qo9WfcY6V9YgxFVkdqfovCXPQ6G1ADPIFdzLmg+T8QBJP7ISvP2RndPKHyjt
vPLFeqbsUKGAC6nYN0QRuMOA1nP6b1E35SlGWrb9cqo/cqE0auc=
=BPSr
-----END PGP SIGNATURE-----

--2x6ubsbugwdbfylu--
