Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795802797;
	b=OiC5pFqKYOtOpFaXRKgQB3GnTiAu7WPVVOxUkk7N+YRyckyTc9c5jRo8kNlwh+YPpHd5
	 IOlp+QnWnRXFLCVtMrGRcjaR7H6N8dyVu6tS4wYGLeIA8F6TjtpoACryqEBL1lGKwE3Ui
	 /TG061wBDnA/To56xJiRGz+2znvY+nuBZWoiRuo4xQHwIOZpPTyu00lo/6CnEPPpq5Pkv
	 LsGsPj3ouu2d6k90S5Vds/Sd678+NT9QValc1Kus82H5/QcnrvuosTNd1id2OVKQYsDcw
	 /vJRQQre92N7l//1i/OPawUAOgYjwUD4JISVsfK7wnKk/IT3+1Fs6ZYjxe1r8SfgQ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795802797;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=31lkBKO8oQ3sa6c4sPU8C1+DntgMuazBHbo8HSmfOrA=;
	b=XV0Sqhegw0SPMP+pGkLV25G7GEvMqyP0OvTISnY6vVCh4T0h0kbJqmAhSgFSADw2X8tg
	 p0+fFXJTtem/5BpaDqFaKuaMBOicOEd7DAaTzN3bhIFRCiLPnSKSRba5tkiISUSCFH4MW
	 8E0YLHSxKGGilV5ZLPFsah45Le+RDV+SHcYFoRyxRmv9H/jt1MXDp0/iCR5jKaQl5shxM
	 Pt8kFDb9x23CQSHi3gSl5PXf+p2akxOQpNdIdJ1v3KCCMDD0UX6lkg4frETCGjEds5tCd
	 e02lXsA2kKWzQP/cOr1i8pTsKyhCDE9/cW9x0EUvzidnCp+TCB8bV42TXyYVpb7avjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gtOjgV7k;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF76606A327
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 18:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CF76606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gtOjgV7k
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so55287775e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 10:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795802795; x=1796407595; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=31lkBKO8oQ3sa6c4sPU8C1+DntgMuazBHbo8HSmfOrA=;
        b=gtOjgV7kQRPDJZxzHD5ysYcKBIp1wluCgKbD4A8k17RCVgasxJdU1GV+jVyh0WPzUT
         +Q/ve92Tzv2/ub7GIYZe70pSbaTvhdI8kA8AMDz2HtS/Ry+MFm4UiGxsHcahVRg75WMT
         t/wSSU4K80PUANTU3YB4OPbnzq8Uy+S1zPuebou8cJqYR7NMskfeUqdR+r443eHCjrqV
         WeaBY0njy3dxba1R8lmilwhLmhtZ5jVA63UUIjbFv+yVIhLNhr5WzHLp8OUXgWWeq7RM
         ru2IOyoe73DlDU6K+SF3IPEyUrje5RVMGeJ3rfVKiDOQv6iNyTD/kE1Lr76k2brIPhQq
         q3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795802795; x=1796407595;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=31lkBKO8oQ3sa6c4sPU8C1+DntgMuazBHbo8HSmfOrA=;
        b=P+nGJ+JbRRrWZj46dVfpIwltT0lkyNbKbM7sAiWnpA8jF0iHNiWUcwimeK1K6JSCkC
         NP2d7GASFNeYiM7DZA4EL6aFUzXGEdgeLU8pJREK2eSR14jwjDKal3FfwW0WyMgvKIH5
         Jcwv7F6K+rkR5Ur4d2yqXbZE4Up4fSrOLJOSP4KENukwK/4qinJrGiDzTq+vU43tM75O
         DkL6F1XjWLclE/WcJY1KyeBpUOjPK9Acz/VPpE8HWydZz988Noa4aM6biUutUN1SePos
         OdSJMi37xTF7fFxKSsRNP/IHL3KQzO+A2eND9V92E2DzkbakgSV1P+ost1/8LRfX0xBb
         O17Q==
X-Forwarded-Encrypted: i=1; AL+hErFd/Th9Pf8QBIDLcqvW/uZKTkwuPRTGuJ7Z1iPkN5h+cl/aGZ5LZjk0NhmMEQrDDZC2mtn2u0+B5dc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/adZiB6BTtj5BJtF9mZ9mEY5489O5Mkn+04IPq7MCJJ+5Vnqpk
	lX3VMUG8hIk/F1FDBPE778hoEINhc9xgiu3Y66LJA6fdrj5DiUM/bFf8
X-Gm-Gg: AZFdTZeGANol7bp/s7tej0pkIH6YSyH75f69dh1MK3En7EerG4mRdyiggOnJDrKukhy
	Iq+Kk8DyUA1/ksHLZhep6bpI7hzbP4syEkLLnFpI9Rc/pBDDJ7R8s5xUSZm7MUobWKX+vrCTEQ1
	F3/b5EzVNtqvphr4zuJ2blFs9q8BkL7v1wZrukLVkdchTga/lLO2BqGaj42us/e1X5SaYCMxr8z
	X3j5SlCH7CcNDAlwQ668rbX2GfOILhzers5YEmMUtPM5kwhUv4R+SQegmoE8PvBcbkHta1gOQWg
	YKf5OsfDDJjN7CPVoWNYDvnQwMKnAO8Go7+qvuNiByFOvnnMIHO/mzC1/BL2UUP0zuKAtXYwFIt
	A1ldxl60uH2oPC+Vv8ppW8Y2k5QMjoxjc8A7YVXFgQbF40vmXhHBCYUov0Q+O10zyKLlSIItRyc
	wSljm+cQcF65DXQn7hogEwaP2fbM6WWevWNuWCHQ8Kp66ZZciMbMeVxKtiV5Rt/d67QyqyJdtXJ
	8jRnu/LLj4l7atgfyd31SF9Ys77f+h1uweOAkbEqMgM2MMgJBsBdTPdFhmyZjGvxIdxKkHof1RL
	R6V6o96+sVXaltJauZdkhirmbQ==
X-Received: by 2002:a05:600d:a:b0:4bb:aa4f:c01d with SMTP id 5b1f17b1804b1-4bbaa4fc151mr135668155e9.1.1795802795080;
        Fri, 27 Nov 2026 10:06:35 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b3a7sm791527715e9.3.2026.11.27.10.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 10:06:34 -0800 (PST)
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
 boundary=5a3f61e607b661bce23953d8b2acf29cca7bc4b24c3dca1ea3d419584a61;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 19:06:30 +0100
Message-Id: <DN66YKVRVRU7.1062V6NCL4LUW@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-4-koray.fra@gmail.com>
 <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>

--5a3f61e607b661bce23953d8b2acf29cca7bc4b24c3dca1ea3d419584a61
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 6:48 PM CET, Amir Goldstein wrote:
> On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
>> __u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
>> FILE_ATTR_SIZE_VER1, which is now 40 bytes.
>>
>> Add equivalent masks and a has_masks selector to struct file_kattr, so
>> we can know when a user of this API (userspace or filesystem) supports
>> them.
>>
>> This lets filesystems advertise their support for specific xflags, like
>> statx.stx_attributes_mask does, and userspace can specify only which
>> xflags it wants to change without needing a RMW cycle.
>>
>> These masks have the following semantics:
>> - fsx_xflags_rw_mask:
>>   * for filesystems: advertise which xflags they support changing
>>   * for userspace:   specify which xflags it wants to modify
>> - fsx_xflags_ro_mask:
>>   * for filesystems: advertise which xflags they support only reading
>>   * for userspace:   ignored
>>
>> And they should be filled according to the following:
>> - GET:
>>   each filesystem that wants to implement this new API fills the masks
>>   according to its supported read-write and read-only xflags,
>>   then:
>>   * for boolean xflags: it fills fsx_xflags with the current on-disk val=
ue;
>>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
>>     xflag value in the struct field;
>> - SET:
>>   userspace fills the rw_mask with the bits of the xflags it wants to
>>   change, then:
>>   * for boolean xflags: it provides the xflag value as a bit in fa_xflag=
s;
>>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
>>     provides the value in the struct field; if the xflag bit is set to 0
>>     instead, this informs the kernel to unset/clear that value.
>>
>> Add AT_FILE_ATTR_MASKS at_flags option that userspace needs to pass
>> (with usize >=3D FILE_ATTR_SIZE_VER1) in order to be able to use masks,
>> otherwise legacy RMW semantics are used.
>>
>> If AT_FILE_ATTR_MASKS is not specified:
>> - on GET, zero fa_xflags_rw_mask and fa_xflags_ro_mask and strip new
>>   xflags added in or after VER1, so older programs doing RMW don't pass
>>   them back;
>> - on SET, reject non-zero fa_xflags_{rw,ro}_mask with -EINVAL.
>>
>> If AT_FILE_ATTR_MASKS is specified on SET with fa_xflags_rw_mask =3D 0,
>> return early as a no-op after permission and support checks.
>>
>> To make both legacy and new programs interact correctly with both legacy
>> and new/upgraded filesystems, add:
>> - xflags_to_flags() / flags_to_xflags(): use fileattr_fill_*() to
>>   convert xflags to their flags counterpart and vice-versa;
>> - fileattr_set_mask_to_legacy() / fileattr_set_legacy_to_mask(): convert
>>   between legacy read-modify-write API and modern rw_mask/ro_mask API.
>>
>> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
>> the projid using file_[gs]etattr() by leveraging the new masks.
>> In order to prevent the legacy FS_IOC_FSSETXATTR from accepting
>> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
>> and use it to validate/clamp both the _xflags fields and the masks.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c             | 332 +++++++++++++++++++++++++++++++++----
>>  include/linux/fileattr.h   |   7 +
>>  include/uapi/linux/fcntl.h |   6 +
>>  include/uapi/linux/fs.h    |   7 +-
>>  4 files changed, 320 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/file_attr.c b/fs/file_attr.c
> ...
>
>> +/*
>> + * Convert legacy RMW input format without masks, coming from userspace=
, to new
>> + * input format with masks, for filesystems that already support masks.
>> + */
>
> The term "legacy" is always a bit ambiguous so best to avoid if possible
>
> So maybe something more explicit like v0_to_v1
> ...

Ah ok.

>> @@ -283,20 +485,62 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap=
, struct dentry *dentry,
>>         if (!inode_owner_or_capable(idmap, inode))
>>                 return -EPERM;
>>
>> +       if (fa->has_masks && !fa->fsx_xflags_rw_mask)
>> +               return 0;
>> +
>>         inode_lock(inode);
>>         err =3D vfs_fileattr_get(dentry, &old_ma);
>>         if (err)
>>                 goto out;
>>
>> -       /* initialize missing bits from old_ma */
>> +       if (old_ma.has_masks) {
>> +               old_ma.fsx_xflags_rw_mask &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +               old_ma.fsx_xflags_ro_mask &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +       }
>> +       old_ma.fsx_xflags &=3D FS_FILE_ATTR_XFLAGS_MASK;
>> +
>> +       /* Convert between formats and initialize missing bits from old_=
ma */
>>         if (fa->flags_valid) {
>> -               fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG_COMMON=
;
>> -               fa->fsx_extsize =3D old_ma.fsx_extsize;
>> -               fa->fsx_nextents =3D old_ma.fsx_nextents;
>> -               fa->fsx_projid =3D old_ma.fsx_projid;
>> -               fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>> +               if (!old_ma.has_masks) {
>> +                       /* FS_IOC_SETFLAGS */
>> +                       fa->fsx_xflags_rw_mask =3D 0;
>> +                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLA=
G_COMMON;
>> +                       fa->fsx_extsize =3D old_ma.fsx_extsize;
>> +                       fa->fsx_nextents =3D old_ma.fsx_nextents;
>> +                       fa->fsx_projid =3D old_ma.fsx_projid;
>> +                       fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>> +               } else {
>> +                       err =3D fileattr_set_legacy_to_mask(fa, &old_ma)=
;
>> +                       if (err)
>> +                               goto out;
>> +               }
>> +       } else if (!fa->has_masks) {
>> +               if (!old_ma.has_masks) {
>> +                       /* FS_IOC_FSSETXATTR / file_attr VER0 */
>> +                       fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> +               } else {
>> +                       err =3D fileattr_set_legacy_to_mask(fa, &old_ma)=
;
>> +                       if (err)
>> +                               goto out;
>> +               }
>>         } else {
>> -               fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> +               /* file_attr VER1 */
>> +               if (old_ma.has_masks) {
>> +                       /*
>> +                        * Don't preserve non-common flags since filesys=
tems
>> +                        * with masks only use xflags
>> +                        */
>> +               } else {
>> +                       /*
>> +                        * Filesystem doesn't support _mask API yet, swi=
tch to
>> +                        * old rmw format.
>> +                        * PROJID is supported like the legacy masks, bu=
t will
>> +                        * be stripped during conversion.
>> +                        */
>> +                       err =3D fileattr_set_mask_to_legacy(fa, &old_ma)=
;
>> +                       if (err)
>> +                               goto out;
>> +               }
>
> I stand behind my earlier comment - this is too much for open coding
> here. I won't suggest a better factoring I am sure you will figure out
> one by yourself. focus on readability and reviewability please.

Hmm, ok, I'll try.
Can I keep the comments though? (changing them a little maybe)
I think it's important to have them since we're dealing with bitwise
operations and a not so easy to understand logic.

>>         }
>>
>>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
>> @@ -390,7 +634,8 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char _=
_user *, filename,
>>         BUILD_BUG_ON(sizeof(struct file_attr) < FILE_ATTR_SIZE_VER0);
>>         BUILD_BUG_ON(sizeof(struct file_attr) !=3D FILE_ATTR_SIZE_LATEST=
);
>>
>> -       if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) !=3D 0)
>> +       if ((at_flags &
>> +            ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_FILE_ATTR_MASKS)=
) !=3D 0)
>>                 return -EINVAL;
...
>>  int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __=
user *ufa);
>> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
>> index e43e3de3e9ee..a6ecca6f5e63 100644
>> --- a/include/uapi/linux/fcntl.h
>> +++ b/include/uapi/linux/fcntl.h
>> @@ -191,4 +191,10 @@ struct delegation {
>>  #define AT_EXECVE_CHECK                0x10000 /* Only perform a check =
if execution
>>                                            would be allowed. */
>>
>> +/* Flags for file_getattr(2) / file_setattr(2). */
>> +#define AT_FILE_ATTR_MASKS     0x001   /* Advertise knowing and being a=
ble to
>> +                                          handle the struct file_attr f=
ields
>> +                                          fa_xflags_rw_mask and
>> +                                          fa_xflags_ro_mask */
>> +
>
> I prefer AT_FILEATTR_
> This is consistent with other AT_<SYSCALL> using a single word.
> And there is no risk of misunderstanding what FILEATTR refers to.

Ah ok, I used FILE_ATTR because all UAPI references to fileattr are
with _: struct file_attr, file_([gs]et)attr.

>
>>  #endif /* _UAPI_LINUX_FCNTL_H */
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index a13c7b32a1bd..63d88ebe3420 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -238,10 +238,13 @@ struct file_attr {
>>         __u32 fa_nextents;      /* nextents field value (get)   */
>>         __u32 fa_projid;        /* project identifier (get/set) */
>>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) */
>> +       __u64 fa_xflags_rw_mask;/* supported writeable xflags (get) / fl=
ags to set (set) */
>> +       __u64 fa_xflags_ro_mask;/* supported read-only xflags (get) */
>>  };
>>
>>  #define FILE_ATTR_SIZE_VER0 24
>> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> +#define FILE_ATTR_SIZE_VER1 40
>> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>>
>
> Man... we really need a bot to review all UAPI changes
> Please someone tell the bot to check
> NO LATEST/LAST/ALL constants in UAPI headers!!!
>
> Your patch does not introduce this constant in UAPI but if we change
> it we risk spreading different versions in installed headers.

You mean someone having different versions of the header, each with a
different FILE_ATTR_SIZE_LATEST?

> Honestly I see no reason for FILE_ATTR_SIZE_VER* to be in UAPI
> either. For other UAPIs those constants are not in the UAPI header:
>
> ~/src/linux$ git grep SIZE_LATEST include/linux/
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER=
0
> include/linux/seccomp.h:#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST
> SECCOMP_NOTIFY_ADDFD_SIZE_VER0
> include/linux/xattr.h:#define XATTR_ARGS_SIZE_LATEST    XATTR_ARGS_SIZE_V=
ER0
>
> So please move those contacts before adding/changing them
> (can be in the same patch IMO).

Should I move them to fs/linux/fileattr.h?
If so, all of them or only VER1/LATEST? (since they're maybe used by
some userspace program already (?))

> This is a high level review.
> I did not look at the details of the conversions and validations
> Will do that for v3.

No problem, there are already many issues to fix before looking at the
actual implementation.

Thanks,
koraynilay

> Thanks,
> Amir.



--5a3f61e607b661bce23953d8b2acf29cca7bc4b24c3dca1ea3d419584a61
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawnGpgAKCRDmj22qf5IG
XJC+AQD6rT0x9Y4hNSrZsuWrnS6U/9AJpmN8qD+WhFPWqpdK6AEAvcMy7n9UkdCP
E9IT921CF76ZCCOLHHb0fYGaVgrMHwg=
=30Fr
-----END PGP SIGNATURE-----

--5a3f61e607b661bce23953d8b2acf29cca7bc4b24c3dca1ea3d419584a61--
