Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C2264A92;
	Tue, 21 Oct 2025 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071429; cv=none; b=dvfpUwJiXei2IfGV0uRfbXzysu8iQiLEiHW6D9Xfv+VN0b0+C49xYo5if/csb/sGQxdx0MwcPXKiVGScXD+pWcmMyh61lf74K+W3+RbZcVhguCVB/FD+0KNrzzqEAlo1ftN/TmtIunkQ4EvWCA0kSZMJ6tvbf/0LOBrfMn1hxtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071429; c=relaxed/simple;
	bh=RlmGRMUJOAQRCvPPOGGitJNNVKeSnPhG6/RR8KkODlM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWlgBcAYK0VA02gb76geNGmTAGqaX76WXhg6y4a5YLxeIDySvCouSgTt+XlY92kbV3mVZCXJLPXJlPYcJzAF5gVyREB1p6C4NntyXgfjq/LYYUx5CZUrul9DNOPy8UxQlIAW+aiDnsphny/c2UXg2SPiDBMxv9xbi0RPcKgJ5Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZW+Tp43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZW+Tp43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E22C4CEF1;
	Tue, 21 Oct 2025 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071428;
	bh=RlmGRMUJOAQRCvPPOGGitJNNVKeSnPhG6/RR8KkODlM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bZW+Tp439RhcQFhb9291fjTdkwHo/WRcH93EtvwD1lf+js+Mm+7VanyMKkF90ijRp
	 6+IFE9/S5xqvu256f8lx2dEZpiDhTEoMLUcqT3M6uR6Ks8MMWupEmGZOXQWGWWcW92
	 xpyZ4Cyp5JnkcXLsY2eaYQJoH4qZ9yBCeWlP1mQEdquwuKJbTMyjC+Wl/89udt/mqL
	 D7em5IjAKwMlyKH/6P5IRP2tG95vQmWm2OaVu+lPcY3GREwiUYkojkBmOR+9u4ZTyk
	 p2vK7xiWgXD6dQ4oXwP21fwFXvT6G8S8GcxoxuPKrZ71d9uYniPJFu6sHbuS0zQ+Mi
	 7DeZt2tWtJntA==
Date: Tue, 21 Oct 2025 11:30:27 -0700
Subject: [PATCH 3/4] xfs: loudly complain about defunct mount options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: oleksandr@natalenko.name, stable@vger.kernel.org, vbabka@suse.cz,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <176107134044.4152072.18403833729642060548.stgit@frogsfrogsfrogs>
In-Reply-To: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Apparently we can never deprecate mount options in this project, because
it will invariably turn out that some foolish userspace depends on some
behavior and break.  From Oleksandr Natalenko:

  In v6.18, the attr2 XFS mount option is removed. This may silently
  break system boot if the attr2 option is still present in /etc/fstab
  for rootfs.

  Consider Arch Linux that is being set up from scratch with / being
  formatted as XFS. The genfstab command that is used to generate
  /etc/fstab produces something like this by default:

  /dev/sda2 on / type xfs (rw,relatime,attr2,discard,inode64,logbufs=8,logbsize=32k,noquota)

  Once the system is set up and rebooted, there's no deprecation warning
  seen in the kernel log:

  # cat /proc/cmdline
  root=UUID=77b42de2-397e-47ee-a1ef-4dfd430e47e9 rootflags=discard rd.luks.options=discard quiet

  # dmesg | grep -i xfs
  [    2.409818] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
  [    2.415341] XFS (sda2): Mounting V5 Filesystem 77b42de2-397e-47ee-a1ef-4dfd430e47e9
  [    2.442546] XFS (sda2): Ending clean mount

  Although as per the deprecation intention, it should be there.

  Vlastimil (in Cc) suggests this is because xfs_fs_warn_deprecated()
  doesn't produce any warning by design if the XFS FS is set to be
  rootfs and gets remounted read-write during boot. This imposes two
  problems:

  1) a user doesn't see the deprecation warning; and
  2) with v6.18 kernel, the read-write remount fails because of unknown
     attr2 option rendering system unusable:

  systemd[1]: Switching root.
  systemd-remount-fs[225]: /usr/bin/mount for / exited with exit status 32.

  # mount -o rw /
  mount: /: fsconfig() failed: xfs: Unknown parameter 'attr2'.

  Thorsten (in Cc) suggested reporting this as a user-visible regression.

  From my PoV, although the deprecation is in place for 5 years already,
  it may not be visible enough as the warning is not emitted for rootfs.
  Considering the amount of systems set up with XFS on /, this may
  impose a mass problem for users.

  Vlastimil suggested making attr2 option a complete noop instead of
  removing it.

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

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
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

