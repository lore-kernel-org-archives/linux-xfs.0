Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46703137934
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716231838; cv=none; b=O2tN7Vyui8KTrNYRZ7plvPS/3uGp8aH6RzuKHWhVx7WdhP4fhmJLXCULGh8lch7zm1BkKE0jZEZIHJuAV5SSlvKfeaR7/gNAVI6KSsLz7c6t6JnXSnz+pW8DWidnfMGUXzJXXT5PDgZAB4BhAl4CixD4A2YSTiLHhU19R1fvjko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716231838; c=relaxed/simple;
	bh=iohNmKIIB0ET1c1vHcwQhH5gp5/1p8wIXXMtg+ZpmuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lI68Cvhpy/gHzR7brqyv1hsJ1dbkvf976J9Xp7CTcu/nOzVLbvUnIlni0YDr2wthtGxMeQEyD0IPQhgOzQDbu4dAOQ6AuUd4wc2o51RHDa3YE+v5PvjS3TeFAPbTxJUT8ygdJTz4C2Tax5LgfLSIJfGs6onXaFNOfCeXpMYpAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BN+VpRXw; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BN+VpRXw"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-792b8d30075so270018385a.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 12:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716231836; x=1716836636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BwCwDY5e4Nt32TQBfm/Kpy3evCON3mLJFZVki+wAqH4=;
        b=BN+VpRXwW1Ob0UbripgfEYVMsFzNUp8DPcKnExzjd3uLZ0ALtD1ndd6qx+fEUy2ncj
         lfMVa+xLKWLO1zHiXlq+0eB/vW+fQjqSD/nfthrrVF8JlHIVNfStaAf0sZ4S8z/mw/gF
         yaiqgC5OfoJdADi4LiSpM+DSpjmYWfaD+Lo8rVmsb50KD58tOmU43NDMxoDoKZT6zEhX
         mJLqRaNNrwi+Hpog3gkhbqnfdZz0tSJcSYvuAoIzGG1R4OUyxrDkliQ23QmYW0m7j4C5
         R2N1Y8R2CLVEvRiWTbSKqfani1BAkOuasPyr6vLt8YQsYKF7yJOC0owRyj6mgafwHCbJ
         lLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716231836; x=1716836636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BwCwDY5e4Nt32TQBfm/Kpy3evCON3mLJFZVki+wAqH4=;
        b=azWi/NWb9FkezCq0c+GCHjtkErVzJZ0r1gfnjRioupFx9duz5FkDiBBuLNbDIgQL0s
         hJzwy8DxranPquXKN6vtcv5zsXDFjIDq55TLd5qEwe1IuKzdZJsji4kNp5MlfWroWt2d
         g45vf+qbArDXQhs4nsJmSnNdc3tixGYEnk/v+oAOSzQbjC80XM/DV7aHSJKfBsdH+ReN
         vBEH1J0krTHtUIHb+TUfU9dnf+hK6znBvoC07wUlyd45sLpbJLgvuHPp3PnK/PuEJ9wH
         sX3qIdhysja8qtEs98PFZBEjIQQMzJtmS/YeXULLiyFOBt86ttI3d8K6Y5urRt7ly6tZ
         snJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnd3Uei1t9uCI5/nfgQmNMsmWXRQLoTAeAfF0b1bon/aHjoTf9v9ILFlJ8O3f7LVlzEoQlsRikjThUwEQtTNSfu4rv9M39E/3p
X-Gm-Message-State: AOJu0YyqJPBjz6o1eCEqGgOP/VjPsX+8S/ntyfVwECWwRRXUhbJucSqd
	tSF9s2ZXO2AEXFXHNwbF8B9r8RnudiugEHByOeqkvXX24QLHPBVm5z7O+B9OgTSnZJSwbPdkGzB
	FxgkJWUtS14qtoSQAIQ0dUTC/sEQ=
X-Google-Smtp-Source: AGHT+IEIZdqgfv8ZZ7aX2NdScRLkUxuuQzHEo0usHDPnSSm/5kJl0DXUswf5nd2DI7fE+HhBRaUjDY/qwS1dM7pYSaI=
X-Received: by 2002:a05:620a:2088:b0:790:a39d:c895 with SMTP id
 af79cd13be357-792c75775bfmr3015744385a.1.1716231836032; Mon, 20 May 2024
 12:03:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520164624.665269-2-aalbersh@redhat.com> <20240520164624.665269-4-aalbersh@redhat.com>
In-Reply-To: <20240520164624.665269-4-aalbersh@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 May 2024 22:03:43 +0300
Message-ID: <CAOQ4uxikMjmAkXwGk3d9897622JfkeE8LXaT9PBrtTiR5y3=Rg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and FS_IOC_FSGETXATTRAT
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 7:46=E2=80=AFPM Andrey Albershteyn <aalbersh@redhat=
.com> wrote:
>
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID set on parent
> directory.
>
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them returns a special
> inode from VFS. Therefore, some inodes are left with empty project
> ID. Those inodes then are not shown in the quota accounting but
> still exist in the directory.
>
> This patch adds two new ioctls which allows userspace, such as
> xfs_quota, to set project ID on special files by using parent
> directory to open FS inode. This will let xfs_quota set ID on all
> inodes and also reset it when project is removed. Also, as
> vfs_fileattr_set() is now will called on special files too, let's
> forbid any other attributes except projid and nextents (symlink can
> have one).
>
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h | 11 +++++
>  2 files changed, 104 insertions(+)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1d5abfdf0f22..3e3aacb6ea6e 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -22,6 +22,7 @@
>  #include <linux/mount.h>
>  #include <linux/fscrypt.h>
>  #include <linux/fileattr.h>
> +#include <linux/namei.h>
>
>  #include "internal.h"
>
> @@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
>         if (fa->fsx_cowextsize =3D=3D 0)
>                 fa->fsx_xflags &=3D ~FS_XFLAG_COWEXTSIZE;
>
> +       /*
> +        * The only use case for special files is to set project ID, forb=
id any
> +        * other attributes
> +        */
> +       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> +               if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)
> +                       return -EINVAL;
> +               if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)
> +                       return -EINVAL;
> +               if (fa->fsx_extsize || fa->fsx_cowextsize)
> +                       return -EINVAL;
> +       }
> +
>         return 0;
>  }
>
> @@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void =
__user *argp)
>         return err;
>  }
>
> +static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
> +{
> +       struct path filepath;
> +       struct fsxattrat fsxat;
> +       struct fileattr fa;
> +       int error;
> +
> +       if (!S_ISDIR(file_inode(file)->i_mode))
> +               return -EBADF;

So the *only* thing that is done with the fd of the ioctl is to verify
that it is a directory fd - there is no verification that this fd is on the
same sb as the path to act on.

Was this the intention? It does not make a lot of sense to me
and AFAIK there is no precedent to an API like this.

There are ioctls that operate on the filesystem using any
fd on that fs, such as FS_IOC_GETFS{UUID,SYSFSPATH}
and maybe the closest example to what you are trying to add
XFS_IOC_BULKSTAT.

Trying to think of a saner API for this - perhaps pass an O_PATH
fd without any filename in struct fsxattrat, saving you also the
headache of passing a variable length string in an ioctl.

Then atfile =3D fdget_raw(fsxat.atfd) and verify that atfile->f_path
and file->f_path are on the same sb before proceeding to operate
on atfile->f_path.dentry.

The (maybe more sane) alternative is to add syscalls instead of
ioctls, but I won't force you to go there...

What do everyone think?

Thanks,
Amir.
