Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2350914291A
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309276; cv=none; b=ICivRmc8D2+22NaAktkgz5IuArWMLtA+dZNsHnfWr0FvRLklIeJvZ2gFWNkrX2/2k+BAyw1HIFRxmXMsYiEkg78uJbO5YRiTqq5ff0mQ4qlmuhwKxpzy2IqQllw8qMP1nCFGOwiEt8dpMSEockjLG/viq5dtxjlccAfdCiDojWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309276; c=relaxed/simple;
	bh=juSFdfByfPrlbSQpoABkvj/nbibedrl1YknKIP1oZf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIM/cD+v0M3WmIE5o/Yxyv4GpLH6O81tovq1SgtZ6JfI8Uq8Uj5b6mQlUdUMDnTlrJxDvcepnD12nV+9YEaGNrnll30rCcdZu4PiSZU+1dihUZfiE8xZEPfpCHuKvEwix6niJu8bznYXkBDvkmoMiLusMoW1F3MRbF/oqv8fzrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFEuo0HD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFEuo0HD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716309274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xMWjXlQzrkt+R9p0EdQfQQ8DoBUNqzqS8fhr5tw1zQM=;
	b=TFEuo0HD93CNXjpA+zIrBSm76qHkB3AqoZC/9NLg8qRjigIeuvcYFT319Mj+E6/O8nB5B3
	LoGQrmyh3i6l6etrKlmf//+QRt8xAukCX9idMQ2U9FOhwGy+SLKjZt8Un2DJ2oB8XMj9RF
	bXIDWwbuvG7gtGfu0oOxqhiuqCRDXeA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-ekWaKUchN0GowbgiwRmieQ-1; Tue, 21 May 2024 12:34:32 -0400
X-MC-Unique: ekWaKUchN0GowbgiwRmieQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4200e6a9901so60096525e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 09:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309271; x=1716914071;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xMWjXlQzrkt+R9p0EdQfQQ8DoBUNqzqS8fhr5tw1zQM=;
        b=chQIT3jcKRCW/9niIG+ZMaaxlrcVA3MYL/WEJusEYs7ssJ1JBNZVdVMvMheVkey1/t
         cFdX4fCF1UJ2WAi+UqVCnOgoRHKG6iqd7sKZCDjnOTyE/h9HzTU3AjwgnihT+YosKqGH
         3fnslDqfTgdWlKOtwfAJNqMUbYnq1xSKpo6+b9DQyjhRVHYjL4zndDTG6jVBLSzuRiCc
         N6YoyOfPkD3LU9RnJxKaYEKRlqGJy+vuAF6uIZJPF3aS0Wu8EXAyHCVu2/1dIGpuEOt8
         wrJm7TJgxt8bWqeQXXpd+8gJkc44DnxMrAGNZnt6QxdeMMNR4KzaBD9lNGjPu3KpxT0V
         OVwA==
X-Forwarded-Encrypted: i=1; AJvYcCXx7OhpPx0yF/OCVuEWslLOOBWVdafkKdSMxLs6atNsspYj0bjtWNJ339nfkWHBvJbKZuDfytI+/S2FYl45O7Ys2M/ta3Vo9vB+
X-Gm-Message-State: AOJu0Yy75Clo5idL84DF/71F2rrnxOH9fvX36JqlBi5L6xQNKVmfmY0I
	dPSsdBJJpQ/fguHiQNpC9sDUxK2qcrWrO0SPT3WtuwRNWPhObgKSz7hdx6xTmvin3gEdumngehH
	Qh6uPQ+mFxEXcFGATSrRmVaTiOOCrFxT67yGUeTIQBw/m4vaEcAoBIUBJ
X-Received: by 2002:a05:600c:314e:b0:41f:c83d:5ba8 with SMTP id 5b1f17b1804b1-41feac59e95mr236895005e9.32.1716309271310;
        Tue, 21 May 2024 09:34:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYRbPc/sJrxiwnThiGGQ+172mOuNjepOBj7pUUx1GUQEKJSR3K40eBc0oTA6+HQF5F5MNTFg==
X-Received: by 2002:a05:600c:314e:b0:41f:c83d:5ba8 with SMTP id 5b1f17b1804b1-41feac59e95mr236894675e9.32.1716309270559;
        Tue, 21 May 2024 09:34:30 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccce25d5sm472885415e9.14.2024.05.21.09.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 09:34:30 -0700 (PDT)
Date: Tue, 21 May 2024 18:34:29 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <z6ctkxtwhwioc5a5kzisjxffkde6xpchstrr3zlflh4bsz4mpd@5z2s2d7lbje5>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
 <CAOQ4uxikMjmAkXwGk3d9897622JfkeE8LXaT9PBrtTiR5y3=Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxikMjmAkXwGk3d9897622JfkeE8LXaT9PBrtTiR5y3=Rg@mail.gmail.com>

On 2024-05-20 22:03:43, Amir Goldstein wrote:
> On Mon, May 20, 2024 at 7:46 PM Andrey Albershteyn <aalbersh@redhat.com> wrote:
> >
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID set on parent
> > directory.
> >
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. as opening them returns a special
> > inode from VFS. Therefore, some inodes are left with empty project
> > ID. Those inodes then are not shown in the quota accounting but
> > still exist in the directory.
> >
> > This patch adds two new ioctls which allows userspace, such as
> > xfs_quota, to set project ID on special files by using parent
> > directory to open FS inode. This will let xfs_quota set ID on all
> > inodes and also reset it when project is removed. Also, as
> > vfs_fileattr_set() is now will called on special files too, let's
> > forbid any other attributes except projid and nextents (symlink can
> > have one).
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/fs.h | 11 +++++
> >  2 files changed, 104 insertions(+)
> >
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 1d5abfdf0f22..3e3aacb6ea6e 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/fscrypt.h>
> >  #include <linux/fileattr.h>
> > +#include <linux/namei.h>
> >
> >  #include "internal.h"
> >
> > @@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
> >         if (fa->fsx_cowextsize == 0)
> >                 fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
> >
> > +       /*
> > +        * The only use case for special files is to set project ID, forbid any
> > +        * other attributes
> > +        */
> > +       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> > +               if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)
> > +                       return -EINVAL;
> > +               if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)
> > +                       return -EINVAL;
> > +               if (fa->fsx_extsize || fa->fsx_cowextsize)
> > +                       return -EINVAL;
> > +       }
> > +
> >         return 0;
> >  }
> >
> > @@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void __user *argp)
> >         return err;
> >  }
> >
> > +static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
> > +{
> > +       struct path filepath;
> > +       struct fsxattrat fsxat;
> > +       struct fileattr fa;
> > +       int error;
> > +
> > +       if (!S_ISDIR(file_inode(file)->i_mode))
> > +               return -EBADF;
> 
> So the *only* thing that is done with the fd of the ioctl is to verify
> that it is a directory fd - there is no verification that this fd is on the
> same sb as the path to act on.
> 
> Was this the intention? It does not make a lot of sense to me
> and AFAIK there is no precedent to an API like this.

yeah, as we want to set xattrs on that inode the path is pointing
to, so, VFS will call to the FS under that sb.

> 
> There are ioctls that operate on the filesystem using any
> fd on that fs, such as FS_IOC_GETFS{UUID,SYSFSPATH}
> and maybe the closest example to what you are trying to add
> XFS_IOC_BULKSTAT.

Not sure that I get what you mean here, the *at() part is to get
around VFS special inodes and call vfs_fileattr_set/get on FS inodes.

> 
> Trying to think of a saner API for this - perhaps pass an O_PATH
> fd without any filename in struct fsxattrat, saving you also the
> headache of passing a variable length string in an ioctl.
> 
> Then atfile = fdget_raw(fsxat.atfd) and verify that atfile->f_path
> and file->f_path are on the same sb before proceeding to operate
> on atfile->f_path.dentry.

Thanks! Didn't know about O_PATH that seems to be a way to get rid
of the path passing.

> 
> The (maybe more sane) alternative is to add syscalls instead of
> ioctls, but I won't force you to go there...
> 
> What do everyone think?
> 
> Thanks,
> Amir.
> 

-- 
- Andrey

