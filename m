Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DB019E971
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 10:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753785359; cv=none; b=oA53rPbcUymTZUMHVPXxX+vtqQHNezXepF7bDP5uWYZZtjdBWVajlhBZEg0aD1aiebVhHwIhamjFj4QDmzT4f0x0VawzYO6MlV2pToyiH3287DgoiVhSdCzf13txYjxghqoGLedPglD0MZKr9pyhs5epnXPtL0mEkCIsz9xV9Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753785359; c=relaxed/simple;
	bh=HO5d2wAJgWq6Tl4cr7avtyFxxM9YP0MhCx3yLUH1H/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfLx+cYI5VWWNf+2K74sBhwvbLsHUOWiQ0TIopmUtI63CkEVdqF0lwosJ7qiMBlqxypsibV2vfmc0o0hvKJXt3hzknLmdEkUIlbuDzNipo2G/pZfkkCAsv7k0YHC3ZJUzyuNbwe4VRoTVBjoFuEkklaJVxh6Dw4Dgm/KUEOoPGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHbvAT1f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHbvAT1f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753785356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTPMGB6z2nyOCHdJ7CbXMpiw/sTsf8ojO933mhQUepA=;
	b=gHbvAT1fLIXC712nz6WiznW9684rnuMlwh9rvWGhHseU0dIij926lFBvydBcdLl+kSJuDn
	ufopNWeW+82p1QcpwCX6hTyqZCt7yQgMNFZuz0nInlGO7gv4jPBWp0inoYMfVKaW1G3q6N
	FcmPaCVh6u8rCTVLdxQzX263gsvIy6E=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-GdeqR-9ZO3uaIj0zCnd5EA-1; Tue, 29 Jul 2025 06:35:54 -0400
X-MC-Unique: GdeqR-9ZO3uaIj0zCnd5EA-1
X-Mimecast-MFC-AGG-ID: GdeqR-9ZO3uaIj0zCnd5EA_1753785354
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ad56a52edc5so537353066b.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 03:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753785354; x=1754390154;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTPMGB6z2nyOCHdJ7CbXMpiw/sTsf8ojO933mhQUepA=;
        b=THldnGqduwlwHZ/MgD5xo7cRPdRvpYbSccgUxX8h2w6iOfv2P3HQllX7fpM5b8CFdx
         oI2I3TcJcs4cfwZKqHMFQF7BTR6n/biyqHSa+LvedJwVxz2YmfPBXX6h755F+lOynVuv
         WD49pIGXKrcKlceS4jtDesb0wNOeuMCOOP2PDivotDal7tJwiT4ftC/KdyVRopVSDGVt
         vUpTrYdOop3hR1fkeNmBAjX0ekzY3r0UZXGobayycrwNkh6mqQpOIsItSV1QcqAVrxe1
         by2n3Wn4GhKN1y5Rz4NDUqrKo+F8Knr4A2vo68nyTW8+TIhyhGouDyPdlstUrH/lzGqe
         dgwg==
X-Forwarded-Encrypted: i=1; AJvYcCXgcV4q31lSq2RbGPtI3e46nzaBWQJpPEv9vZYl5czT5wKWAVUB7r4afS7WeGYF+BeX8ptrOYtgH+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGAfrlIuyD/qDicxP8J1NJAUlqcBR4UgB5dtfkiXxxNzs8YgZY
	MzLS9RW1DkXiDo05ATJuaQPNOowMMTbG8fymSIvtmu2HXeYGdIevdJralhQvOB1GHaYA5u6IBTp
	FmnN26jXLE7+vfM3cJ/QjxSS/r3mk+hdn1fDY/rAuk7hQpLNwvL1xsCPAeFMe
X-Gm-Gg: ASbGncsYjujst42sODYu1xl6fjSfpRhb/KyMPEJMApSc4T5j8wdv9NGiUpm8iiZd8J3
	P6HTv0GWEpdcSQZLtur3NWGzzjR0Qwati9pvo87PdG0VszalshJPf3l0uIBIfUrk5eKNeKZ/D8Q
	I5XebeCS/AJDu5HVe6BPu2eW2+3DVo05XOWjTjpkaHua2ie+v1I1jVwY/Nbd9yNFyJS2ARpz66B
	GjS6sG1jv5DroDig6TIutFfYkky9J8gxJKk4yXp37cS9NBdJaVfmB8e/M4g2e7Dw5bszs7tQ0nT
	u/CdO6rlVpLMy16+M1SJa47MxdRqiejfo/MMm/JuqxBNFhpGk3+qGL/1t0Y=
X-Received: by 2002:a17:907:7f0b:b0:ae0:a483:39bc with SMTP id a640c23a62f3a-af61960265emr1623453066b.46.1753785353622;
        Tue, 29 Jul 2025 03:35:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrTT+nSEpY2hTKBRWCIHp8//T157MzOq0SO4kMFDOhKTEbq9mH172vvX2jSKOC7gjPBDNa1Q==
X-Received: by 2002:a17:907:7f0b:b0:ae0:a483:39bc with SMTP id a640c23a62f3a-af61960265emr1623449166b.46.1753785353121;
        Tue, 29 Jul 2025 03:35:53 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635860003sm571051066b.10.2025.07.29.03.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 03:35:52 -0700 (PDT)
Date: Tue, 29 Jul 2025 12:35:51 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	djwong@kernel.org, ebiggers@kernel.org, hch@lst.de, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 03/29] fs: add FS_XFLAG_VERITY for verity files
Message-ID: <ppcw73dlw4qdumbmel4spy2uvlaocnqfowquiop4mhauw3xxc4@kjad3vbucx7v>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-3-9e5443af0e34@kernel.org>
 <CAOQ4uxjXucbQderHmkd7Dw9---U4hA7PjdgA7M7r5BZ+kXbKiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjXucbQderHmkd7Dw9---U4hA7PjdgA7M7r5BZ+kXbKiQ@mail.gmail.com>

On 2025-07-29 11:53:09, Amir Goldstein wrote:
> On Mon, Jul 28, 2025 at 10:31 PM Andrey Albershteyn <aalbersh@redhat.com> wrote:
> >
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> >
> > Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
> > enabled.
> 
> Oh man! Please don't refer to this as an "extended attribute".
> 
> I was quite surprised to see actually how many times the term
> "extended attribute" was used in commit messages in your series
> that Linus just merged including 4 such references in the Kernel-doc
> comments of security_inode_file_[sg]etattr(). :-/

You can comment on this, I'm fine with fixing these, I definitely
don't have all the context to know the best suitable terms.

> 
> The terminology used in Documentation/filesystem/vfs.rst and fileattr.h
> are some permutations of "miscellaneous file flags and attributes".
> Not perfect, but less confusing than "extended attributes", which are
> famously known as something else.

Yeah sorry, it's very difficult to find out what is named how and
what is outdated.

I will update commit messages to "file flags".

> 
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > [djwong: fix broken verity flag checks]
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  Documentation/filesystems/fsverity.rst |  8 ++++++++
> >  fs/ioctl.c                             | 11 +++++++++++
> >  include/uapi/linux/fs.h                |  1 +
> >  3 files changed, 20 insertions(+)
> >
> > diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> > index dacdbc1149e6..33b588c32ed1 100644
> > --- a/Documentation/filesystems/fsverity.rst
> > +++ b/Documentation/filesystems/fsverity.rst
> > @@ -342,6 +342,14 @@ the file has fs-verity enabled.  This can perform better than
> >  FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
> >  opening the file, and opening verity files can be expensive.
> >
> > +FS_IOC_FSGETXATTR
> > +-----------------
> > +
> > +Since Linux v6.17, the FS_IOC_FSGETXATTR ioctl sets FS_XFLAG_VERITY (0x00020000)
> > +in the returned flags when the file has verity enabled. Note that this attribute
> > +cannot be set with FS_IOC_FSSETXATTR as enabling verity requires input
> > +parameters. See FS_IOC_ENABLE_VERITY.
> > +
> >  .. _accessing_verity_files:
> >
> >  Accessing verity files
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 69107a245b4c..6b94da2b93f5 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -480,6 +480,8 @@ void fileattr_fill_xflags(struct fileattr *fa, u32 xflags)
> >                 fa->flags |= FS_DAX_FL;
> >         if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
> >                 fa->flags |= FS_PROJINHERIT_FL;
> > +       if (fa->fsx_xflags & FS_XFLAG_VERITY)
> > +               fa->flags |= FS_VERITY_FL;
> >  }
> >  EXPORT_SYMBOL(fileattr_fill_xflags);
> >
> > @@ -510,6 +512,8 @@ void fileattr_fill_flags(struct fileattr *fa, u32 flags)
> >                 fa->fsx_xflags |= FS_XFLAG_DAX;
> >         if (fa->flags & FS_PROJINHERIT_FL)
> >                 fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
> > +       if (fa->flags & FS_VERITY_FL)
> > +               fa->fsx_xflags |= FS_XFLAG_VERITY;
> >  }
> >  EXPORT_SYMBOL(fileattr_fill_flags);
> >
> 
> I think you should add it to FS_COMMON_FL/FS_XFLAG_COMMON?
> 
> And I guess also to FS_XFLAGS_MASK/FS_XFLAG_RDONLY_MASK
> after rebasing to master.
> 
> > @@ -640,6 +644,13 @@ static int fileattr_set_prepare(struct inode *inode,
> >             !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> >                 return -EINVAL;
> >
> > +       /*
> > +        * Verity cannot be changed through FS_IOC_FSSETXATTR/FS_IOC_SETFLAGS.
> > +        * See FS_IOC_ENABLE_VERITY.
> > +        */
> > +       if ((fa->fsx_xflags ^ old_ma->fsx_xflags) & FS_XFLAG_VERITY)
> > +               return -EINVAL;
> > +
> 
> I think that after rebase, if you add the flag to FS_XFLAG_RDONLY_MASK
> This check will fail, so can either remove this check and ignore user trying to
> set FS_XFLAG_VERITY, same as if user was trying to set FS_XFLAG_HASATTR.
> or, as I think Darrick may have suggested during review, we remove the masking
> of FS_XFLAG_RDONLY_MASK in the fill helpers and we make this check more
> generic here:
> 
> +       if ((fa->fsx_xflags ^ old_ma->fsx_xflags) & FS_XFLAG_RDONLY_MASK)
> +               return -EINVAL;

Sure, will look into that in the next revision, I haven't used the
latest master, so this wasn't updated

> 
> Thanks,
> Amir.
> 

-- 
- Andrey

