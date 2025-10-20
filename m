Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59E6284883;
	Mon, 20 Oct 2025 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760977575; cv=none; b=EoHpVWCtpUoLabXKY6mxhvQNeAy9Dbg5EsopHaOdCtIW9rm9vq0x1jyQ8ds3y7DcjVEoIWymiVB5bbfYExonTT4w4mkkM3RtkKEc9N+A+EYlsqiYAfieGRjaBLYPbYMClD0CtXJrqwVwNqKjeUAs/blN0ljbOA0dobG0b0yn5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760977575; c=relaxed/simple;
	bh=zsZoMD4MPLGVHY2Ca63iS4NhlAloiOvul2Ex28jGRew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APACgXLT+ligJLGfj/ErkagTYdxL2a+26G5CVpUCX+2HLJ6+a6pvWVPxmv8Rw0sPHPrmYAnzOW/+4py7e52Fvo26bGJ9X6lqbxMkMbfZalb18xgQESap9fzPHlehX2Gd5xgjd3ury3PKe0WTk4HEPON5bldUy0nMaU/Sg92R+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvNn7awj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvNn7awj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE84DC113D0;
	Mon, 20 Oct 2025 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760977574;
	bh=zsZoMD4MPLGVHY2Ca63iS4NhlAloiOvul2Ex28jGRew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lvNn7awj0/QOcEugbSpjqnBvLsCZfKUcFRY3fZ1L0dTy1xXxBtXE+YPP5OazARHp4
	 awI/MiCWfmF8nq7+GZ/Zsz5l+8MB/WR7azAnOvtFYXANSV09zc1RccFCZJjUcQuLzk
	 Ke6t+lgBHnnk1DPfESmWH6qs5yF+6ouMxsDKfswW4ZOhPuJa/bXhCEeHRflGRIDmW9
	 HFLOpc8jlXn9Tbr5txSuphxbK50TRZRvJeMMaA93PxBpcsi907ETcRbBX/eqaPUVCZ
	 PIgi6efoon5MkQXnfXO1RO88M1jqHMWdkRjVvYRXerLwK7L9u4ZNodlrKTm2OScH6E
	 9BTPWcsuGMIIA==
Date: Mon, 20 Oct 2025 09:26:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251020162614.GK6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <20251017174633.lvfvpv2zoauwo7s7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251017225448.GH6178@frogsfrogsfrogs>
 <20251018075708.t7agddy5ceisek2e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018075708.t7agddy5ceisek2e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Oct 18, 2025 at 03:57:08PM +0800, Zorro Lang wrote:
> On Fri, Oct 17, 2025 at 03:54:48PM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 18, 2025 at 01:46:33AM +0800, Zorro Lang wrote:
> > > On Wed, Oct 15, 2025 at 09:38:01AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > On XFS in 6.17, this test fails with:
> > > > 
> > > >  --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
> > > >  +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
> > > >  @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
> > > >   Can not set fsxattr on ./foo: Invalid argument
> > > >   Initial attributes state
> > > >   ----------------- SCRATCH_MNT/prj
> > > >  ------------------ ./fifo
> > > >  ------------------ ./chardev
> > > >  ------------------ ./blockdev
> > > >  ------------------ ./socket
> > > >  ------------------ ./foo
> > > >  ------------------ ./symlink
> > > >  +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
> > > >  +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
> > > >  +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
> > > >  +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> > > > 
> > > > This is a result of XFS' file_getattr implementation rejecting special
> > > > files prior to 6.18.  Therefore, skip this new test on old kernels.
> > > > 
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > >  tests/generic/772 |    3 +++
> > > >  tests/xfs/648     |    3 +++
> > > >  2 files changed, 6 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/tests/generic/772 b/tests/generic/772
> > > > index cc1a1bb5bf655c..e68a6724654450 100755
> > > > --- a/tests/generic/772
> > > > +++ b/tests/generic/772
> > > > @@ -43,6 +43,9 @@ touch $projectdir/bar
> > > >  ln -s $projectdir/bar $projectdir/broken-symlink
> > > >  rm -f $projectdir/bar
> > > >  
> > > > +file_attr --get $projectdir ./fifo &>/dev/null || \
> > > > +	_notrun "file_getattr not supported on $FSTYP"
> > > 
> > > I'm wondering if a _require_file_attr() is better?
> > 
> > It's checking specifically that the new getattr syscall works on special
> > files.  I suppose you could wrap that in a helper, but I think this is a
> > lot more direct about what it's looking for.
> 
> Please correct me if I'm wrong. The new syscall is created for setting extended
> attributes on special files, therefore I suppose if there's file_setattr syscall
> and it can work on regular file, then it can work on any other files the fs supports.
> If this's correct, _require_file_attr can use file_attr to try to set and get
> attr on a regular file in $TEST_DIR, to make sure the whole file_set/getattr
> feature is supported. Is that right?

No.  The new new syscall allows programs to specify a {dir fd, path}
input that points to a special file, but it uses the existing per-fs
get/setattr implementations.  All of those implementations have to
remove their copy-pasta'd code:

	if (d_is_special(dentry))
		return -ENOTTY;

before the new syscall will return non-error for special files.  This
wasn't done for all of the filesystems before 6.18, which means that
6.17 has the syscall but none of the filesystems support accessing
special files.  As of 6.18-rc2, gfs, jfs, and ubifs still have that
code.

TLDR: You can't assume that the new syscall works with special files.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +
> > > >  echo "Error codes"
> > > >  # wrong AT_ flags
> > > >  file_attr --get --invalid-at $projectdir ./foo
> > > > diff --git a/tests/xfs/648 b/tests/xfs/648
> > > > index 215c809887b609..e3c2fbe00b666a 100755
> > > > --- a/tests/xfs/648
> > > > +++ b/tests/xfs/648
> > > > @@ -47,6 +47,9 @@ touch $projectdir/bar
> > > >  ln -s $projectdir/bar $projectdir/broken-symlink
> > > >  rm -f $projectdir/bar
> > > >  
> > > > +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> > > > +	_notrun "file_getattr not supported on $FSTYP"
> > > > +
> > > >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > > >  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> > > >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > > > 
> > > 
> > > 
> > 
> 
> 
