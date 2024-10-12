Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F28AD517;
	Sat, 12 Oct 2024 08:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723477; cv=none; b=PYtJK8kqEz+534MaySpL+o2hcrpzuk87Gjk2fIUv93ED8spkEhfYJ12Rp0I96iMbbw+SPdp625/Vvgqc0ejekO2N4/Bh0EAtftGS7LfC42AgAtiyzDr9ZNdqO6IxMf3Q8pIzVU8h58fLi9vRlLdpjSOpNLWPvO7EOtLyZtcwW/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723477; c=relaxed/simple;
	bh=svtSclBz9u/qrG2oa7Ec/7nKqnQY51mTitmUQpOR/0Q=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=GqmCm06GF5MLHHweppG61Bc0jeV/TIPGxZf+7XwQZt0nAtfQtQOzzzwL+TtzuPjfbbv9H+YqjjJoxQrHsJ2ByWFbnGdXf4YWZ/lT0ucRGiN0pTBbQKKw6KOjusJt2s2ol2oHeCrdzmWlsBVFMI2W9vd3es5xyYJY27JJ33dWaK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3mpKjcV; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3mpKjcV"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20c8c50fdd9so15320905ad.0;
        Sat, 12 Oct 2024 01:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728723475; x=1729328275; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KyfF37ymaVo+9RotRE+iXjYSIUoLMLM+SfYp3V/ZJcU=;
        b=S3mpKjcVXSDOA73n2kDgfh5h7sdklNCJKYJ2FpqwjlvKMjz+zA4zG5lX+YbYS2gU4w
         gx9CNNyHIISpQxgUoQjzSZCZyIhJFVXhvh/DKoRvtoFLiWf/BECa5tbPMdixR5460hHq
         JZqovNQDlA6DbvnHtKPbrdbP6XJ8Aatbh2iM+WCh3CMRsg5+KkqPUZPxiytXROgGSQeC
         PxD5pxF/fWzmwMxqn9105QBxunMav+UhSQcELbGmPvkXpSQT6gdEp+wiYfezVxdrbF5H
         QP3vHCJxwbqDHcx3ptmDwjKUiC29PHxFj3j9xGfHj7MLI6RJVeoyrADo26VAm8W//xp+
         8/3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728723475; x=1729328275;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyfF37ymaVo+9RotRE+iXjYSIUoLMLM+SfYp3V/ZJcU=;
        b=FJCXIAw26HvUMWr1zzyqEf+yV1ZkST/nRG+vN1+x54CeKfg6j4uJdUrjdbY3ZB2XF7
         bjYP6L2QDFbnMoznMjFSxHVnrnzoeDSv+KT+8mp5BlrJd2OlK2Fs/QexsSKuka/EGyy7
         r3Kx1ojDOblN/jXXJF0seQ+bMWm78oBqudz+eCNpGPYuapR9YAEbzH10p4IyRVs5btIZ
         yalMlTnyGl9nvQL6+SBkP4cJb0GZPT/NW/dVgbLJYyn36OcegfmxoyVGxXXo4LC4qnsX
         DQYljVnI5DXOAumusRkZp27dCl+Jpwxcnr9ohcbhwQ/DigbouyGv4crqr8EpmiZfi1H5
         zZmA==
X-Forwarded-Encrypted: i=1; AJvYcCVQg/LX5IHNxPPtuoMTzTs87OCh0Y4gNySQtwoooJe55PVewTUz9xo6IflYeqa64xVN3gh3sj6ZTDSY0jRgeQ==@vger.kernel.org, AJvYcCW0E1FdKoXT2s6agkB8TrZ7EwlaX9jD3yi+j10DxdfZQisgwyb++ldaoAGwoO0PdfJa935QaP3dBtY+@vger.kernel.org
X-Gm-Message-State: AOJu0Yybn7vlRU43NYIyyhAqs164K2TCB40rCK3qL5wyK6Bg4JHU7mu0
	TQqOn0glQe7laqc+Mo6ufU0c6L/8dmFnF3yg1cnbmywNFdswCdcM
X-Google-Smtp-Source: AGHT+IF5crCEIiWB7Wp5ggs4Q4kZZSy4b20GsXIA2qB3AhBUtt91hc4QbaMLEFyecf/SMCu6FUxj0Q==
X-Received: by 2002:a17:902:d2c8:b0:20b:a73b:3f5 with SMTP id d9443c01a7336-20ca0399c9amr90304055ad.14.1728723475446;
        Sat, 12 Oct 2024 01:57:55 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c375d86sm34054685ad.309.2024.10.12.01.57.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2024 01:57:54 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Libmount bug ?
Message-Id: <14ADF290-5B46-44D5-83BC-9AE3732B192C@gmail.com>
Date: Sat, 12 Oct 2024 16:57:39 +0800
Cc: util-linux@vger.kernel.org,
 linux-bcachefs@vger.kernel.org,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Hongbo Li <lihongbo22@huawei.com>,
 "Darrick J. Wong" <djwong@kernel.org>,
 xfs <linux-xfs@vger.kernel.org>
To: kzak@redhat.com
X-Mailer: Apple Mail (2.3776.700.51)

Hello Karel,

The bcachefs has the helper called mount.bcachefs.

Currently, there are users using fstab with nofail/user fail to mount,
we would like to know whether other filesystems using similar helper
properly handle this.

This is like commit 06e05eb0f78566b68c44328c37d7c28d8655e9df=20
(=E2=80=9Clibmount: don't pass option "defaults" to helper")

Or would you like something like this? This might be incomplete though =
(e.g. owner, noowner etc.)

diff --git a/libmount/src/optmap.c b/libmount/src/optmap.c
index d7569a0f0..c13b9ba19 100644
--- a/libmount/src/optmap.c
+++ b/libmount/src/optmap.c
@@ -152,11 +152,11 @@ static const struct libmnt_optmap =
userspace_opts_map[] =3D
    { "auto",    MNT_MS_NOAUTO, MNT_NOHLPS | MNT_INVERT | MNT_NOMTAB },  =
/* Can be mounted using -a */
    { "noauto",  MNT_MS_NOAUTO, MNT_NOHLPS | MNT_NOMTAB },  /* Can only =
be mounted explicitly */

-   { "user[=3D]", MNT_MS_USER },                             /* Allow =
ordinary user to mount (mtab) */
-   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB },    /* Forbid =
ordinary user to mount */
+   { "user[=3D]", MNT_MS_USER, MNT_NOHLPS},                             =
/* Allow ordinary user to mount (mtab) */
+   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS},    =
/* Forbid ordinary user to mount */

-   { "users",   MNT_MS_USERS, MNT_NOMTAB },                /* Allow =
ordinary users to mount */
-   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB },   /* Forbid =
ordinary users to mount */
+   { "users",   MNT_MS_USERS, MNT_NOMTAB | MNT_NOHLPS},                =
/* Allow ordinary users to mount */
+   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS},   =
/* Forbid ordinary users to mount */

    { "owner",   MNT_MS_OWNER, MNT_NOMTAB },                /* Let the =
owner of the device mount */
    { "noowner", MNT_MS_OWNER, MNT_INVERT | MNT_NOMTAB },   /* Device =
owner has no special privs */
@@ -180,7 +180,7 @@ static const struct libmnt_optmap =
userspace_opts_map[] =3D
    { "sizelimit=3D", MNT_MS_SIZELIMIT, MNT_NOHLPS | MNT_NOMTAB },	 =
  /* loop device size limit */
    { "encryption=3D", MNT_MS_ENCRYPTION, MNT_NOHLPS | MNT_NOMTAB },	 =
  /* loop device encryption */

-   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB },               /* Do not =
fail if ENOENT on dev */
+   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB | MNT_NOHLPS},               =
/* Do not fail if ENOENT on dev */

    { "uhelper=3D", MNT_MS_UHELPER },			   /* =
/sbin/umount.<helper> */


Thanks,
Alan



