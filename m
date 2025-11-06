Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B3222DF99
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 01:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762394177; cv=none; b=MMp32u2phlKCjnfv35QcgS85eVoDgvmYHwxbKKsCZAN5upe3JsAA0J+WxOY8YZjdaDSDnqiXJPAO7HeVpKqA8faSu/C0Fr2l+hw6+d84Bn26DhtJFn1wZWba9gsl6hPheR/yW2aF+V3zCOAz8l9eR0YzgXIhjRfrjW7A20YX07I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762394177; c=relaxed/simple;
	bh=Lwi+HBW6NI9Zzpj1VH4WGk4UsyyneW2Nkp2PQ1aZCJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y77pCON2zAAEACEo3rKxrtJccGT0UO/ix5BDkjWuxlAlNs5YG9EgFLwXFqX8B5l5/vvk8GZJ9qtvFYrm18decsT2vRuK5bYfnkN9JQPbi0At9M832BVo8USLsU4VfYsdcItBFO0BgPNxex8K/A0dqtaXD8ydZ+O+lwGvLABHs0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFAezk7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFAezk7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD96CC4CEF8
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762394176;
	bh=Lwi+HBW6NI9Zzpj1VH4WGk4UsyyneW2Nkp2PQ1aZCJk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jFAezk7bFkzOnpSyKtu/v/0eMNhdxWRoH1Mwm+NPQd0YUkK/tMK3Xje0KPEp81c7F
	 XsYqd64+4G4K6CK9dfdMN/Z1hEHdawN/kdcYTQpiQJNwk3yQk9hwx698TPLcTPbwHG
	 9d1vTFv8sBziGLxYtWQkJlP8ajLZZPGjPgJwGOEblng3QHZLv+j2LuQ7XwG0n4UzUa
	 TeLk3tNQzrVyW2ycOtHn/XQuZy0wN+sNSPL/5bTh4MhmvKJf/kjYvRSb0HQxZv2cu0
	 WKGGnfm/9o/+LHPHYI4upH6AjvoBfTgVVnEcnXfaY3ZSsDJpK48OI5cAmZcxGbRqbW
	 EJvb0sm9iPvDA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640b9c7eab9so626971a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 17:56:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXbWPkodqWmHdvHw0RxpRE9i8b5vBlGryhbilppHuiO74WyhtLBnzhZ0NbL4aWnPG/8S6Qi9LEwAwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0ZbG4DAJRK9FQUntfqjvoJmC4/BNriunx9wOaRzEmShJXSJTG
	ewRfgq4pK1Yek5t2C2ubrRUFy/IFu8VaMJ8iwAgpWn2C6TFMA7UreMx0mzqZi/3UJzj7BsSd4de
	dx6kDju1zB7W1Jk+NprotoM/uBWoes1w=
X-Google-Smtp-Source: AGHT+IGRWQr/yMix2KC9FWBoMcuBXJI8axGaVe0Q7R1p9lozVUkvmiwrl4KtXQgDBkKGB2LM0O8foBaqARcRluikU3E=
X-Received: by 2002:a05:6402:51d1:b0:63c:2d72:56e3 with SMTP id
 4fb4d7f45d1cf-64105a5d549mr4682456a12.23.1762394174672; Wed, 05 Nov 2025
 17:56:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106005333.956321-1-neilb@ownmail.net> <20251106005333.956321-8-neilb@ownmail.net>
In-Reply-To: <20251106005333.956321-8-neilb@ownmail.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 6 Nov 2025 10:56:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8noOKEPEBDKSFa4FLFsHH3oCKRM58Tq+PTmTG5yjyDdw@mail.gmail.com>
X-Gm-Features: AWmQ_blmBmQhx0SfF_RJrLZwQ93tMKfLranVnNF6NMqPQEMSGUPWm6n05JxFEa0
Message-ID: <CAKYAXd8noOKEPEBDKSFa4FLFsHH3oCKRM58Tq+PTmTG5yjyDdw@mail.gmail.com>
Subject: Re: [PATCH v5 07/14] VFS: introduce start_removing_dentry()
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tyler Hicks <code@tyhicks.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Chuck Lever <chuck.lever@oracle.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Carlos Maiolino <cem@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Stefan Berger <stefanb@linux.ibm.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, netfs@lists.linux.dev, 
	ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 9:55=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote:
>
> From: NeilBrown <neil@brown.name>
>
> start_removing_dentry() is similar to start_removing() but instead of
> providing a name for lookup, the target dentry is given.
>
> start_removing_dentry() checks that the dentry is still hashed and in
> the parent, and if so it locks and increases the refcount so that
> end_removing() can be used to finish the operation.
>
> This is used in cachefiles, overlayfs, smb/server, and apparmor.
>
> There will be other users including ecryptfs.
>
> As start_removing_dentry() takes an extra reference to the dentry (to be
> put by end_removing()), there is no need to explicitly take an extra
> reference to stop d_delete() from using dentry_unlink_inode() to negate
> the dentry - as in cachefiles_delete_object(), and ksmbd_vfs_unlink().
>
> cachefiles_bury_object() now gets an extra ref to the victim, which is
> drops.  As it includes the needed end_removing() calls, the caller
> doesn't need them.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: NeilBrown <neil@brown.name>
For ksmbd part,
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
