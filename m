Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442297;
	b=4NNwjT15Foi2wJbxOcsGpsi9is4faA7Nbr1bkaKstdr28h7qvZgPlots+N640Jj0xiQb
	 hRT6TB1Ib1TrfQLayOSYxF+aTpBQqymxofvyeCezbbOb05n7lVCkweAZS7vlNatS3S/q7
	 tEF7B+urJZhNo/VQzVABBuRYObN5vkKAmJ/dAViyvJBTzOI7C3CXk75gQcOJrI9286wmI
	 UkWj+2VX9kq72BKLPdEiNUXHSBDDj9BuQT2GJtjwxyZvCv4hGysghx/15bs5fO65lhLQq
	 kSRwmhRU4/z7tCMFg6EJY/vzsVEFB7rgTg+YTv6B44fBlVn7nxVoXpTzrK0djwrq1tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=5Q/yc2w5X3XQrg0gbtxjS5qGQ76XxwRJnEkyShTk6I4=;
	b=KcU1fnn1fH3AqIxPa7sKeKDMmGHEdVqjKpm4mBywmK5MH0Cp4nfkL1BDUeOGDsk9Gg+f
	 mVICyidJSlTZofqzFWCl3DmOaVQDitNpaLZolQqfk10WVT8oOAvPhVk0fThcrwzeHAqPG
	 Oa01AxM0UxYzHtiJi4F2IADDARIm8s4WqhRaRmiP2t0RHcSMEoF6VxuIJNcuLbrTwI+bI
	 K5B7TdJHn/R1gjV4vx0bBvGvhQfYPcbeEFPs/zEZh2VjwaJtGM3MVtp+56/J0TNfStZtb
	 q+1FlMF0i5xKlPYR/jxsD2TgKl8mRvn8gsh2FYdUuaaFAuyxBAg/n6AXpjZi49uK2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kMk+HBsv;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8F2606A69A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 13:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D8F2606A69A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kMk+HBsv
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4b467581b98so31151265e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 05:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795442294; x=1796047094; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5Q/yc2w5X3XQrg0gbtxjS5qGQ76XxwRJnEkyShTk6I4=;
        b=kMk+HBsvyGhZitDhdIV2fqKapsGB9oA9IQe91yTId8R53gCyi5sJ0I/gHkQtLanRb2
         CVfPl3n9w6vmEMX6tY7TBqik+3PJgZCxa1COHL+eyhmGSAe10J66iB6MjMJP+Hf74i/D
         WVrlY6gOqm+XeSnAJVNUixYyNVemF7qu9M4ttxeEK6SDtlxhzHrGSH4PVaiidZLNZbY0
         v1B6DemdeNZ8OmclfMoPPShGkXq9J2dGGJ23s2yR5k697q++eAG1GXXMJz7xr1+FElBh
         ikV2BNk8IwIAuiCUv+yUSKGoWZDxwzvskLXfpZSHh4kIQ8dnwH/Ba0ypeMo4+6x03jJp
         +UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442294; x=1796047094;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5Q/yc2w5X3XQrg0gbtxjS5qGQ76XxwRJnEkyShTk6I4=;
        b=VjEMwmk0INTmOjmv+hGDGCyG3pRJlWXUUEuTzHy10u5ruFplORjuS4Z+dCs57wqSVx
         NX58jvx1lr+SQlSkcRP0eiGFfUFhB0OQzxmV33cWKKvfRYbSCWFO0xhsa1XdMtWp50Zb
         /P/M4toyIWAAu2Pu3N2BuDxZx7cTgVBMiLNBrvNpd+8+IU1CA/th/rVU8RDWsrHAP019
         zSoslXe6CmMSQCNYOb13OuQfu0V/zf/udYSDJuNqejOFr0rEuAcp/ruN7DLw+uJgII6s
         I/KZ180A4Ba2OHmBs17/czuOxjH1SF243RmHx6J64s37ti/UzqzAeVCqjncuUOXBGGN+
         8pFQ==
X-Forwarded-Encrypted: i=1; AL+hErG862UE7qEktl9sAwJzg1L4AAXRtOEHTg+qBnt3D62ZJT1z9dbqBRDaEHkp++3Zz0xq/nTQprl8Wcw=@vger.kernel.org
X-Gm-Message-State: APuU4Z81U7FmJbLzOP4Hke+X5UH5TRKfLxRRQgrHAElnoRtBAEUzkP2M
	0MV6xKyq56R96qwppnnjXpf8rBHDtSxf0t8unpNeh4qbCoWK4PsXTuKN
X-Gm-Gg: AZFdTZfsWrGT0thAtqxP0xCc1S8p76dFppIIDkK6CfJEX8luc0PikWJ+DYIxqZwGTRk
	aIXbrA4ITkW2VSS2A4XvAV8pdc+YB7oxflHFVl+3nJhTREPcg7yYOjmS1b60xfJZW6frN9PocBm
	5P5AVvF1aS7w9LcEmoNko0mnYDGpRV4bzDd42rsNkwF0NoW4RX3aGXbJiA/EeX0fo5FiZrDwELv
	jYXdVRcYp9nNKJVHqTG9i96krPgMwOgABgLjGpaZxNR7ZgfKa2tgQNHpU83udjwiRAPgthv6fn1
	vPOv+TQIete74N+djQA8BvJm5B0XIPhu8fth/++4u63VwKaqdxSRZNkxqD7iJzUeOpKBKaiwdxd
	jRbL508x5S+a6S4iW63Pra3rHI72BPIsHKp81GIn6RM53kZsrm3ZNmLI0BofO4o3sT1t+5Ig9qA
	S1IQl9gfXrTBGXHYKxWN3GeZYCrdpzjdsJ09AjMPbMGe6wpZO9LqMYbmSUSdyf2I9YZbn1Z1Nz9
	q3ASHgaYAOpp7AaqYuuybOGP0MFBeeNnAQe4xjqFEXP3NMz9Z1QAZ3Pikl8rstSbngvXH7yuq0X
	8XfUZmunqXKdZQtvDjoxjCp+Lw==
X-Received: by 2002:a05:600c:1389:b0:4bb:7347:d5c0 with SMTP id 5b1f17b1804b1-4bb88826937mr218333645e9.9.1795442294159;
        Mon, 23 Nov 2026 05:58:14 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b3a7sm403446295e9.3.2026.11.23.05.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 05:58:13 -0800 (PST)
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
 boundary=52bce07b6ee0cd9a9d2c4c9ddff1a8c18d7d4193ed2dd8ff64d9d44f8343;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 14:58:11 +0100
Message-Id: <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>

--52bce07b6ee0cd9a9d2c4c9ddff1a8c18d7d4193ed2dd8ff64d9d44f8343
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
> On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
>> equivalent masks to struct file_kattr.
>>
>> Also add has_masks selector to struct file_kattr so we can know when a
>> user of this API (userspace or filesystem) supports them.
>>
>> This lets filesystems advertise their support for specific xflags, like
>> statx.stx_attributes_mask does, and userspace can specify only which
>> xflags it wants to change without needing a RMW cycle:
>> - on GET: each filesystem that wants to support this new API fills the
>>   masks according to its supported and read-only xflags, then:
>>   * for boolean xflags: it fills fsx_xflags with the current on-disk val=
ue
>>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
>>     xflag value in the struct field;
>> - on SET: userspace fills the rw_mask with the bits of the xflags it
>>   wants to change, then:
>>   * for boolean xflags: it provides the xflag value as a bit in fa_xflag=
s
>>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
>>     provides the value in the struct field; if the xflag bit is set to 0
>>     instead, this informs the kernel to unset/clear that value.
>>
>> Since fa_xflags_rw_mask means "I want to change the xflags specified in
>> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check for
>> permissions and fileattr support without checking any xflags.
>>
>> Behaviour of older programs that already use file_[gs]etattr() is
>> preserved by checking against FILE_ATTR_SIZE_VER*.
>>
>> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
>> the projid using file_[gs]etattr() by leveraging the new masks.
>>
>> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accepting
>> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
>> and use it to validate/clamp both the _xflags fields and the masks.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c           | 128 ++++++++++++++++++++++++++++++++++++---
>>  include/linux/fileattr.h |   7 +++
>>  include/uapi/linux/fs.h  |   7 ++-
>>  3 files changed, 131 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> index 40d6518f1d8e..0e16c23368b2 100644
>> --- a/fs/file_attr.c
>> +++ b/fs/file_attr.c
>> @@ -102,13 +102,20 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>>                                   struct file_attr *fattr)
>>  {
>> -       __u32 mask =3D FS_XFLAGS_MASK;
>> -
>>         memset(fattr, 0, sizeof(struct file_attr));
>> -       fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> +       /* Pass the masks to userspace if underlying fs uses them. */
>> +       if (fa->has_masks) {
>> +               fattr->fa_xflags_rw_mask =3D fa->fsx_xflags_rw_mask &
>> +                                          FS_FILE_ATTR_XFLAGS_MASK;
>> +               fattr->fa_xflags_ro_mask =3D fa->fsx_xflags_ro_mask &
>> +                                          FS_FILE_ATTR_XFLAGS_MASK;
>> +       }
>> +       fattr->fa_xflags =3D fa->fsx_xflags & FS_FILE_ATTR_XFLAGS_MASK;
>>         fattr->fa_extsize =3D fa->fsx_extsize;
>>         fattr->fa_nextents =3D fa->fsx_nextents;
>>         fattr->fa_projid =3D fa->fsx_projid;
>> +       if (fa->fsx_projid)
>> +               fattr->fa_xflags |=3D FS_XFLAG_PROJID;
>>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>>  }
>>
>> @@ -141,12 +148,30 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>>                                  struct file_kattr *fa)
>>  {
>> -       __u64 mask =3D FS_XFLAGS_MASK;
>> +       u64 rw_mask =3D fa->has_masks ? fattr->fa_xflags_rw_mask : FS_XF=
LAGS_MASK;
>>
>> -       if (fattr->fa_xflags & ~mask)
>> +       /*
>> +        * No need to check for has_masks here, as fa_xflags_rw_mask is =
0 in
>> +        * VER0 mode.
>> +        */
>> +       if (fattr->fa_xflags_rw_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
>>                 return -EINVAL;
>>
>> -       fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MAS=
K);
>> +       if (fattr->fa_xflags & ~rw_mask)
>> +               return -EINVAL;
>> +
>> +       /*
>> +        * Filter with ~FS_XFLAG_RDONLY_MASK only when in VER0 mode, so
>> +        * filtering with the actual filesystem read-only xflags can be =
done in
>> +        * vfs_fileattr_set() once we have the fsx_xflags_ro_mask from t=
he fs.
>> +        */
>> +       if (fa->has_masks) {
>> +               fileattr_fill_xflags(fa, fattr->fa_xflags);
>> +               fa->fsx_xflags_rw_mask =3D fattr->fa_xflags_rw_mask;
>> +       } else {
>> +               fileattr_fill_xflags(fa,
>> +                                    fattr->fa_xflags & ~FS_XFLAG_RDONLY=
_MASK);
>> +       }
>>         fa->fsx_extsize =3D fattr->fa_extsize;
>>         fa->fsx_projid =3D fattr->fa_projid;
>>         fa->fsx_cowextsize =3D fattr->fa_cowextsize;
>> @@ -187,6 +212,14 @@ static int fileattr_set_prepare(struct inode *inode=
,
>>  {
>>         int err;
>>
>> +       /*
>> +        * If the fs supports the fsx_xflags_{rw,ro}_mask API, fail when=
 the
>> +        * requested rw flags are not in the supported ones for that fs
>> +        */
>> +       if (old_ma->has_masks &&
>> +           (fa->fsx_xflags_rw_mask & ~old_ma->fsx_xflags_rw_mask))
>> +               return -EOPNOTSUPP;
>> +
>>         /*
>>          * The IMMUTABLE and APPEND_ONLY flags can only be changed by
>>          * the relevant capability.
>> @@ -211,6 +244,11 @@ static int fileattr_set_prepare(struct inode *inode=
,
>>                                 FS_XFLAG_PROJINHERIT)
>>                         return -EINVAL;
>>         } else {
>> +               /* If user wants to unset projid, set it to 0 */
>> +               if ((fa->fsx_xflags_rw_mask & FS_XFLAG_PROJID) &&
>> +                   ((fa->fsx_xflags & FS_XFLAG_PROJID) =3D=3D 0))
>> +                       fa->fsx_projid =3D 0;
>> +
>>                 /*
>>                  * Caller is allowed to change the project ID. If it is =
being
>>                  * changed, make sure that the new value is valid.
>> @@ -250,6 +288,8 @@ static int fileattr_set_prepare(struct inode *inode,
>>                 fa->fsx_xflags &=3D ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZI=
NHERIT);
>>         if (fa->fsx_cowextsize =3D=3D 0)
>>                 fa->fsx_xflags &=3D ~FS_XFLAG_COWEXTSIZE;
>> +       if (fa->fsx_projid =3D=3D 0)
>> +               fa->fsx_xflags &=3D ~FS_XFLAG_PROJID;
>>
>>         return 0;
>>  }
>> @@ -275,6 +315,8 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, =
struct dentry *dentry,
>>  {
>>         struct inode *inode =3D d_inode(dentry);
>>         struct file_kattr old_ma =3D {};
>> +       u32 rw_user_mask =3D fa->fsx_xflags_rw_mask;
>> +       u32 rw_fs_mask =3D 0, ro_fs_mask =3D 0;
>>         int err;
>>
>>         if (!inode->i_op->fileattr_set)
>> @@ -288,15 +330,53 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap=
, struct dentry *dentry,
>>         if (err)
>>                 goto out;
>>
>> +       if (old_ma.has_masks) {
>> +               old_ma.fsx_xflags_rw_mask &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +               old_ma.fsx_xflags_ro_mask &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +               rw_fs_mask =3D old_ma.fsx_xflags_rw_mask;
>> +               ro_fs_mask =3D old_ma.fsx_xflags_ro_mask;
>> +       }
>> +       old_ma.fsx_xflags &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +
>>         /* initialize missing bits from old_ma */
>>         if (fa->flags_valid) {
>> +               /* FS_IOC_SETFLAGS */
>> +               fa->fsx_xflags_rw_mask =3D 0;
>>                 fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG_COMMON=
;
>>                 fa->fsx_extsize =3D old_ma.fsx_extsize;
>>                 fa->fsx_nextents =3D old_ma.fsx_nextents;
>>                 fa->fsx_projid =3D old_ma.fsx_projid;
>>                 fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>>         } else {
>> +               /*
>> +                * Preserve flags not being set when using FS_IOC_FSSETX=
ATTR or
>> +                * file_setattr VER0+.
>> +                */
>>                 fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> +
>> +               /* file_setattr VER1+ */
>> +               if (fa->has_masks) {
>> +                       /* Preserve old xflags that aren't being set. */
>> +                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~rw_user=
_mask;
>> +
>> +                       /*
>> +                        * Filter fsx_xflags by removing xflags that are=
:
>> +                        * - filesystem-reported read only
>> +                        * - globally read only
>> +                        * but keeping xflags that are:
>> +                        * - filesystem-reported rw, globally ro
>> +                        */
>> +                       ro_fs_mask |=3D FS_XFLAG_RDONLY_MASK & ~rw_fs_ma=
sk;
>> +                       fileattr_fill_xflags(fa, fa->fsx_xflags & ~ro_fs=
_mask);
>> +
>> +                       if (!(rw_user_mask &
>> +                             (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)=
))
>> +                               fa->fsx_extsize =3D old_ma.fsx_extsize;
>> +                       if (!(rw_user_mask & FS_XFLAG_PROJID))
>> +                               fa->fsx_projid =3D old_ma.fsx_projid;
>> +                       if (!(rw_user_mask & FS_XFLAG_COWEXTSIZE))
>> +                               fa->fsx_cowextsize =3D old_ma.fsx_cowext=
size;
>> +               }
>>         }
>>
>>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
>> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char =
__user *, filename,
>>                 return error;
>>
>>         fileattr_to_file_attr(&fa, &fattr);
>> +       /*
>> +        * Remove xflags added in or after VER1 so userspace programs co=
mpiled
>> +        * against VER0 don't try to write xflags they don't know about =
(since
>> +        * they do RMW).
>> +        */
>> +       if (usize < FILE_ATTR_SIZE_VER1)
>> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
>> +
>
> This looks odd.
> old struct size with new flags should be -EINVAL not silently drop them

Right, and the GET path should strip any new flags, so old programs
doing RMW will never see them, correct?

>
>>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
>>                                     sizeof(struct file_attr), NULL);
>>
>> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char =
__user *, filename,
>>         if (error)
>>                 return error;
>>
>> -       error =3D file_attr_to_fileattr(&fattr, &fa);
>> -       if (error)
>> -               return error;
>> -
>>         CLASS(filename_maybe_null, name)(filename, at_flags);
>>         if (!name && dfd >=3D 0) {
>>                 CLASS(fd, f)(dfd);
>> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char =
__user *, filename,
>>                         return error;
>>         }
>>
>> +       /*
>> +        * Userspace said "I don't want to change any flag", so be it I =
guess.
>> +        * Still check for fileattr support and permissions, also in cas=
e this
>> +        * is just a probe.
>> +        */
>> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask =
=3D=3D 0) {
>> +               struct inode *inode =3D d_inode(filepath.dentry);
>
>
> No No this is not what this userspace said!
>
> This user space is the same old chattr programs recompiled with a new
> fs.h header file
> installed.

Oh, right, I did not think about this case, I hope it doesn't break too
much of the new code I changed already for v2 :(

> When userspace does not set anything is masks it means "old API"

And so a modern program using masks that passes rw_mask as 0 should be
also interpreted as "old API", even if it kinda goes against the
definition of rw_mask right?
And other than VER there is no way to know if it's a SETFLAGS compiled
against modern fs.h or fileattr VER1 explicitly setting rw_mask to 0,
right?

>
>> +
>> +               if (!inode->i_op->fileattr_set)
>> +                       return -EOPNOTSUPP;
>> +
>> +               if (!inode_owner_or_capable(mnt_idmap(filepath.mnt), ino=
de))
>> +                       return -EPERM;
>> +
>> +               return error;
>> +       }
>> +
>> +       if (usize >=3D FILE_ATTR_SIZE_VER1)
>> +               fa.has_masks =3D true;
>
> And a non-zero ro or rw mask

Right, for the same case as above.

>
>> +
>> +       error =3D file_attr_to_fileattr(&fattr, &fa);
>> +       if (error)
>> +               return error;
>> +
>>         error =3D mnt_want_write(filepath.mnt);
>>         if (!error) {
>>                 error =3D vfs_fileattr_set(mnt_idmap(filepath.mnt),
>> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
>> index c8f69dde5dd3..4faa40febf11 100644
>> --- a/include/linux/fileattr.h
>> +++ b/include/linux/fileattr.h
>> @@ -35,6 +35,10 @@
>>         (FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK |=
 \
>>          FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
>>
>> +/* Flags only for fa_ fields */
>> +#define FS_FILE_ATTR_XFLAGS_MASK \
>> +       (FS_XFLAGS_MASK | FS_XFLAG_PROJID)
>> +
>>  /*
>>   * Merged interface for miscellaneous file attributes.  'flags' origina=
tes from
>>   * ext* and 'fsx_flags' from xfs.  There's some overlap between the two=
, which
>> @@ -45,6 +49,8 @@ struct file_kattr {
>>         u32     flags;          /* flags (FS_IOC_GETFLAGS/FS_IOC_SETFLAG=
S) */
>>         /* struct fsxattr: */
>>         u32     fsx_xflags;     /* xflags field value (get/set) */
>> +       u32     fsx_xflags_rw_mask; /* supported writeable xflags (get) =
/ flags to set (set) */
>> +       u32     fsx_xflags_ro_mask; /* supported read-only xflags (get) =
*/
>>         u32     fsx_extsize;    /* extsize field value (get/set)*/
>>         u32     fsx_nextents;   /* nextents field value (get)   */
>>         u32     fsx_projid;     /* project identifier (get/set) */
>> @@ -52,6 +58,7 @@ struct file_kattr {
>>         /* selectors: */
>>         bool    flags_valid:1;
>>         bool    fsx_valid:1;
>> +       bool    has_masks:1;
>>  };
>>
>>  int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __=
user *ufa);
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index a13c7b32a1bd..e40806b3a69c 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -238,10 +238,13 @@ struct file_attr {
>>         __u32 fa_nextents;      /* nextents field value (get)   */
>>         __u32 fa_projid;        /* project identifier (get/set) */
>>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) */
>> +       __u32 fa_xflags_rw_mask;/* supported writeable xflags (get) / fl=
ags to set (set) */
>> +       __u32 fa_xflags_ro_mask;/* supported read-only xflags (get) */
>>  };
>>
>
> fa_xflags is __u64
> It is short sighted to use __u32 masks for the syscall API

Ah yes thanks, gemini neon pointed this out to me just yesterday ahah.

Thanks,
koraynilay

>
>>  #define FILE_ATTR_SIZE_VER0 24
>> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> +#define FILE_ATTR_SIZE_VER1 32
>> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>>
>>  /*
>>   * Flags for the fsx_xflags field
>> @@ -270,6 +273,8 @@ struct file_attr {
>>   */
>>  #define FS_XFLAG_CASEFOLD      0x00040000      /* case-insensitive look=
ups */
>>  #define FS_XFLAG_CASENONPRESERVING 0x00080000  /* case not preserved */
>> +
>> +#define FS_XFLAG_PROJID                0x00100000      /* project ID */
>>  #define FS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   =
*/
>>
>
>
> If anything the newline should be before the gap to HASATTR
>
> Thanks,
> Amir.



--52bce07b6ee0cd9a9d2c4c9ddff1a8c18d7d4193ed2dd8ff64d9d44f8343
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRGcwAKCRDmj22qf5IG
XGWAAPwIE0u/PGLd9P/5gVrEqfENoMRgSEkY/CGTX3l10MXQEAEAiKApsB0sRwW4
qR/JMZzAvQk+kTT5ouAY04C1AqBRmwk=
=ptYa
-----END PGP SIGNATURE-----

--52bce07b6ee0cd9a9d2c4c9ddff1a8c18d7d4193ed2dd8ff64d9d44f8343--
