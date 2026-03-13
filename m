Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21671383C8E;
	Fri, 13 Mar 2026 23:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445505; cv=none; b=LwjVUCU/T9DEVFMfkHHWCBN35IvfIjYVuRktwHsj7eG/OTxHxBOZGeHKbCciFATXq0BluP8d6kdX9ccItHrIL5wDAGhUWDC4+8dysyw99q5LC8yHZwwNDgWDqe2XeV/gXPyugDh7znmbrs3/Ewsfk+6q573XBrJGko2T2byKVro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445505; c=relaxed/simple;
	bh=eod/zR3rnEhO5dFB+Y3DQS6ZLZHg6M3ReeWt6GwdUBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ6UqB1+F1QXxnJuh/wNRni5fn7CYplPDeWPuwhmvqDdLJKrTM6rF71KjCZMmAOEQ3CFBkKkQRvn9ILNirjMFt4FGUIgK5cM4GVRXdJKGw32BBPPuFnAxNaAdhaV3d04QHmR6VUDDLgvNDhhK3keBy2H287JIJZXvx6B1mMI470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDgo1T5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDgo1T5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD27DC19421;
	Fri, 13 Mar 2026 23:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773445504;
	bh=eod/zR3rnEhO5dFB+Y3DQS6ZLZHg6M3ReeWt6GwdUBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDgo1T5W2H7RixfBCZF8LTXSUQT5xBeA3HEWLlHfent5m3kbBqvErPnVIUczzuTkD
	 d9/tberwjZd0gfPbZf3I2SKRD1eNkbEP2wacis/m4VD5mheljMU5axQOkdOzlk8NJ6
	 VftY5FtX4xnkbLpeAgqbAQm+f++QbZIVwJpwj4PVmkDVddyMnYS7fhfb12Kr0RNnkl
	 pqy/AS5brLAsTPIGZ/X09gs0Hnjj3A1CRH7x2ueLddtCYwc1EF52f5hW2mLqPlxET0
	 Auv1XX5qcbpmNvgNlQNK+cu5fyVUEUwxqEzsQ/2+ajPFYJbY4TJaosm31eyVj5qn6K
	 UftIruoGnikLA==
Date: Fri, 13 Mar 2026 16:45:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/62[3-8]: require XFS_SCRUB_PROG
Message-ID: <20260313234504.GG6023@frogsfrogsfrogs>
References: <20260311041443.GC6023@frogsfrogsfrogs>
 <20260313175529.kdwqkjtpn2fwigrz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260313175529.kdwqkjtpn2fwigrz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 14, 2026 at 01:55:29AM +0800, Zorro Lang wrote:
> On Tue, Mar 10, 2026 at 09:14:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > QA reports that xfs/62[3-8] fail because they didn't install
> > xfsprogs-xfs_scrub package and this test requires xfs_scrub(8).
> > Add the missing _require call, and update the README so that anyone
> > running fstests on RHEL/Fedora actually get all the necessary
> > components to do a full test of XFS.
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.06.27
> > Fixes: 4de8fd7860a2bb ("scrub: test correction of directory tree corruptions")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  README        |    2 +-
> >  tests/xfs/623 |    3 +--
> >  tests/xfs/624 |    3 +--
> >  tests/xfs/625 |    3 +--
> >  tests/xfs/626 |    3 +--
> >  tests/xfs/627 |    3 +--
> >  tests/xfs/628 |    1 +
> >  7 files changed, 7 insertions(+), 11 deletions(-)
> > 
> > diff --git a/README b/README
> > index 211e273115f08f..36684cc6572d4b 100644
> > --- a/README
> > +++ b/README
> > @@ -126,7 +126,7 @@ Fedora
> >     $ sudo yum install acl attr automake bc dbench dump e2fsprogs fio gawk gcc \
> >          gdbm-devel git indent kernel-devel libacl-devel libaio-devel \
> >          libcap-devel libtool liburing-devel libuuid-devel lvm2 make psmisc \
> > -        python3 quota sed sqlite udftools  xfsprogs
> > +        python3 quota sed sqlite udftools xfsprogs xfsprogs-xfs_scrub
> 
> Sure,
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> I’m thinking we could split this package list into "necessary" dependencies and "optional"
> ones. The "necessary" dependencies would include all packages required for building and
> basic execution of xfstests, while missing "optional" dependencies would simply result in
> certain cases being notrun. Any thoughts on this :)

Hrmm.  Now that I look at README a bit more, we /could/ break things out
by what you need to run xfstests at all vs. what you need for specific
filesystems.  For example, xfsprogs-xfs_scrub is really only necessary
for testing XFS itself, but xfsprogs is needed even if you're testing
ext4.

Oh.  The RHEL/Centos sections actually do that, and the only difference
between Fedora and RHEL/Centos seem to be that you have to configure
EPEL repos for !Fedora.

Those sections really ought to be merged to avoid repetition.  Also I'm
pretty sure RHEL is supposed to use dnf not yum nowadays.

--D

> Thanks,
> Zorro
> 
> >  
> >  2. Install packages for the filesystem(s) being tested:
> >  
> > diff --git a/tests/xfs/623 b/tests/xfs/623
> > index aff3f903660fa7..7f79ccbcbf7f14 100755
> > --- a/tests/xfs/623
> > +++ b/tests/xfs/623
> > @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
> >  . ./common/fuzzy
> >  . ./common/populate
> >  
> > -
> > -# Modify as appropriate.
> > +_require_scrub
> >  _require_xfs_db_command "link"
> >  _require_xfs_db_command "unlink"
> >  _require_scratch
> > diff --git a/tests/xfs/624 b/tests/xfs/624
> > index e63cfcc6e7ba82..09a922c8d18c8a 100755
> > --- a/tests/xfs/624
> > +++ b/tests/xfs/624
> > @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
> >  . ./common/fuzzy
> >  . ./common/populate
> >  
> > -
> > -# Modify as appropriate.
> > +_require_scrub
> >  _require_xfs_db_command "link"
> >  _require_xfs_db_command "unlink"
> >  _require_scratch
> > diff --git a/tests/xfs/625 b/tests/xfs/625
> > index 23013f195c9e7f..2654216b67aa11 100755
> > --- a/tests/xfs/625
> > +++ b/tests/xfs/625
> > @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
> >  . ./common/fuzzy
> >  . ./common/populate
> >  
> > -
> > -# Modify as appropriate.
> > +_require_scrub
> >  _require_xfs_db_command "link"
> >  _require_xfs_db_command "unlink"
> >  _require_scratch
> > diff --git a/tests/xfs/626 b/tests/xfs/626
> > index c424819cede6e1..3b4cdca4fe4e24 100755
> > --- a/tests/xfs/626
> > +++ b/tests/xfs/626
> > @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
> >  . ./common/fuzzy
> >  . ./common/populate
> >  
> > -
> > -# Modify as appropriate.
> > +_require_scrub
> >  _require_xfs_db_command "link"
> >  _require_xfs_db_command "unlink"
> >  _require_scratch
> > diff --git a/tests/xfs/627 b/tests/xfs/627
> > index 411a7603317058..fc54199b4a95de 100755
> > --- a/tests/xfs/627
> > +++ b/tests/xfs/627
> > @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
> >  . ./common/fuzzy
> >  . ./common/populate
> >  
> > -
> > -# Modify as appropriate.
> > +_require_scrub
> >  _require_xfs_db_command "link"
> >  _require_xfs_db_command "unlink"
> >  _require_scratch
> > diff --git a/tests/xfs/628 b/tests/xfs/628
> > index c77d67db358983..e003f41999f401 100755
> > --- a/tests/xfs/628
> > +++ b/tests/xfs/628
> > @@ -17,6 +17,7 @@ _begin_fstest scrub fsstress_scrub
> >  . ./common/inject
> >  . ./common/xfs
> >  
> > +_require_scrub
> >  _require_scratch
> >  _require_xfs_stress_scrub
> >  
> > 
> 
> 
