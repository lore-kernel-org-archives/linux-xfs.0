Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B82224F3
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783966544; cv=none; b=GMdNtZdcZwaXrweSCjvX4ofik45a6sExiEOWyfsT/qdKJvlzN2VdV4zZTqCNBMWn9EVUrP/WvwM/pX1sYHl4hZ+ak0U4jqVcC2ClqKcyuNJNvkwpPAQw1L9i7idY/0Xbn8EMpd1vVoTGtrQgzJnqDDr3NHlXp3IUNpfHuEV9lVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783966544; c=relaxed/simple;
	bh=96eCL7vpuKviD+DhOjNxJBPSMmGflLVi3nFn/4dSx7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLHvUp76ht5iFwDeyQkeCdWmHFyf6/GDltayn4ASo/rWCGcCxmbSkEO6oR8QiSJmm/Ax6qrBh9YBujlr9fWMezMlVshG3HryhN/VumIEbat596O5z3YThKPolwFSV7T4/dHn5pUOZUYfVp3FQ1llGLLBXsR+fCyZTOW6Vav1P6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXbVVoMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXbVVoMW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 292F41F000E9;
	Mon, 13 Jul 2026 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783966543;
	bh=f55HfY7u5XXQqJR2iAP0tyWQrt/QtrK67qwYtZ7F00A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXbVVoMWc+ZK/kqVY/LNtXyHRtYSEC+6HUEZw0tM3+Fvb0Y34M4K7FB7s/dAlm0J4
	 AhP4LzhaBx6OVXSPmYGZMA51FMqv0w/n/2U0jMfFNa9uoexQwAQypg+GIn4dpApi1c
	 ejCxk2WzSHk2QYvBxX33dQqdLLcm90reJXFRc60vu0FLUp3n/7o1Vmvq0sYbNAfu51
	 bFnz/eGbu5d62146YQX5MZVt0Ey7D2Fb9/xKo9DRh+ttU9UbLMVYZKlyVIGBrd1Li5
	 o0w6qqWjAWGE7QzkUWGxTAnHOUkNFtxTv09bjvlEirgzi9XFFfEQ6DyRyYV0HidWeZ
	 YzCCBO8sLvAGQ==
Date: Mon, 13 Jul 2026 11:15:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com, bfoster@redhat.com, cem@kernel.org,
	cmaiolino@redhat.com, dgc@kernel.org, hch@lst.de,
	liuhuan01@kylinos.cn, msinguru@redhat.com, romain.naour@smile.fr,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com,
	wilfred.mallawa@wdc.com, ytohnuki@amazon.com
Subject: Re: [ANNOUNCE] xfsprogs: v7.1.0 released
Message-ID: <20260713181542.GF7195@frogsfrogsfrogs>
References: <alDUTZkDnQodyG2R@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260713155405.GC7195@frogsfrogsfrogs>
 <alUm3yMFKm9w0Mjm@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alUm3yMFKm9w0Mjm@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Mon, Jul 13, 2026 at 08:02:37PM +0200, Andrey Albershteyn wrote:
> On 2026-07-13 08:54:05, Darrick J. Wong wrote:
> > On Mon, Jul 13, 2026 at 11:23:41AM +0200, Andrey Albershteyn wrote:
> > > Hi folks,
> > > 
> > > The xfsprogs master branch in repository at:
> > > 
> > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > 
> > > has just been updated.
> > > 
> > > This release consist mostly of a bunch of fixes for xfs_scrub and xfs_healer
> > > found with help of Codex. The xfs_scrub systemd units now have less security
> > > restrictions due to issues with postfix. Multiple memory leaks and overflows
> > > fixed. A lot of fixes for xfs_scrub phased repair flow. xfs_protofile now also
> > > works with non-directories. The build system is fixed for path containing ".o".
> > > Manual pages and mkfs messages now have correct MiB units.
> > > 
> > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > on the list and not included in this update, please let me know.
> > > 
> > > The for-next branch has also been updated to match the state of master.
> > > 
> > > The new head of the master branch is commit:
> > > 
> > > e80b048d87fdc5735e0d03ae29b497b402ea8bbe
> > > 
> > > New commits:
> > > 
> > > Andrey Albershteyn (1):
> > >       [e80b048d87fd] xfsprogs: Release v7.1.0
> > > 
> > > Christoph Hellwig (1):
> > >       [846570fc6498] xfs: switch (back) to a per-buftarg buffer hash
> > > 
> > > Darrick J. Wong (65):
> > >       [1aadfecf6afb] xfs_healer: fix error reporting
> > >       [d21aab594247] xfs_healer: recommend offline fsck for XCORRUPT repairs
> > >       [44849c72c720] xfs_healer: initialize variable here
> > >       [fc76bac6ce1f] xfs_healer: run a full xfs_scrub repair if we don't know how to do a spot repair
> > >       [79551362141a] xfs_healer: fix Makefile errors
> > >       [4d62c2fa83ba] xfs_healer: don't leak wh->mntpoint if fd_to_handle fails
> > >       [a6b85058f1ae] xfs_healer: coordinate access to weakhandle::mntpoint correctly
> > >       [de2bc2763b53] xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
> > >       [ff0aeb233200] xfs_scrub_all: fix broken command line string array construction
> > >       [ee3ea981af6b] xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
> > >       [24362b13fb76] xfs_scrub_fail: send content headers for xfs_scrub_all failures
> > >       [472b010d0c84] xfs_scrub: fix uninitialized variable
> > >       [a42fc3ec97db] xfs_scrub: fix integer overflows
> > >       [9d36b3db1212] xfs_scrub: don't count internal log space in the data device used count
> > >       [064834b6a0a2] xfs_scrub: widen scrub and repair dependency mask
> > >       [44eee006149b] xfs_scrub: fix work estimation for rtgroups filesystems
> > >       [5db0a8b13358] xfs_scrub: don't report media errors in specially-owned areas as file data
> > >       [b65854f9e580] xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
> > >       [a34231de7668] xfs_scrub: fix nonsense advice after a scrub finds errors
> > >       [25c97ededd3e] xfs_scrub: don't allow NAN as fstrim percentage
> > >       [709b7eab8977] xfs_scrub: reset bulkstat pointer on retry
> > >       [dc4e11fa3d7c] xfs_scrub: don't return garbage value from bulkstat_the_rest
> > >       [d0b07b57faf0] xfs_scrub: don't continue with phase1 if autofsck=none
> > >       [4a093a994c63] xfs_scrub: don't crash trying to complain about clean health
> > >       [353333f0f3ff] xfs_scrub: fix inverted return value from ptvar_get
> > >       [a5732e6c61f5] xfs_scrub: don't obscure repair failures in repair_list_schedule
> > >       [33cc9bbc4dce] xfs_scrub: bitmap iteration functions must retur
> > >       [5556c32a0304] xfs_scrub: read verification isn't ok if it hit runtime errors
> > >       [359eeef71fae] libfrog: fix buffer overflow in getparents path_to_string
> > >       [5b0f430d8e59] xfs_healer: don't allow aliasing of mon_fd in setup_monitor
> > >       [425126caa89c] xfs_healer_start: check listmount when doing a --check
> > >       [577d6415adbb] xfs_healer_start: fix static checking
> > >       [76ef8d90a3f0] xfs_healer_start: increase statmount buffer size
> > >       [a0f50dec3540] xfs_healer: allow AF_UNIX socket access for xfs_healer instances
> > >       [f6505519ef79] xfs_healer: don't put the slice file in LDIRT
> > >       [64344c43430a] xfs_scrub: handle missing media verify ioctl failure return codes
> > >       [2712427c08a5] xfs_scrub: report bad file ranges correctly
> > >       [3e4bb144f657] xfs_scrub: handle media scans of internal rt devices correctly
> > >       [c001fa7d4db4] xfs_scrub: track inode scan abort state with an enum
> > >       [bc9371417a61] xfs_scrub: don't skip bulkstat batch when scrub_scan_user_files helper returns ESTALE
> > >       [b6dba3d85ae5] xfs_scrub: warn about incomplete repairs if we never get to them
> > >       [e2df9f9bb984] xfs_scrub: report external log space usage in phase 7
> > >       [243048f90dd4] xfs_scrub: account only data extent tail after an overlap
> > >       [baef30aabbd5] xfs_scrub: account for reflinked realtime file data
> > >       [a4080cef33fd] xfs_scrub: don't leak the autofsck fsproperty handle
> > >       [157d76940c3c] xfs_scrub: warn about difficult rtgroup repairs
> > >       [0bafb12d66e7] xfs_scrub: stop user file scan if caller already aborted
> > >       [bac5085ac2e3] xfs_scrub: don't flatten error numbers in read_verify_schedule_now
> > >       [b43e9064d665] xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
> > >       [41530a0981a1] xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
> > >       [f4dfa0b0c565] xfs_scrub: fix phase 8 debug reporting
> > >       [f75bb3f2d598] xfs_scrub: always finish cleanup, even if reporting healthy state fails
> > >       [4399db49dec0] xfs_scrub: fix spacemap external log device scan dev key
> > >       [70d0a4f27464] xfs_scrub: fix estimate of work items for phase 4
> > >       [b64c29f5bfed] xfs_db: fix type conversions
> > >       [1bbedb6d165e] xfs_db: dump zoned filesystem superblock fields
> > >       [7a26df144fad] xfs_healer: fix getmntent race in weakhandle
> > >       [b07c386bc60b] mkfs: don't redefine DIRT for protofiles
> > >       [2df5f48fb829] mkfs: fix PATH_MAX check
> > >       [46b0ee102f25] mkfs: fix symlink target length check in create_nondir_inode
> > >       [b3268fb3d822] xfs_protofile: make nondirectory arguments actually work
> > >       [a2b765f7d0fd] mkfs: pass stat buf pointers around the protofile code
> > >       [63a4a9d6966c] mkfs: fix hardlink detection in directory import code
> > >       [8c6bf6721ac4] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
> > >       [074c18165ea3] xfs_scrub: fix spacemap scan for internal rt devices
> > 
> > Hmmm, this patch seems to have gotten the same rtstart hunk pasted into
> > both scan_ag_rmaps and scan_rtg_rmaps even though the original patch
> > only changed scan_rtg_rmaps.  I'll send a fix.
> 
> Hmm I miss-understood the patch flow here. I intentionally squashed
> these two patches, I thought you sent fix in two patches (both had
> identical commit message).
> 
> standalone fix:
> https://lore.kernel.org/linux-xfs/20260701145124.GE6526@frogsfrogsfrogs/
> 
> part of the pr:
> https://lore.kernel.org/linux-xfs/178302114913.828394.9290073519402547866.stg-ugh@frogsfrogsfrogs/

Both the standalone patch I sent to the list and the one in the PR[1]
modify scan_rtg_rmaps.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=scrub-codex-fixes5_2026-07-02&id=892743f0f955427a89a911b96baa998cd7b549b8
