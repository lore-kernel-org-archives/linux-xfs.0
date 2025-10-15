Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694041C72;
	Wed, 15 Oct 2025 05:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760504672; cv=none; b=dalzLi4rqrEUMWSY39buHONWg0yGFlkVcKqpXrJ8x5MeJhHJutlXEiLIMcTmpx6L6a0bs5nsqv6GiqwJ/V3Ef1MCrTponcFE/rskR10L0spiAUyVolO9pPqtBPpzbTpdWmar6BdRYfcCCEWi1gUh+VFLzJwvuN91LPqIq0YvuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760504672; c=relaxed/simple;
	bh=ROs0/aJSxf5bw4pfgvsocvKYTXYP3/TwCSPJpjDf5Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrh91ECDP1kCrXKuh4DSYhv84vnJD5nt35mDIRqojo2Rs3sQmkR4i1PARw1kcERmGnTcqBG3PM1i8I4f1agifI5EzU6Ods/qfaR4Yghpq7gQJl5BErRQZEb6zG1rF9PucHv24dCcftuVHfLN7HOfqpK9f3Wq8nAb/X2qGNdSqp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sp0jfe71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sp0jfe71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7818C4CEF8;
	Wed, 15 Oct 2025 05:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760504671;
	bh=ROs0/aJSxf5bw4pfgvsocvKYTXYP3/TwCSPJpjDf5Dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sp0jfe7186tpxKBRrEUa538AiGg//w9/LT3qIFEyNIUAkahOzmmax+IKdgFJeeeTZ
	 PCFfJTDrcVNMWviWH/QDPy3sTcgFZO6HsaXo0Gf00UK+rBa0Yu2j0JXXENrzWDCfpG
	 JnF4QzdFgP5coB7+/yiWU89dWsDRzDt8SG36oU+0Wt/15mVlYoef0evHPYe4ESo+cQ
	 g5YkGyG+VuvfKdhCXsfrXdNcLe2V4AxzMKc9QINK3Rbl7RmnXYdZpQFnkosQydk/w+
	 DGUgRYh/XfamY5VTY21Fozs8PmABXs5HWGlgSB3nNF5blR0RZEgDMsOXW353zilAgq
	 DWqWGwFMBS8Rw==
Date: Tue, 14 Oct 2025 22:04:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH v2 3/3] xfs: quietly ignore deprecated mount options
Message-ID: <20251015050431.GX6188@frogsfrogsfrogs>
References: <20251015050133.GV6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015050133.GV6188@frogsfrogsfrogs>

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
ioctl).  But we've learned our lesson, so complain as LOUDLY as possible
about the deprecation.

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
 fs/xfs/xfs_super.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ae9b17730eaf41..d8f326d8838036 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -102,7 +102,7 @@ static const struct constant_table dax_param_enums[] = {
  * Table driven mount option parser.
  */
 enum {
-	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
+	Op_deprecated, Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
 	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
 	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32,
@@ -114,7 +114,21 @@ enum {
 	Opt_lifetime, Opt_nolifetime, Opt_max_atomic_write,
 };
 
+#define fsparam_dead(NAME) \
+	__fsparam(NULL, (NAME), Op_deprecated, fs_param_deprecated, NULL)
+
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
+	/*
+	 * These mount options were supposed to be deprecated in September 2025
+	 * but the deprecation warning was buggy, so not all users were
+	 * notified.  The deprecation is now obnoxiously loud and postponed to
+	 * September 2030.
+	 */
+	fsparam_dead("attr2"),
+	fsparam_dead("noattr2"),
+	fsparam_dead("ikeep"),
+	fsparam_dead("noikeep"),
+
 	fsparam_u32("logbufs",		Opt_logbufs),
 	fsparam_string("logbsize",	Opt_logbsize),
 	fsparam_string("logdev",	Opt_logdev),
@@ -1417,6 +1431,9 @@ xfs_fs_parse_param(
 		return opt;
 
 	switch (opt) {
+	case Op_deprecated:
+		xfs_fs_warn_deprecated(fc, param);
+		return 0;
 	case Opt_logbufs:
 		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
@@ -1537,7 +1554,6 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
-	/* Following mount options will be removed in September 2025 */
 	case Opt_max_open_zones:
 		parsing_mp->m_max_open_zones = result.uint_32;
 		return 0;
