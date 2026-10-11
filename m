Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745BCB640;
	Sun, 11 Oct 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737900; cv=none; b=KDDXJ6R5Ji+BYqNokcxOazant2IhfAfoy3U0VuEBFjoUS8K0eL2zsW7PEUFvNi+HKxKpHcMthlbvQMlKQDYfaTp/SvL/TgUE6rmK52iVW2lLlxYSe3w123Yobu4oIME7hhf21JVyeNUU90TbHXU0lk1uebPs62WUW69SIs2InrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737900; c=relaxed/simple;
	bh=Xtk1UcAcM3y6Zph0ttR/lYM+9M6itcqmv1xB6gwQgfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/44+PAJEewIMU/jJW9B4zVvv9Grr7QWLtWDV62zX/mBniELi4BPNRnQTlPjuGeqqXlvwHVvx/vd8eNaGZeII5XkonACmFDZ5fjbdIi/3pAKyskSFObUGTUeYJJzQtOkJl8tOBGqs9zs4XOzRpoVy9PyZvKAcR+6wf1bj6/vhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axz7Vp3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axz7Vp3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777FD1F0089B;
	Sun, 11 Oct 2026 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737899;
	bh=cRNXTK4x98QMWwRgA0GPi+hRWkF15/pCDfmxnv8GttE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=axz7Vp3lgMoT/QvX/fOwlcgZxQHnwaNoaBaaEJVInSS9M6XnQZQS5YgN+xGZbg3cD
	 ZotjsOv+WH4W5YY7HlTRV1b5y3h6yuej2lQecGPtJTE2BFL2Wx4+jhqBId17Te6UOr
	 asOdNLoDwadN7pHyq2Dzccyk3CsF7rgs2QR+spBTEVlsyXQBjX1wW2b/MF/X+76dPB
	 LqvP4IJaxSfdybyme/rT9Ke487JT2lRlthZctMwM5b6kqgz2KYe3MrnDT772xKh2BP
	 mZK+FC2Cf1EPzmoOqWF/Zzl85koRfyCeaF0Tb8zIcgV3C+EK3Su5+55ZqJeoJO3qqK
	 zM2I6aKYH+Auw==
Date: Sun, 11 Oct 2026 18:58:13 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 1/3] man/man2: introduce man page for struct file_attr
Message-ID: <asvACCrpUUogv33U@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hr6njegvwktoyi24"
Content-Disposition: inline
In-Reply-To: <20260929130234.3547891-2-aalbersh@kernel.org>


--hr6njegvwktoyi24
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 1/3] man/man2: introduce man page for struct file_attr
Message-ID: <asvACCrpUUogv33U@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-2-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260929130234.3547891-2-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-29 15:02:30+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add manual pages for struct file_attr used by file_getattr() and
> file_setattr() syscalls.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc352=
27b@kernel.org/

Thanks!  I've applied the patch, with some minor amendments.


Have a lovely day!
Alex

> ---
>  man/man2type/file_attr.2type | 153 +++++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>  create mode 100644 man/man2type/file_attr.2type
>=20
> diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
> new file mode 100644
> index 000000000000..3a1aabbc9e7d
> --- /dev/null
> +++ b/man/man2type/file_attr.2type
> @@ -0,0 +1,153 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_attr 2type (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_attr \- describe filesystem file attributes to get or set
> +.SH SYNOPSIS
> +.EX
> +.B #include <linux/fs.h>
> +.P
> +.B struct file_attr {
> +.BR "    u64  fa_xflags;" "     /* Extended flags */"
> +.BR "    u32  fa_extsize;" "    /* Extent size hint */"
> +.BR "    u32  fa_nextents;" "   /* Number of extents (read-only) */"
> +.BR "    u32  fa_projid;" "     /* Project identifier */"
> +.BR "    u32  fa_cowextsize;" " /* CoW extent size hint */"
> +.B };
> +.EE
> +.SH DESCRIPTION
> +Describes filesystem file attributes
> +for use with the
> +.BR file_getattr (2)
> +and
> +.BR file_setattr (2)
> +system calls.
> +.P
> +The fields are as follows:
> +.TP
> +.I fa_xflags
> +This field contains file attribute flags.
> +It is a bit mask consisting of zero or more of the
> +.B FS_XFLAG_*
> +flags.
> +Refer to the section
> +.B FLAGS
> +below for a list of all flags.
> +.TP
> +.I fa_extsize
> +Extent size allocator hint in bytes.
> +This value suggests a preferred extent size
> +for new allocations to this file.
> +.TP
> +.I fa_nextents
> +Number of data extents in the file (read-only).
> +This field is filled in by
> +.BR file_getattr (2)
> +and is ignored by
> +.BR file_setattr (2).
> +.TP
> +.I fa_projid
> +Project identifier.
> +Used by quota systems
> +.BR quotactl (2)
> +to group related files.
> +.TP
> +.I fa_cowextsize
> +Copy-on-Write (CoW) extent size hint in bytes.
> +This value suggests a preferred extent size
> +for CoW operations.
> +.SH FLAGS
> +Flags can be:
> +.RS
> +.TP
> +.B FS_XFLAG_REALTIME
> +Data is stored in a realtime volume.
> +.TP
> +.B FS_XFLAG_IMMUTABLE
> +File cannot be modified.
> +.TP
> +.B FS_XFLAG_APPEND
> +All writes must append to the end of the file.
> +.TP
> +.B FS_XFLAG_SYNC
> +All writes are synchronous.
> +.TP
> +.B FS_XFLAG_NOATIME
> +Do not update file access time on reads.
> +.TP
> +.B FS_XFLAG_NODUMP
> +Do not include file in backups.
> +.TP
> +.B FS_XFLAG_DAX
> +Use Direct Access (DAX) for I/O operations.
> +.TP
> +.B FS_XFLAG_NODEFRAG
> +Exclude this file from defragmentation operations.
> +.TP
> +.B FS_XFLAG_FILESTREAM
> +Use filestream allocator for this file.
> +.TP
> +.B FS_XFLAG_EXTSIZE
> +Use the extent size hint from the
> +.I fa_extsize
> +field.
> +.TP
> +.B FS_XFLAG_COWEXTSIZE
> +Use the CoW extent size hint from the
> +.I fa_cowextsize
> +field.
> +.RE
> +.P
> +Directory only flags:
> +.RS
> +.TP
> +.B FS_XFLAG_RTINHERIT
> +New files created in this directory inherit the realtime flag.
> +.TP
> +.B FS_XFLAG_NOSYMLINKS
> +Disallow creation of symbolic links in this directory.
> +.TP
> +.B FS_XFLAG_EXTSZINHERIT
> +New files created in this directory inherit the extent size hint.
> +.TP
> +.B FS_XFLAG_PROJINHERIT
> +New files created in this directory inherit the project identifier.
> +.RE
> +.P
> +The following flags are read-only:
> +.RS
> +.TP
> +.B FS_XFLAG_PREALLOC
> +File has preallocated extents.
> +.TP
> +.B FS_XFLAG_HASATTR
> +File has extended attributes.
> +.TP
> +.B FS_XFLAG_VERITY
> +File has fs-verity enabled.
> +.TP
> +.B FS_XFLAG_CASEFOLD
> +The filesystem performs case-insensitive lookups (file and directory name
> +comparisons ignore case).
> +.TP
> +.B FS_XFLAG_CASENONPRESERVING
> +The filesystem does not preserve the case of file and directory names.
> +.RE
> +.P
> +Not all filesystems support all flags.
> +Setting unsupported flags may result in an
> +.B EINVAL
> +or
> +.B EOPNOTSUPP
> +error.
> +.SH HISTORY
> +.SS Linux v6.17
> +This structure is introduced.
> +.SS Linux v7.2
> +The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to e=
nable
> +upper layers, such as NFSD, to retrieve case sensitivity information.
> +.SH SEE ALSO
> +.BR file_getattr (2),
> +.BR file_setattr (2)
> --=20
> 2.55.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--hr6njegvwktoyi24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrLwCUACgkQ64mZXMKQ
wqmFLw//TElr+/vk1iehq9lvwXC3oZICaYGlfTrYE8dJaZc10GRZRZh1jp0URDKL
f5SORoOs0nj290KPghlBSfnW5meSMShGtkRyB8WUnU5OtZpQPLMedfe/y6lzNELL
HWxWAvbJd2v+yZ+2LEMlWiEaKMFF5Nbn4i7K/a6oxXiY6i1NdD3qsH5szdd4wQD4
VAerhC+/c4OO2HTJyTFZwn7bO1UAmtMX1PrjBpCF/0SEtdPoB5HJCEpnaG5yfiAv
Bzmki1ghaV+Qsa94i0krEcjnZmb79RAnVaMG+YRENvDrGUlBClYsQ8uY3oH9D+mA
7i0e8mdj6wtt4OqtvjRugHYpFiKGkRLhvdrFvz/+LIjbAJzkcRgi03CzhxDHk8fE
p2j8SfeWedmbz5cW60X/de9K81LMC9+ObutIuUZM16nRZcc9h9A+H+Cbgm4SQFq3
vh3I8Fcrke8sOE+EI7Yu/0z3ZBHaAw6MFi1hCXAgxRYsF0iWVJ92JkoahpZqBn2G
VzhHl4zuGrl5p4DZCE19/n4uffJolEjFkGtjxyxPcxxdz46Nghay8DgLHZPsw1xu
ZZCJxdYWhHNGnB6puHiTX3xx1B6gLfNwMJUbu2c8bRB0hUqHsQcpCbStwbipdL0d
Nfq65+S+PAKi8r9MQTnuikTeeJrRtkbx3fRJLpIYfk/OySZihfo=
=aCxE
-----END PGP SIGNATURE-----

--hr6njegvwktoyi24--
