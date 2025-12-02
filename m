Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE6136D510
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764665216; cv=none; b=M10g5mg04oNrqEsZgtE4iK9kTPp2SgJmqoVpkXp4MAaeQwgdRbzw+N7v43oh2b9h5FmVjPaDbp7P0WGDIm1GE+YObS1h8ioaJhVwZ+FK4e0J6XdgV/nbE3+9SHnSEizQSVpBpBJVmjal7xWySHpqwx57PZnWcI5LbFb3s9sFf8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764665216; c=relaxed/simple;
	bh=qcpxFQirLzafdSnNIq92XhuOn+HzWCu4AcZ2SW0UjqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t4BtovtT16OSWETXotPi2ZIS7lixpGiMSlwqLsp45WyqcvfhSweKr0cXqz/Cw49yQshYAhueM5Sx6N9flD6dD+ko2corIGOYQTfwtqL2WY5sBA95x8LXUY82BF81FL13uTKJaSWyp8AKD4J+jGSR8lpj0vlGHPZQ8WnFL/MQx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bbbrFs6+; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bbbrFs6+"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee0ce50b95so53517151cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Dec 2025 00:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1764665213; x=1765270013; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dxvySic7ZCI3Kve7CCt8lN1Lme0d3OPvrFfTikR164w=;
        b=bbbrFs6+5vw0v4zASrPuLyid+iafPWKvHeYf/XOZ4RlTfrAcYHZVAdk6e+pk3VUvT5
         48D6eTBCgo/3krpFsqeWdnF8GCD9YaUPsH9bnVDmtOnvHdlmeiRQ7K1+nPucKysf1DKV
         mmqSSKGrjMO7aaGrUT4vdZIAqeiNk+895+LjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764665213; x=1765270013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxvySic7ZCI3Kve7CCt8lN1Lme0d3OPvrFfTikR164w=;
        b=Jgk5kxMIq0xPMnn1YfakPCnLZrmf0EQfdSCwNLD7XbWWBIlKJzoUpcwpHLwQYND8LE
         2ECupCGDaFJ5dL59ChUh6GOM7djRT1kFjCf6ps9qBf3FZQg/5PlKCeOEHYyFcHzxP3BJ
         eVlij5fEeBCgMXblS7Hq7v9z2zboimZgW6O6no1mGjHYdhVZwnT5LXVN8svmZYfLuWKh
         CjQT51zR7VfirSZlqG8vDOJT0U85eb7ZGjRhLfkecf0mncVxhMSNBxIgFSXZweAKZtU/
         7xPP1TfkbtxAPBCmD5Q+/qlAjXAZEV/hP9osJr4nIEALS9ni/32d2ZqccOByE/069v5z
         nkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHJOr6Kpms6dLhhVJBpZzmVDw1RXxwF1DwvZ/YIjJHiweG0NJMH9TPtT6gNEHRvlZB19DJKQwcxYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfeEXNA9/X4bu2loQpcqzFQHpY1Gwhlc6m68Wfa6NvCzGWaSJA
	hDDe1/0/RvNObrxizdx7DJ6LA9MQwmrBrHHskcIEtf7tZLKKk0dSAGBXtZ0U363ZGlJ6sPpAM7H
	VH4O6AQ1P1Os6AYj+G35Yljd1TzJ1tudl4+Iu88qElA==
X-Gm-Gg: ASbGncuM+YwezkweQwaQmBAzxhT7KGYOgwQTvfW7tLNKlQ4b6II5k+8JXlh7mmqubMt
	42dLMHIrt9UEQg/y3kkF/VGZzXWDZjiXXoSxZDYVrkRpARUblpBxVy23v5QvagRxnLHVUND/exb
	NjBmiTiVdCjX4J8T2l/pKffhxH19SRUPdZ1Jz+jNQX+170oaAKSsLU4CUEj9v8K4WGfnrfrr7Y3
	jOs3SKsa3ul7/+8jfgXCppI5AF5x17XNQYX1CWzaN207cDFLJKx/zUt594WXnnl0ZMAgw==
X-Google-Smtp-Source: AGHT+IEmdgKRfEJt7lhW9JewHKYA/V5LXGRt+5HoCO1i6voev0VJmL65LKUm+BLjfUqBCpppRBhIODxs9MlwVlA6duw=
X-Received: by 2002:ac8:7dc2:0:b0:4ee:1f69:fdeb with SMTP id
 d75a77b69052e-4f0088dcc91mr26981181cf.11.1764665212783; Tue, 02 Dec 2025
 00:46:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113002050.676694-1-neilb@ownmail.net> <20251113002050.676694-7-neilb@ownmail.net>
 <6713ea38-b583-4c86-b74a-bea55652851d@packett.cool> <176454037897.634289.3566631742434963788@noble.neil.brown.name>
 <CAOQ4uxjihcBxJzckbJis8hGcWO61QKhiqeGH+hDkTUkDhu23Ww@mail.gmail.com>
 <20251201083324.GA3538@ZenIV> <CAJfpegs+o01jgY76WsGnk9j41LS5V0JQSk--d6xsJJp4VjTh8Q@mail.gmail.com>
 <20251201170813.GH3538@ZenIV>
In-Reply-To: <20251201170813.GH3538@ZenIV>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 2 Dec 2025 09:46:41 +0100
X-Gm-Features: AWmQ_blWv82I_AJ0z54S1o3oAiX82VQ2RDfse7yanE0u3ZklpA9ZzlQdeqtb1vo
Message-ID: <CAJfpegtJDJL7T0-Uj664xOm4N2e6fyJp_XwFecHX_9e9ipUyEw@mail.gmail.com>
Subject: Re: [PATCH] fuse: fix conversion of fuse_reverse_inval_entry() to start_removing()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, NeilBrown <neil@brown.name>, 
	Christian Brauner <brauner@kernel.org>, Val Packett <val@packett.cool>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, David Howells <dhowells@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tyler Hicks <code@tyhicks.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Carlos Maiolino <cem@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Stefan Berger <stefanb@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Dec 2025 at 18:08, Al Viro <viro@zeniv.linux.org.uk> wrote:

> Then as far as VFS is concerned, it's an equivalent of "we'd done
> a dcache lookup and revalidate told us to bugger off", which does
> *not* need locking the parent - the same sequence can very well
> happen without touching any inode locks.

Okay.

> IOW, from the point of view of locking protocol changes that's not
> a removal at all.
>
> Or do you need them serialized for fuse-internal purposes?

Not as far as I can see. As to any fuse filesystem being reliant on
this behavior, I think that's unlikely, though it's sort of documented
in the libfuse APIs as:

 * To avoid a deadlock this function must not be called in the
 * execution path of a related filesystem operation or within any code
 * that could hold a lock that could be needed to execute such an
 * operation. As of kernel 4.18, a "related operation" is a lookup(),
 * symlink(), mknod(), mkdir(), unlink(), rename(), link() or create()
 * request for the parent, and a setattr(), unlink(), rmdir(),
 * rename(), setxattr(), removexattr(), readdir() or readdirplus()
 * request for the inode itself.

Why the locking was added in the first place?  Oversight, probably.

Thanks,
Miklos
