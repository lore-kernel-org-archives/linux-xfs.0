Received: from sonic307-15.consmr.mail.ne1.yahoo.com (sonic307-15.consmr.mail.ne1.yahoo.com [66.163.190.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255764119F0
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279266; cv=none; b=XQYXXtji/3/FsVDshuIYRD/TSf75xxSyQqse25DVq8z6pNX9sbVlAhyklpINhgazX2g1/PPMdLpMIA/buHcZ/k+ttN9CSkGAWnQTrBBVIGaIfxNDObijp+nw59fGdQcJ2/Nn4zce1kO3xSfm7AdM/fviOlDX9dtqHBfo8PtekJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279266; c=relaxed/simple;
	bh=EIjyPnqw8QTTn+ydcMEjt0qRWEFtEg0Ql8NGv6CxEVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7T8vZBvrWkHlUGeJPKbUcLt14tPmr93h4+wioMHUVVtb5bZWKF+L0MdNWqxpmVkMeOYasrZ+cQ/yZYeFBxv1gTx7tPoYuy2JT2cdmDwtrRsa6BjopKQdyJxnI4StNWsFWI0gcY7Xuo2jNrSmYGeCgFG1TDEN895OeglHRn4o4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=dKXWigqB; arc=none smtp.client-ip=66.163.190.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="dKXWigqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788279264; bh=gPh+X/iBiqRKhw1S4WGz1YTRGse+nCFpHEMx4R0LHRw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=dKXWigqBPpZ0eaG8TWu/XP5ar3FPrhpdwiPLn3bCwy/im1bzlBlyfu+f4CdV76V7+Mx1HzGDE0093grGrbgXTtxHa9j23fRTdt5r+y0dei05Treb86V77kPAJHKw8hVgu1Rv67U217M1gcBJsbmKQ/ckrXW/YAXOgpKwAg+0KXxKlbFZxr0AO/MhhbSv3x27fgwbpyI0vBD9jF3POoqU5+ryJ9jp0Yi9Thu5UZ5+qbMmuk8H9GT0Ctz7XicNF+XqEKD4oJ2lsVDtQetBLyx/gIdYCf7XjCPInqqih8ZCP2cGSufs4m7ias6em9vttCuPXj5MNgKDrpXENbJ1LhPaxA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788279264; bh=fsCZ0BS71yxNQpsn2FF7RlcBF1Mt1b/hz0oidksDtlG=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=MmdR5mp2hcpZJ5tD3eleQ4oqPxMHup3C+F3KBWWqFuClZcuv5jC5fnAoJ340L9dAfFSX0QsM2JZQHzCkBUlMhSxSDitSdSwaKv49rosLGSaH+Msx1wHzfZeRBaLtrlRElqI6nTD6gG83pEo9VUGMW7IFqM5/h7BCEoo/in45c0En1UwWUYeLwfYIQRYDLLsX5H4Z3W61NE/OchEjebuLl9DGJDV8TKix0105FSYy7oJvu5UK/68hV+IQKbB9/Uczd/xqgT+pPzkqcRxBwL33cAovMKWutcBdX9gRzBV8neZ3yKlHU+fRAA09zWtq9mMpicqhrtWtA1OKxQsNH80oTw==
X-YMail-OSG: BnRSzUsVM1l6DMJ0RcDbVkj8OA4EnfP5.zaF5Sy_6KG2J6a5XNB2nRUsOjT3ART
 x5kLRUjxN7qI.IXN_GOJxUAxbDm4WQ1qWxDFpikbntvRnmDeeModNmJvEuDFj70nMxMVDCfR7i08
 TLoHA1R6hIZ1LhwgEBJz6BXTQpcu137HEdLRqbU3iAMWdmdCgHN.jybBtQrF.C89oj3iXdcwq83U
 kyDrUGwY2QAD56uB_yS9.v1b6lpsfgvy_wVq5Xl.XMcya.NblpqHct.74b_WgBLRj.n2g260Ze_5
 MC6oHD9kLsWBzV7oNxexUIrvLvA2NSEWiiQVAEF5Dyw0J_p2gi34blnPWV1ffY2fr2.2ndZK5mCw
 q8JZUkPybYawiAqbZMETn62xgxSJxqPLZriKVsh.Yur2GcbnN9rZY_BrvztvDaILL1w.poZ6QlwF
 HHWdMVYN65I.NYExwdSzLBLVE_XCTXiFgVwWkHjUWiRUX1WAttlhY7x7O4pRzoFf7rDr5KUvjq5T
 QFYbawEwONrjsddJQcutigmcwqUqQcYbsFsMPcGrG7uqKjThJvkpiyR9ZVvBcSQW7i.VmngJ09L3
 zNPMqOW23l3jYUmLNJA9tdLGcCRY8qixdtT_dA_LF6khvJdag3IzZ0iJXOPiBVwoPqOpVzmSDK0K
 rYXwTp56ucWKOEXaUx9qB5fKNpyhTVno69lmXRn586srKGKH9bcyQNuag15gmd4cQ_bwLRJpsebv
 hrH9oshCVWTElz0zb3kh5ZTnkTH3F540Joo96iqkl4GF1jBVeoHTGqM93jXemH20j.XQzu7F1kjv
 silAPMLu3nlfcOUZEuG6P6yeunGiFF8wT88ZXiNAvrO_eCWdV.BKTTl_GDY8Ki1_nhXYmMPNWTWL
 L4WVgb9bg2GzAGgwe7O_YWw1lUPljGE_7kizgV86h5n6.AeO1GAta2FijW7JtM4CIp94IlvVt3_X
 n2JoT.pEZXBK5T0805WWPzRfy0KT0RDYN2uYFdzPP3vo1mIWkiWPjfBSfdpa0P6T2p84k6QfmCkz
 HPyi8EzuxmPrb0oXLYeiYnj9Wv99M29bnqSOdD_91vneq9YVbWF7Q6Ob8VIQf6f_em9BBLlclDi4
 EXEc8pebwZ6v3bSF9hJIvWVd_1nwlDXudPKpTYbDy01lfwwMPxHqX4U7yo7jMXECMbWjiPC_EIei
 1rwJ6gZqwT_kXId0dQZTUuj7.NHXwISkRI5c77y.JwwNOrTopnjvAO50EPbmSmBYZ.Wm9.zbd7zz
 8mffN78xMRX437TWJmZsia5XHlwnD__SwtGTCFgLLDLqG0waLpdI5Gnjsk7PEsRhAB7b3weR_G4t
 mFhIaY7iOjLIM44a1g_LCMSSyJWLGhnL1u9Qf2jhZLL5gJ_6IYVXHVRVfV9ziNetQXEm_8WaIrTT
 tlixevJkEx6Dz..j6uh5NXC35zBpJbSM7StGjzdCZ6VVY86xr1QYX9Xm8BJhSQ7pkqx89uwC3CP0
 .p1kR0Plgh_Gdiw1C.9uSEEfWllyoBISuzXgpocW6t8tN5S53NAmNWF18cQm.SZHhO3Ncak.CkAx
 lo6eXKa52FjEofHF7ZRseScCLRHlnMH854MvxW05_v4OQqzn_dKcr.1mdNt1FlZvmNwoNCvKEhTr
 GBc11oR5WIkXvaO1zclx6FmXGgDjPc.Ie266nDgGo_72clnHYHYUKf875KOPIW1AzvxAW7oCLKHe
 2ahfFP1DPqv5akZ1S14Gks6tf1x27QnHtgR7mdotq8XOFuwAZe7DpFOphuTtnOuu3rwpY5WAFfoO
 8trFKjtEC7u.3PTb_9.FyXwuzAcJdZp6xU1DxO1LCDc9QG1ccOvBHiFjpwSgUkohS1J3Mu_vnr1p
 d5Wxy21YJJhYtS21aiCcV50vmBxj0jgvFg59llCpT3vN1pMaxf14PawfRh5PKiqRWhpad2vNXT4f
 FKtJWRdyhVAaFVTSBsbPot7S9XzzRgEInkTcl.vBKUhn9jtA8ADT7YWT9zvV1foYbKik0_X_dnYJ
 7ckBVPo6fIx2.7eqgJZ8JOsUBOfYNp5C6Cd2io8btrpEiGP8XXEIXv8lNiMIuiZrcm841JUkmksG
 DyK0xgr3MeyHSybaP_Fys7Nltg.EIr4Q0v4309l60Yib91EEQ7awW7xjVpdcnBZw1bekGO9PBACm
 HJtn0fGSUS3U9JB.nlXkq9a.8PxosWl9UkcaGzsm98E_rYsjhEt3dLJIH0eSlHBj8M9ednNL0JvJ
 WkoKD3FJpOYf25tly81HBtlpU0e0sVW1fbNJ3xF70RJgzlCrypYY0bHfiaif786dAoWYR1oDy_Pd
 SPBHQbxcB6yTNOQ--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: ae5512ae-c89c-4588-a92d-d5c736d4192f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 1 Sep 2026 16:14:24 +0000
Received: by hermes--production-gq1-678d9dd684-mxdfs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7bb86a24437c43194baefa3abed212e3;
          Tue, 01 Sep 2026 15:53:44 +0000 (UTC)
Message-ID: <d3656927-c39d-421f-8baa-f04c8d4eeff3@schaufler-ca.com>
Date: Tue, 1 Sep 2026 08:53:42 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/27] fs: port ->setattr() to pass const mnt_idmap
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>,
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org,
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.26380 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 9/1/2026 5:14 AM, Christian Brauner wrote:
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

...


> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index df4fc6ff26aa..bb78569b3d5b 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1270,7 +1270,7 @@ static int smack_inode_permission(struct inode *inode, int mask)
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int smack_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       struct iattr *iattr)

Please keep to 80 columns.

+static int smack_inode_setattr(const struct mnt_idmap *idmap,
+				struct dentry *dentry, struct iattr *iattr)

Note that the above may get whitespace mangled.

>  {
>  	struct smk_audit_info ad;
>
