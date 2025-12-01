Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E2B281369
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 21:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764626138; cv=none; b=ujQEZvVhioP3kn2DSaIP0glDEkji4D9QxLaqBIlrQ7nc+etQkQb9swie58cuERXkIPCTNPAZO36qovkw/acU5Cx2Ur700e/ssujLpfXW8GktR42xi/9UExtmXhk1OGQ1BJrVUDpdXJdBGRFvBJn8MrUXQKzzF+vYvbiXDfUTK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764626138; c=relaxed/simple;
	bh=QxbxLYrYfYGVAbLvDrsLXqUZfldH0SXC0JtOVqAdGvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+wD6rnsi7rWDtyR3OcEoAVLeGs94rvgANP2rBOYZNj3RySWLIj7yY5UrTbvYORh3BWgfAnN06SRQsTGQG8GFA5VmC2bOtJDKpUNAWxm6fb671w+4pFEpB4o36I11DBPN491mlXICfP/nGc9vEWxdgWhavQpV0OcOBhiqL+DJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Swp0XTDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Swp0XTDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E4BC4CEF1;
	Mon,  1 Dec 2025 21:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764626138;
	bh=QxbxLYrYfYGVAbLvDrsLXqUZfldH0SXC0JtOVqAdGvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Swp0XTDk58EJLJI5r6hVGCtbNBred7BjEA4ii/kkWXPtYjdTbtWupbv4CCvRf1wkV
	 5qzlriL/5zcL+5tSkgKG1doWcWTMG7KzhsPZsqK9poN/8lbx+5KzdNy0eVMqBejUFc
	 1dwKLzOurgy9m2J2CYMVf2T/VbQ4akJHPU1F//1qqeJ9uXrS7m7tIIbh2x/kn6FzJI
	 xUqf+vsmiFA8YLkA+OVIkngbWMjIp+qo0fy2oPRcYAh+9xECbEJ0IAn3oDW1s2t5vb
	 kysCO804V1/ZAakp/hPMLrQsd9xwQjt7Eb272Y4+7ZZa4bGs4KUZvk/XaPjBAX2O80
	 YTY3d3kQprXQA==
Date: Mon, 1 Dec 2025 13:55:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	Neal Gompa <neal@gompa.dev>
Subject: Re: [PATCHSET V2 2/2] xfsprogs: autonomous self healing of
 filesystems in Rust
Message-ID: <20251201215537.GA89472@frogsfrogsfrogs>
References: <20251022235646.GO3356773@frogsfrogsfrogs>
 <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
 <20251104224806.GN196370@frogsfrogsfrogs>
 <qssqvaog4s3y3d7rgncahookkxiswzqiu5kx5jveulj32apgar@zy7nvw6haymm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qssqvaog4s3y3d7rgncahookkxiswzqiu5kx5jveulj32apgar@zy7nvw6haymm>

On Mon, Dec 01, 2025 at 06:59:53PM +0100, Andrey Albershteyn wrote:
> On 2025-11-04 14:48:06, Darrick J. Wong wrote:
> > On Wed, Oct 22, 2025 at 05:00:20PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > The initial implementation of the self healing daemon is written in
> > > Python.  This was useful for rapid prototyping, but a more performant
> > > and typechecked codebase is valuable.  Write a second implementation in
> > > Rust to reduce event processing overhead and library dependence.  This
> > > could have been done in C, but I decided to use an environment with
> > > somewhat fewer footguns.
> > 
> > Having discarded the json output format last week, I decided to rewrite
> > the Python version of xfs_healer in C partly out of curiosity and partly
> > because I didn't see much advantage to having a Python script to call
> > ioctls and interpret C structs.  After removing the json support from
> > the Rust version, the release binary sizes are:
> > 
> > -rwxr-xr-x root/root   1051096 2025-11-04 14:25 ./usr/libexec/xfsprogs/xfs_healer
> > -rwxr-xr-x root/root     43904 2025-11-04 14:25 ./usr/libexec/xfsprogs/xfs_healer.orig
> > 
> > This is a nearly 24x size increase to have Rust.  I'm a n00b Rustacean
> 
> cargo build --release? (optimized + no debug info)

That (1.05M) is the release build size.  The debug build size was 33MB.
Not sure how or why Rust binaries get so huge, but there it is. :/

--D

> > and a veteran C stuckee, but between that and the difficulties of
> > integrating two languages and two build systems together, I don't think
> > it's worth the trouble to keep the Rust code.  I've made a final push
> > with the Rust code to my dev repo for the sake of posterity:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust_2025-11-04
> > 
> > But I'm deleting this from my tree after I send this email.
> 
> :'(
> 
> > 
> > That said, I quite enjoyed using this an excuse to familiarize myself
> > with how to write bad Rust code.  Using traits and the newtype pattern
> > for geometric units (e.g. xfs_fsblock_t) was very helpful in keeping
> > unit conversions understandable; and having to think about object access
> > and lifetimes helped me produce a stable prototype very quickly.  It
> > also helps that rustc errors are far more helpful than gcc.
> > 
> > The only thing I didn't particularly like is the forced coordination for
> > shared resources that already coordinate threads -- you can't easily
> > have multiple readers sharing an open fd, even if that magic fd only
> > emits struct sized objects and takes i_rwsem exclusively to prevent
> > corruption problems.
> > 
> > Dealing with cargo for a distro package build was nightmarish --
> > hermetically sealed build systems (you want this) can't access crates.io
> > which means that I as the author had to be careful only to use crate
> > packages that are in EPEL or Debian stable, and to tell cargo only to
> > look on the local filesystem.  So I guess I now have experience in that,
> > should anyone want to know how to do that.
> > 
> > (Also, how do you do i18n in Rust programs?  gettext???)
> > 
> > --D
> > 
> > > If you're going to start using this code, I strongly recommend pulling
> > > from my git trees, which are linked below.
> > > 
> > > This has been running on the djcloud for months with no problems.  Enjoy!
> > > Comments and questions are, as always, welcome.
> > > 
> > > --D
> > > 
> > > xfsprogs git tree:
> > > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust
> > > ---
> > > Commits in this patchset:
> > >  * xfs_healer: start building a Rust version
> > >  * xfs_healer: enable gettext for localization
> > >  * xfs_healer: bindgen xfs_fs.h
> > >  * xfs_healer: define Rust objects for health events and kernel interface
> > >  * xfs_healer: read binary health events from the kernel
> > >  * xfs_healer: read json health events from the kernel
> > >  * xfs_healer: create a weak file handle so we don't pin the mount
> > >  * xfs_healer: fix broken filesystem metadata
> > >  * xfs_healer: check for fs features needed for effective repairs
> > >  * xfs_healer: use getparents to look up file names
> > >  * xfs_healer: make the rust program check if kernel support available
> > >  * xfs_healer: use the autofsck fsproperty to select mode
> > >  * xfs_healer: use rc on the mountpoint instead of lifetime annotations
> > >  * xfs_healer: use thread pools
> > >  * xfs_healer: run full scrub after lost corruption events or targeted repair failure
> > >  * xfs_healer: use getmntent in Rust to find moved filesystems
> > >  * xfs_healer: validate that repair fds point to the monitored fs in Rust
> > >  * debian/control: listify the build dependencies
> > >  * debian/control: pull in build dependencies for xfs_healer
> > > ---
> > >  healer/bindgen_xfs_fs.h          |    6 +
> > >  configure.ac                     |   84 ++++++++
> > >  debian/control                   |   30 +++
> > >  debian/rules                     |    3 
> > >  healer/.cargo/config.toml.system |    6 +
> > >  healer/Cargo.toml.in             |   37 +++
> > >  healer/Makefile                  |  143 +++++++++++++
> > >  healer/rbindgen                  |   57 +++++
> > >  healer/src/fsgeom.rs             |   41 ++++
> > >  healer/src/fsprops.rs            |  101 +++++++++
> > >  healer/src/getmntent.rs          |  117 +++++++++++
> > >  healer/src/getparents.rs         |  210 ++++++++++++++++++++
> > >  healer/src/healthmon/cstruct.rs  |  354 +++++++++++++++++++++++++++++++++
> > >  healer/src/healthmon/event.rs    |  122 +++++++++++
> > >  healer/src/healthmon/fs.rs       |  163 +++++++++++++++
> > >  healer/src/healthmon/groups.rs   |  160 +++++++++++++++
> > >  healer/src/healthmon/inodes.rs   |  142 +++++++++++++
> > >  healer/src/healthmon/json.rs     |  409 ++++++++++++++++++++++++++++++++++++++
> > >  healer/src/healthmon/mod.rs      |   47 ++++
> > >  healer/src/healthmon/samefs.rs   |   33 +++
> > >  healer/src/lib.rs                |   17 ++
> > >  healer/src/main.rs               |  390 ++++++++++++++++++++++++++++++++++++
> > >  healer/src/repair.rs             |  390 ++++++++++++++++++++++++++++++++++++
> > >  healer/src/util.rs               |   81 ++++++++
> > >  healer/src/weakhandle.rs         |  209 +++++++++++++++++++
> > >  healer/src/xfs_types.rs          |  292 +++++++++++++++++++++++++++
> > >  healer/src/xfsprogs.rs.in        |   33 +++
> > >  include/builddefs.in             |   13 +
> > >  include/buildrules               |    1 
> > >  m4/Makefile                      |    1 
> > >  m4/package_rust.m4               |  163 +++++++++++++++
> > >  31 files changed, 3851 insertions(+), 4 deletions(-)
> > >  create mode 100644 healer/bindgen_xfs_fs.h
> > >  create mode 100644 healer/.cargo/config.toml.system
> > >  create mode 100644 healer/Cargo.toml.in
> > >  create mode 100755 healer/rbindgen
> > >  create mode 100644 healer/src/fsgeom.rs
> > >  create mode 100644 healer/src/fsprops.rs
> > >  create mode 100644 healer/src/getmntent.rs
> > >  create mode 100644 healer/src/getparents.rs
> > >  create mode 100644 healer/src/healthmon/cstruct.rs
> > >  create mode 100644 healer/src/healthmon/event.rs
> > >  create mode 100644 healer/src/healthmon/fs.rs
> > >  create mode 100644 healer/src/healthmon/groups.rs
> > >  create mode 100644 healer/src/healthmon/inodes.rs
> > >  create mode 100644 healer/src/healthmon/json.rs
> > >  create mode 100644 healer/src/healthmon/mod.rs
> > >  create mode 100644 healer/src/healthmon/samefs.rs
> > >  create mode 100644 healer/src/lib.rs
> > >  create mode 100644 healer/src/main.rs
> > >  create mode 100644 healer/src/repair.rs
> > >  create mode 100644 healer/src/util.rs
> > >  create mode 100644 healer/src/weakhandle.rs
> > >  create mode 100644 healer/src/xfs_types.rs
> > >  create mode 100644 healer/src/xfsprogs.rs.in
> > >  create mode 100644 m4/package_rust.m4
> > > 
> > > 
> > 
> 
> -- 
> - Andrey
> 
> 
