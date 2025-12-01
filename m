Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B24131813F
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764612032; cv=none; b=JjtRmyMoYXPKZ8zz1s5LeNZUtLpafQpoj5jbTrpH0hPYGWbpo6pVJHn++WgkgylVxC32Wh6Z24UsksOJ45m53gfPqBLZlt9R7L685p+n78u0SqcNzrD1unDhKOOZza1qY6jEoQ7e6QC7GMyhu92MnIt3ZcpZGfrHDUr3whSKJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764612032; c=relaxed/simple;
	bh=oS0xVsxpGDFHtACUzeVmsste6ayGHLvpEVwQrrTMru0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdTT+vXe28/Vt8uD6ZO5DhWTud6o4TojSZMHzUxfdENQRwpx0Aj1jwV8LINjveFoItzgmkWV50hiFZgTmSQ/oQlu+H5eIu+59E3fb4PDo+Gs5l00HrYiBmzz3K3QkOi7MB+28SjWdmonGZCmpVaCAci5lTmQAWb8A0cvI2hkDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X/4IJQOP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cs7yYEKe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X/4IJQOP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cs7yYEKe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764612029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RSeRcYTKm0XJxZxPIKmEp5JgZXZRLHyitAoyvtucrgY=;
	b=X/4IJQOPDzP2qvqig79gXNx6QoKG/DvnqA1kxrZ/a/b+5kJJ4HjUXdhJSWAiqoVBnIxq/7
	2yoK1RUGLiAHOJ6TxvvYeS/UpU+Md2KZocDUUWc3A27sXvOFiI2K/nxclKGsayqw3T5dG0
	+6zkVx1dObw+p1PXuyMMkHAcJDNEEhE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-O2EsWrmPNh2YIuIBM9yi6Q-1; Mon, 01 Dec 2025 13:00:27 -0500
X-MC-Unique: O2EsWrmPNh2YIuIBM9yi6Q-1
X-Mimecast-MFC-AGG-ID: O2EsWrmPNh2YIuIBM9yi6Q_1764612026
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so35594915e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 10:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764612026; x=1765216826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RSeRcYTKm0XJxZxPIKmEp5JgZXZRLHyitAoyvtucrgY=;
        b=cs7yYEKehTdzU7MPb1xNPH2vQxyXa0k/xFmkQmilZg8DOV06Zw/YXdDNwdJnk3UuOR
         l/nj2X1ZKj5OqZm2rNfHkeRhD7Jf1W8mr5SxmViJSB0DqP0poXONy+7OFvZ7vNXPvP4U
         ANjxF8mrM4xyCF+vcyWet43XV8V7r/9GlQeC8CAxquXxbh0k0m3D2Bbw7cHe3ZkzOn68
         boRwGnY5XhNvP9wIPxVv2v1+xeb0PsKZy08nczG+EaWMbMBekM8KWBiZ54o08QlbOCc/
         lGKYtG1zdpUAj9/lIqTh10l7Fjlc1uhZYjh/23PmiEIIzkCFppZ7Yg8O1SfpiBkfHrj+
         xmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764612026; x=1765216826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSeRcYTKm0XJxZxPIKmEp5JgZXZRLHyitAoyvtucrgY=;
        b=lcjRBSAJFyNU5DHv/qxe+FDLQncn4fkYgNhhuy03E8n/NgD0eXkCO3AH7/f0FwWm98
         Dn88+efUI45/cwE0dMvxUM2bjfiRCaUbxhSvf+quA2ZOXqLpU89GyWALPq//xymAZ3FN
         kSliVrDt/VyeRfYUN0cynb6dFG+ys+itgfqa1Ma3FonpjV83Or2z8etiR0iCJ9Cmm/Zw
         4kBkS90ODC4pZ1RkIOOP6AY1o+KGaOlzsURUhY209Jgor/qpR1Rrpkc8MQ7+IoBMbqPF
         7a5Qn2L7nKmV49yytTOoroqbDWoGpB9jLxDhE4EXQE9MiTBncgrWqwhdJSzmA5+p5i8H
         DCjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIyMITVuEWyklr+QArQmSuBHi2+w/77BzILqoMPVvZEGU/KOfUzetQf4pniBj+bzS6iV/eLL8ajoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2HPvP5swmMJwyRU12r7CR1G78dx/3R2pLaqF+Bvl611hHVyYu
	pS2N0TQQVUSw2DUS7i8VPrvGIdK6buuHCjzfoYxK5Rgm+37otbG5XavtSrpCZ6T/1n8QLPTUPqp
	D1lQ3ZmRsuk84H18aHxLG7HTUlRyxsWPMjaw3T358jMhgLBOOOBhhE2LvOJQC
X-Gm-Gg: ASbGncunm7y/KazxFKTkrurPYCdEIp4vXqKbYmMBJ8L7FWScjea1Jo78Lj8jVQk/Ull
	s2AqZVJoemY7/MZh3/XJVQbyPwCg/3Gg0/sjHz59x5piEHzGbJ2anFh28fh6jfNrDGXd66SG2qV
	k8kk6qCZ7FyXZnUNNw04Hxh0+QxRLVVYM95nTNkU4mwg3iJuJl/U93vpplTf9dseRarWv4RBJ0W
	TET3a6b3zx5Z+sbnWWyn3YZEaV+KWpn1o9HSu82Y+omaUyGuQsJrCEET7JfyX+GvtEhRNZDyH+u
	P1rZfucViwFIbhziVSyhs6YYYi8kcvB++PMtu+g073fwoKmlU6i+PGdlY8Gl5Fatr8YBmOjf5hE
	=
X-Received: by 2002:a05:600c:1c20:b0:477:9d54:58d7 with SMTP id 5b1f17b1804b1-477c1131d60mr421563885e9.29.1764612026252;
        Mon, 01 Dec 2025 10:00:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmG6Pm6RDn+BDaktwQRj9S7Pu5EKSixnesF7purvqL8+UdNz5CArjG1RwQB7xSc9qpTfcZbg==
X-Received: by 2002:a05:600c:1c20:b0:477:9d54:58d7 with SMTP id 5b1f17b1804b1-477c1131d60mr421563205e9.29.1764612025604;
        Mon, 01 Dec 2025 10:00:25 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791164ceecsm254141865e9.14.2025.12.01.10.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:00:25 -0800 (PST)
Date: Mon, 1 Dec 2025 18:59:53 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, 
	Neal Gompa <neal@gompa.dev>
Subject: Re: [PATCHSET V2 2/2] xfsprogs: autonomous self healing of
 filesystems in Rust
Message-ID: <qssqvaog4s3y3d7rgncahookkxiswzqiu5kx5jveulj32apgar@zy7nvw6haymm>
References: <20251022235646.GO3356773@frogsfrogsfrogs>
 <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
 <20251104224806.GN196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104224806.GN196370@frogsfrogsfrogs>

On 2025-11-04 14:48:06, Darrick J. Wong wrote:
> On Wed, Oct 22, 2025 at 05:00:20PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > The initial implementation of the self healing daemon is written in
> > Python.  This was useful for rapid prototyping, but a more performant
> > and typechecked codebase is valuable.  Write a second implementation in
> > Rust to reduce event processing overhead and library dependence.  This
> > could have been done in C, but I decided to use an environment with
> > somewhat fewer footguns.
> 
> Having discarded the json output format last week, I decided to rewrite
> the Python version of xfs_healer in C partly out of curiosity and partly
> because I didn't see much advantage to having a Python script to call
> ioctls and interpret C structs.  After removing the json support from
> the Rust version, the release binary sizes are:
> 
> -rwxr-xr-x root/root   1051096 2025-11-04 14:25 ./usr/libexec/xfsprogs/xfs_healer
> -rwxr-xr-x root/root     43904 2025-11-04 14:25 ./usr/libexec/xfsprogs/xfs_healer.orig
> 
> This is a nearly 24x size increase to have Rust.  I'm a n00b Rustacean

cargo build --release? (optimized + no debug info)

> and a veteran C stuckee, but between that and the difficulties of
> integrating two languages and two build systems together, I don't think
> it's worth the trouble to keep the Rust code.  I've made a final push
> with the Rust code to my dev repo for the sake of posterity:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust_2025-11-04
> 
> But I'm deleting this from my tree after I send this email.

:'(

> 
> That said, I quite enjoyed using this an excuse to familiarize myself
> with how to write bad Rust code.  Using traits and the newtype pattern
> for geometric units (e.g. xfs_fsblock_t) was very helpful in keeping
> unit conversions understandable; and having to think about object access
> and lifetimes helped me produce a stable prototype very quickly.  It
> also helps that rustc errors are far more helpful than gcc.
> 
> The only thing I didn't particularly like is the forced coordination for
> shared resources that already coordinate threads -- you can't easily
> have multiple readers sharing an open fd, even if that magic fd only
> emits struct sized objects and takes i_rwsem exclusively to prevent
> corruption problems.
> 
> Dealing with cargo for a distro package build was nightmarish --
> hermetically sealed build systems (you want this) can't access crates.io
> which means that I as the author had to be careful only to use crate
> packages that are in EPEL or Debian stable, and to tell cargo only to
> look on the local filesystem.  So I guess I now have experience in that,
> should anyone want to know how to do that.
> 
> (Also, how do you do i18n in Rust programs?  gettext???)
> 
> --D
> 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust
> > ---
> > Commits in this patchset:
> >  * xfs_healer: start building a Rust version
> >  * xfs_healer: enable gettext for localization
> >  * xfs_healer: bindgen xfs_fs.h
> >  * xfs_healer: define Rust objects for health events and kernel interface
> >  * xfs_healer: read binary health events from the kernel
> >  * xfs_healer: read json health events from the kernel
> >  * xfs_healer: create a weak file handle so we don't pin the mount
> >  * xfs_healer: fix broken filesystem metadata
> >  * xfs_healer: check for fs features needed for effective repairs
> >  * xfs_healer: use getparents to look up file names
> >  * xfs_healer: make the rust program check if kernel support available
> >  * xfs_healer: use the autofsck fsproperty to select mode
> >  * xfs_healer: use rc on the mountpoint instead of lifetime annotations
> >  * xfs_healer: use thread pools
> >  * xfs_healer: run full scrub after lost corruption events or targeted repair failure
> >  * xfs_healer: use getmntent in Rust to find moved filesystems
> >  * xfs_healer: validate that repair fds point to the monitored fs in Rust
> >  * debian/control: listify the build dependencies
> >  * debian/control: pull in build dependencies for xfs_healer
> > ---
> >  healer/bindgen_xfs_fs.h          |    6 +
> >  configure.ac                     |   84 ++++++++
> >  debian/control                   |   30 +++
> >  debian/rules                     |    3 
> >  healer/.cargo/config.toml.system |    6 +
> >  healer/Cargo.toml.in             |   37 +++
> >  healer/Makefile                  |  143 +++++++++++++
> >  healer/rbindgen                  |   57 +++++
> >  healer/src/fsgeom.rs             |   41 ++++
> >  healer/src/fsprops.rs            |  101 +++++++++
> >  healer/src/getmntent.rs          |  117 +++++++++++
> >  healer/src/getparents.rs         |  210 ++++++++++++++++++++
> >  healer/src/healthmon/cstruct.rs  |  354 +++++++++++++++++++++++++++++++++
> >  healer/src/healthmon/event.rs    |  122 +++++++++++
> >  healer/src/healthmon/fs.rs       |  163 +++++++++++++++
> >  healer/src/healthmon/groups.rs   |  160 +++++++++++++++
> >  healer/src/healthmon/inodes.rs   |  142 +++++++++++++
> >  healer/src/healthmon/json.rs     |  409 ++++++++++++++++++++++++++++++++++++++
> >  healer/src/healthmon/mod.rs      |   47 ++++
> >  healer/src/healthmon/samefs.rs   |   33 +++
> >  healer/src/lib.rs                |   17 ++
> >  healer/src/main.rs               |  390 ++++++++++++++++++++++++++++++++++++
> >  healer/src/repair.rs             |  390 ++++++++++++++++++++++++++++++++++++
> >  healer/src/util.rs               |   81 ++++++++
> >  healer/src/weakhandle.rs         |  209 +++++++++++++++++++
> >  healer/src/xfs_types.rs          |  292 +++++++++++++++++++++++++++
> >  healer/src/xfsprogs.rs.in        |   33 +++
> >  include/builddefs.in             |   13 +
> >  include/buildrules               |    1 
> >  m4/Makefile                      |    1 
> >  m4/package_rust.m4               |  163 +++++++++++++++
> >  31 files changed, 3851 insertions(+), 4 deletions(-)
> >  create mode 100644 healer/bindgen_xfs_fs.h
> >  create mode 100644 healer/.cargo/config.toml.system
> >  create mode 100644 healer/Cargo.toml.in
> >  create mode 100755 healer/rbindgen
> >  create mode 100644 healer/src/fsgeom.rs
> >  create mode 100644 healer/src/fsprops.rs
> >  create mode 100644 healer/src/getmntent.rs
> >  create mode 100644 healer/src/getparents.rs
> >  create mode 100644 healer/src/healthmon/cstruct.rs
> >  create mode 100644 healer/src/healthmon/event.rs
> >  create mode 100644 healer/src/healthmon/fs.rs
> >  create mode 100644 healer/src/healthmon/groups.rs
> >  create mode 100644 healer/src/healthmon/inodes.rs
> >  create mode 100644 healer/src/healthmon/json.rs
> >  create mode 100644 healer/src/healthmon/mod.rs
> >  create mode 100644 healer/src/healthmon/samefs.rs
> >  create mode 100644 healer/src/lib.rs
> >  create mode 100644 healer/src/main.rs
> >  create mode 100644 healer/src/repair.rs
> >  create mode 100644 healer/src/util.rs
> >  create mode 100644 healer/src/weakhandle.rs
> >  create mode 100644 healer/src/xfs_types.rs
> >  create mode 100644 healer/src/xfsprogs.rs.in
> >  create mode 100644 m4/package_rust.m4
> > 
> > 
> 

-- 
- Andrey

