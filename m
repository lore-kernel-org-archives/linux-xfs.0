Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086023;
	b=4jB2up0KpbH2QYtY8tNGQVRD7iV0hEuEAAgvrld70rbMYtGFaDVf/5BczgYY9OEVUW+A
	 TcfoOmfLXvwlgZ3F76P3qvON4H3W9pedYJKtqTGkud3cFmUpEKORFVw0hgeE42H3v8e8d
	 oJScqr90zBR/RCIF3167zM7gmkspn9D4duU5966XCcQuwYtAbcq/GaPNB3dJHssq51nDW
	 60X63jtOqTNZHb5ytVxfG6yBE+LdcN0AiQi5yhTQqUsZ2L8o9BwHmT95Spt6BpeTOGtUs
	 Z9HzFwa1ayuO3rOvmShgZM9f9BVAR2dQEgSIQPqwx4BJqGChI/q24V/38ErKc8mgj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:X-Mailer:
	 References:In-Reply-To;
	bh=A9oz9N9wH00FCW5H3UowtSmH7Mh76gUUYu8lgBfPcTY=;
	b=yFbaZFgXm3qN02YTKB40kKpB4eZYNBCJmQ535X5w4iiM8e/Pm9lhAgtXMq7sWfLhDvJ+
	 ttINGkJy+Lmjh72JyG14HLBZF4/kDWsNZ+/2WaxiS+DY66m3+Uley4OZwP1kEE3W4kEUs
	 8Gdc16CQtMCNttBNpaeh48GazWqwTcLD2JHh5834b4QZhLVG9vB8LY1kuPVW/C0aQ9cWl
	 8FJD+95Dv/C2qDS+ts0wa+lc34z0PTnqqlClQViGfA6+b3E2Si1BrNcsxX+oSbFthS4K9
	 J1tKiBZPKjmcHCL1rw8Ft6XLRhkBJAPewuB5/tN1fJDvL+B9/dwJF7+PRkj3FSXmrLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p+8y4zX1;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411D606A330
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 11:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5411D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p+8y4zX1
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb68c197c7so29756265e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 03:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795086022; x=1795690822; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=A9oz9N9wH00FCW5H3UowtSmH7Mh76gUUYu8lgBfPcTY=;
        b=p+8y4zX1UI+mfeJMp1kRmcRAREPQADmhTVfjwwRI88EjgnuIVQGkaBCJWGDqulNg56
         qZLBHTfK06G3YF3YQSRWX8m+vVHiieMTkDYSgmwiy/8pZ2u5p1jzXb+saLyYFE+symgc
         XwvR7gNzlBUv8jT7ejMAl52+fA6I9fW5y42cG24CLkTfkMuzP35I2d84GrYtRFqMoboA
         D+VbsUKrj9ueSA9ZvnY0211UUuM7RVIzcOf42AcUSKbYmp8PKmWrDlqpUBrSz09aRZuF
         vbuqpLlk38nEHuUROa2vow7zuk951pDNkAcPkOuJaXssazOo+udgoIX7xMuJU23oFXVJ
         36LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795086022; x=1795690822;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=A9oz9N9wH00FCW5H3UowtSmH7Mh76gUUYu8lgBfPcTY=;
        b=HrMhJnyCj5vDh8uf3A6wSr9vabBMmq6M4cctYwCfalmiAbagtP13G0MTK5rE/sU9WH
         KUrVcuUOXpQ8XYSAykT1ZDuF0o8Ny+3Qnvn3EHThKJxxtjZKHqt+rg5ziDB8XdlFzMBJ
         McF9jzr8GpwHNUM4wA2HGP+jCOgsd8WWG3/Pgo6S0oyBGPz3eedl6xHXKUoixxRz6WR0
         Bi5MqLdonn3XwRp0HFgS3lRKX//bTu/xFpsAjJEkAm4Rzq8cnHN0WhVkdcAy32tJ/VZI
         O55lwRS5yCJNtValzZ81O33D1ENUpSkFWZFHXhPcZ+IpQ1tfePQ2c4XTzKjokS4et9/Y
         k5kg==
X-Forwarded-Encrypted: i=1; AL+hErEPLop/eV4VhKowKEkWMzAbTw6R1BTqyQkRY40Y9aE6HkPfXWqdpp+lrI8i/XzXIFBhIzZwbNpv5bA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+nxVJhf7OXVxYVt0W7W/Mv47hlYTvwsqKRu+QI26lHDezz7tZQ
	GfVbU1/fTIrMf/PD0vcDqjWDFnKnRvIpXnlnHM0ZOiouY2chCwBCLHfh
X-Gm-Gg: AYBFou37Gk0Qp3YCnn7b0Iirb8cvfuwllmtHb5ROXVz4ziwIe2Emqur65wRezo6D4A2
	FcDKkqcg/HE/k7Y7fZMFJnpLzfNGgETPH0YTrx3dleg4+ZZxu4AYNQBQE4YJH7yMaGV2zyIuCBZ
	KDqkOYLItwjc99piG6dVOuA6al+ZMm7wvB4LpzUuS6wJlH3FZl1BBORC4qAn/8Ovx70vvGG+DPr
	AcK6/lf+lyI3s4Sim8ebrRXtMm9JD/G19tSYb233785syYgK3ZeDeYj0xpIIiFgZuYFlXW2x4sn
	PIuVATz1KLTHE18dydvuQwZjm08lgl7y+LOslvP5RUrov7J7iDqRU9w2n7JqXoOAnlnpl2sWL/j
	/s/0/il1chFxutpTDXynwVRpIKwrL10Bv8KoBeruhtFuJpOo8xomRRU8mmoN3/3vBN+vli2u+L0
	icHJm+b0/bE0N3cUXgl+iBiucxsvVjaHyXeLDEW4sz76tgvW7/6QzyApVjOnDOJ4gn4XDkI+RUg
	JVh8YbCHV1e3eEGxrU0iSOrk3exT1HvNI8vhPsT+DUuFSyDf2FO1JuzK0mEN+laHz9MdktKlTLA
	ikXOS14Pb5HTxCD53R/tFQP9DStFd09YDmT+7jwV8HN0sbKG
X-Received: by 2002:a05:600c:6095:b0:4a2:c2b:a91b with SMTP id 5b1f17b1804b1-4bb7da03b45mr96312765e9.10.1795086021026;
        Thu, 19 Nov 2026 03:00:21 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8534d908sm30956005e9.9.2026.11.19.03.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 03:00:20 -0800 (PST)
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
 boundary=a790ada8fe7b7f1ee219e7d28021102d19589829fb834fe469ae5db7b9de;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 12:00:04 +0100
Message-Id: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Amir Goldstein" <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
In-Reply-To: <20261119095943.85048-1-lauri.gates@gmail.com>

--a790ada8fe7b7f1ee219e7d28021102d19589829fb834fe469ae5db7b9de
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 10:59 AM CET, Lauri Gates wrote:
> On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
>> I really don't care if it is exposed by statx or file_attr; checking
>> the flag through either interface will be orders of magnitude faster
>> than using FIEMAP to iterate extents on every file to find shared
>> extents. My concern with statx is coherency - it runs completely
>> unlocked and so can race with operations that add/remove the reflink
>> flag...
>
> Thanks, Dave and Christian. Given Christian's preference and the
> coherency point, I'll write the RFC against file_attr, once the
> question at the end is settled. xfs_fileattr_get() already reads the
> flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
> work. The answer can still go stale right after the call, as with any
> stat result: a clone that lands after the read is missed, just as one
> that lands after FIEMAP returns is missed today.
>
> As I suggested on the 6th, the flag would take the inverted meaning,
> so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
> ("no extents shared with another file"), read-only, in
> FS_XFLAG_RDONLY_MASK next to the case-folding flags.

Hello, I don't have any say in the FIEMAP issue, but I wanted to let you
know that, since also a mask was mentioned and your patch would be
touching the fileattr API, there is work going[1] on for adding a
fsx_xflags_mask that filesystem use[2][3] to advertise supported flags (on
get, like stx_attributes_mask) and users use to say what they want to
change (on set).
It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
change, but I thought it was worth pointing out, especially because this
patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
to have a way to include both legacy and newly added xflags, so
FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

> Christian, one question on the shape within file_attr: would you take
> the inverted flag, or would you rather keep a plain "may share" flag
> and add a mask to struct file_attr that says which xflags the
> filesystem reports?

And if Christian chooses the mask approach, then my patch[4] becomes
relevant.
(in [4] I put the patch that will be sent in v5 of [1], since in [1]
it's merged with the ptime change)

(For Amir who I just CC'd, [5] is the main link for this thread)

Thanks,
koraynilay

[1]: https://lore.kernel.org/all/20261115180343.576773-1-koray.fra@gmail.co=
m/T/#u
[2]: https://lore.kernel.org/all/CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3pry=
tW36j1LgA@mail.gmail.com/
[3]: https://lore.kernel.org/all/CAOQ4uxiuJ=3DeZu28FZAUz3rpqPKqCimPxJucOnYY=
uBowvD09_Cw@mail.gmail.com/
[5]: https://lore.kernel.org/linux-xfs/20261102193533.93690-1-lauri.gates@g=
mail.com/T/#u

[4]:
commit 0efe0de3b5cc2b767aa6e2bb9174eb05b0d818f1
Author: koraynilay <koray.fra@gmail.com>
Date:   Tue Nov 17 14:57:47 2026 +0100

    vfs: add xflags mask to file_attr API
   =20
    Add fa_xflags_mask to struct file_attr and equivalent fsx_xflags_mask
    to struct file_kattr.
   =20
    This lets filesystems advertise their support for specific xflags and
    users specify only what they want to change, behaving like
    statx.stx_attributes_mask:
    - on GET (file_getattr): each filesystem fills the mask according to
      its supported xflags, e.g. FS_XFLAG_COWEXTSIZE or FS_XFLAG_EXTSIZE,
      and provides the values in the corresponding struct fields;
    - on SET (file_setattr): userspace fills the mask according to which
      xflags it wants to change, VFS validates this and preserves xflags
      that were not specified in the mask;
    - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
      compatibility with older programs.
   =20
    Furthermore, add the missing FS_XFLAG_PROJID flag, to allow userspace t=
o
    set the projid using file_[sg]etattr().
   =20
    Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from acceptin=
g
    FS_XFLAG_PROJID, add an FS_FILE_ATTR_XFLAGS_MASK to support new xflags
    and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
    validate that the xflags passed in fa_xflags and fa_xflags_mask fields
    are valid.
   =20
    Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
    Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c           | 46 ++++++++++++++++++++++++++++++++++++++++++--=
--
 include/linux/fileattr.h |  5 +++++
 include/uapi/linux/fs.h  |  3 +++
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..56ea65f790f1 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -102,10 +102,18 @@ EXPORT_SYMBOL(vfs_fileattr_get);
 static void fileattr_to_file_attr(const struct file_kattr *fa,
 				  struct file_attr *fattr)
 {
-	__u32 mask =3D FS_XFLAGS_MASK;
+	/*
+	 * fsx_xflags_mask contains only flags added after the
+	 * file_[gs]etattr() API, so we need to tell userspace the filesystem
+	 * actually supports all legacy (FS_XFLAGS_MASK and FS_XFLAG_PROJID,
+	 * which lacked its own bit) and new advertised flags.
+	 */
+	__u32 mask =3D (FS_XFLAGS_MASK | FS_XFLAG_PROJID | fa->fsx_xflags_mask) &
+		     FS_FILE_ATTR_XFLAGS_MASK;
=20
 	memset(fattr, 0, sizeof(struct file_attr));
 	fattr->fa_xflags =3D fa->fsx_xflags & mask;
+	fattr->fa_xflags_mask =3D mask;
 	fattr->fa_extsize =3D fa->fsx_extsize;
 	fattr->fa_nextents =3D fa->fsx_nextents;
 	fattr->fa_projid =3D fa->fsx_projid;
@@ -141,12 +149,17 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
 static int file_attr_to_fileattr(const struct file_attr *fattr,
 				 struct file_kattr *fa)
 {
-	__u64 mask =3D FS_XFLAGS_MASK;
+	__u64 mask =3D fattr->fa_xflags_mask ?: FS_XFLAGS_MASK;
+
+	if (fattr->fa_xflags_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
+		return -EINVAL;
=20
 	if (fattr->fa_xflags & ~mask)
 		return -EINVAL;
=20
-	fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
+	fileattr_fill_xflags(fa, fattr->fa_xflags & FS_XFLAGS_MASK &
+				 ~FS_XFLAG_RDONLY_MASK);
+	fa->fsx_xflags_mask =3D fattr->fa_xflags_mask;
 	fa->fsx_extsize =3D fattr->fa_extsize;
 	fa->fsx_projid =3D fattr->fa_projid;
 	fa->fsx_cowextsize =3D fattr->fa_cowextsize;
@@ -288,12 +301,37 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, s=
truct dentry *dentry,
 	if (!err) {
 		/* initialize missing bits from old_ma */
 		if (fa->flags_valid) {
-			fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+			/* FS_IOC_SETFLAGS */
+			fa->fsx_xflags_mask =3D 0;
+			fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAGS_MASK) &
+					  ~FS_XFLAG_COMMON;
 			fa->fsx_extsize =3D old_ma.fsx_extsize;
 			fa->fsx_nextents =3D old_ma.fsx_nextents;
 			fa->fsx_projid =3D old_ma.fsx_projid;
 			fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
 		} else {
+			/*
+			 * Preserve unmasked xflags when running file_setattr()
+			 * with a mask, which doesn't need a read-modify-write
+			 * so these attributes would be set to 0.
+			 *
+			 * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (legacy mode)
+			 * this is not needed as userspace does
+			 * read-modify-write already.
+			 */
+			if (fa->fsx_xflags_mask) {
+				fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAGS_MASK) &
+						  ~fa->fsx_xflags_mask;
+				fileattr_fill_xflags(fa, fa->fsx_xflags &
+						     ~FS_XFLAG_RDONLY_MASK);
+				if (!(fa->fsx_xflags_mask &
+				      (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)))
+					fa->fsx_extsize =3D old_ma.fsx_extsize;
+				if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJID))
+					fa->fsx_projid =3D old_ma.fsx_projid;
+				if (!(fa->fsx_xflags_mask & FS_XFLAG_COWEXTSIZE))
+					fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
+			}
 			fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
 		}
=20
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 09e32b84e02a..40ecb29f6235 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -35,6 +35,10 @@
 	(FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK | \
 	 FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
=20
+/* Flags only for fa_ fields */
+#define FS_FILE_ATTR_XFLAGS_MASK \
+	(FS_XFLAGS_MASK | FS_XFLAG_PROJID)
+
 /*
  * Merged interface for miscellaneous file attributes.  'flags' originates=
 from
  * ext* and 'fsx_flags' from xfs.  There's some overlap between the two, w=
hich
@@ -45,6 +49,7 @@ struct file_kattr {
 	u32	flags;		/* flags (FS_IOC_GETFLAGS/FS_IOC_SETFLAGS) */
 	/* struct fsxattr: */
 	u32	fsx_xflags;	/* xflags field value (get/set) */
+	u32	fsx_xflags_mask; /* supported xflags (get) / flags to set (set) */
 	u32	fsx_extsize;	/* extsize field value (get/set)*/
 	u32	fsx_nextents;	/* nextents field value (get)	*/
 	u32	fsx_projid;	/* project identifier (get/set) */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a46c33692aa2..b168f1b75126 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -229,6 +229,7 @@ struct file_attr {
 	__u32 fa_nextents;	/* nextents field value (get)   */
 	__u32 fa_projid;	/* project identifier (get/set) */
 	__u32 fa_cowextsize;	/* CoW extsize field value (get/set) */
+	__u32 fa_xflags_mask;   /* supported xflags (get) / flags to set (set) */
 };
=20
 #define FILE_ATTR_SIZE_VER0 24
@@ -261,6 +262,8 @@ struct file_attr {
  */
 #define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+
+#define FS_XFLAG_PROJID		0x00200000	/* project ID */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
=20
 /* the read-only stuff doesn't really belong here, but any other place is

--a790ada8fe7b7f1ee219e7d28021102d19589829fb834fe469ae5db7b9de
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav7WtQAKCRA0bnTtJTDo
OOFTAP9cSbNg14OXapAqT+mncV13potVsiqOZOXJtAk63T7kPgD/SJGc0uh1yl7P
zMRtZOHywYA/PKzpBOYpIXLlW3BzCg4=
=/S3z
-----END PGP SIGNATURE-----

--a790ada8fe7b7f1ee219e7d28021102d19589829fb834fe469ae5db7b9de--
