Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB49E4AD7DA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377728; cv=none; b=mrXXlaKTm1jXXAPM8/sLHFz2Hzy8u9xRT17v16nNfXzhuwVYZbPiiVsW6+/WZLSh0BbgNb/GDLyrPmjtOOAGRAK2DnEcPcvQ0gKWNXyz/zxx6KGZii58uvrk0Pt5b1CKRh+5FSRibzA9ukwCzGJQDGCKyjluoP3cNtSU/5jAnNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377728; c=relaxed/simple;
	bh=hV2MW1omBZf24pDu1TyLQ7VokUTMjJdalm/WKcqe5oQ=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=pmsDIvDlLRQuJSHaYgqDwl6rg543N27VHMAYCK6vuXveR6hH/n+VFdHDgY/zRws5Z/VXekiOnsW22vlgRdVqpt05WryWwg2U1zzonQjspsf8B0ZE7V86CVpymhcSKTTY2kHGcbQWq102hXgZKHZ8avH6uJ38YoNskmqxmcYyKw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GOKkdTYL; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GOKkdTYL"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-936cda0e3fbso184529985a.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377695; x=1788982495; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GC4FIfkk2kp9PFt1uwqlIhd5i3bfmRn6wjlpVpmfWwA=;
        b=GOKkdTYLHtwfO3ngYpVGTvFI8bS9jy2AxeRMxBguqtyz+mrrUORq9lf9kDCSAKxOoR
         I2u1MFMWwWZGUNwTNq/9I+IlnwmgCDArVPN+m+Iu/wTXYKIlMgFa93lR+Jynm0Mu4qEf
         5PxuBOn4U3HwoWjMrUL94iXOSPSBHNeM4yrBPcctQBFB5MDB+AQSFM9k5owfyUGQEbiN
         HUGDO1RvIz7iOVnLN1KfotthYbhUcF+ZHQXILDGx1Sj+n9/Ike59tT+7EsIK6KEFRo2/
         Badzc6YVVwyjOiepd7sGNucttV9+0d0PqG4UHoWs9HhvSznmEOYBaD96nPZTIopNTfjc
         ituw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377695; x=1788982495;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GC4FIfkk2kp9PFt1uwqlIhd5i3bfmRn6wjlpVpmfWwA=;
        b=BMMCN+iFiuawjT3o8hyCiAhzSaT7rnzWXXuJxPFH5H0ww5cEt5E+iwodJCcVgqb8G6
         ZjK6TicAGs8m0JlaaIPMIqj2eZ+Q5c0KuSJsIHqchyfqTEakESoo8UDsNvjrfo+9HyAI
         50+jJSw5pBNqTcD8gjeC+S//enKZ0N9MZGk264BWO4NKtH4VtSgZItrfUWGXRf1M+ZFg
         nWIAk3j5MUgUzItQ1FhzCRffPGtjmP1TxDv+c/AybM9jTLCl+XxV+uHUlYysm44EuLPG
         +MXLE0HEJdnpFVIYXCZVXDteG7+F2jpKk7ct0kfJORdDB9CThcJdsYseUalD/BZDdZ5+
         2NSw==
X-Forwarded-Encrypted: i=1; AKwUvBxmj90lpohLf7oC+H48ACiXadl1mRw7qZqth+w02UCWNei0PqyrEzOEj8XNSRge/xpEf4YraxKZAk8=@vger.kernel.org
X-Gm-Message-State: AFuF++k6EiHq6Elzj9ncEW2ehHbm4lxTknL7dd4yM/7MQ41UNCFzFEl+
	JKaWxunj+LHtgp+FuInGOKyGHGkULtpmLozzcqikPVny74sqdf/jlI5NxuqEbV9Xjw==
X-Gm-Gg: AYBFou2iCG7c1UtdCIqymo6yqzfntAfrhPx+ps5AFJx0+IwPrkkOjZlQfwFqiA62KoK
	EIfOhQMhR8TfHs23OdjL2Yd7Gk01I64vYj9hsPkJumqEbWc/n4DeUdZN4I2PGXNwV0rlVmnxdIo
	uFbXxPbtRpzL4rv5XQv0qyAxCVim9/L1cG7wEnh0DE71U7T2DrUnmVFBsE1j9G3u3Ngsw4E/JB2
	Yoa3rnNGm3adwl7EnjwLVkgzpU2XCeb1MQEq/coWRfkPftqaym+7CA30+c1ffrpfdSasN3ai1lo
	l96odR5dV4T9qKkKAcGVsmSKWcVKvREFJhKc1bU0/z+2MVZZFtZuszw0KogCxaexnTUXTcfbob8
	c41bNEGWM8g3QVRNs6Au6LFVFQKEgS14dPNvOmhdIPdq6wipUNsMMrNeVrGL4EKBlPcoyOuCPvX
	EirgmY6lb5dwQEfzt6ui2VN5TJl59JGuzD2rxscIfqlIEvp/bIcNEoWRfJDlUhRmSRfx5YXc4OO
	sYx+z3ozB7R+nExKAzK9Pm1OtcML0ZFfjQ=
X-Received: by 2002:a05:620a:d94:b0:939:6de9:4cfb with SMTP id af79cd13be357-9396de968a9mr206623085a.46.1788377695492;
        Wed, 02 Sep 2026 12:34:55 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0e9b1sm25737496d6.43.2026.09.02.12.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:54 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:53 -0400
Message-ID: <0a5d61e6a17442e42646e98ac73dd7df@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260902_1319/pstg-lib:20260901_1604/pstg-pwork:20260902_1319
From: Paul Moore <paul@paul-moore.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, linux-security-module@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 24/27] fs: port ->setattr() to pass const mnt_idmap
References: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>

On Sep  1, 2026 Christian Brauner <brauner@kernel.org> wrote:
> 
> Convert to const struct mnt_idmap.
> 
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  Documentation/filesystems/locking.rst     | 2 +-
>  Documentation/filesystems/vfs.rst         | 2 +-
>  arch/powerpc/platforms/cell/spufs/inode.c | 2 +-
>  fs/9p/v9fs_vfs.h                          | 2 +-
>  fs/9p/vfs_inode.c                         | 2 +-
>  fs/9p/vfs_inode_dotl.c                    | 2 +-
>  fs/adfs/adfs.h                            | 2 +-
>  fs/adfs/inode.c                           | 2 +-
>  fs/affs/affs.h                            | 2 +-
>  fs/affs/inode.c                           | 2 +-
>  fs/afs/inode.c                            | 2 +-
>  fs/afs/internal.h                         | 2 +-
>  fs/anon_inodes.c                          | 2 +-
>  fs/attr.c                                 | 2 +-
>  fs/bad_inode.c                            | 2 +-
>  fs/btrfs/inode.c                          | 2 +-
>  fs/ceph/inode.c                           | 2 +-
>  fs/ceph/super.h                           | 2 +-
>  fs/coda/coda_linux.h                      | 2 +-
>  fs/coda/inode.c                           | 2 +-
>  fs/configfs/configfs_internal.h           | 2 +-
>  fs/configfs/inode.c                       | 2 +-
>  fs/debugfs/inode.c                        | 2 +-
>  fs/ecryptfs/inode.c                       | 2 +-
>  fs/efivarfs/inode.c                       | 2 +-
>  fs/exfat/exfat_fs.h                       | 2 +-
>  fs/exfat/file.c                           | 2 +-
>  fs/ext2/ext2.h                            | 2 +-
>  fs/ext2/inode.c                           | 2 +-
>  fs/ext4/ext4.h                            | 2 +-
>  fs/ext4/inode.c                           | 2 +-
>  fs/f2fs/f2fs.h                            | 2 +-
>  fs/f2fs/file.c                            | 2 +-
>  fs/fat/fat.h                              | 2 +-
>  fs/fat/file.c                             | 2 +-
>  fs/fuse/dir.c                             | 2 +-
>  fs/gfs2/inode.c                           | 2 +-
>  fs/hfs/hfs_fs.h                           | 2 +-
>  fs/hfs/inode.c                            | 2 +-
>  fs/hfsplus/inode.c                        | 2 +-
>  fs/hostfs/hostfs_kern.c                   | 2 +-
>  fs/hpfs/hpfs_fn.h                         | 2 +-
>  fs/hpfs/inode.c                           | 2 +-
>  fs/hugetlbfs/inode.c                      | 2 +-
>  fs/inode.c                                | 2 +-
>  fs/internal.h                             | 2 +-
>  fs/jffs2/fs.c                             | 2 +-
>  fs/jffs2/os-linux.h                       | 2 +-
>  fs/jfs/file.c                             | 2 +-
>  fs/jfs/jfs_inode.h                        | 2 +-
>  fs/kernfs/inode.c                         | 2 +-
>  fs/kernfs/kernfs-internal.h               | 2 +-
>  fs/libfs.c                                | 4 ++--
>  fs/minix/file.c                           | 2 +-
>  fs/nfs/inode.c                            | 2 +-
>  fs/nfs/namespace.c                        | 2 +-
>  fs/nilfs2/inode.c                         | 2 +-
>  fs/nilfs2/nilfs.h                         | 2 +-
>  fs/ntfs/file.c                            | 2 +-
>  fs/ntfs/inode.h                           | 2 +-
>  fs/ntfs3/file.c                           | 2 +-
>  fs/ntfs3/ntfs_fs.h                        | 2 +-
>  fs/ocfs2/dlmfs/dlmfs.c                    | 2 +-
>  fs/ocfs2/file.c                           | 2 +-
>  fs/ocfs2/file.h                           | 2 +-
>  fs/omfs/file.c                            | 2 +-
>  fs/orangefs/inode.c                       | 2 +-
>  fs/orangefs/orangefs-kernel.h             | 2 +-
>  fs/overlayfs/inode.c                      | 2 +-
>  fs/overlayfs/overlayfs.h                  | 2 +-
>  fs/pidfs.c                                | 2 +-
>  fs/proc/base.c                            | 2 +-
>  fs/proc/generic.c                         | 2 +-
>  fs/proc/internal.h                        | 2 +-
>  fs/proc/proc_sysctl.c                     | 2 +-
>  fs/ramfs/file-nommu.c                     | 4 ++--
>  fs/smb/client/cifsfs.h                    | 2 +-
>  fs/smb/client/inode.c                     | 2 +-
>  fs/tracefs/event_inode.c                  | 2 +-
>  fs/tracefs/inode.c                        | 2 +-
>  fs/ubifs/file.c                           | 2 +-
>  fs/ubifs/ubifs.h                          | 2 +-
>  fs/udf/file.c                             | 2 +-
>  fs/ufs/inode.c                            | 2 +-
>  fs/ufs/ufs.h                              | 2 +-
>  fs/vboxsf/utils.c                         | 2 +-
>  fs/vboxsf/vfsmod.h                        | 2 +-
>  fs/xfs/xfs_iops.c                         | 2 +-
>  fs/zonefs/super.c                         | 2 +-
>  include/linux/fs.h                        | 6 +++---
>  include/linux/lsm_hook_defs.h             | 4 ++--
>  include/linux/nfs_fs.h                    | 2 +-
>  include/linux/security.h                  | 8 ++++----
>  mm/secretmem.c                            | 2 +-
>  mm/shmem.c                                | 2 +-
>  net/socket.c                              | 2 +-
>  security/integrity/evm/evm_main.c         | 4 ++--
>  security/integrity/ima/ima_appraise.c     | 2 +-
>  security/security.c                       | 4 ++--
>  security/selinux/hooks.c                  | 2 +-
>  security/smack/smack_lsm.c                | 2 +-
>  virt/kvm/guest_memfd.c                    | 2 +-
>  102 files changed, 112 insertions(+), 112 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
