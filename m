Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6C1E9B37;
	Mon, 13 Oct 2025 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398350; cv=none; b=SRG8KZ7BAZS21l8LTYymygNGqi1ckoMPUb0L34cK+Rt3osXwFYvyj5uiF8hi/nwfCLNR44oWLtMg3yzQEXXulVnMJWRfMewJEgWSgGMVYe/Q05LE6VFRCVOktddaQV+rF1fj4xmNdZONxwNnTAXi5f33L6EgN6wLtYtsxiv7hjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398350; c=relaxed/simple;
	bh=Z4efOZyEHCh6Exj2wHYZNtvp31AUQB0CfE6zHpapMqc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VmSIgL1iVfs2G6qxjcCtC+B+A5FD8KeQwh30Qw2oXciTok9mw7wZtTPKPLyvjEdXQYrCWhAghS2SVv3lbCxSGmYDHFJZhnow+otKi/wzc6qUKoWoddguTyEchlnbgpwElcVjoEAjw5IDH6yOZQoroV5qWw7r1FuRMLJ/FVSgmT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyB4aOO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyB4aOO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DBEC4CEE7;
	Mon, 13 Oct 2025 23:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760398350;
	bh=Z4efOZyEHCh6Exj2wHYZNtvp31AUQB0CfE6zHpapMqc=;
	h=Date:From:To:Cc:Subject:From;
	b=NyB4aOO1DeSxLdysn6eQHpFjqdJUaFy8joQJlicmS6VIM6hYJbX+z9x3FeXK1mnZD
	 U1dlq2t1hJyObka9kHojJH6G5hkMiM18wbgHYe5a7dlq5Cb4Vmgy8VO5Y/mfz5OcJ1
	 qb4BfPIcoWU1ERshkKVPpS3hASfQI3/QE6cWjRtOz3SVgUJbaxGZtCTRl60DIvScJO
	 QQVvOwPbj8BsXdocPwgNZl8km4b5GqiIQk6tEy5HqhnWtHA9kNmlhnrnI4yUtGFDsL
	 kL3SMrVEIdxXdz3c2sYawaSE5+e00QJN91voP+o8sL3TrGOkvulh3Pwmd5ZJBW8QzP
	 Vdw/j5gS38ppA==
Date: Mon, 13 Oct 2025 16:32:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH 1/2] xfs: quietly ignore deprecated mount options
Message-ID: <20251013233229.GR6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Apparently we can never deprecate mount options in this project, because
it will invariably turn out that some foolish userspace depends on some
behavior and break.  From Oleksandr Natalenko:

> In v6.18, the attr2 XFS mount option is removed. This may silently
> break system boot if the attr2 option is still present in /etc/fstab
> for rootfs.
>
> Consider Arch Linux that is being set up from scratch with / being
> formatted as XFS. The genfstab command that is used to generate
> /etc/fstab produces something like this by default:
>
> /dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota)
>
> Once the system is set up and rebooted, there's no deprecation warning
> seen in the kernel log:
>
> # cat /proc/cmdline
> root=UUID=77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=discard rd.luks.options=discard quiet
>
> # dmesg | grep -i xfs
> [    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
> [    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1ef-4dfd430e47e9
> [    2.442546] XFS (sda2): Ending clean mount
>
> Although as per the deprecation intention, it should be there.
>
> Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated()
> doesn't produce any warning by design if the XFS FS is set to be
> rootfs and gets remounted read-write during boot. This imposes two
> problems:
>
> 1) a user doesn't see the deprecation warning; and
> 2) with v6.18 kernel, the read-write remount fails because of unknown
>    attr2 option rendering system unusable:
>
> systemd[1]: Switching root.
> systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 32.
>
> # mount -o rw /
> mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.
>
> Thorsten (in Cc) suggested reporting this as a user-visible regression.
>
> From my PoV, although the deprecation is in place for 5 years already,
> it may not be visible enough as the warning is not emitted for rootfs.
> Considering the amount of systems set up with XFS on /, this may
> impose a mass problem for users.
>
> Vlastimil suggested making attr2 option a complete noop instead of
> removing it.

IOWs, the initrd mounts the root fs with (I assume) no mount options,
and mount -a remounts with whatever options are in fstab.  However,
XFS doesn't complain about deprecated mount options during a remount, so
technically speaking we were not warning all users in all combinations
that they were heading for a cliff.

Gotcha!!

Now, how did 'attr2' get slurped up on so many systems?  The old code
would put that in /proc/mounts if the filesystem happened to be in attr2
mode, even if user hadn't mounted with any such option.  IOWs, this is
because someone thought it would be a good idea to advertise system
state via /proc/mounts.

The easy way to fix this is to reintroduce the four mount options but
map them to a no-op option that ignores them, and hope that nobody's
depending on attr2 to appear in /proc/mounts.  (Hint: use the fsgeometry
ioctl).

Lessons learned:

 1. Don't expose system state via /proc/mounts; the only strings that
    ought to be there are options *explicitly* provided by the user.
 2. Never tidy, it's not worth the stress and irritation.

Reported-by: oleksandr@natalenko.name
Reported-by: vbabka@suse.cz
Cc: <stable@vger.kernel.org> # v6.18-rc1
Fixes: b9a176e54162f8 ("xfs: remove deprecated mount options")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d16..e1df41991fccc3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -102,7 +102,7 @@ static const struct constant_table dax_param_enums[] = {
  * Table driven mount option parser.
  */
 enum {
-	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
+	Opt_quietlyignore, Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
 	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
 	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32,
@@ -115,6 +115,14 @@ enum {
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
+	/*
+	 * These mount options were advertised in /proc/mounts even if the
+	 * filesystem had not been mounted with that option.  Quietly ignore
+	 * them to avoid breaking scripts that captured /proc/mounts.
+	 */
+	fsparam_flag("attr",		Opt_quietlyignore),
+	fsparam_flag("noattr2",		Opt_quietlyignore),
+
 	fsparam_u32("logbufs",		Opt_logbufs),
 	fsparam_string("logbsize",	Opt_logbsize),
 	fsparam_string("logdev",	Opt_logdev),
@@ -1408,6 +1416,8 @@ xfs_fs_parse_param(
 		return opt;
 
 	switch (opt) {
+	case Opt_quietlyignore:
+		return 0;
 	case Opt_logbufs:
 		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
@@ -1528,7 +1538,6 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
-	/* Following mount options will be removed in September 2025 */
 	case Opt_max_open_zones:
 		parsing_mp->m_max_open_zones = result.uint_32;
 		return 0;
