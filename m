Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270672951CE
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056182; cv=none; b=aGfqQDNFDw9ReLOUj5I53JZI3SYrC8jf7BZZ/1vzLCA7G+yVZM2KezY5OVLSCjST1PaHGi3r75hGkq4hvHfpQ+um4xA4I6TJdA6k1TyRzLkTVxiv1fZ0oNqRTZhLQ1p09EnUis8cXoE19C3p1OprBIVa83sT7Rc9G6JwHwKoxo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056182; c=relaxed/simple;
	bh=bzJZzvvRpjn9CYUnburWeDj8PO5yPP+Ob2vNmYc/qsA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjDsVDVmNmnvvU7wpMILeOwJKS1z4EVvDha46XCc8qezLu6aPNHIfv2Zj6UY/hj5UOtZ6vZA7Qm0gmfvtzFRym2tOcp7WsAq1wVczGtQeqEwMN35CRPMcF0eE+JtDwnjrk1BIHiDfmqqrN37lOcWUmgoBohCXDgrUjcKoprtBUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5TG11IN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5TG11IN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747056179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rt9GtFBQJVx2og2U+6x9mcRi6vq6T7dh1csKu94DEVk=;
	b=Q5TG11INiTWo6N09iqEhF0dcEJzieqKaCkgyuBXVH2hy8osnjZwRrBTb0r5JCY5Ad3CaMR
	iz4GVz9Kh9BnCOuTmXoRYHJDCT+y0mRB4o08fTv7o8p065ngLR12SNhi/XkCWE1eWRaRlh
	0sy8wxLQ8ofjKRVDXqRhrWQ4BaBH9QU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-WCh86FK-N-iep93OfdPcMg-1; Mon, 12 May 2025 09:22:57 -0400
X-MC-Unique: WCh86FK-N-iep93OfdPcMg-1
X-Mimecast-MFC-AGG-ID: WCh86FK-N-iep93OfdPcMg_1747056176
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-acbbb00099eso414381166b.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 06:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747056176; x=1747660976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rt9GtFBQJVx2og2U+6x9mcRi6vq6T7dh1csKu94DEVk=;
        b=oK2V5Z6DGjQgds37j26m8kCQQyBBCTwvPyLfyoJA+lLomGGZazfM500j5in6Neuj+1
         DyHLEZpJhU3z3s9rx+1HP4eV/DR30LLTXJKElE6VfCwtqbnI6qz0WqigXyqOIIq1P/CY
         X+wtY83eIqW8UsaOZipufeo9EDIDQs9OrqA0RqsShJ1PtJ1RwIM5P3upUfxVYz88LOfs
         88VlqW4qflTYP3r9N9UrI2lrPwYqNT5WXFccoFHFgTWdQlllv4POvVmvk5ijAvjBSWlh
         J31StrkOYlRrUSTcN23AqkpKgi3W6yLlNAO1NuvB2zJtEv+siUCCgdkVmW/Ykz0DbtLR
         G3Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVHHduwWtlyHF0iSh7Nn9QskXf6myg8FteOqk/G2w7z6l9NV1Z6gq0UXNFYpu+Lub3BgUxSeUyqrtA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzrYr4hEizwBnHpRUiGAivTHAA8/TpBjmc112NZTDfAtl75Ik8
	+d59397gwTcquN0/FdNi1w3TaipBTm9VddKgHFFEmxC4ak7S8cHuf9tsNq6g4bLmK3U0esKZ5YU
	476FW5pBCaL4JznKmbIoUbDeG/PAqUzmXEIilDu85Y7XwVaaBw8rb1IMS
X-Gm-Gg: ASbGncs/vf6/ftwkzWSvWQVLW6JTSuq3mnxevUf2T2eVtw+iwlDwIBmksQKN5xPhlyO
	s7KmGoGEbm3NCJYhjCAySeACGur4JUVJBtQLdhlIJQlpvqe9o7lqGqQ7yeUA1y85Mg8zXEyaLZI
	hWM5dILsrHWmdZ+AAvf0eGs4RoGA4Tes1LeAu+gLlHc8dvBoJ+S65Ynrl3QzTCIZd3ikTHMjXPj
	Fmu0cwxRmyq3x0nx+bgfNZgZc3K/CCDbYT2khbvFE1aKZinwir/h3v/hnadxkXIk/zBQvUKf7og
	tXzXAQIJo+EYCWhGq0TJYKmMQFarLfOh3GUgCURu
X-Received: by 2002:a17:907:6ea4:b0:ad4:d00f:b4ca with SMTP id a640c23a62f3a-ad4d00fb8fcmr36841466b.50.1747056176253;
        Mon, 12 May 2025 06:22:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ1H/zptS/AHQGJ0FK52hePcKQfFfrpXhxDrhZE1E6E4AE2JiwqXtAXQ7n2gKkCn93DDW/NA==
X-Received: by 2002:a17:907:6ea4:b0:ad4:d00f:b4ca with SMTP id a640c23a62f3a-ad4d00fb8fcmr36835166b.50.1747056175640;
        Mon, 12 May 2025 06:22:55 -0700 (PDT)
Received: from thinky (109-92-26-237.static.isp.telekom.rs. [109.92.26.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad2197bd28dsm613933766b.128.2025.05.12.06.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 06:22:55 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 May 2025 15:22:52 +0200
To: Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Tyler Hicks <code@tyhicks.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	selinux@vger.kernel.org, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v5 5/7] fs: make vfs_fileattr_[get|set] return -EOPNOSUPP
Message-ID: <20250512-xattrat-syscall-v5-5-ffbc7c477332@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3357; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=xNZgMi4eRRk641oOEdpKdfQ/bF05YfbIRMmgusqStnI=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMhS/7gpUUlnz86nTDU79jiMuhmaSU5Y0X4uZXFdRe
 Vmc8dGRozkdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJtIRzsjwXWjjY7HXi7bl
 PFdbzGTT97Nn+gxH75Rvx4wCZ9h+erijleGfefXLzfMlHhZ1SRydlrlHbP8WO6cPJmv/zTu7xuT
 VWu893ACrBku/
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108
References: <20250512-xattrat-syscall-v5-0-ffbc7c477332@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512-xattrat-syscall-v5-0-ffbc7c477332@kernel.org>

Future patches will add new syscalls which use these functions. As
this interface won't be used for ioctls only the EOPNOSUPP is more
appropriate return code.

This patch coverts return code from ENOIOCTLCMD to EOPNOSUPP for
vfs_fileattr_get and vfs_fileattr_set. To save old behavior
translate EOPNOSUPP back for current users - overlayfs, encryptfs
and fs/ioctl.c.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/ecryptfs/inode.c  |  8 +++++++-
 fs/file_attr.c       | 12 ++++++++++--
 fs/overlayfs/inode.c |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 51a5c54eb740..6bf08ff4d7f7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1124,7 +1124,13 @@ static int ecryptfs_removexattr(struct dentry *dentry, struct inode *inode,
 
 static int ecryptfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
-	return vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
+	int rc;
+
+	rc = vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
+	if (rc == -EOPNOTSUPP)
+		rc = -ENOIOCTLCMD;
+
+	return rc;
 }
 
 static int ecryptfs_fileattr_set(struct mnt_idmap *idmap,
diff --git a/fs/file_attr.c b/fs/file_attr.c
index d9eab553dc25..d696f440fa4f 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -79,7 +79,7 @@ int vfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 	int error;
 
 	if (!inode->i_op->fileattr_get)
-		return -ENOIOCTLCMD;
+		return -EOPNOTSUPP;
 
 	error = security_inode_file_getattr(dentry, fa);
 	if (error)
@@ -239,7 +239,7 @@ int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 
 	if (!inode->i_op->fileattr_set)
-		return -ENOIOCTLCMD;
+		return -EOPNOTSUPP;
 
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
@@ -281,6 +281,8 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	if (err == -EOPNOTSUPP)
+		err = -ENOIOCTLCMD;
 	if (!err)
 		err = put_user(fa.flags, argp);
 	return err;
@@ -302,6 +304,8 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
 			fileattr_fill_flags(&fa, flags);
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
+			if (err == -EOPNOTSUPP)
+				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
@@ -314,6 +318,8 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	if (err == -EOPNOTSUPP)
+		err = -ENOIOCTLCMD;
 	if (!err)
 		err = copy_fsxattr_to_user(&fa, argp);
 
@@ -334,6 +340,8 @@ int ioctl_fssetxattr(struct file *file, void __user *argp)
 		if (!err) {
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
+			if (err == -EOPNOTSUPP)
+				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6f0e15f86c21..096d44712bb1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -721,7 +721,7 @@ int ovl_real_fileattr_get(const struct path *realpath, struct fileattr *fa)
 		return err;
 
 	err = vfs_fileattr_get(realpath->dentry, fa);
-	if (err == -ENOIOCTLCMD)
+	if (err == -EOPNOTSUPP)
 		err = -ENOTTY;
 	return err;
 }

-- 
2.47.2


-- 
- Andrey

