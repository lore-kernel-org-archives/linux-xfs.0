Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394318;
	b=MkBQ5i5oGSgYl6w1uwQAayXRtrV1ycna82H7rdvEkNDQpBacRVx0rdgqLkYmcbXrG5ub
	 7/LMvHtmgzKkz0sVQXruiCNZW6mU5vrgaJv3qx/jQBFPi6JrTEQ2koU/NBUI1tz0h88pV
	 dUEYO3VaoIwAWvgXrRfDsovFugcUt0qbJAGq8SBZcJl/YUTP3OeYAulrAaI8Jw0Ppq+1C
	 LDBoh0rMz1fRTVuWAIhvOnkcsJY3hdRukNAA1fsJs0u+97fr8P36Hw0pq0CyO1d+lkx02
	 z3OJmbkgYLbFadIoDPIs6YgbCNK+l4V/0tTxwU2anpb4Hk88TEQyLX8x9HC+p1/vVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=HP9zOCOBYYSdBf8b8BfCMeW0ZoB3i2I21hDr8WIDWn4=;
	b=RYdaXYNrI1O/AhkqxCvEgJRICs9e5VpvA/DcUwsmpktF7SGpIxLJaqpAzbO4yv+mTrW2
	 EDCaFP7D+wLDdJBVzW5cVkFzARyhPOwKakBpPsO40t1RfXGtwidHMLLC3z9ICrOo1yyfR
	 CwRaiXAk8XtfdCiamStOBq+wp3Q7CMxePik87zWsvZaw6b3NgrKrjRGu19rBrAYTWeWqK
	 A7SZgEgWLLdKhsP2PejkXlQqlQ/b+UynCNz8jsusDvqvQ/7awIdePDa9DO4cNuDEmQV1e
	 7YqNMc9YPbT8OFKKK0QjXUObbLwGrEksOSRwAfilzqfrW/uMhOq5ejSPucqYvMRronA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s2W3jKAm;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8F1606A320
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 00:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE8F1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s2W3jKAm
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4ac109a8a12so1480877f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2026 16:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795394316; x=1795999116; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HP9zOCOBYYSdBf8b8BfCMeW0ZoB3i2I21hDr8WIDWn4=;
        b=s2W3jKAmP/sFUJsVuUvRm0HuRbELyF3pVWS2t67SmmIgzqW9Px3e5RdQ7nRjJA/ws6
         G3oWIywM8m7mViMiHOcQ8c9+2ZC3fzNk0xw3zQ/gsn5F2zRzXUCNg7qrHZYakrcXDU2y
         yUcXHRtOkA4YGxQs843exf9afZG/hf+y30N3VrBNLGrRsAg0b/1WRkVeuw33gaxvBEGw
         wujKERQZF9SnF0YF6ZgznMdoo/Y6qdBP+orEwMAWbf9swgQyU/SARitmcH7JFWfC9vd3
         flRgzVZ6yDy7p2JCBWSlYZtPO5S5PnncNTgWNNMOsNNNWx7RDko/Z6EqsNFscNGo8Gcj
         L5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795394316; x=1795999116;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HP9zOCOBYYSdBf8b8BfCMeW0ZoB3i2I21hDr8WIDWn4=;
        b=KIL4mhg/txp/oCXN8Yp68zudnqFe2TNO2mKSC8DQMSjt3M5Rkk+ENxeO3MnE0799wA
         7GltY61OSL5aEIEqTIADUy3X4TYc+opwSXESnEUtN8NAbui6RLNxv8SCJQ5f2VouKLLq
         M6AAuwT4GBkmb3/epIckTLVT+sagF/fGJqg0rHlLSm2WlSkrynboiBx4s9KN/o2edhQy
         CHWoCeis1P3E2PvsJjs5uo7OyRbZ3Tkc6w/Fh/KDheQXfsX8zGGdjbHdotofCnHxAmHO
         3CQW9SHfH3aKe6j6h31EPOInDs9GoKkSejc1mrk5rC5dRTdaa5sU06pni6zr09DnDCzN
         rtMQ==
X-Forwarded-Encrypted: i=1; AL+hErFvMgWRfDKIbmJAqLG0/BuZMNM7D4WudQBOz4ffYkAx2b6HNptlIU1d4psHTCsYNmMP4hNkqUOhi/g=@vger.kernel.org
X-Gm-Message-State: APuU4Z9koZQ+EqazyMZmYiy924rFxLH0dDhWfWaMimrLbTrCW/mS4usz
	lLK55Rt50zvNXRdApytD4e3QxqS0jmlask7GmSJ+QucVwX9w6eMWops6
X-Gm-Gg: AZFdTZf6I9nEppQyIuuuSQf1yX16Ghb1aIUd35uyDJlFDBfz9pDnwLPlHQyVrYV4Aus
	i4H/3lvyp00k8Fs2Q+ZJ6/Bk+ufH+1KlGcK96vKemY7a/Gilgp9ZmL9G52iFYNLBHsHSfvytK9e
	WLyB0v4ZFBcneVKbViLRQTtqy04F9JyZCXaZjWIQj9rxnR+RJeqEzzwY7b3KW1apKe5mZ+BSO9P
	/lhjgi2N5g0Yvn6hzwV1IXWTnnH0gGjQKV1pGcY6ssweCrPGWNEdEUtKPM1Fjo9FHjMde0QkhBM
	WFQzaFtf17AvnpimIr6SWaTBGxwpGyYByON97UlI1gE+EZy8ya4qINjTaNOK30dRiyMuEsRDHeA
	Ou6IAdjabubEweTYNjX1PZmp8VwGmLhLiTXbDInYh7PtZmrgSwk7s3SIioryXb0mmCGDxOs/Kcl
	Dbrb9WxN0UZVIka59BppMg4Ho+aycS1RRoB7g3i5563fLk7G9knf+LCD4asB6TQQVZ/4MCXLQJs
	IYUm5SISMs0Vk48BaO0kxtob+kd2a3sUDKcRFO+rh6xqUFvSVhQsOkWI0C8k9ghU9a1th9R+0HV
	b1vomz7SYRqhjjQ1Tp2lrqNh3A==
X-Received: by 2002:adf:ef06:0:b0:4a9:5848:3640 with SMTP id ffacd0b85a97d-4abb5db79e6mr15647617f8f.55.1795394316019;
        Sun, 22 Nov 2026 16:38:36 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989e3sm19085530f8f.52.2026.11.22.16.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 16:38:34 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=e1fb7fe5361dd0dcfcd46f0aa31ce9f52e225a0a7b5a4d7bd3c717407afa;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 01:38:26 +0100
Message-Id: <DN265Y2EAGQV.1ZD49JSIDMME5@gmail.com>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "liubaolin" <liubaolin12138@163.com>, "koraynilay"
 <koray.fra@gmail.com>, "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul
 Lee" <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-4-koray.fra@gmail.com>
 <1ebbb85f-3515-4c45-a850-8039aad93800@163.com>
In-Reply-To: <1ebbb85f-3515-4c45-a850-8039aad93800@163.com>

--e1fb7fe5361dd0dcfcd46f0aa31ce9f52e225a0a7b5a4d7bd3c717407afa
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sun Nov 22, 2026 at 1:49 PM CET, liubaolin wrote:
>
>
> =E5=9C=A8 2026/11/22 08:08, koraynilay =E5=86=99=E9=81=93:
>> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
>> modern xflags (FS_XFLAG_*) fileattr API with masks.
>>=20
>> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
>> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
>> to be used in this API switch.
>>=20
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>   fs/file_attr.c           |  8 +++++
>>   fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>>   include/linux/fileattr.h |  6 ++--
>>   include/uapi/linux/fs.h  |  2 ++
>
> Hi koraynilay,
>     One suggestion on the patch split: would it make sense to put the
> new COMPR/ENCRYPT xflags and their VFS handling in a separate patch
> before the NTFS conversion?
>     The changes to include/uapi/linux/fs.h, include/linux/fileattr.h
> and fs/file_attr.c introduce generic fileattr support, and the
> COMMON mask changes also affect other filesystems.
>     Keeping those changes together in a VFS patch would make the API
> and compatibility aspects easier to review.
>     The following NTFS patch could then focus on using the new flags=20
> while preserving the existing NTFS behaviour.

Hi Baolin and thanks for the feedback,
for now I put them in the same patch since they're not many lines of
code changes, but I now also had to add NOCOMP, maybe I'll split it in
the next version.

> Thanks,
> Baolin.
>
>>   4 files changed, 44 insertions(+), 35 deletions(-)
>> [...]
>>   	if (err)
>>   		return err;
>>  =20
>> -	if (fileattr_has_fsx(fa))
>> -		return -EOPNOTSUPP;
>> -
>> -	/* chattr passes the unchanged read-only flags back to us too. */
>> -	if (NInoCompressed(ni) || NInoWofCompressed(ni))
>> -		readonly |=3D FS_COMPR_FL;
>> -	if (NInoEncrypted(ni))
>> -		readonly |=3D FS_ENCRYPT_FL;
>> -	if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
>> -		return -EOPNOTSUPP;
>> -	allowed |=3D readonly;
>> -
>> -	/* Case folding is a read-only, mount-wide property. */
>> -	if (!NVolCaseSensitive(ni->vol))
>> -		allowed |=3D FS_CASEFOLD_FL;
>> -	if (fa->flags & ~allowed)
> Hi koraynilay,
>     There is another case worth keeping in mind when replacing this check=
:
>     fileattr_fill_flags() only translates a subset of FS_*_FL bits,
> so some unsupported flags will not appear in fsx_xflags.
>    For example, a direct SETFLAGS request containing only FS_NOCOW_FL=20
> produces fsx_xflags =3D=3D 0. On a normal file on a case-sensitive mount,
> the new check would accept that request.
>    If the file already has persistent NODUMP set, the request would also
> clear it, since the setter rebuilds linuxflags without NODUMP and writes
> it back to the EA. The current code rejects the request and leaves the
> existing attributes unchanged.
>
>    Would it be possible to keep validating fa->flags when flags_valid is
> set, in addition to the xflags check?

We could, but the objective is to have filesystems that implement the
new _masks API use only xflags.

> Thanks,
> Baolin.
>
>
>> +	/*
>> +	 * When userspace uses file_[gs]etattr(), VFS already checks and fails
>> +	 * with -EOPNOTSUPP if rw_mask & ro_mask !=3D 0 and rw_mask & ~allowed=
,
>> +	 * but for FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR VFS can't check for
>> +	 * allowed flags as these ioctls don't support fsx_xflags_{rw,ro}_mask=
,
>> +	 * so we need to check for unsupported flags anyway.
>> +	 */
>> +	if (!fa->has_masks &&
>> +	    ((fa->fsx_xflags & ~NTFS_RW_XFLAGS) ||
>> +	     fa->fsx_extsize || fa->fsx_projid || fa->fsx_cowextsize))
>>   		return -EOPNOTSUPP;
>
> Hi koraynilay,
>     Could we keep the existing handling of read-only attributes
> for legacy SETFLAGS callers here?
>     On a case-insensitive NTFS mount, the VFS carries over=20
> FS_XFLAG_CASEFOLD from the current attributes, since it is not in=20
> FS_XFLAG_COMMON.
> This check would then reject it because CASEFOLD is not in=20
> NTFS_RW_XFLAGS, so even chattr +d would fail with EOPNOTSUPP.
>     The unchanged COMPR/ENCRYPT bits that chattr reads with GETFLAGS and
> passes back with SETFLAGS would also be rejected on compressed/encrypted=
=20
> files.
>     Allowing those existing read-only attributes to be passed back=20
> unchanged  would let users continue setting and clearing the persistent=
=20
> flags through chattr,as they can today.
>
> Thanks,
> Baolin.

Since I wasn't quite satisfied with this version, I'm working on a
revisited v2, that is hopefully cleaner and fixes these bugs and the
ones reported by sashiko.

Thanks,
koraynilay


>>  =20
>>   	forced_immutable =3D ntfs_is_forced_immutable(vi);
>> -	if (!(fa->flags & FS_IMMUTABLE_FL) && forced_immutable)
>> +	if (!(fa->fsx_xflags & FS_XFLAG_IMMUTABLE) && forced_immutable)
>>   		return -EPERM;
>>  =20
>> -	if (fa->flags & FS_IMMUTABLE_FL) {
>> +	if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) {
>>   		new_fl |=3D S_IMMUTABLE;
>>   		/* Do not persist an immutable bit derived from the mount. */
>>   		if (!forced_immutable ||
>>   		    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
>>   			linuxflags |=3D NTFS_LINUXFLAGS_IMMUTABLE;
>>   	}
>> -	if (fa->flags & FS_APPEND_FL) {
>> +	if (fa->fsx_xflags & FS_XFLAG_APPEND) {
>>   		new_fl |=3D S_APPEND;
>>   		linuxflags |=3D NTFS_LINUXFLAGS_APPEND;
>>   	}
>> -	if (fa->flags & FS_NODUMP_FL)
>> +	if (fa->fsx_xflags & FS_XFLAG_NODUMP)
>>   		linuxflags |=3D NTFS_LINUXFLAGS_NODUMP;
>> -	if (fa->flags & FS_NOATIME_FL) {
>> +	if (fa->fsx_xflags & FS_XFLAG_NOATIME) {
>>   		new_fl |=3D S_NOATIME;
>>   		linuxflags |=3D NTFS_LINUXFLAGS_NOATIME;
>>   	}
>> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
>> index 4faa40febf11..219e7c8eb601 100644
>> --- a/include/linux/fileattr.h
>> +++ b/include/linux/fileattr.h
>> @@ -7,12 +7,14 @@
>>   #define FS_COMMON_FL \
>>   	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>>   	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
>> -	 FS_PROJINHERIT_FL | FS_VERITY_FL)
>> +	 FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
>> +	 FS_ENCRYPT_FL)
>>  =20
>>   #define FS_XFLAG_COMMON \
>>   	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>>   	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
>> -	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
>> +	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
>> +	 FS_XFLAG_ENCRYPT)
>>  =20
>>   /* Read-only inode flags */
>>   #define FS_XFLAG_RDONLY_MASK \
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index e40806b3a69c..09fc7e066485 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -275,6 +275,8 @@ struct file_attr {
>>   #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
>>  =20
>>   #define FS_XFLAG_PROJID		0x00100000	/* project ID */
>> +#define FS_XFLAG_COMPR		0x00200000	/* Compress file */
>> +#define FS_XFLAG_ENCRYPT	0x00400000	/* Encrypted file */
>>   #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>>  =20
>>   /* the read-only stuff doesn't really belong here, but any other place=
 is



--e1fb7fe5361dd0dcfcd46f0aa31ce9f52e225a0a7b5a4d7bd3c717407afa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawOLAgAKCRDmj22qf5IG
XKLxAQCTRtAIOKyKCy1HCPCIGMpDT8mK4MMZQCw2HwUAkHF6dQD/TwpK7+eZCgaK
R5Ac0/ouAvLeGZs5OiVE22OAY998dQw=
=V3ow
-----END PGP SIGNATURE-----

--e1fb7fe5361dd0dcfcd46f0aa31ce9f52e225a0a7b5a4d7bd3c717407afa--
