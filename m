Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B6927F01E;
	Tue, 14 Oct 2025 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760466150; cv=none; b=s1xmnAQe+ds9IUb73OTd0dWvWsSVScdcT/hLXB36xVOgAvOjkabTD/Fuyoq28Cwn2xcSOh94Ugp/d+cZUXGGEMHerre7J6cjBLrFXyQGGG3KqTnF8N8zarZWIOIhBRy34BN3FtD3DniaKi7a7jdq3xfcWD1uPm92VrX/nXCuJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760466150; c=relaxed/simple;
	bh=khlNisH8i2Ud4Fkv3yboxw0azYLQViia2aglBjxVop0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzjBQ+aI9Uypif4iflKdf7s8osTJUsh9NdL4IV/sBFwmRu3tXBPnncNvKs10dRQAKloIIZSiQ6aqey+kq3vN0L8rdUcJOgz6MR6SwgVfgwH8X19A9KZZNXWVGGkGpnwOln8dn1qIZb9bEyC2Nw+SgnAH0PiRBHaHlAwVw15WDwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCeelzAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCeelzAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA6FC4CEE7;
	Tue, 14 Oct 2025 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760466149;
	bh=khlNisH8i2Ud4Fkv3yboxw0azYLQViia2aglBjxVop0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YCeelzAi4il5II6IqjasPsEDpq2aeQMC+tk37SVCi8T2Ppu84kRj/4n7+SEG9CfUi
	 bNCNsR7EZ+s3ByhN73AuPNf4jsIZ04J/L8Yr8GM/XcNVyxRHEWr3K856/iBf8zdHsV
	 DKwWEIva1/9IKVl7Uq6cVDJQ+NZUIpo5KHsKKL0L6hTvyi1dV8cmdVtGMCC5enBg22
	 zwP8kwVkdkpR6D3M+L009s2de0ztI2bG7LjD6lNKcQDdzhkAXd5HR1rei10/hDCmKT
	 FaAnR8VK8Twh8fj9k8PZrw8bz44MdbsOUtBqlYvLDcAiFaziyDLU/qG+ous/znQpf4
	 4c8ANYnwvO0lw==
Date: Tue, 14 Oct 2025 11:22:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 1/2] xfs: quietly ignore deprecated mount options
Message-ID: <20251014182229.GY6188@frogsfrogsfrogs>
References: <20251013233229.GR6188@frogsfrogsfrogs>
 <2800646.mvXUDI8C0e@natalenko.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2800646.mvXUDI8C0e@natalenko.name>

On Tue, Oct 14, 2025 at 01:27:40PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> On úterý 14. října 2025 1:32:29, středoevropský letní čas Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Apparently we can never deprecate mount options in this project, because
> > it will invariably turn out that some foolish userspace depends on some
> > behavior and break.  From Oleksandr Natalenko:
> > 
> > > In v6.18, the attr2 XFS mount option is removed. This may silently
> > > break system boot if the attr2 option is still present in /etc/fstab
> > > for rootfs.
> > >
> > > Consider Arch Linux that is being set up from scratch with / being
> > > formatted as XFS. The genfstab command that is used to generate
> > > /etc/fstab produces something like this by default:
> > >
> > > /dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota)
> > >
> > > Once the system is set up and rebooted, there's no deprecation warning
> > > seen in the kernel log:
> > >
> > > # cat /proc/cmdline
> > > root=UUID=77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=discard rd.luks.options=discard quiet
> > >
> > > # dmesg | grep -i xfs
> > > [    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
> > > [    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1ef-4dfd430e47e9
> > > [    2.442546] XFS (sda2): Ending clean mount
> > >
> > > Although as per the deprecation intention, it should be there.
> > >
> > > Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated()
> > > doesn't produce any warning by design if the XFS FS is set to be
> > > rootfs and gets remounted read-write during boot. This imposes two
> > > problems:
> > >
> > > 1) a user doesn't see the deprecation warning; and
> > > 2) with v6.18 kernel, the read-write remount fails because of unknown
> > >    attr2 option rendering system unusable:
> > >
> > > systemd[1]: Switching root.
> > > systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 32.
> > >
> > > # mount -o rw /
> > > mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.
> > >
> > > Thorsten (in Cc) suggested reporting this as a user-visible regression.
> > >
> > > From my PoV, although the deprecation is in place for 5 years already,
> > > it may not be visible enough as the warning is not emitted for rootfs.
> > > Considering the amount of systems set up with XFS on /, this may
> > > impose a mass problem for users.
> > >
> > > Vlastimil suggested making attr2 option a complete noop instead of
> > > removing it.
> > 
> > IOWs, the initrd mounts the root fs with (I assume) no mount options,
> > and mount -a remounts with whatever options are in fstab.  However,
> > XFS doesn't complain about deprecated mount options during a remount, so
> > technically speaking we were not warning all users in all combinations
> > that they were heading for a cliff.
> > 
> > Gotcha!!
> > 
> > Now, how did 'attr2' get slurped up on so many systems?  The old code
> > would put that in /proc/mounts if the filesystem happened to be in attr2
> > mode, even if user hadn't mounted with any such option.  IOWs, this is
> > because someone thought it would be a good idea to advertise system
> > state via /proc/mounts.
> > 
> > The easy way to fix this is to reintroduce the four mount options but
> > map them to a no-op option that ignores them, and hope that nobody's
> > depending on attr2 to appear in /proc/mounts.  (Hint: use the fsgeometry
> > ioctl).
> > 
> > Lessons learned:
> > 
> >  1. Don't expose system state via /proc/mounts; the only strings that
> >     ought to be there are options *explicitly* provided by the user.
> >  2. Never tidy, it's not worth the stress and irritation.
> > 
> > Reported-by: oleksandr@natalenko.name
> > Reported-by: vbabka@suse.cz
> > Cc: <stable@vger.kernel.org> # v6.18-rc1
> > Fixes: b9a176e54162f8 ("xfs: remove deprecated mount options")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_super.c |   13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e85a156dc17d16..e1df41991fccc3 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -102,7 +102,7 @@ static const struct constant_table dax_param_enums[] = {
> >   * Table driven mount option parser.
> >   */
> >  enum {
> > -	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
> > +	Opt_quietlyignore, Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
> >  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
> >  	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
> >  	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32,
> > @@ -115,6 +115,14 @@ enum {
> >  };
> >  
> >  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> > +	/*
> > +	 * These mount options were advertised in /proc/mounts even if the
> > +	 * filesystem had not been mounted with that option.  Quietly ignore
> > +	 * them to avoid breaking scripts that captured /proc/mounts.
> > +	 */
> > +	fsparam_flag("attr",		Opt_quietlyignore),
> 
> Should have been "attr2" here I suppose.

Yeah, sorry about that, will fix for v2.

Maybe I should use fs_param_deprecated here too.

--D

> Thanks.
> 
> > +	fsparam_flag("noattr2",		Opt_quietlyignore),
> > +
> >  	fsparam_u32("logbufs",		Opt_logbufs),
> >  	fsparam_string("logbsize",	Opt_logbsize),
> >  	fsparam_string("logdev",	Opt_logdev),
> > @@ -1408,6 +1416,8 @@ xfs_fs_parse_param(
> >  		return opt;
> >  
> >  	switch (opt) {
> > +	case Opt_quietlyignore:
> > +		return 0;
> >  	case Opt_logbufs:
> >  		parsing_mp->m_logbufs = result.uint_32;
> >  		return 0;
> > @@ -1528,7 +1538,6 @@ xfs_fs_parse_param(
> >  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
> >  		return 0;
> >  #endif
> > -	/* Following mount options will be removed in September 2025 */
> >  	case Opt_max_open_zones:
> >  		parsing_mp->m_max_open_zones = result.uint_32;
> >  		return 0;
> > 
> 
> -- 
> Oleksandr Natalenko, MSE


